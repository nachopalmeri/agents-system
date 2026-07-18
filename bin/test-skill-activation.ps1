#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$failures = @()
$skillFiles = Get-ChildItem (Join-Path $repoRoot ".agents\skills") -Filter SKILL.md -Recurse -File

foreach ($file in $skillFiles) {
    $text = Get-Content $file.FullName -Raw
    $relative = $file.FullName.Substring($repoRoot.Path.Length + 1)
    if ($text -match "(?i)before ANY response|starting any conversation|1% chance") {
        $failures += "$relative has a universal activation trigger"
    }
    if ($text -match "AskUserQuestionTool") {
        $failures += "$relative names a nonportable input tool"
    }
    if ($text -match "STOP and STOP") {
        $failures += "$relative contains unconditional STOP syntax"
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }
    exit 1
}

Write-Host "[PASS] skill activation is proportional and portable" -ForegroundColor Green
exit 0
