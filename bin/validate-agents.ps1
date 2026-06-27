#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot
try {
    $failures = @()

    function Add-Failure {
        param([string]$Message)
        $script:failures += $Message
        Write-Host "[FAIL] $Message" -ForegroundColor Red
    }

    function Add-Ok {
        param([string]$Message)
        Write-Host "[OK] $Message" -ForegroundColor Green
    }

    function Test-NonEmptyStringArray {
        param(
            [Parameter(Mandatory = $true)] $Value,
            [Parameter(Mandatory = $true)] [string] $Field,
            [Parameter(Mandatory = $true)] [string] $AgentId
        )

        if ($null -eq $Value -or $Value.Count -eq 0) {
            Add-Failure "$AgentId missing non-empty array: $Field"
            return
        }

        foreach ($item in $Value) {
            if ($item -isnot [string] -or [string]::IsNullOrWhiteSpace($item)) {
                Add-Failure "$AgentId has invalid array item in $Field"
            }
        }
    }

    Write-Host "Agents Registry Validation" -ForegroundColor Cyan
    Write-Host "Repo: $repoRoot"
    Write-Host ""

    $registryPath = "agents.registry.json"
    if (-not (Test-Path $registryPath)) {
        Add-Failure "Missing $registryPath"
    }

    $schemaPath = "schemas\agent.schema.json"
    if (-not (Test-Path $schemaPath)) {
        Add-Failure "Missing $schemaPath"
    }

    if ($failures.Count -gt 0) {
        exit 1
    }

    try {
        $registry = Get-Content $registryPath -Raw | ConvertFrom-Json
        Add-Ok "JSON parse: $registryPath"
    } catch {
        Add-Failure "JSON parse failed: $registryPath :: $($_.Exception.Message)"
        exit 1
    }

    try {
        Get-Content $schemaPath -Raw | ConvertFrom-Json | Out-Null
        Add-Ok "JSON parse: $schemaPath"
    } catch {
        Add-Failure "JSON parse failed: $schemaPath :: $($_.Exception.Message)"
    }

    if ($null -eq $registry.version -or $registry.version -lt 1) {
        Add-Failure "Registry version must be >= 1"
    }

    if ($null -eq $registry.agents -or $registry.agents.Count -eq 0) {
        Add-Failure "Registry must contain at least one agent"
    }

    $allowedRisk = @("low", "medium", "high")
    $allowedTools = @("Read", "Grep", "Edit", "Write", "Bash")
    $allowedMemoryTags = @("project", "user", "team", "run")
    $requiredFields = @("id", "name", "file", "division", "description", "whenToUse", "inputs", "outputs", "riskLevel", "tools", "requiresApproval", "memoryTags")

    $idGroups = $registry.agents | Group-Object id
    foreach ($group in $idGroups) {
        if ($group.Count -gt 1) {
            Add-Failure "Duplicate agent id: $($group.Name)"
        }
    }

    foreach ($agent in $registry.agents) {
        $agentId = $agent.id
        if ([string]::IsNullOrWhiteSpace($agentId)) {
            $agentId = "<missing-id>"
        }

        foreach ($field in $requiredFields) {
            if (-not ($agent.PSObject.Properties.Name -contains $field)) {
                Add-Failure "$agentId missing required field: $field"
            }
        }

        if ($agent.id -notmatch "^[a-z0-9]+(?:-[a-z0-9]+)*$") {
            Add-Failure "$agentId has invalid id format"
        }

        if ([string]::IsNullOrWhiteSpace($agent.name)) {
            Add-Failure "$agentId missing name"
        }

        if ([string]::IsNullOrWhiteSpace($agent.division)) {
            Add-Failure "$agentId missing division"
        }

        if ([string]::IsNullOrWhiteSpace($agent.description) -or $agent.description.Length -lt 20) {
            Add-Failure "$agentId description is too short"
        }

        Test-NonEmptyStringArray -Value $agent.whenToUse -Field "whenToUse" -AgentId $agentId
        Test-NonEmptyStringArray -Value $agent.inputs -Field "inputs" -AgentId $agentId
        Test-NonEmptyStringArray -Value $agent.outputs -Field "outputs" -AgentId $agentId
        Test-NonEmptyStringArray -Value $agent.tools -Field "tools" -AgentId $agentId

        if ($allowedRisk -notcontains $agent.riskLevel) {
            Add-Failure "$agentId has invalid riskLevel: $($agent.riskLevel)"
        }

        foreach ($tool in $agent.tools) {
            if ($allowedTools -notcontains $tool) {
                Add-Failure "$agentId uses unsupported tool: $tool"
            }
        }

        foreach ($tag in $agent.memoryTags) {
            if ($allowedMemoryTags -notcontains $tag) {
                Add-Failure "$agentId uses unsupported memory tag: $tag"
            }
        }

        if ($agent.requiresApproval -isnot [bool]) {
            Add-Failure "$agentId requiresApproval must be boolean"
        }

        $filePath = $agent.file -replace "/", "\"
        if (-not (Test-Path $filePath)) {
            Add-Failure "$agentId references missing file: $($agent.file)"
            continue
        }

        $agentText = Get-Content $filePath -Raw
        if ($agentText -notmatch "(?m)^name:\s*$([regex]::Escape($agent.id))\s*$") {
            Add-Failure "$agentId file frontmatter name does not match registry id"
        }
    }

    if ($failures.Count -gt 0) {
        Write-Host ""
        Write-Host "Agent registry validation failed with $($failures.Count) issue(s)." -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Add-Ok "Agent registry valid: $($registry.agents.Count) agents"
    exit 0
} finally {
    Pop-Location
}

