#!/usr/bin/env pwsh
[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$config = Get-Content (Join-Path $root "config\model-routing.json") -Raw | ConvertFrom-Json
if ($config.tiers.'free-fast'.candidates -notcontains "opencode/muse-spark-1.3-contributor-free") { throw "free-fast-muse-missing" }
if ($config.rules.freeTiersMayNotWriteOutsideWorkspace -ne $true) { throw "free-workspace-policy-missing" }
if ($config.rules.freeWorkerRequiresParentReview -ne $true) { throw "free-worker-review-policy-missing" }
if ($config.rules.highRiskRequiresPrimary -ne $true) { throw "high-risk-primary-policy-missing" }
if ($config.taskClasses.'preliminary-red-team' -ne "free-fast") { throw "red-team-not-routed-free-fast" }
if ($config.taskClasses.'security-decision' -eq "free-fast") { throw "security-decision-free-only" }
if ($config.taskClasses.'mechanical-edit' -ne "free-worker") { throw "mechanical-edit-not-routed-free-worker" }
Write-Host "MODEL_ROUTING_TESTS_OK" -ForegroundColor Green
