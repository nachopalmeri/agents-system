#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [string] $RepoUrl = "https://github.com/nachopalmeri/agents-system.git",
    [string] $Branch = "main",
    [string] $RepoPath,
    [string] $HomePath = $env:USERPROFILE,
    [switch] $WhatIf,
    [switch] $Force
)

$ErrorActionPreference = "Stop"
if (-not $RepoPath) {
    $currentRepo = [System.IO.Path]::GetFullPath($PSScriptRoot)
    if (Test-Path (Join-Path $currentRepo ".git")) {
        $RepoPath = $currentRepo
    } else {
        $RepoPath = Join-Path $HomePath "agents-system"
    }
}
$repoRoot = [System.IO.Path]::GetFullPath($RepoPath)

if (-not (Test-Path (Join-Path $repoRoot ".git"))) {
    if ($WhatIf) {
        Write-Host "[WhatIf] git clone --branch $Branch $RepoUrl $repoRoot"
        exit 0
    }
    & git clone --branch $Branch $RepoUrl $repoRoot
    if ($LASTEXITCODE -ne 0) { throw "git clone failed for $RepoUrl" }
} elseif ($WhatIf) {
    Write-Host "[WhatIf] repository update skipped for $repoRoot"
} else {
    & git -C $repoRoot pull origin $Branch
    if ($LASTEXITCODE -ne 0) { throw "git pull failed for $repoRoot" }
}

$syncScript = Join-Path $repoRoot "bin\sync-runtime.ps1"
if (-not (Test-Path $syncScript -PathType Leaf)) { throw "sync-runtime.ps1 not found: $syncScript" }
$parameters = @{ HomePath = $HomePath }
if ($WhatIf) { $parameters.WhatIf = $true }
if ($Force) { $parameters.Force = $true }
Write-Host "install.ps1 delegates to managed runtime sync."
& $syncScript @parameters
exit $LASTEXITCODE
