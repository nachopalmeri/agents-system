#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
& (Join-Path $repoRoot "bin\install-hooks.ps1")
$hooksDir = (& git -C $repoRoot rev-parse --git-path hooks).Trim()
if (-not [IO.Path]::IsPathRooted($hooksDir)) { $hooksDir = Join-Path $repoRoot $hooksDir }
foreach ($hook in @("pre-commit", "pre-push")) {
    $path = Join-Path $hooksDir $hook
    if (-not (Test-Path $path)) { throw "Hook missing: $hook" }
    $content = Get-Content $path -Raw
    if ($content -notmatch "git rev-parse --show-toplevel") { throw "Hook is not portable: $hook" }
}
& (Join-Path $repoRoot "bin\install-hooks.ps1") -Uninstall
Write-Host "[PASS] portable hook installation" -ForegroundColor Green
