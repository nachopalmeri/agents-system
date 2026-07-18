#!/usr/bin/env pwsh

function ConvertTo-RouteText {
    param([AllowEmptyString()] [string] $Text)

    $normalized = $Text.ToLowerInvariant().Normalize([Text.NormalizationForm]::FormD)
    $builder = New-Object Text.StringBuilder
    foreach ($character in $normalized.ToCharArray()) {
        if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($character) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$builder.Append($character)
        }
    }
    return $builder.ToString().Normalize([Text.NormalizationForm]::FormC)
}

function Test-RoutePatterns {
    param(
        [Parameter(Mandatory = $true)] [string] $Text,
        [Parameter(Mandatory = $true)] [object[]] $Patterns
    )

    foreach ($pattern in $Patterns) {
        if ($Text -match [string]$pattern) {
            return $true
        }
    }
    return $false
}

function New-RouteAgent {
    param($Agent, [string] $Purpose)

    $routeAgent = [ordered]@{
        id = $Agent.id
        file = $Agent.file
    }
    if ($Purpose) {
        $routeAgent.purpose = $Purpose
    }
    return $routeAgent
}

function Get-AgentRoute {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] $Task,
        [Parameter(Mandatory = $true)] $Registry,
        $Rules
    )

    if ($null -eq $Rules) {
        $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $Rules = Get-Content (Join-Path $repoRoot "config\routing-rules.json") -Raw | ConvertFrom-Json
    }

    $agentsById = @{}
    foreach ($agent in $Registry.agents) {
        $agentsById[$agent.id] = $agent
    }

    $labels = @($Task.labels) -join " "
    $text = ConvertTo-RouteText "$($Task.title) $($Task.body) $labels"
    $lane = "SIMPLE"
    $primaryId = "agente-principal"
    $supportIds = @()
    $components = @()
    $reasons = @("simple-fallback")
    $approvalRequired = [bool]$Task.requiresApproval

    $riskMatch = $null
    foreach ($rule in $Rules.highRisk) {
        if (Test-RoutePatterns -Text $text -Patterns @($rule.patterns)) {
            $riskMatch = $rule
            break
        }
    }

    if ($null -ne $riskMatch -or $Task.riskLevel -eq "high") {
        $lane = "HIGH_RISK"
        $primaryId = if ($null -ne $riskMatch) { $riskMatch.primary } else { "agente-security-auditor" }
        $components = @(".agents/workflows/validation.md")
        $reasons = @($(if ($null -ne $riskMatch) { $riskMatch.reason } else { "risk-level-high" }))
        $approvalRequired = $true
    } else {
        $explicitIds = @()
        foreach ($agent in $Registry.agents) {
            $escaped = [regex]::Escape([string]$agent.id)
            if ($text -match "(?<![a-z0-9-])$escaped(?![a-z0-9-])") {
                $explicitIds += $agent.id
            }
        }

        if ($explicitIds.Count -gt 0) {
            $primaryId = $explicitIds[0]
            $lane = if ($primaryId -eq "agente-principal") { "SIMPLE" } else { "SPECIALIZED" }
            $reasons = @("explicit-agent")
        } else {
            $isCouncil = Test-RoutePatterns -Text $text -Patterns @($Rules.parallel.councilPatterns)
            $isParallel = $isCouncil -or (Test-RoutePatterns -Text $text -Patterns @($Rules.parallel.patterns))
            if ($isParallel) {
                $lane = "PARALLEL"
                $primaryId = if ($text -match "\b(?:research|investiga|documentation|documentacion|libraries|costos)\b") { "agente-researcher" } else { "agente-principal" }
                $supportIds = if ($primaryId -eq "agente-researcher") { @("agente-principal") } else { @("agente-researcher") }
                $components = @($(if ($isCouncil) { ".agents/workflows/multiagent_review_loop.md" } else { ".agents/workflows/parallel_agents.md" }))
                $reasons = @($(if ($isCouncil) { "explicit-council" } else { "explicit-parallel" }))
            } else {
                $matches = @()
                foreach ($rule in ($Rules.specialists | Sort-Object priority)) {
                    if (Test-RoutePatterns -Text $text -Patterns @($rule.patterns)) {
                        $matches += $rule
                    }
                }
                if ($matches.Count -gt 0) {
                    $selectedRule = $matches[0]
                    $lane = "SPECIALIZED"
                    $primaryId = $selectedRule.primary
                    $components = if ($selectedRule.component) { @($selectedRule.component) } else { @() }
                    $reasons = @($selectedRule.reason)
                    if ($matches.Count -gt 1) {
                        $reasons += "ambiguous-specialist"
                    }
                }
            }
        }
    }

    if (-not $agentsById.ContainsKey($primaryId)) {
        throw "Routing rule selected unknown agent: $primaryId"
    }

    $primary = New-RouteAgent -Agent $agentsById[$primaryId]
    $support = @()
    foreach ($supportId in $supportIds) {
        if ($agentsById.ContainsKey($supportId) -and $supportId -ne $primaryId) {
            $support += New-RouteAgent -Agent $agentsById[$supportId] -Purpose "research"
        }
    }

    $selectedAgents = @($primary) + @($support)
    $budget = $Rules.laneBudgets.$lane
    $capabilityMap = if ($Rules.capabilityByAgent) { $Rules.capabilityByAgent } else { @{} }
    $primaryCapability = if ($capabilityMap.PSObject.Properties.Name -contains $primaryId) { [string]$capabilityMap.$primaryId } else { "general-implementation" }
    return [ordered]@{
        schemaVersion = 1
        taskId = $Task.id
        lane = $lane
        primary = $primary
        support = @($support)
        components = @($components)
        reasons = @($reasons)
        primaryCapability = $primaryCapability
        capabilities = @($primaryCapability)
        budgetClass = $lane
        selectionBasis = @($reasons)
        approvalRequired = $approvalRequired
        budgets = [ordered]@{
            maxIterations = [int]$budget.maxIterations
            maxReplans = [int]$budget.maxReplans
            maxAgents = [int]$budget.maxAgents
        }
        selectedAgents = $selectedAgents
    }
}
