#!/usr/bin/env pwsh

function Add-RouteAgent {
    param(
        [System.Collections.ArrayList] $Selected,
        [Parameter(Mandatory = $true)] [string] $AgentId
    )

    if (-not $Selected.Contains($AgentId)) {
        [void] $Selected.Add($AgentId)
    }
}

function Test-AnyPattern {
    param(
        [Parameter(Mandatory = $true)] [string] $Text,
        [Parameter(Mandatory = $true)] [string[]] $Patterns
    )

    foreach ($pattern in $Patterns) {
        if ($Text -match $pattern) {
            return $true
        }
    }

    return $false
}

function Get-AgentRoute {
    param(
        [Parameter(Mandatory = $true)] $Task,
        [Parameter(Mandatory = $true)] $Registry
    )

    $agentsById = @{}
    foreach ($agent in $Registry.agents) {
        $agentsById[$agent.id] = $agent
    }

    $selected = [System.Collections.ArrayList]::new()
    $reasons = [System.Collections.ArrayList]::new()
    $labels = @($Task.labels) -join " "
    $text = "$($Task.title) $($Task.body) $labels".ToLowerInvariant()

    foreach ($agentId in $agentsById.Keys) {
        if ($text -match "(^|\s|@)$([regex]::Escape($agentId))(\s|$|[.,;:])") {
            Add-RouteAgent -Selected $selected -AgentId $agentId
            [void] $reasons.Add("explicit mention: $agentId")
        }
    }

    if ($selected.Count -eq 0) {
        if (Test-AnyPattern -Text $text -Patterns @("security", "secret", "token", "credential", "auth", "permission", "unsafe", "risk", "publish")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-security-auditor"
            [void] $reasons.Add("security or permission risk detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("\bmcp\b", "plugin", "tool permission", "opencode")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-mcp-architect"
            [void] $reasons.Add("MCP/plugin integration detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("test", "coverage", "playwright", "e2e", "vitest", "jest", "regression")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-tests"
            [void] $reasons.Add("testing or regression work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("review", "pr", "diff", "merge", "ready to ship", "listo para subir")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-code-reviewer"
            [void] $reasons.Add("review/readiness work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("readme", "docs", "documentation", "changelog", "docstring", "guide")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-docs"
            [void] $reasons.Add("documentation work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("css", "ui", "design", "responsive", "accessibility", "tailwind", "animation")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-design"
            [void] $reasons.Add("design/UI work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("seo", "geo", "aeo", "keyword", "search console", "schema", "sitemap", "robots")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-growth-seo-geo"
            [void] $reasons.Add("organic growth/search work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("product", "mvp", "product validation", "validar idea", "idea de producto", "launch", "kill", "scale")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-product-founder"
            [void] $reasons.Add("product validation or MVP work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("\bai\b", "\bllm\b", "rag", "agent architecture", "prompt registry", "semantic cache")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-ai-architect"
            [void] $reasons.Add("AI architecture work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("research", "investigate", "compare", "current docs", "competitor")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-researcher"
            [void] $reasons.Add("research work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("release", "publish", "version", "installation", "cross-machine")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-release-manager"
            [void] $reasons.Add("release work detected")
        }

        if (Test-AnyPattern -Text $text -Patterns @("implement", "fix", "bug", "feature", "api", "database", "backend", "frontend", "script")) {
            Add-RouteAgent -Selected $selected -AgentId "agente-principal"
            [void] $reasons.Add("implementation work detected")
        }
    }

    if ($selected.Count -eq 0) {
        Add-RouteAgent -Selected $selected -AgentId "agente-principal"
        [void] $reasons.Add("fallback route")
    }

    $codeWork = Test-AnyPattern -Text $text -Patterns @("implement", "fix", "bug", "feature", "api", "database", "backend", "frontend", "script")
    if ($codeWork -and -not $selected.Contains("agente-code-reviewer")) {
        Add-RouteAgent -Selected $selected -AgentId "agente-code-reviewer"
        [void] $reasons.Add("code work should receive review")
    }

    $approvalRequired = [bool] $Task.requiresApproval
    if ($Task.riskLevel -eq "high") {
        $approvalRequired = $true
        [void] $reasons.Add("task riskLevel is high")
    }

    $agentSummaries = @()
    foreach ($agentId in $selected) {
        $agent = $agentsById[$agentId]
        if ($null -eq $agent) {
            continue
        }

        if ($agent.requiresApproval) {
            $approvalRequired = $true
        }

        $agentSummaries += [ordered]@{
            id = $agent.id
            file = $agent.file
            riskLevel = $agent.riskLevel
            requiresApproval = $agent.requiresApproval
            outputs = @($agent.outputs)
        }
    }

    return [ordered]@{
        taskId = $Task.id
        source = $Task.source
        riskLevel = $Task.riskLevel
        approvalRequired = $approvalRequired
        selectedAgents = $agentSummaries
        reasons = @($reasons)
    }
}
