#!/usr/bin/env pwsh
[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$config = Get-Content (Join-Path $root "config\model-routing.json") -Raw | ConvertFrom-Json
foreach ($tier in @('free-fast','free-worker','cheap')) {
    if ($config.tiers.$tier.maxAttempts -ne 1) { throw "Lean workers must return to primary after one model attempt: $tier" }
}
if ($config.tiers.'free-fast'.maxOutputTokens -gt 2000 -or $config.tiers.'free-worker'.maxOutputTokens -gt 4000 -or $config.tiers.cheap.maxOutputTokens -gt 4000) { throw 'Lean worker output guidance exceeds its default budget.' }
if ($config.tiers.'free-fast'.candidates[0] -ne "opencode/glm-5.3-flash-free") { throw "free-fast-glm-not-first" }
$trainingModels = '(?i)muse-spark|iceman|nemotron|mimo-.*-free|contributor'
foreach ($tierName in $config.tiers.PSObject.Properties.Name) { foreach ($candidate in $config.tiers.$tierName.candidates) { if ($candidate -match $trainingModels) { throw "training-model-in-routing: $tierName -> $candidate" } } }
$tiersFile = Get-Content (Join-Path $root "config\model-tiers.json") -Raw | ConvertFrom-Json
foreach ($t in @('fast','balanced','strong')) { if ([string]$tiersFile.$t.opencode -match $trainingModels) { throw "training-model-in-tiers: $t" } }
foreach ($f in @(Get-ChildItem (Join-Path $root "config\opencode\agents") -Filter *.md) + @(Get-ChildItem (Join-Path $root "config\generated\opencode\agent") -Filter *.md -ErrorAction SilentlyContinue) + @(Get-Item (Join-Path $root "config\opencode\opencode.jsonc"))) { if ((Get-Content $f.FullName -Raw) -match "model.{0,4}opencode/\S*($trainingModels)") { throw "training-model-in-agent: $($f.Name)" } }
if ($config.rules.freeTiersMayNotWriteOutsideWorkspace -ne $true) { throw "free-workspace-policy-missing" }
if ($config.rules.freeWorkerRequiresParentReview -ne $true) { throw "free-worker-review-policy-missing" }
if ($config.rules.highRiskRequiresPrimary -ne $true) { throw "high-risk-primary-policy-missing" }
if ($config.taskClasses.'preliminary-red-team' -ne "free-fast") { throw "red-team-not-routed-free-fast" }
if ($config.taskClasses.'security-decision' -eq "free-fast") { throw "security-decision-free-only" }
if ($config.taskClasses.'mechanical-edit' -ne "free-worker") { throw "mechanical-edit-not-routed-free-worker" }
Write-Host "MODEL_ROUTING_TESTS_OK" -ForegroundColor Green
