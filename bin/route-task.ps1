#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $TaskPath
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$routerPath = Join-Path $repoRoot "orchestrator\router.ps1"
$registryPath = Join-Path $repoRoot "agents.registry.json"
$resolvedTaskPath = Resolve-Path $TaskPath

. $routerPath

$task = Get-Content $resolvedTaskPath -Raw | ConvertFrom-Json
$registry = Get-Content $registryPath -Raw | ConvertFrom-Json

$route = Get-AgentRoute -Task $task -Registry $registry
$route | ConvertTo-Json -Depth 10

