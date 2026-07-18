#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $TaskPath,
    [string] $TraceDirectory
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$routerPath = Join-Path $repoRoot "orchestrator\router.ps1"
$registryPath = Join-Path $repoRoot "agents.registry.json"
$resolvedTaskPath = Resolve-Path $TaskPath

. $routerPath

$task = Get-Content $resolvedTaskPath -Raw -Encoding UTF8 | ConvertFrom-Json
$registry = Get-Content $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json

$route = Get-AgentRoute -Task $task -Registry $registry
if ($TraceDirectory) {
    & (Join-Path $repoRoot "bin\record-runtime-event.ps1") -TraceDirectory $TraceDirectory -TaskId $route.taskId -Type route -Lane $route.lane -Status selected -ReasonCode ([string]$route.reasons[0]) -Detail $route.primary.id
}
$route | ConvertTo-Json -Depth 10

