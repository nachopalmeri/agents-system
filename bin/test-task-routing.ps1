#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
. (Join-Path $root 'orchestrator/router.ps1')
$registry = Get-Content (Join-Path $root 'agents.registry.json') -Raw | ConvertFrom-Json
$rules = Get-Content (Join-Path $root 'config/routing-rules.json') -Raw | ConvertFrom-Json
$cases = @(
    @{ title = 'Explain this function'; lane = 'SIMPLE'; agent = 'implementador' },
    @{ title = 'Research the current official documentation'; lane = 'SPECIALIZED'; agent = 'explorador' },
    @{ title = 'Production RAG architecture'; lane = 'SPECIALIZED'; agent = 'planner' },
    @{ title = 'Design a responsive landing'; lane = 'SPECIALIZED'; agent = 'implementador' },
    @{ title = 'Deploy it to production'; lane = 'HIGH_RISK'; agent = 'reviewer' },
    @{ title = 'Rotate secret token'; lane = 'HIGH_RISK'; agent = 'reviewer' },
    @{ title = 'Work in parallel'; lane = 'PARALLEL'; agent = 'implementador' },
    @{ title = 'Tomame un parcial'; lane = 'SPECIALIZED'; agent = 'implementador' },
    @{ title = 'Actualizacion parcial de la aplicacion'; lane = 'SIMPLE'; agent = 'implementador' },
    @{ title = 'planner'; lane = 'SPECIALIZED'; agent = 'planner' }
)
foreach ($case in $cases) {
    $task = [pscustomobject]@{ id = 'smoke'; title = $case.title; body = ''; labels = @(); riskLevel = 'low'; requiresApproval = $false }
    $route = Get-AgentRoute -Task $task -Registry $registry -Rules $rules
    if ($route.lane -ne $case.lane -or $route.primary.id -ne $case.agent) { throw "Routing failed: $($case.title) -> $($route.lane)/$($route.primary.id)" }
    foreach ($component in $route.components) { if (-not (Test-Path (Join-Path $root $component))) { throw "Missing component: $component" } }
}
foreach ($rule in @($rules.highRisk) + @($rules.specialists)) {
    if ($registry.agents.id -notcontains $rule.primary) { throw "Unknown rule agent: $($rule.primary)" }
    if ($rule.component -and -not (Test-Path (Join-Path $root $rule.component))) { throw "Missing rule component: $($rule.component)" }
}
Write-Host "TASK_ROUTING_TESTS_OK: $($cases.Count) cases"
