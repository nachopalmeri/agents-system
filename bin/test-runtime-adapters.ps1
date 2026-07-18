#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$manifest = Get-Content (Join-Path $repoRoot "config\runtime-manifest.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$required = @("codex", "claude", "opencode", "devin", "gemini", "cursor", "aider", "zed", "cli")
$failures = @()
foreach ($client in $required) {
    if (@($manifest.adapters.client) -notcontains $client) { $failures += "adapter missing from manifest: $client" }
}

& (Join-Path $repoRoot "bin\render-runtime-adapters.ps1") -Check
if ($LASTEXITCODE -ne 0) { $failures += "adapter renderer drift check failed" }

$canonicalHash = (Get-FileHash (Join-Path $repoRoot $manifest.canonicalPath) -Algorithm SHA256).Hash.ToLowerInvariant()
foreach ($adapter in @($manifest.adapters | Where-Object { $_.client -notin @("cli") })) {
    $path = Join-Path $repoRoot $adapter.repoPath
    if (-not (Test-Path $path)) { $failures += "adapter path missing: $($adapter.repoPath)"; continue }
    $content = Get-Content $path -Raw -Encoding UTF8
    if ($content -notmatch [regex]::Escape($canonicalHash)) { $failures += "adapter lacks canonical hash: $($adapter.client)" }
}

if ($failures.Count -gt 0) { $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }; exit 1 }
Write-Host "[PASS] cross-IDE adapter parity" -ForegroundColor Green
exit 0
