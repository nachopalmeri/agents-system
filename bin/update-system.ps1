#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [string] $RepoPath = ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))),
    [string] $HomePath = $env:USERPROFILE,
    [switch] $SkipPull,
    [switch] $DryRun,
    [switch] $WhatIf,
    [switch] $Force,
    [switch] $VerboseOutput
)

$ErrorActionPreference = "Stop"
$dry = $DryRun -or $WhatIf
$repoRoot = [System.IO.Path]::GetFullPath($RepoPath)
if (-not (Test-Path (Join-Path $repoRoot ".git"))) { throw "RepoPath is not a git worktree: $repoRoot" }

if (-not $SkipPull) {
    if ($dry) {
        Write-Host "[WhatIf] git -C $repoRoot pull"
    } else {
        $output = & git -C $repoRoot pull 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { throw "git pull failed:`n$output" }
        if ($VerboseOutput) { Write-Host $output }
    }
}

$syncScript = Join-Path $repoRoot "bin\sync-runtime.ps1"
if (-not (Test-Path $syncScript -PathType Leaf)) { throw "sync-runtime.ps1 not found: $syncScript" }
$parameters = @{ HomePath = $HomePath }
if ($dry) { $parameters.WhatIf = $true }
if ($Force) { $parameters.Force = $true }
Write-Host "update-system delegates to managed runtime sync."
& $syncScript @parameters
exit $LASTEXITCODE
