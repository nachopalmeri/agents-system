#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot
try {
    Write-Host "Agents System Release Check" -ForegroundColor Cyan
    Write-Host "Repo: $repoRoot"
    Write-Host ""

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

    $psFiles = @(
        "bin\nuevo-proyecto.ps1",
        "bin\check-agents-system.ps1",
        "bin\check-secrets.ps1",
        "bin\validate-agents.ps1",
        "bin\route-task.ps1",
        "bin\doctor.ps1",
        "bin\release-check.ps1",
        "install.ps1",
        "install-private.ps1",
        "setup-local.ps1",
        "update.ps1"
    )

    foreach ($file in $psFiles) {
        if (-not (Test-Path $file)) {
            Add-Failure "Missing PowerShell script: $file"
            continue
        }

        $tokens = $null
        $parseErrors = $null
        [System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path $file), [ref]$tokens, [ref]$parseErrors) | Out-Null
        if ($parseErrors.Count -gt 0) {
            Add-Failure "PowerShell parse failed: $file :: $($parseErrors[0].Message)"
        } else {
            Add-Ok "PowerShell parse: $file"
        }
    }

    $bashFiles = @("install.sh", "update.sh", "bin/nuevo-proyecto.sh")
    $bash = Get-Command bash -ErrorAction SilentlyContinue
    $isWslLauncher = $bash -and ($bash.Source -like "$env:WINDIR\system32\bash.exe" -or $bash.Source -like "$env:WINDIR\SysWOW64\bash.exe")
    if ($bash -and -not $isWslLauncher) {
        foreach ($file in $bashFiles) {
            if (-not (Test-Path $file)) {
                Add-Failure "Missing Bash script: $file"
                continue
            }

            & bash -n $file 2>$null
            if ($LASTEXITCODE -ne 0) {
                Add-Failure "Bash syntax failed: $file"
            } else {
                Add-Ok "Bash syntax: $file"
            }
        }
    } elseif ($isWslLauncher) {
        Write-Host "[SKIP] Bash syntax: solo WSL launcher disponible. Validar manualmente o instalar Git for Windows." -ForegroundColor DarkGray
    } else {
        Write-Host "[SKIP] Bash syntax: bash no disponible" -ForegroundColor DarkGray
    }

    try {
        Get-Content "config\opencode\opencode.jsonc" -Raw | ConvertFrom-Json | Out-Null
        Add-Ok "JSON parse: config/opencode/opencode.jsonc"
    } catch {
        Add-Failure "JSON parse failed: config/opencode/opencode.jsonc :: $($_.Exception.Message)"
    }

    $required = @(
        ".agents\AGENTS.md",
        ".agents\rules\chat-first.md",
        ".agents\rules\anti-cemetery.md",
        ".agents\workflows\index.md",
        ".agents\workflows\validation.md",
        ".agents\workflows\session_checkpoint.md",
        ".agents\workflows\multiagent_review_loop.md",
        ".agents\workflows\parallel_agents.md",
        ".agents\workflows\skills_routing.md",
        ".agents\workflows\start.md",
        ".agents\workflows\hooks.md",
        ".agents\workflows\agent_coordination.md",
        ".agents\workflows\mcp_catalog.md",
        ".agents\workflows\mcp_security.md",
        ".agents\workflows\mcp_adoption.md",
        ".agents\memory\README.md",
        ".agents\memory\lessons-global.md",
        ".agents\memory\developer_growth.md",
        ".agents\memory\tech_radar.md",
        ".agents\skills\client-work\SKILL.md",
        ".agents\skills\client-work\pricing.md",
        "docs\world-class-workflow.md",
        "README.md",
        "agents.registry.json",
        "schemas\agent.schema.json",
        "schemas\task.schema.json",
        "docs\agent-contract-baseline.md",
        "docs\task-envelope.md",
        "bin\nuevo-proyecto.ps1",
        "bin\check-agents-system.ps1",
        "bin\validate-agents.ps1",
        "bin\route-task.ps1",
        "bin\release-check.ps1",
        "orchestrator\router.ps1",
        "examples\tasks\security-review.json",
        "examples\tasks\docs-update.json",
        "examples\tasks\bugfix.json",
        "config\opencode\opencode.jsonc"
    )

    foreach ($file in $required) {
        if (Test-Path $file) {
            Add-Ok "Required file: $file"
        } else {
            Add-Failure "Missing required file: $file"
        }
    }

    $name = git config user.name
    $email = git config user.email
    if ($name -eq "nachopalmeri" -and $email -eq "ipalmeri@uade.edu.ar") {
        Add-Ok "Git identity: $name <$email>"
    } else {
        Add-Failure "Git identity mismatch: $name <$email>"
    }

    $badEmailPattern = "uade\.edu\.com\.ar|ipalmeri@uade\.edu\.com"
    $badEmailMatches = & git grep -n -I -E $badEmailPattern -- "*.md" "*.ps1" "*.sh" "*.jsonc" "*.txt" 2>$null
    if ($LASTEXITCODE -eq 0 -and $badEmailMatches) {
        Add-Failure "Incorrect email variant found in repository"
    } elseif ($LASTEXITCODE -eq 1) {
        Add-Ok "No incorrect email variant found"
    } else {
        Add-Failure "Email scan failed"
    }

    & "$PSScriptRoot\check-secrets.ps1"
    if ($LASTEXITCODE -ne 0) {
        Add-Failure "Secret scan found critical issues"
    } else {
        Add-Ok "Secret scan: no critical findings"
    }

    & "$PSScriptRoot\validate-agents.ps1"
    if ($LASTEXITCODE -ne 0) {
        Add-Failure "Agent registry validation failed"
    } else {
        Add-Ok "Agent registry validation"
    }

    $routeExamples = @(
        "examples\tasks\security-review.json",
        "examples\tasks\docs-update.json",
        "examples\tasks\bugfix.json"
    )

    foreach ($example in $routeExamples) {
        try {
            $routeJson = & "$PSScriptRoot\route-task.ps1" $example
            $route = $routeJson | ConvertFrom-Json
            if ($LASTEXITCODE -ne 0 -or $null -eq $route.selectedAgents -or $route.selectedAgents.Count -eq 0) {
                Add-Failure "Route smoke failed: $example"
            } else {
                Add-Ok "Route smoke: $example -> $($route.selectedAgents.Count) agent(s)"
            }
        } catch {
            Add-Failure "Route smoke failed: $example :: $($_.Exception.Message)"
        }
    }

    Write-Host ""
    if ($failures.Count -gt 0) {
        Write-Host "Release check failed with $($failures.Count) issue(s)." -ForegroundColor Red
        exit 1
    }

    Write-Host "Release check passed." -ForegroundColor Green
    exit 0
} finally {
    Pop-Location
}
