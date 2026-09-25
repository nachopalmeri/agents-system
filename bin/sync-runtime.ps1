#!/usr/bin/env pwsh
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch] $Force,
    [switch] $Check,
    [string] $Restore,
    [string] $HomePath = $env:USERPROFILE
)

$ErrorActionPreference = "Stop"
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$manifestPath = Join-Path $repoRoot "config/runtime-manifest.json"
$runtimeManifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$homeRoot = [System.IO.Path]::GetFullPath($HomePath).TrimEnd('\', '/')
$stateRoot = Join-Path $homeRoot ".agents-system-sync"
$statePath = Join-Path $stateRoot "state.json"

function Assert-NoReparseTraversal {
    param([string] $Root, [string] $Candidate, [string] $Label)
    $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
    $candidateFull = [IO.Path]::GetFullPath($Candidate)
    $relative = $candidateFull.Substring($rootFull.Length).TrimStart('\', '/')
    $current = $rootFull
    foreach ($segment in @($relative -split '[\\/]' | Where-Object { $_ })) {
        $current = Join-Path $current $segment
        if (-not (Test-Path -LiteralPath $current)) { continue }
        $item = Get-Item -LiteralPath $current -Force
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "$Label crosses reparse point: $current"
        }
    }
}

function Get-ContainedPath {
    param([string] $Root, [string] $RelativePath, [string] $Label)
    if ([string]::IsNullOrWhiteSpace($RelativePath) -or [System.IO.Path]::IsPathRooted($RelativePath)) {
        throw "$Label must be a non-rooted declared path: $RelativePath"
    }
    $RelativePath = $RelativePath.Replace('\', '/')
    $rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
    $candidate = [System.IO.Path]::GetFullPath((Join-Path $rootFull $RelativePath))
    $prefix = $rootFull + [System.IO.Path]::DirectorySeparatorChar
    if (-not $candidate.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "$Label escapes declared home/root: $RelativePath"
    }
    Assert-NoReparseTraversal -Root $rootFull -Candidate $candidate -Label $Label
    return $candidate
}

Assert-NoReparseTraversal -Root $homeRoot -Candidate $stateRoot -Label "Sync state path"

function Get-StringHash([string] $Value) {
    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
        return (($algorithm.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join "")
    } finally {
        $algorithm.Dispose()
    }
}

function Get-FileContentHash([string] $Path) {
    try {
        $content = [System.IO.File]::ReadAllText($Path)
        $normalized = $content.Replace("`r`n", "`n")
        return Get-StringHash $normalized
    } catch {
        $algorithm = [System.Security.Cryptography.SHA256]::Create()
        $stream = [System.IO.File]::OpenRead($Path)
        try {
            return (($algorithm.ComputeHash($stream) | ForEach-Object { $_.ToString("x2") }) -join "")
        } finally {
            $stream.Dispose()
            $algorithm.Dispose()
        }
    }
}

function Get-PathHash([string] $Path) {
    if (-not (Test-Path $Path)) { return $null }
    $item = Get-Item $Path -Force
    if (-not $item.PSIsContainer) {
        return Get-FileContentHash $Path
    }
    $root = $item.FullName.TrimEnd('\')
    $records = @()
    foreach ($child in @(Get-ChildItem $root -Force -Recurse | Sort-Object FullName)) {
        $relative = $child.FullName.Substring($root.Length).TrimStart('\').Replace('\', '/')
        if ($child.PSIsContainer) {
            $records += "D`0$relative"
        } else {
            $hash = Get-FileContentHash $child.FullName
            $records += "F`0$relative`0$hash"
        }
    }
    return Get-StringHash ($records -join "`n")
}

function Copy-ManagedPath([string] $Source, [string] $Destination) {
    $sourceItem = Get-Item $Source -Force
    $parent = Split-Path $Destination -Parent
    if (-not (Test-Path $parent)) { [void](New-Item -ItemType Directory -Path $parent -Force) }
    if ($sourceItem.PSIsContainer) {
        [void](New-Item -ItemType Directory -Path $Destination -Force)
        foreach ($child in @(Get-ChildItem $Source -Force)) {
            Copy-Item $child.FullName -Destination $Destination -Recurse -Force
        }
    } else {
        Copy-Item $Source -Destination $Destination -Force
    }
}

function Test-RuntimePathExcluded([string] $SourcePath) {
    $relative = [System.IO.Path]::GetFullPath($SourcePath).Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')
    foreach ($excluded in @($runtimeManifest.excludedRuntimePaths)) {
        $normalized = ([string]$excluded).Trim('/').Replace('\', '/')
        if ($relative -eq $normalized -or $relative.StartsWith("$normalized/", [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
        if (-not $normalized.Contains('/') -and ("/$relative/").IndexOf("/$normalized/", [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            return $true
        }
    }
    return $false
}

function Copy-StagedSource([string] $Source, [string] $Destination) {
    $sourceItem = Get-Item $Source -Force
    if (-not $sourceItem.PSIsContainer) {
        Copy-ManagedPath $Source $Destination
        return
    }
    [void](New-Item -ItemType Directory -Path $Destination -Force)
    foreach ($child in @(Get-ChildItem $Source -Force)) {
        if (Test-RuntimePathExcluded $child.FullName) { continue }
        $childDestination = Join-Path $Destination $child.Name
        if ($child.PSIsContainer) {
            Copy-StagedSource $child.FullName $childDestination
        } else {
            Copy-ManagedPath $child.FullName $childDestination
        }
    }
}

function Remove-ManagedPath([string] $Path) {
    if (-not (Test-Path $Path)) { return }
    $item = Get-Item $Path -Force
    if ($item.PSIsContainer -and -not $item.LinkType) {
        Remove-Item $Path -Recurse -Force
    } else {
        Remove-Item $Path -Force
    }
}

function Write-JsonFile([string] $Path, $Value) {
    $parent = Split-Path $Path -Parent
    if (-not (Test-Path $parent)) { [void](New-Item -ItemType Directory -Path $parent -Force) }
    $temporary = "$Path.tmp-$([guid]::NewGuid().ToString('N'))"
    [System.IO.File]::WriteAllText($temporary, ($Value | ConvertTo-Json -Depth 50), (New-Object System.Text.UTF8Encoding($false)))
    Move-Item $temporary $Path -Force
}

function Read-SyncState {
    if (-not (Test-Path $statePath -PathType Leaf)) {
        return [pscustomobject]@{ schemaVersion = 1; entries = @() }
    }
    return Get-Content $statePath -Raw | ConvertFrom-Json
}

function Get-StateEntry($State, [string] $RelativeTarget) {
    return @($State.entries | Where-Object { ([string]$_.relativeTarget) -eq $RelativeTarget }) | Select-Object -First 1
}

function Test-Preserved([string] $RelativeTarget) {
    foreach ($prefix in @($runtimeManifest.preserveIfExists)) {
        $normalized = ([string]$prefix).Trim('/')
        if ($RelativeTarget -eq $normalized -or $RelativeTarget.StartsWith("$normalized/", [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
    }
    return $false
}

# Merge: cada skill (carpeta con SKILL.md) y cada archivo suelto es una unidad
# propia; lo que exista en destino y no venga del repo no se toca.
function Get-MergeUnits([string] $SourceDir, [string] $TargetRelative) {
    $units = @()
    foreach ($child in @(Get-ChildItem $SourceDir -Force | Sort-Object Name)) {
        if (Test-RuntimePathExcluded $child.FullName) { continue }
        $relative = "$TargetRelative/$($child.Name)"
        if ($child.PSIsContainer -and -not (Test-Path (Join-Path $child.FullName "SKILL.md"))) {
            $units += Get-MergeUnits $child.FullName $relative
        } else {
            $units += [pscustomobject]@{ sourcePath = $child.FullName; relativeTarget = $relative; kind = $(if ($child.PSIsContainer) { "directory" } else { "file" }) }
        }
    }
    return $units
}

function Get-ForeignEntries([string] $TargetDir, [string] $TargetRelative, [hashtable] $Expected) {
    $foreign = @()
    if (-not (Test-Path $TargetDir -PathType Container)) { return $foreign }
    foreach ($child in @(Get-ChildItem $TargetDir -Force | Sort-Object Name)) {
        $relative = "$TargetRelative/$($child.Name)"
        if ($Expected.ContainsKey($relative)) { continue }
        $isAncestor = $child.PSIsContainer -and @($Expected.Keys | Where-Object { $_.StartsWith("$relative/") }).Count -gt 0
        if ($isAncestor) {
            $foreign += Get-ForeignEntries $child.FullName $relative $Expected
        } else {
            $foreign += $relative
        }
    }
    return $foreign
}

$externalSkillNames = @((Get-Content (Join-Path $repoRoot "config/external-skills.json") -Raw | ConvertFrom-Json).skills.name)
function Test-ExternalSkill([string] $RelativeTarget) {
    if ($RelativeTarget -notmatch '^\.agents/skills-library/([^/]+)$') { return $false }
    return $externalSkillNames -contains $Matches[1]
}

# Nombres que el repo gestionó antes y ya movió o retiró: si aparecen en un destino
# merge no son "tuyos" sino copias viejas del repo -> [stale], se quitan con -Force (con backup).
$baselinePath = Join-Path $repoRoot "config/capability-baseline.json"
$retiredNames = @()
if (Test-Path $baselinePath) { $retiredNames = @((Get-Content $baselinePath -Raw | ConvertFrom-Json).retired | ForEach-Object { [string]$_.id }) }
$tierNames = @{}
foreach ($tier in @("skills", "skills-library")) {
    $tierNames[$tier] = @(Get-ChildItem (Join-Path $repoRoot ".agents/$tier") -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
}
function Test-StaleEntry([string] $RelativeTarget) {
    $leaf = Split-Path $RelativeTarget -Leaf
    $base = [IO.Path]::GetFileNameWithoutExtension($leaf)
    if ($retiredNames -contains $leaf -or $retiredNames -contains $base) { return $true }
    if ($RelativeTarget -match '(^|/)skills/[^/]+$' -and $tierNames["skills-library"] -contains $leaf) { return $true }
    if ($RelativeTarget -match '^\.agents/skills-library/[^/]+$' -and $tierNames["skills"] -contains $leaf) { return $true }
    return $false
}

$script:mergeRoots = @()

function Get-SyncTargets {
    $targets = @()
    foreach ($install in @($runtimeManifest.installTargets)) {
        $source = Get-ContainedPath -Root $repoRoot -RelativePath ([string]$install.sourcePath) -Label "Source path"
        $targetRelative = ([string]$install.targetPath).Replace('\', '/')
        if ([string]$install.mode -eq "merge") {
            $script:mergeRoots += [pscustomobject]@{ client = [string]$install.client; relativeTarget = $targetRelative; targetPath = (Get-ContainedPath -Root $homeRoot -RelativePath $targetRelative -Label "Target path") }
            foreach ($unit in @(Get-MergeUnits $source $targetRelative)) {
                $targets += [pscustomobject]@{
                    client = [string]$install.client
                    kind = $unit.kind
                    relativeTarget = $unit.relativeTarget
                    sourcePath = $unit.sourcePath
                    targetPath = (Get-ContainedPath -Root $homeRoot -RelativePath $unit.relativeTarget -Label "Target path")
                }
            }
            continue
        }
        $target = Get-ContainedPath -Root $homeRoot -RelativePath $targetRelative -Label "Target path"
        $targets += [pscustomobject]@{
            client = [string]$install.client
            kind = [string]$install.kind
            relativeTarget = $targetRelative
            sourcePath = $source
            targetPath = $target
        }
    }
    foreach ($adapter in @($runtimeManifest.adapters | Where-Object { $_.globalTarget })) {
        $globalSource = if ($adapter.globalSourcePath) { [string]$adapter.globalSourcePath } else { [string]$adapter.repoPath }
        $source = Get-ContainedPath -Root $repoRoot -RelativePath $globalSource -Label "Source path"
        $target = Get-ContainedPath -Root $homeRoot -RelativePath ([string]$adapter.globalTarget) -Label "Target path"
        $targets += [pscustomobject]@{
            client = [string]$adapter.client
            kind = "file"
            relativeTarget = ([string]$adapter.globalTarget).Replace('\', '/')
            sourcePath = $source
            targetPath = $target
        }
    }
    $duplicates = @($targets | Group-Object targetPath | Where-Object Count -gt 1)
    if ($duplicates.Count -gt 0) { throw "Duplicate declared target: $($duplicates[0].Name)" }
    foreach ($target in $targets) {
        if (-not (Test-Path $target.sourcePath)) { throw "Declared source missing: $($target.sourcePath)" }
        $sourceItem = Get-Item $target.sourcePath -Force
        if ($target.kind -eq "directory" -and -not $sourceItem.PSIsContainer) { throw "Declared directory source is not a directory: $($target.sourcePath)" }
        if ($target.kind -eq "file" -and $sourceItem.PSIsContainer) { throw "Declared file source is not a file: $($target.sourcePath)" }
    }
    return @($targets)
}

function Get-MissingAncestors([string] $TargetPath) {
    $missing = @()
    $parent = Split-Path $TargetPath -Parent
    while ($parent -and $parent.Length -gt $homeRoot.Length -and -not (Test-Path $parent)) {
        $missing += $parent.Substring($homeRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $parent = Split-Path $parent -Parent
    }
    return $missing
}

function Remove-EmptyCreatedDirs($Entries) {
    $dirs = @($Entries | ForEach-Object { @($_.createdDirs) } | Where-Object { $_ } | Sort-Object -Unique | Sort-Object Length -Descending)
    foreach ($relative in $dirs) {
        $path = Get-ContainedPath -Root $homeRoot -RelativePath $relative -Label "Created directory"
        if ((Test-Path $path -PathType Container) -and @(Get-ChildItem $path -Force).Count -eq 0) { Remove-Item $path -Force }
    }
}

function Restore-Transaction([string] $RestoreManifestPath) {
    $resolvedManifest = [System.IO.Path]::GetFullPath($RestoreManifestPath)
    if (-not (Test-Path $resolvedManifest -PathType Leaf)) { throw "Restore manifest not found: $resolvedManifest" }
    $transaction = Get-Content $resolvedManifest -Raw | ConvertFrom-Json
    if ([string]$transaction.homePath -ne $homeRoot) { throw "Restore manifest belongs to a different HomePath" }
    if ([string]$transaction.status -ne "completed") { throw "Restore requires a completed manifest; status is $($transaction.status)" }
    $manifestDirectory = Split-Path $resolvedManifest -Parent
    $state = Read-SyncState

    foreach ($entry in @($transaction.entries)) {
        $target = Get-ContainedPath -Root $homeRoot -RelativePath ([string]$entry.relativeTarget) -Label "Restore target"
        if ($target -ne [System.IO.Path]::GetFullPath([string]$entry.targetPath)) { throw "Restore target does not match declared ownership: $($entry.relativeTarget)" }
        $stateEntry = Get-StateEntry $state ([string]$entry.relativeTarget)
        $currentHash = Get-PathHash $target
        if ($null -eq $stateEntry -or [string]$stateEntry.ownerId -ne [string]$transaction.id -or [string]$currentHash -ne [string]$entry.installedHash) {
            throw "Ownership mismatch for restore target: $($entry.relativeTarget)"
        }
        if ([bool]$entry.hadOriginal) {
            $backupPath = Get-ContainedPath -Root $manifestDirectory -RelativePath ([string]$entry.backupRelative) -Label "Backup path"
            if (-not (Test-Path $backupPath) -or (Get-PathHash $backupPath) -ne [string]$entry.backupHash) {
                throw "Backup hash mismatch for restore target: $($entry.relativeTarget)"
            }
        }
    }

    $restoreStage = Join-Path $stateRoot "restore-staging/$([guid]::NewGuid().ToString('N'))"
    [void](New-Item -ItemType Directory -Path $restoreStage -Force)
    foreach ($entry in @($transaction.entries)) {
        if (Test-Path ([string]$entry.targetPath)) { Copy-ManagedPath ([string]$entry.targetPath) (Join-Path $restoreStage ([string]$entry.index)) }
    }
    $restored = @()
    try {
        foreach ($entry in @($transaction.entries | Sort-Object index -Descending)) {
            $target = Get-ContainedPath -Root $homeRoot -RelativePath ([string]$entry.relativeTarget) -Label "Restore target"
            $restored += $entry
            Remove-ManagedPath $target
            if ([bool]$entry.hadOriginal) {
                $backupPath = Get-ContainedPath -Root $manifestDirectory -RelativePath ([string]$entry.backupRelative) -Label "Backup path"
                Copy-ManagedPath $backupPath $target
            }
            if ($env:AGENTS_SYNC_FAIL_RESTORE_AFTER -and $restored.Count -ge [int]$env:AGENTS_SYNC_FAIL_RESTORE_AFTER) {
                throw "Injected restore failure after $($restored.Count) target(s)"
            }
        }
    } catch {
        $restoreFailure = $_
        foreach ($entry in @($restored | Sort-Object index)) {
            $target = Get-ContainedPath -Root $homeRoot -RelativePath ([string]$entry.relativeTarget) -Label "Restore rollback target"
            Remove-ManagedPath $target
            $staged = Join-Path $restoreStage ([string]$entry.index)
            if (Test-Path $staged) { Copy-ManagedPath $staged $target }
        }
        Remove-ManagedPath $restoreStage
        throw $restoreFailure
    }
    Remove-ManagedPath $restoreStage
    if ($transaction.PSObject.Properties.Name -contains "claudeSettings" -and $null -ne $transaction.claudeSettings) {
        $claudeSettingsPath = Join-Path $homeRoot ".claude/settings.json"
        if ([bool]$transaction.claudeSettings.hadOriginal) {
            Copy-Item (Join-Path $manifestDirectory $transaction.claudeSettings.backupRelative) $claudeSettingsPath -Force
        } elseif (Test-Path $claudeSettingsPath) {
            Remove-Item $claudeSettingsPath -Force
        }
    }
    Remove-EmptyCreatedDirs $transaction.entries

    $restoredEntries = @()
    $restoredTargets = @($transaction.entries.relativeTarget)
    foreach ($entry in @($state.entries)) {
        if ($restoredTargets -notcontains [string]$entry.relativeTarget) { $restoredEntries += $entry }
    }
    foreach ($entry in @($transaction.entries)) {
        if ($null -ne $entry.previousStateEntry) { $restoredEntries += $entry.previousStateEntry }
    }
    Write-JsonFile $statePath ([pscustomobject]@{ schemaVersion = 1; entries = @($restoredEntries) })
    $transaction.status = "restored"
    $transaction.restoredAtUtc = [DateTime]::UtcNow.ToString("o")
    Write-JsonFile $resolvedManifest $transaction
    Write-Host "Restored transaction $($transaction.id)." -ForegroundColor Green
}

if ($Restore) {
    if ($WhatIfPreference) { throw "-WhatIf cannot be combined with -Restore" }
    Restore-Transaction $Restore
    exit 0
}

function Invoke-ClaudeSettings([switch] $CheckOnly, [switch] $DryRun) {
    $parameters = @{ HomePath = $homeRoot }
    if ($CheckOnly) { $parameters.Check = $true }
    if ($DryRun) { $parameters.WhatIf = $true }
    & (Join-Path $PSScriptRoot "sync-claude-settings.ps1") @parameters | Out-Host
    return $LASTEXITCODE
}

foreach ($install in @($runtimeManifest.installTargets)) {
    $path = Join-Path $homeRoot ([string]$install.targetPath)
    if ((Test-Path -LiteralPath $path) -and ((Get-Item -LiteralPath $path -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw "~/$($install.targetPath) es un symlink/junction (instalación vieja). Borrá sólo el link con: cmd /c rmdir `"$path`"  (no borra el repo) y volvé a correr."
    }
}

$targets = Get-SyncTargets

$expected = @{}
foreach ($target in $targets) { $expected[$target.relativeTarget] = $true }
$staleTargets = @()
foreach ($root in $script:mergeRoots) {
    $foreign = @(Get-ForeignEntries $root.targetPath $root.relativeTarget $expected | Where-Object { -not (Test-Preserved $_) -and -not (Test-ExternalSkill $_) })
    $stale = @($foreign | Where-Object { Test-StaleEntry $_ })
    $keep = @($foreign | Where-Object { -not (Test-StaleEntry $_) })
    if ($keep.Count -gt 0) {
        Write-Warning "$($root.relativeTarget): $($keep.Count) item(s) fuera del repo; se conservan sin tocar:"
        foreach ($item in $keep) { Write-Host "  [keep] $item" -ForegroundColor Yellow }
    }
    foreach ($item in $stale) {
        $staleTargets += [pscustomobject]@{ client = $root.client; kind = "remove"; relativeTarget = $item; sourcePath = $null; targetPath = (Get-ContainedPath -Root $homeRoot -RelativePath $item -Label "Stale path") }
    }
}
if ($staleTargets.Count -gt 0) {
    Write-Warning "$($staleTargets.Count) copia(s) viejas del repo (movidas o retiradas) se quitan con -Force, con backup:"
    foreach ($item in $staleTargets) { Write-Host "  [stale] $($item.relativeTarget)" -ForegroundColor Yellow }
}

if ($Check) {
    $drift = @()
    foreach ($target in $targets) {
        $exists = Test-Path $target.targetPath
        if ($exists -and (Test-Preserved $target.relativeTarget)) { continue }
        if (-not $exists) { $drift += [pscustomobject]@{ status = "missing"; target = $target.relativeTarget; client = $target.client }; continue }
        if ((Get-PathHash $target.targetPath) -ne (Get-PathHash $target.sourcePath)) {
            $drift += [pscustomobject]@{ status = "drift"; target = $target.relativeTarget; client = $target.client }
        }
    }
    foreach ($item in $drift) { Write-Host ("[{0}] {1} ({2})" -f $item.status.ToUpper(), $item.target, $item.client) -ForegroundColor Red }
    foreach ($item in $staleTargets) { $drift += [pscustomobject]@{ status = "stale"; target = $item.relativeTarget; client = $item.client } }
    foreach ($item in $drift | Where-Object { $_.status -eq "stale" }) { Write-Host ("[STALE] {0} ({1})" -f $item.target, $item.client) -ForegroundColor Red }
    $settingsExit = Invoke-ClaudeSettings -CheckOnly
    if ($drift.Count -gt 0 -or $settingsExit -ne 0) {
        Write-Host "$($drift.Count) destino(s) distintos del repo. Corré sync-runtime.ps1 para actualizarlos." -ForegroundColor Red
        exit 1
    }
    Write-Host "Sin drift: $($targets.Count) destinos iguales al repo." -ForegroundColor Green
    exit 0
}

$state = Read-SyncState
$validTargets = @()
$skipped = @()
foreach ($target in $targets) {
    if (-not (Test-Path $target.targetPath)) { $validTargets += $target; continue }
    if (Test-Preserved $target.relativeTarget) { continue }
    $stateEntry = Get-StateEntry $state $target.relativeTarget
    $currentHash = Get-PathHash $target.targetPath
    if ($currentHash -eq (Get-PathHash $target.sourcePath)) { continue }
    if ($null -eq $stateEntry) {
        if (-not $Force) { $skipped += "unmanaged: $($target.relativeTarget)"; continue }
    } elseif ($currentHash -ne [string]$stateEntry.installedHash) {
        if (-not $Force) { $skipped += "drift: $($target.relativeTarget)"; continue }
    }
    $validTargets += $target
}
if ($Force) { $validTargets += $staleTargets }
$targets = $validTargets
if ($skipped.Count -gt 0) {
    Write-Warning "$($skipped.Count) destino(s) existentes distintos del repo; no se tocan sin -Force (que reemplaza sólo esos, con backup):"
    foreach ($item in $skipped) { Write-Host "  $item" -ForegroundColor Yellow }
}
if ($targets.Count -eq 0 -and -not $WhatIfPreference) {
    Write-Host "Archivos: nada para actualizar." -ForegroundColor Green
    exit (Invoke-ClaudeSettings)
}

if ($WhatIfPreference) {
    foreach ($target in $targets) { Write-Host "[WhatIf] $($target.relativeTarget) <= $($target.sourcePath)" }
    [void](Invoke-ClaudeSettings -DryRun)
    exit 0
}

$transactionId = "$(Get-Date -Format 'yyyyMMdd-HHmmssfff')-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
$stagingRoot = Join-Path $stateRoot "staging/$transactionId"
$backupRoot = Join-Path $stateRoot "backups/$transactionId"
$transactionManifestPath = Join-Path $backupRoot "manifest.json"
[void](New-Item -ItemType Directory -Path $stagingRoot -Force)
[void](New-Item -ItemType Directory -Path $backupRoot -Force)
$entries = @()

for ($index = 0; $index -lt $targets.Count; $index++) {
    $target = $targets[$index]
    $stagePath = Join-Path $stagingRoot "$index"
    if ($target.kind -eq "remove") {
        $sourceHash = $null
    } else {
        Copy-StagedSource $target.sourcePath $stagePath
        $sourceHash = Get-PathHash $stagePath
    }
    $hadOriginal = Test-Path $target.targetPath
    $backupRelative = $null
    $backupHash = $null
    if ($hadOriginal) {
        $backupRelative = "items/$index"
        $backupPath = Join-Path $backupRoot "items/$index"
        Copy-ManagedPath $target.targetPath $backupPath
        $backupHash = Get-PathHash $backupPath
        if ($backupHash -ne (Get-PathHash $target.targetPath)) { throw "Backup verification failed for $($target.relativeTarget)" }
    }
    $entries += [pscustomobject]@{
        index = $index
        client = $target.client
        kind = $target.kind
        relativeTarget = $target.relativeTarget
        targetPath = $target.targetPath
        sourceHash = $sourceHash
        installedHash = $sourceHash
        hadOriginal = [bool]$hadOriginal
        backupRelative = $backupRelative
        backupHash = $backupHash
        createdDirs = @(Get-MissingAncestors $target.targetPath)
        previousStateEntry = Get-StateEntry $state $target.relativeTarget
    }
}

$transaction = [pscustomobject]@{
    schemaVersion = 1
    id = $transactionId
    status = "prepared"
    homePath = $homeRoot
    createdAtUtc = [DateTime]::UtcNow.ToString("o")
    completedAtUtc = $null
    restoredAtUtc = $null
    rolledBackAtUtc = $null
    failure = $null
    entries = @($entries)
}
Write-JsonFile $transactionManifestPath $transaction

$replaced = @()
try {
    foreach ($entry in @($entries)) {
        $target = $targets[[int]$entry.index]
        $replaced += $entry
        Remove-ManagedPath $target.targetPath
        $parent = Split-Path $target.targetPath -Parent
        if (-not (Test-Path $parent)) { [void](New-Item -ItemType Directory -Path $parent -Force) }
        if ($env:AGENTS_SYNC_FAIL_BEFORE_MOVE_AT -and $replaced.Count -ge [int]$env:AGENTS_SYNC_FAIL_BEFORE_MOVE_AT) {
            throw "Injected failure before move $($replaced.Count)"
        }
        if ($target.kind -eq "remove") { Remove-Item $target.targetPath -Recurse -Force -ErrorAction SilentlyContinue } else { Move-Item (Join-Path $stagingRoot "$($entry.index)") $target.targetPath }
        if ($env:AGENTS_SYNC_FAIL_AFTER_REPLACE -and $replaced.Count -ge [int]$env:AGENTS_SYNC_FAIL_AFTER_REPLACE) {
            throw "Injected failure after replacement $($replaced.Count)"
        }
    }
    $stateEntries = @()
    $managedTargets = @($entries.relativeTarget)
    foreach ($existing in @($state.entries)) {
        if ($managedTargets -notcontains [string]$existing.relativeTarget) { $stateEntries += $existing }
    }
    foreach ($entry in @($entries)) {
        $stateEntries += [pscustomobject]@{
            relativeTarget = $entry.relativeTarget
            installedHash = $entry.installedHash
            ownerId = $transactionId
            manifestPath = $transactionManifestPath
        }
    }
    Write-JsonFile $statePath ([pscustomobject]@{ schemaVersion = 1; entries = @($stateEntries) })
    $transaction.status = "completed"
    $transaction.completedAtUtc = [DateTime]::UtcNow.ToString("o")
    Write-JsonFile $transactionManifestPath $transaction
    Remove-ManagedPath $stagingRoot
    # Estado previo de ~/.claude/settings.json para que -Restore también lo revierta.
    $claudeSettingsPath = Join-Path $homeRoot ".claude/settings.json"
    $hadSettings = Test-Path $claudeSettingsPath -PathType Leaf
    if ($hadSettings) { Copy-Item $claudeSettingsPath (Join-Path $backupRoot "claude-settings.json") }
    $transaction | Add-Member -NotePropertyName claudeSettings -NotePropertyValue ([pscustomobject]@{ hadOriginal = $hadSettings; backupRelative = "claude-settings.json" }) -Force
    Write-JsonFile $transactionManifestPath $transaction
    Write-Host "Runtime sync completed for $homeRoot." -ForegroundColor Green
    Write-Host "Backup manifest: $transactionManifestPath"
} catch {
    $failure = $_
    foreach ($entry in @($replaced | Sort-Object index -Descending)) {
        $target = $targets[[int]$entry.index]
        Remove-ManagedPath $target.targetPath
        if ([bool]$entry.hadOriginal) {
            Copy-ManagedPath (Join-Path $backupRoot "items/$($entry.index)") $target.targetPath
        }
    }
    Remove-EmptyCreatedDirs $replaced
    $transaction.status = "rolled-back"
    $transaction.failure = $failure.Exception.Message
    $transaction.rolledBackAtUtc = [DateTime]::UtcNow.ToString("o")
    Write-JsonFile $transactionManifestPath $transaction
    Remove-ManagedPath $stagingRoot
    Write-Host "Backup manifest: $transactionManifestPath"
    throw $failure
}

exit (Invoke-ClaudeSettings)
