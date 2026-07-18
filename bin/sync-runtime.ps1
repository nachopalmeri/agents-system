#!/usr/bin/env pwsh
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch] $Force,
    [string] $Restore,
    [string] $HomePath = $env:USERPROFILE
)

$ErrorActionPreference = "Stop"
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$manifestPath = Join-Path $repoRoot "config\runtime-manifest.json"
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
    $relative = [System.IO.Path]::GetFullPath($SourcePath).Substring($repoRoot.Length).TrimStart('\').Replace('\', '/')
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

function Get-SyncTargets {
    $targets = @()
    foreach ($install in @($runtimeManifest.installTargets)) {
        $source = Get-ContainedPath -Root $repoRoot -RelativePath ([string]$install.sourcePath) -Label "Source path"
        $target = Get-ContainedPath -Root $homeRoot -RelativePath ([string]$install.targetPath) -Label "Target path"
        $targets += [pscustomobject]@{
            client = [string]$install.client
            kind = [string]$install.kind
            relativeTarget = ([string]$install.targetPath).Replace('\', '/')
            sourcePath = $source
            targetPath = $target
        }
    }
    foreach ($adapter in @($runtimeManifest.adapters | Where-Object { $_.globalTarget })) {
        $source = Get-ContainedPath -Root $repoRoot -RelativePath ([string]$adapter.repoPath) -Label "Source path"
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
        if ($null -eq $stateEntry -or [string]$stateEntry.ownerId -ne [string]$transaction.id -or $currentHash -ne [string]$entry.installedHash) {
            throw "Ownership mismatch for restore target: $($entry.relativeTarget)"
        }
        if ([bool]$entry.hadOriginal) {
            $backupPath = Get-ContainedPath -Root $manifestDirectory -RelativePath ([string]$entry.backupRelative) -Label "Backup path"
            if (-not (Test-Path $backupPath) -or (Get-PathHash $backupPath) -ne [string]$entry.backupHash) {
                throw "Backup hash mismatch for restore target: $($entry.relativeTarget)"
            }
        }
    }

    $restoreStage = Join-Path $stateRoot "restore-staging\$([guid]::NewGuid().ToString('N'))"
    [void](New-Item -ItemType Directory -Path $restoreStage -Force)
    foreach ($entry in @($transaction.entries)) {
        Copy-ManagedPath ([string]$entry.targetPath) (Join-Path $restoreStage ([string]$entry.index))
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
            Copy-ManagedPath (Join-Path $restoreStage ([string]$entry.index)) $target
        }
        Remove-ManagedPath $restoreStage
        throw $restoreFailure
    }
    Remove-ManagedPath $restoreStage

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

$targets = Get-SyncTargets
$state = Read-SyncState
$validTargets = @()
foreach ($target in $targets) {
    if (-not (Test-Path $target.targetPath)) { $validTargets += $target; continue }
    $stateEntry = Get-StateEntry $state $target.relativeTarget
    $currentHash = Get-PathHash $target.targetPath
    if ($null -eq $stateEntry) {
        if (-not $Force) { Write-Warning "Unmanaged target detected at $($target.targetPath); skipping. Use -Force to overwrite."; continue }
    } elseif ($currentHash -ne [string]$stateEntry.installedHash) {
        if (-not $Force) { Write-Warning "Managed drift detected at $($target.targetPath); skipping. Use -Force to overwrite."; continue }
    }
    $validTargets += $target
}
$targets = $validTargets

if ($WhatIfPreference) {
    foreach ($target in $targets) { Write-Host "[WhatIf] $($target.relativeTarget) <= $($target.sourcePath)" }
    exit 0
}

$transactionId = "$(Get-Date -Format 'yyyyMMdd-HHmmssfff')-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
$stagingRoot = Join-Path $stateRoot "staging\$transactionId"
$backupRoot = Join-Path $stateRoot "backups\$transactionId"
$transactionManifestPath = Join-Path $backupRoot "manifest.json"
[void](New-Item -ItemType Directory -Path $stagingRoot -Force)
[void](New-Item -ItemType Directory -Path $backupRoot -Force)
$entries = @()

for ($index = 0; $index -lt $targets.Count; $index++) {
    $target = $targets[$index]
    $stagePath = Join-Path $stagingRoot "$index"
    Copy-StagedSource $target.sourcePath $stagePath
    $sourceHash = Get-PathHash $stagePath
    $hadOriginal = Test-Path $target.targetPath
    $backupRelative = $null
    $backupHash = $null
    if ($hadOriginal) {
        $backupRelative = "items/$index"
        $backupPath = Join-Path $backupRoot "items\$index"
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
        Move-Item (Join-Path $stagingRoot "$($entry.index)") $target.targetPath
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
    Write-Host "Runtime sync completed for $homeRoot." -ForegroundColor Green
    Write-Host "Backup manifest: $transactionManifestPath"
} catch {
    $failure = $_
    foreach ($entry in @($replaced | Sort-Object index -Descending)) {
        $target = $targets[[int]$entry.index]
        Remove-ManagedPath $target.targetPath
        if ([bool]$entry.hadOriginal) {
            Copy-ManagedPath (Join-Path $backupRoot "items\$($entry.index)") $target.targetPath
        }
    }
    $transaction.status = "rolled-back"
    $transaction.failure = $failure.Exception.Message
    $transaction.rolledBackAtUtc = [DateTime]::UtcNow.ToString("o")
    Write-JsonFile $transactionManifestPath $transaction
    Remove-ManagedPath $stagingRoot
    Write-Host "Backup manifest: $transactionManifestPath"
    throw $failure
}

exit 0
