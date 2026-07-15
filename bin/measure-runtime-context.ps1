#!/usr/bin/env pwsh
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$manifestPath = Join-Path $repoRoot "config\runtime-manifest.json"
$failures = @()

if (Test-Path $manifestPath) {
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
    $canonicalPath = Join-Path $repoRoot $manifest.canonicalPath
    $budgets = $manifest.contextBudgets
} else {
    $canonicalPath = Join-Path $repoRoot ".agents\AGENTS.md"
    $budgets = [pscustomobject]@{ canonicalMaxChars = 6000; openCodeMaxChars = 8000; baselineChars = 51958; minReductionPercent = 80 }
    $failures += "Runtime manifest missing"
}

$canonicalChars = (Get-Content $canonicalPath -Raw).Length
$openCodeConfigPath = Join-Path $repoRoot "config\opencode\opencode.jsonc"
$openCodeConfig = Get-Content $openCodeConfigPath -Raw | ConvertFrom-Json
$openCodeChars = 0
$resolvedInstructions = @()
foreach ($instruction in @($openCodeConfig.instructions)) {
    $relative = [string]$instruction
    if ($relative.StartsWith("~/.agents/")) {
        $relative = ".agents/" + $relative.Substring(10)
    }
    $path = Join-Path $repoRoot $relative
    $resolvedInstructions += $relative.Replace("\", "/")
    if (-not (Test-Path $path -PathType Leaf)) {
        $failures += "OpenCode instruction missing: $instruction"
        continue
    }
    $openCodeChars += (Get-Content $path -Raw).Length
}

$reduction = [math]::Round(100 * (1 - ($openCodeChars / [double]$budgets.baselineChars)), 2)
$metrics = [ordered]@{
    schemaVersion = 1
    canonicalChars = $canonicalChars
    canonicalMaxChars = [int]$budgets.canonicalMaxChars
    openCodeChars = $openCodeChars
    openCodeMaxChars = [int]$budgets.openCodeMaxChars
    reductionPercent = $reduction
    minReductionPercent = [int]$budgets.minReductionPercent
    openCodeInstructions = @($resolvedInstructions)
}

if ($canonicalChars -gt [int]$budgets.canonicalMaxChars) {
    $failures += "Canonical core exceeds budget: $canonicalChars > $($budgets.canonicalMaxChars)"
}
if ($openCodeChars -gt [int]$budgets.openCodeMaxChars) {
    $failures += "OpenCode preload exceeds budget: $openCodeChars > $($budgets.openCodeMaxChars)"
}
if ($reduction -lt [int]$budgets.minReductionPercent) {
    $failures += "OpenCode reduction below target: $reduction% < $($budgets.minReductionPercent)%"
}

$metrics | ConvertTo-Json -Depth 5
if ($Check -and $failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Host "[FAIL] $failure" -ForegroundColor Red
    }
    exit 1
}
exit 0
