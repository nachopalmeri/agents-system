#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [string] $Client,
    [string] $HomePath = $env:USERPROFILE
)

$ErrorActionPreference = "Stop"
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$homeRoot = [System.IO.Path]::GetFullPath($HomePath).TrimEnd('\', '/')
$manifest = Get-Content (Join-Path $repoRoot "config\runtime-manifest.json") -Raw | ConvertFrom-Json
$canonicalSource = Join-Path $repoRoot ([string]$manifest.canonicalPath)
$canonicalTarget = Join-Path $homeRoot ([string]$manifest.canonicalPath)
$canonicalSourceHash = (Get-FileHash $canonicalSource -Algorithm SHA256).Hash.ToLowerInvariant()
$script:hasInvalidInstall = $false

function Get-FileSha256([string] $Path) {
    if (-not (Test-Path $Path -PathType Leaf)) { return $null }
    return (Get-FileHash $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

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
    if ($null -eq $configTarget) { return [pscustomobject]@{ Ok = $false; Detail = "preload target undeclared" } }
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
        if ($canonical.Status -eq "unsupported") { $script:hasInvalidInstall = $true }
        return
    }

    $adapter = @($manifest.adapters | Where-Object { ([string]$_.client) -eq $Name }) | Select-Object -First 1
    if ($null -eq $adapter) {
        Write-Status "unsupported" $Name "client is not declared in runtime manifest"
        return
    }
    if (-not $adapter.globalTarget) {
        Write-Status "unsupported" $Name "repository-only adapter; no global install target"
        return
    }
    $targetPath = Join-Path $homeRoot ([string]$adapter.globalTarget)
    if (-not (Test-Path $targetPath -PathType Leaf)) {
        Write-Status "not-installed" $Name $targetPath
        return
    }
    $sourcePath = Join-Path $repoRoot ([string]$adapter.repoPath)
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
        if ($canonical.Status -eq "unsupported") { $script:hasInvalidInstall = $true }
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

Write-Host "Agents System Doctor"
Write-Host "Repo: $repoRoot"
Write-Host "Home: $homeRoot"

if ($Client) {
    Test-Client $Client.ToLowerInvariant()
} else {
    Test-Client "cli"
    foreach ($adapter in @($manifest.adapters)) { Test-Client ([string]$adapter.client) }
}

if ($script:hasInvalidInstall) { exit 1 }
exit 0
