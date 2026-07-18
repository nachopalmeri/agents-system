#!/usr/bin/env pwsh
[CmdletBinding()] param([Parameter(Mandatory=$true)][string]$TaskPath,[string]$TraceDirectory)
$ErrorActionPreference='Stop'; $root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $root 'orchestrator/router.ps1')
$task=Get-Content -LiteralPath (Resolve-Path $TaskPath) -Raw -Encoding UTF8 | ConvertFrom-Json
$registry=Get-Content (Join-Path $root 'agents.registry.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$route=Get-AgentRoute -Task $task -Registry $registry
$budget=[ordered]@{maxIterations=[int]$route.budgets.maxIterations;maxReplans=[int]$route.budgets.maxReplans;maxAgents=[int]$route.budgets.maxAgents;maxWallSeconds=if($route.lane -eq 'SIMPLE'){300}else{900};maxToolCalls=if($route.lane -eq 'SIMPLE'){12}else{40};maxTokenEstimate=if($route.lane -eq 'SIMPLE'){12000}else{50000};maxCostUsd=if($route.lane -eq 'HIGH_RISK'){5}else{2}}
$session=[ordered]@{schemaVersion=1;taskId=[string]$task.id;objective=[string]$task.body;successCriteria=@('route selected','validation evidence');invariants=@('no secrets','no unapproved external writes');lane=$route.lane;capabilities=@([string]$route.primary.id);budgets=$budget;policy=[ordered]@{allowedTools=@('Read','Grep');allowedMcpServers=@();requiresApproval=[bool]$route.approvalRequired};provider=[ordered]@{status='unknown'};stopReasons=@('SUCCESS','NEEDS_USER','BLOCKED','BUDGET_EXCEEDED','PROVIDER_REFUSAL','RATE_LIMITED')}
$session | ConvertTo-Json -Depth 12
