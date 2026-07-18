#!/usr/bin/env pwsh
param([switch]$Uninstall)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$hooksDir = (& git -C $repoRoot rev-parse --git-path hooks 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($hooksDir)) { throw "Unable to resolve Git hooks directory at $repoRoot" }
$hooksDir = $hooksDir.Trim()
if (-not [IO.Path]::IsPathRooted($hooksDir)) { $hooksDir = Join-Path $repoRoot $hooksDir }
if (-not (Test-Path $hooksDir)) { [void](New-Item -ItemType Directory -Path $hooksDir -Force) }

if ($Uninstall) {
    foreach ($hook in @("pre-commit", "pre-push")) {
        $path = Join-Path $hooksDir $hook
        if (Test-Path $path) { Remove-Item $path -Force }
    }
    Write-Host "Hooks removed." -ForegroundColor Green
    exit 0
}

$preCommit = @'
#!/bin/sh
repo_root=$(git rev-parse --show-toplevel) || exit 1
if command -v pwsh >/dev/null 2>&1; then
  pwsh -NoProfile -ExecutionPolicy Bypass -File "$repo_root/bin/check-secrets.ps1"
else
  powershell -NoProfile -ExecutionPolicy Bypass -File "$repo_root/bin/check-secrets.ps1"
fi
'@
$prePush = @'
#!/bin/sh
repo_root=$(git rev-parse --show-toplevel) || exit 1
printf '%s\n' 'Runtime policy reminder: run doctor and validation before publishing.'
'@

Set-Content -Path (Join-Path $hooksDir "pre-commit") -Value $preCommit -NoNewline
Set-Content -Path (Join-Path $hooksDir "pre-push") -Value $prePush -NoNewline
Write-Host "Hooks installed." -ForegroundColor Green
