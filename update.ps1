#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "=== Updating local agents system ===" -ForegroundColor Cyan
Write-Host ""

$agentsDir = Join-Path $env:USERPROFILE ".agents"
$binDir = Join-Path $env:USERPROFILE "bin"
$opencodeDir = Join-Path $env:USERPROFILE ".config\opencode"

$usingSymlinks = $false
if (Test-Path $agentsDir) {
    $item = Get-Item $agentsDir -ErrorAction SilentlyContinue
    if ($item -and $item.Target) {
        $usingSymlinks = $true
    }
}

if ($usingSymlinks) {
    Write-Host "Mode: Symlinks (git pull already activates changes)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verification:" -ForegroundColor Yellow

    $checks = @(
        [pscustomobject]@{ Name = "~/.agents"; Path = $agentsDir },
        [pscustomobject]@{ Name = "~/bin"; Path = $binDir }
    )

    foreach ($check in $checks) {
        $target = $null
        if (Test-Path $check.Path) {
            $target = (Get-Item $check.Path -ErrorAction SilentlyContinue).Target
        }

        if ($target -and $target -like "*agents-system*") {
            Write-Host "  [OK] $($check.Name) -> $target" -ForegroundColor Green
        } else {
            Write-Warning "  [WARN] $($check.Name) is not pointing to agents-system"
        }
    }
} else {
    Write-Host "Mode: Copies (manual sync required)" -ForegroundColor Yellow
    Write-Host "  Copying updated files..." -ForegroundColor Gray

    if (Test-Path ".\.agents") {
        if (Test-Path $agentsDir) { Remove-Item $agentsDir -Recurse -Force }
        Copy-Item ".\.agents" $agentsDir -Recurse -Force
        Write-Host "  [OK] ~/.agents updated" -ForegroundColor Green
    }

    if (Test-Path ".\bin") {
        if (Test-Path $binDir) { Remove-Item $binDir -Recurse -Force }
        Copy-Item ".\bin" $binDir -Recurse -Force
        Write-Host "  [OK] ~/bin updated" -ForegroundColor Green
    }

    if (Test-Path ".\config\opencode") {
        if (-not (Test-Path $opencodeDir)) {
            New-Item -ItemType Directory -Path $opencodeDir -Force | Out-Null
        }
        Copy-Item ".\config\opencode\*" $opencodeDir -Recurse -Force
        Write-Host "  [OK] OpenCode config updated" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Update complete ===" -ForegroundColor Green
Write-Host "Restart your terminal or IDE to ensure changes are loaded."
