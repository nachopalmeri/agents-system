#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [ValidateSet("all", "routing", "reference", "adapter", "safety", "feedback", "visual")]
    [string] $Category = "all"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$corpusPath = Join-Path $repoRoot "evals\runtime-cases.json"
$registryPath = Join-Path $repoRoot "agents.registry.json"
$rulesPath = Join-Path $repoRoot "config\routing-rules.json"
$routerPath = Join-Path $repoRoot "orchestrator\router.ps1"
$visualTestPath = Join-Path $repoRoot "bin\test-visual-workflow.ps1"
$categoryScripts = @{
    adapter = Join-Path $repoRoot "bin\test-runtime-adapters.ps1"
    reference = Join-Path $repoRoot "bin\check-runtime-graph.ps1"
    feedback = Join-Path $repoRoot "bin\test-feedback-loop.ps1"
    visual = $visualTestPath
}

function Get-ChildPowerShell {
    $shell = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($null -eq $shell) { $shell = Get-Command powershell -ErrorAction Stop }
    return $shell.Source
}

if ($categoryScripts.ContainsKey($Category)) {
    & (Get-ChildPowerShell) -NoProfile -ExecutionPolicy Bypass -File $categoryScripts[$Category]
    exit $LASTEXITCODE
}

if ($Category -eq "all") {
    foreach ($scriptPath in @($categoryScripts.adapter, $categoryScripts.reference, $categoryScripts.feedback, $categoryScripts.visual)) {
        & (Get-ChildPowerShell) -NoProfile -ExecutionPolicy Bypass -File $scriptPath
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

function Add-Failure {
    param([string] $Message)
    $script:failures += $Message
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Test-RouteCase {
    param($Case, $Registry, $Rules)

    try {
        if ($null -eq $Rules) {
            $route = Get-AgentRoute -Task $Case.task -Registry $Registry
        } else {
            $route = Get-AgentRoute -Task $Case.task -Registry $Registry -Rules $Rules
        }
    } catch {
        Add-Failure "$($Case.id): router error: $($_.Exception.Message)"
        return $false
    }

    $caseOk = $true
    $checks = [ordered]@{
        schemaVersion = [int]$route.schemaVersion -eq 1
        lane = $route.lane -eq $Case.expected.lane
        primary = $route.primary.id -eq $Case.expected.primary
        maxAgents = [int]$route.budgets.maxAgents -eq [int]$Case.expected.maxAgents
        approvalRequired = [bool]$route.approvalRequired -eq [bool]$Case.expected.approvalRequired
    }

    foreach ($check in $checks.GetEnumerator()) {
        if (-not $check.Value) {
            Add-Failure "$($Case.id): $($check.Key) mismatch"
            $caseOk = $false
        }
    }

    $components = @($route.components)
    $supportIds = @($route.support | ForEach-Object { $_.id })
    foreach ($component in @($Case.expected.requiredComponents)) {
        if ($components -notcontains $component) {
            Add-Failure "$($Case.id): required component missing: $component"
            $caseOk = $false
        }
    }

    foreach ($forbidden in @($Case.expected.forbiddenComponents)) {
        if ($forbidden -like "support:*") {
            $agentId = $forbidden.Substring(8)
            if ($supportIds -contains $agentId) {
                Add-Failure "$($Case.id): forbidden support selected: $agentId"
                $caseOk = $false
            }
        } elseif ($components -contains $forbidden) {
            Add-Failure "$($Case.id): forbidden component selected: $forbidden"
            $caseOk = $false
        }
    }

    if ($caseOk) {
        Write-Host "[PASS] $($Case.id)" -ForegroundColor Green
    }
    return $caseOk
}

if (-not (Test-Path $corpusPath)) {
    throw "Runtime corpus not found: $corpusPath"
}

. $routerPath
$corpus = Get-Content $corpusPath -Raw -Encoding UTF8 | ConvertFrom-Json
$registry = Get-Content $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$rules = if (Test-Path $rulesPath) { Get-Content $rulesPath -Raw -Encoding UTF8 | ConvertFrom-Json } else { $null }
$allCases = @($corpus.cases)
$cases = if ($Category -eq "all") { $allCases } else { @($allCases | Where-Object category -eq $Category) }
$failures = @()

$laneMinimums = @{ SIMPLE = 12; SPECIALIZED = 8; PARALLEL = 4; HIGH_RISK = 6 }
if ($allCases.Count -lt 30) {
    Add-Failure "Corpus requires at least 30 cases; found $($allCases.Count)"
}
foreach ($lane in $laneMinimums.Keys) {
    $count = @($allCases | Where-Object { $_.expected.lane -eq $lane }).Count
    if ($count -lt $laneMinimums[$lane]) {
        Add-Failure "$lane requires at least $($laneMinimums[$lane]) cases; found $count"
    }
}
foreach ($language in @("es", "en")) {
    $count = @($allCases | Where-Object language -eq $language).Count
    $ratio = if ($allCases.Count -gt 0) { $count / $allCases.Count } else { 0 }
    if ($ratio -lt 0.4) {
        Add-Failure "$language cases must be at least 40%; found $([math]::Round($ratio * 100, 1))%"
    }
}

$passedWeight = 0
$totalWeight = 0
foreach ($case in $cases) {
    $weight = if ($null -eq $case.weight) { 1 } else { [int]$case.weight }
    $totalWeight += $weight
    if (Test-RouteCase -Case $case -Registry $registry -Rules $rules) {
        $passedWeight += $weight
    }
}

$score = if ($totalWeight -eq 0) { 0 } else { [math]::Round(100 * $passedWeight / $totalWeight, 2) }
Write-Host "Runtime eval score: $score% ($passedWeight/$totalWeight weighted points)"
if ($failures.Count -gt 0 -or $score -lt 95) {
    Write-Host "Runtime evals failed with $($failures.Count) issue(s)." -ForegroundColor Red
    exit 1
}

Write-Host "Runtime evals passed." -ForegroundColor Green
exit 0
