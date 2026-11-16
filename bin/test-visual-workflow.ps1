#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$agentPath = Join-Path $repoRoot ".agents/agents/implementador.md"
$externalPath = Join-Path $repoRoot "config/external-skills.json"
$briefPath = Join-Path $repoRoot ".agents/skills-library/zentra-brand-brief/SKILL.md"
$failures = @()

function Require-Pattern {
    param([string] $Text, [string] $Pattern, [string] $Label)
    if ($Text -notmatch $Pattern) { $script:failures += "missing: $Label" }
}

if (Test-Path (Join-Path $repoRoot ".agents/skills/frontend-design")) {
    $failures += "core frontend-design still present; official skill is external and must not be vendored in .agents/skills"
}
if (Test-Path (Join-Path $repoRoot ".agents/skills/anti-slop-design")) {
    $failures += "core anti-slop-design still present; it was retired and archived"
}

$external = Get-Content $externalPath -Raw | ConvertFrom-Json
$names = @($external.skills.name)
if ($names -notcontains "frontend-design") { $failures += "frontend-design missing from config/external-skills.json" }
if ($names -notcontains "impeccable") { $failures += "impeccable missing from config/external-skills.json" }

$agent = Get-Content $agentPath -Raw
if ($agent.Length -gt 2500) { $failures += "implementador duplicates too much workflow ($($agent.Length) chars)" }
if ($agent -notmatch "frontend-design") { $failures += "implementador does not delegate UI work to frontend-design" }

if (-not (Test-Path $briefPath)) {
    $failures += "zentra-brand-brief missing"
} else {
    $brief = Get-Content $briefPath -Raw
    foreach ($requirement in @(
        @{ Pattern = "390"; Label = "mobile width 390" },
        @{ Pattern = "1440"; Label = "desktop width 1440" },
        @{ Pattern = "3 variantes"; Label = "three variants" },
        @{ Pattern = "a confirmar"; Label = "unconfirmed placeholder" }
    )) {
        Require-Pattern -Text $brief -Pattern $requirement.Pattern -Label $requirement.Label
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }
    exit 1
}

Write-Host "[PASS] visual workflow contract" -ForegroundColor Green
exit 0
