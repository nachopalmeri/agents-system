#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$criticalFilePatterns = @(
    "\.env(\.|$)",
    "\.pem$",
    "\.key$",
    "id_rsa"
)

$criticalContentPatterns = @(
    "BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY",
    "ghp_[A-Za-z0-9_]{20,}",
    "github_pat_[A-Za-z0-9_]{20,}",
    "sk-[A-Za-z0-9]{20,}",
    "xox[baprs]-[A-Za-z0-9-]{20,}"
)

$warningPatterns = @(
    "api[_-]?key\s*[:=]",
    "secret\s*[:=]",
    "password\s*[:=]",
    "token\s*[:=]",
    "client_secret\s*[:=]"
)

$excludeDirs = @(".git", "node_modules", "dist", "build", "__pycache__")
$files = Get-ChildItem -Path $repoRoot -Recurse -File -Force | Where-Object {
    $path = $_.FullName
    -not ($excludeDirs | Where-Object { $path -like "*\$_\*" })
}

$critical = @()
$warnings = @()

foreach ($file in $files) {
    $relative = Resolve-Path -Path $file.FullName -Relative
    foreach ($pattern in $criticalFilePatterns) {
        if ($file.Name -match $pattern) {
            $critical += "$relative :: filename matches $pattern"
        }
    }

    $isText = $file.Length -lt 1048576 -and $file.Extension -notin @(".png", ".jpg", ".jpeg", ".gif", ".docx", ".pdf", ".zip", ".lock")
    if (-not $isText) { continue }

    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    foreach ($pattern in $criticalContentPatterns) {
        if ($content -match $pattern) {
            $critical += "$relative :: content matches $pattern"
        }
    }
    foreach ($pattern in $warningPatterns) {
        if ($content -match $pattern) {
            $warnings += "$relative :: possible secret-like text $pattern"
        }
    }
}

Write-Host "Secret scan" -ForegroundColor Cyan

if ($critical.Count -gt 0) {
    Write-Host "Critical findings:" -ForegroundColor Red
    $critical | Sort-Object -Unique | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host "Warnings for manual review:" -ForegroundColor Yellow
    $warnings | Sort-Object -Unique | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
} else {
    Write-Host "No secret-like findings." -ForegroundColor Green
}

exit 0
