#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$skillPath = Join-Path $repoRoot ".agents\skills\frontend-design\SKILL.md"
$rubricPath = Join-Path $repoRoot ".agents\skills\frontend-design\reference\visual-qa-rubric.md"
$agentPath = Join-Path $repoRoot ".agents\agents\agente-design.md"
$failures = @()

function Require-Pattern {
    param([string] $Text, [string] $Pattern, [string] $Label)
    if ($Text -notmatch $Pattern) { $script:failures += "missing: $Label" }
}

$skill = Get-Content $skillPath -Raw
foreach ($requirement in @(
    @{ Pattern = "subject.*audience.*job-to-be-done"; Label = "subject grounding" },
    @{ Pattern = "2(?:-| )3.*references"; Label = "2-3 references" },
    @{ Pattern = "signature"; Label = "visual signature" },
    @{ Pattern = "wireframe"; Label = "wireframe choice" },
    @{ Pattern = "390.?844"; Label = "mobile screenshot" },
    @{ Pattern = "1440.?900"; Label = "desktop screenshot" },
    @{ Pattern = "14/18"; Label = "rubric threshold" },
    @{ Pattern = "one-line|one line|cambio de una linea"; Label = "simple-change escape hatch" }
)) {
    Require-Pattern -Text $skill -Pattern $requirement.Pattern -Label $requirement.Label
}

if ($skill -match "AskUserQuestionTool|STOP and STOP") {
    $failures += "nonportable interaction syntax remains"
}

if (-not (Test-Path $rubricPath)) {
    $failures += "visual QA rubric missing"
} else {
    $rubric = Get-Content $rubricPath -Raw
    foreach ($dimension in @("subject specificity", "hierarchy", "composition", "typography", "color rationale", "responsive integrity", "accessibility", "motion/3D purpose", "generic-pattern avoidance")) {
        Require-Pattern -Text $rubric -Pattern ([regex]::Escape($dimension)) -Label $dimension
    }
}

$agent = Get-Content $agentPath -Raw
if ($agent.Length -gt 2500) { $failures += "design agent duplicates too much workflow ($($agent.Length) chars)" }
if ($agent -notmatch "frontend-design/SKILL.md") { $failures += "design agent does not delegate to frontend skill" }

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }
    exit 1
}

Write-Host "[PASS] visual workflow contract" -ForegroundColor Green
exit 0
