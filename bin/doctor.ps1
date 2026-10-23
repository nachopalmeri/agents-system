#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [string] $Client,
    [switch] $GlobalCommands,
    [string] $HomePath = $env:USERPROFILE
)

$ErrorActionPreference = "Stop"
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$homeRoot = [System.IO.Path]::GetFullPath($HomePath).TrimEnd('\', '/')

function Get-FileSha256([string] $Path) {
    if (-not (Test-Path $Path -PathType Leaf)) { return $null }
    $content = [System.IO.File]::ReadAllText($Path)
    $normalized = $content.Replace("`r`n", "`n")
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($normalized)
    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    $hash = ($algorithm.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""
    $algorithm.Dispose()
    return $hash
}

$manifest = Get-Content (Join-Path $repoRoot "config\runtime-manifest.json") -Raw | ConvertFrom-Json
$canonicalSource = Join-Path $repoRoot ([string]$manifest.canonicalPath)
$canonicalTarget = Join-Path $homeRoot ([string]$manifest.canonicalPath)
$canonicalSourceHash = Get-FileSha256 $canonicalSource
$script:hasInvalidInstall = $false

function Write-Status([string] $Status, [string] $Name, [string] $Detail) {
    Write-Host "[$Status] $Name - $Detail"
}

function Test-CanonicalInstall {
    if (-not (Test-Path $canonicalTarget -PathType Leaf)) {
        return [pscustomobject]@{ Status = "not-installed"; Hash = $null; Detail = "canonical runtime missing" }
    }
    $installedHash = Get-FileSha256 $canonicalTarget
    if ($installedHash -ne $canonicalSourceHash) {
        return [pscustomobject]@{ Status = "unsupported"; Hash = $installedHash; Detail = "canonical hash mismatch" }
    }
    return [pscustomobject]@{ Status = "supported"; Hash = $installedHash; Detail = "canonical-sha256=$installedHash" }
}

function Test-OpenCodePreload {
    $configTarget = @($manifest.installTargets | Where-Object { $_.client -eq "opencode" -and $_.targetPath -match 'opencode\.jsonc$' }) | Select-Object -First 1
    if ($null -eq $configTarget) { return [pscustomobject]@{ Ok = $true; Detail = "native AGENTS.md discovery; personal OpenCode config is unmanaged" } }
    $path = Join-Path $homeRoot ([string]$configTarget.targetPath)
    if (-not (Test-Path $path -PathType Leaf)) { return [pscustomobject]@{ Ok = $false; Detail = "preload config missing" } }
    $sourcePath = Join-Path $repoRoot ([string]$configTarget.sourcePath)
    $sourceHash = Get-FileSha256 $sourcePath
    $installedHash = Get-FileSha256 $path
    if ($sourceHash -ne $installedHash) {
        return [pscustomobject]@{ Ok = $false; Detail = "config hash mismatch; config-sha256=$installedHash expected=$sourceHash" }
    }
    try {
        $config = Get-Content $path -Raw | ConvertFrom-Json
    } catch {
        return [pscustomobject]@{ Ok = $false; Detail = "preload config invalid" }
    }
    $actual = @($config.instructions | ForEach-Object { ([string]$_).Replace("~/.agents/", ".agents/") })
    $expected = @($manifest.preloadAllowlist)
    if (($actual -join "|") -cne ($expected -join "|")) {
        return [pscustomobject]@{ Ok = $false; Detail = "preload mismatch" }
    }
    return [pscustomobject]@{ Ok = $true; Detail = "config-sha256=$installedHash; preload=ok" }
}

function Test-Client([string] $Name) {
    if ($Name -eq "cli") {
        $canonical = Test-CanonicalInstall
        Write-Status $canonical.Status "cli" $canonical.Detail
        if ($canonical.Status -eq "unsupported" -or (($Client -or $GlobalCommands) -and $canonical.Status -eq "not-installed")) { $script:hasInvalidInstall = $true }
        return
    }

    $adapter = @($manifest.adapters | Where-Object { ([string]$_.client) -eq $Name }) | Select-Object -First 1
    if ($null -eq $adapter) {
        Write-Status "unsupported" $Name "client is not declared in runtime manifest"
        if ($Client) { $script:hasInvalidInstall = $true }
        return
    }
    if (-not $adapter.globalTarget) {
        Write-Status "unsupported" $Name "repository-only adapter; no global install target"
        return
    }
    $targetPath = Join-Path $homeRoot ([string]$adapter.globalTarget)
    if (-not (Test-Path $targetPath -PathType Leaf)) {
        Write-Status "not-installed" $Name $targetPath
        if ($Client -or $GlobalCommands) { $script:hasInvalidInstall = $true }
        return
    }
    $sourceRelative = if ($adapter.globalSourcePath) { [string]$adapter.globalSourcePath } else { [string]$adapter.repoPath }
    $sourcePath = Join-Path $repoRoot $sourceRelative
    $sourceHash = Get-FileSha256 $sourcePath
    $targetHash = Get-FileSha256 $targetPath
    if ($sourceHash -ne $targetHash) {
        Write-Status "unsupported" $Name "hash mismatch; sha256=$targetHash expected=$sourceHash"
        $script:hasInvalidInstall = $true
        return
    }
    $canonical = Test-CanonicalInstall
    if ($canonical.Status -ne "supported") {
        Write-Status $canonical.Status $Name "$($canonical.Detail); sha256=$targetHash"
        $script:hasInvalidInstall = $true
        return
    }
    if ($Name -eq "opencode") {
        $preload = Test-OpenCodePreload
        if (-not $preload.Ok) {
            Write-Status "unsupported" $Name "$($preload.Detail); sha256=$targetHash"
            $script:hasInvalidInstall = $true
            return
        }
        Write-Status "supported" $Name "sha256=$targetHash; canonical-sha256=$canonicalSourceHash; $($preload.Detail)"
        return
    }
    Write-Status "supported" $Name "sha256=$targetHash; canonical-sha256=$canonicalSourceHash"
}

function Test-PreservedResource([string] $RelativeTarget) {
    foreach ($path in @($manifest.preserveIfExists)) {
        $prefix = ([string]$path).Replace('\', '/').Trim('/')
        if (($RelativeTarget -eq $prefix -or $RelativeTarget.StartsWith("$prefix/", [StringComparison]::OrdinalIgnoreCase)) -and
            (Test-Path -LiteralPath (Join-Path $homeRoot $prefix))) { return $true }
    }
    return $false
}

function Test-InstalledResources {
    # Common runtime/delegation files are shared dependencies of every installed client.
    # A selected client must not receive missing reports for unrelated client exports.
    $targets = @($manifest.installTargets | Where-Object {
        -not $Client -or $_.client -in @('cli', 'delegation', $Client.ToLowerInvariant())
    })
    foreach ($entry in $targets) {
        $name = "$($entry.client) resource $($entry.targetPath)"
        $target = Join-Path $homeRoot ([string]$entry.targetPath)
        $source = Join-Path $repoRoot ([string]$entry.sourcePath)
        if ($entry.kind -eq 'directory') {
            if (-not (Test-Path -LiteralPath $target -PathType Container)) {
                Write-Status 'not-installed' $name 'managed directory missing; rerun sync-runtime.ps1'
                $script:hasInvalidInstall = $true
                continue
            }
            $missing = @()
            foreach ($file in @(Get-ChildItem -LiteralPath $source -File -Recurse -Force)) {
                # Match sync's manifest exclusions, including bare directory names at any depth.
                $sourceRelative = [IO.Path]::GetRelativePath($repoRoot, $file.FullName).Replace('\', '/')
                $excluded = $false
                foreach ($path in @($manifest.excludedRuntimePaths)) {
                    $prefix = ([string]$path).Replace('\', '/').Trim('/')
                    if ($sourceRelative -eq $prefix -or $sourceRelative.StartsWith("$prefix/", [StringComparison]::OrdinalIgnoreCase) -or
                        (-not $prefix.Contains('/') -and ("/$sourceRelative/").IndexOf("/$prefix/", [StringComparison]::OrdinalIgnoreCase) -ge 0)) {
                        $excluded = $true
                        break
                    }
                }
                if ($excluded) { continue }
                $relative = [IO.Path]::GetRelativePath($source, $file.FullName)
                $targetRelative = "$($entry.targetPath)/$relative".Replace('\', '/')
                if (Test-PreservedResource $targetRelative) { continue }
                if (-not (Test-Path -LiteralPath (Join-Path $target $relative) -PathType Leaf)) { $missing += $relative }
            }
            foreach ($relative in $missing) {
                Write-Status 'not-installed' "$name/$relative" 'managed file missing; rerun sync-runtime.ps1'
                $script:hasInvalidInstall = $true
            }
            if ($missing.Count -eq 0) { Write-Status 'supported' $name 'managed files present; content drift not checked' }
        } elseif (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
            Write-Status 'not-installed' $name 'managed file missing; rerun sync-runtime.ps1'
            $script:hasInvalidInstall = $true
        } else { Write-Status 'supported' $name 'managed file present; content drift not checked' }
    }
}

function Test-InstalledHooks {
    # Git resolves core.hooksPath and linked-worktree hooks; do not assume .git/hooks.
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Status 'unsupported' 'git hooks' 'Git unavailable; presence cannot be checked'
        $script:hasInvalidInstall = $true
        return
    }
    $hooksPath = & git -C $repoRoot rev-parse --git-path hooks 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($hooksPath)) {
        Write-Status 'unsupported' 'git hooks' 'cannot resolve effective hooks directory'
        $script:hasInvalidInstall = $true
        return
    }
    $hooksPath = $hooksPath.Trim()
    if (-not [IO.Path]::IsPathRooted($hooksPath)) { $hooksPath = Join-Path $repoRoot $hooksPath }
    foreach ($hook in @('pre-commit','pre-push')) {
        if (Test-Path -LiteralPath (Join-Path $hooksPath $hook) -PathType Leaf) {
            Write-Status 'present' "git hook $hook" 'effective hook file exists; ownership and execution not verified'
        } else {
            Write-Status 'not-installed' "git hook $hook" 'effective hook file missing; review bin/install-hooks.ps1'
            $script:hasInvalidInstall = $true
        }
    }
}

Write-Host "Agents System Doctor"
Write-Host "Repo: $repoRoot"
Write-Host "Home: $homeRoot"
Write-Host 'Scope: installed filesystem only; client-loaded instructions, model skill activation and tool availability not verified.'

if ($Client) {
    Test-Client $Client.ToLowerInvariant()
} else {
    Test-Client "cli"
    foreach ($adapter in @($manifest.adapters)) { Test-Client ([string]$adapter.client) }
}

if ($GlobalCommands) {
    Test-InstalledResources
    Test-InstalledHooks
    foreach ($entry in @($manifest.installTargets | Where-Object { $_.targetPath -match '^bin/agents\.(ps1|cmd)$' })) {
        $target = Join-Path $homeRoot $entry.targetPath
        $expected = Get-FileSha256 (Join-Path $repoRoot $entry.sourcePath)
        if ((Get-FileSha256 $target) -ne $expected) {
            Write-Status 'unsupported' $entry.targetPath 'missing or drifted global command; rerun setup-global-runtime.ps1'
            $script:hasInvalidInstall = $true
        } else { Write-Status 'supported' $entry.targetPath 'managed global command' }
    }
    $pointerPath = Join-Path $homeRoot '.agents/local-runtime.json'
    if (-not (Test-Path -LiteralPath $pointerPath)) {
        Write-Status 'not-installed' 'global checkout' 'run bin/setup-global-runtime.ps1'
        $script:hasInvalidInstall = $true
    } else {
        try {
            $pointer = Get-Content -LiteralPath $pointerPath -Raw | ConvertFrom-Json
            if ([IO.Path]::GetFullPath([string]$pointer.repoPath) -ne $repoRoot) { throw 'Registered checkout differs from the one being checked.' }
            Write-Status 'supported' 'global checkout' 'registered local checkout'
        } catch { Write-Status 'unsupported' 'global checkout' 'invalid or mismatched pointer'; $script:hasInvalidInstall = $true }
    }
}
if ($script:hasInvalidInstall) { exit 1 }
exit 0
