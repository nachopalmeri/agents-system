#!/usr/bin/env pwsh
$ErrorActionPreference = "Continue"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$homeDir = $env:USERPROFILE
$checks = @()

function Add-Check {
    param([string]$Name, [bool]$Ok, [string]$Detail)
    $script:checks += [pscustomobject]@{ Name = $Name; Ok = $Ok; Detail = $Detail }
}

function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

Add-Check "Git" (Test-CommandExists "git") "git executable available"
Add-Check "GitHub CLI" (Test-CommandExists "gh") "gh executable available for private repo sync"
Add-Check "PowerShell" $true $PSVersionTable.PSVersion.ToString()

$agentsPath = Join-Path $homeDir ".agents"
$binPath = Join-Path $homeDir "bin"
$opencodePath = Join-Path $homeDir ".config\opencode\opencode.jsonc"

Add-Check "~/.agents" (Test-Path $agentsPath) $agentsPath
Add-Check "~/bin" (Test-Path $binPath) $binPath
Add-Check "nuevo-proyecto.ps1" (Test-Path (Join-Path $binPath "nuevo-proyecto.ps1")) (Join-Path $binPath "nuevo-proyecto.ps1")
Add-Check "OpenCode config" (Test-Path $opencodePath) $opencodePath

$pathContainsBin = (($env:Path -split ';') -contains $binPath)
Add-Check "~/bin in PATH" $pathContainsBin $binPath

$ollamaReachable = $false
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/tags" -UseBasicParsing -TimeoutSec 2
    $ollamaReachable = $response.StatusCode -ge 200 -and $response.StatusCode -lt 500
} catch {
    $ollamaReachable = $false
}
Add-Check "Ollama local" $ollamaReachable "http://127.0.0.1:11434"

Write-Host "Agents System Doctor" -ForegroundColor Cyan
Write-Host "Repo: $repoRoot"
Write-Host ""

foreach ($check in $checks) {
    if ($check.Ok) {
        Write-Host "[OK] $($check.Name) - $($check.Detail)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] $($check.Name) - $($check.Detail)" -ForegroundColor Yellow
    }
}

$failed = @($checks | Where-Object { -not $_.Ok })
Write-Host ""
if ($failed.Count -eq 0) {
    Write-Host "Doctor completed with no warnings." -ForegroundColor Green
    exit 0
}

Write-Host "Doctor completed with $($failed.Count) warning(s)." -ForegroundColor Yellow
exit 0
