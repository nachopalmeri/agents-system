#!/usr/bin/env pwsh
param(
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$gitDir = Join-Path $repoRoot ".git"
$hooksDir = Join-Path $gitDir "hooks"

if (-not (Test-Path $gitDir)) {
    throw "No .git directory found at $gitDir"
}

if ($Uninstall) {
    foreach ($hook in @("pre-commit", "pre-push")) {
        $path = Join-Path $hooksDir $hook
        if (Test-Path $path) { Remove-Item $path -Force }
    }
    Write-Host "Hooks removed." -ForegroundColor Green
    exit 0
}

$preCommit = @"
#!/bin/sh
pwsh ./bin/check-secrets.ps1
"@

$prePush = @"
#!/bin/sh
printf '%s\n' 'Reminder: run ./bin/doctor.ps1 and project validation before publishing.'
"@

Set-Content -Path (Join-Path $hooksDir "pre-commit") -Value $preCommit -NoNewline
Set-Content -Path (Join-Path $hooksDir "pre-push") -Value $prePush -NoNewline

Write-Host "Hooks installed." -ForegroundColor Green
Write-Host "Use .\bin\install-hooks.ps1 -Uninstall to remove them."
