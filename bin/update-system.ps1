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

$syncScript = Join-Path $repoRoot "bin/sync-runtime.ps1"
if (-not (Test-Path $syncScript -PathType Leaf)) { throw "sync-runtime.ps1 not found: $syncScript" }
$parameters = @{ HomePath = $HomePath }
if ($dry) { $parameters.WhatIf = $true }
if ($Force) { $parameters.Force = $true }
Write-Host "update-system delegates to managed runtime sync."
& $syncScript @parameters
$syncExit = $LASTEXITCODE
if ($dry -or $syncExit -ne 0) { exit $syncExit }

# Verificación automática post-sync: repo coherente y copias iguales al repo.
& (Join-Path $repoRoot "bin/check-runtime-graph.ps1")
$graphExit = $LASTEXITCODE
& $syncScript -HomePath $HomePath -Check
$checkExit = $LASTEXITCODE
if ($graphExit -ne 0 -or $checkExit -ne 0) { Write-Host "Post-sync: hay problemas (ver arriba)." -ForegroundColor Red; exit 1 }
Write-Host "Post-sync: todo verificado." -ForegroundColor Green
exit 0
