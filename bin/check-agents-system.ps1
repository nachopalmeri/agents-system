# Health check read-only del sistema global de agentes
$ErrorActionPreference = "Continue"

Write-Host "=== Agents System Health Check ===" -ForegroundColor Cyan
Write-Host ""

$checks = @(
    @{ Name = "Global AGENTS.md"; Path = "$env:USERPROFILE\.agents\AGENTS.md" },
    @{ Name = "Chat-first rule"; Path = "$env:USERPROFILE\.agents\rules\chat-first.md" },
    @{ Name = "Workflow index"; Path = "$env:USERPROFILE\.agents\workflows\index.md" },
    @{ Name = "Validation workflow"; Path = "$env:USERPROFILE\.agents\workflows\validation.md" },
    @{ Name = "Feedback loop workflow"; Path = "$env:USERPROFILE\.agents\workflows\feedback_loop.md" },
    @{ Name = "Session checkpoint workflow"; Path = "$env:USERPROFILE\.agents\workflows\session_checkpoint.md" },
    @{ Name = "Project types workflow"; Path = "$env:USERPROFILE\.agents\workflows\project_types.md" },
    @{ Name = "Task ledger workflow"; Path = "$env:USERPROFILE\.agents\workflows\task_ledger.md" },
    @{ Name = "Multiagent review workflow"; Path = "$env:USERPROFILE\.agents\workflows\multiagent_review_loop.md" },
    @{ Name = "Spec Kit workflow"; Path = "$env:USERPROFILE\.agents\workflows\spec_kit.md" },
    @{ Name = "AI production workflow"; Path = "$env:USERPROFILE\.agents\workflows\ai_production.md" },
    @{ Name = "Web briefing workflow"; Path = "$env:USERPROFILE\.agents\workflows\web_briefing.md" },
    @{ Name = "Spec Kit skill"; Path = "$env:USERPROFILE\.agents\skills\spec-kit\SKILL.md" },
    @{ Name = "AI production skill"; Path = "$env:USERPROFILE\.agents\skills\ai-production-architecture\SKILL.md" },
    @{ Name = "Web premium skill"; Path = "$env:USERPROFILE\.agents\skills\web-presentation-premium\SKILL.md" },
    @{ Name = "Venture Loop workflow"; Path = "$env:USERPROFILE\.agents\workflows\venture_loop.md" },
    @{ Name = "Marketing workflow"; Path = "$env:USERPROFILE\.agents\workflows\marketing.md" },
    @{ Name = "Marketing MCP eval"; Path = "$env:USERPROFILE\.agents\workflows\marketing_mcp_eval.md" },
    @{ Name = "Marketing strategist agent"; Path = "$env:USERPROFILE\.agents\agents\agente-marketing-strategist.md" },
    @{ Name = "Product Foundry workflow"; Path = "$env:USERPROFILE\.agents\workflows\product_foundry.md" },
    @{ Name = "Product Foundry skill"; Path = "$env:USERPROFILE\.agents\skills\product-foundry\SKILL.md" },
    @{ Name = "Product Founder agent"; Path = "$env:USERPROFILE\.agents\agents\agente-product-founder.md" },
    @{ Name = "SEO/GEO/AEO growth workflow"; Path = "$env:USERPROFILE\.agents\workflows\seo_geo_growth.md" },
    @{ Name = "SEO/GEO/AEO growth skill"; Path = "$env:USERPROFILE\.agents\skills\seo-geo-growth\SKILL.md" },
    @{ Name = "SEO/GEO/AEO growth agent"; Path = "$env:USERPROFILE\.agents\agents\agente-growth-seo-geo.md" },
    @{ Name = "nuevo-proyecto.ps1"; Path = "$env:USERPROFILE\bin\nuevo-proyecto.ps1" },
    @{ Name = "nuevo-proyecto.sh"; Path = "$env:USERPROFILE\bin\nuevo-proyecto.sh" },
    @{ Name = "OpenCode config"; Path = "$env:USERPROFILE\.config\opencode\opencode.jsonc" }
)

$missing = 0
foreach ($check in $checks) {
    if (Test-Path $check.Path) {
        Write-Host "[OK] $($check.Name)" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] $($check.Name) -> $($check.Path)" -ForegroundColor Red
        $missing++
    }
}

Write-Host ""
if ($missing -eq 0) {
    Write-Host "System OK: all required files exist." -ForegroundColor Green
} else {
    Write-Host "System incomplete: $missing missing item(s)." -ForegroundColor Red
}

Write-Host ""
Write-Host "Tip: run 'nuevo-proyecto --help' to verify scaffold entrypoint." -ForegroundColor Gray
