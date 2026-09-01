# Health check read-only del sistema global de agentes
$ErrorActionPreference = "Continue"

Write-Host "=== Agents System Health Check ===" -ForegroundColor Cyan
Write-Host ""

$checks = @(
    @{ Name = "Global AGENTS.md"; Path = "$env:USERPROFILE\.agents\AGENTS.md" },
    @{ Name = "Chat-first rule"; Path = "$env:USERPROFILE\.agents\rules\chat-first.md" },
    @{ Name = "Workflow index"; Path = "$env:USERPROFILE\.agents\workflows\index.md" },
    @{ Name = "Validation workflow"; Path = "$env:USERPROFILE\.agents\workflows\validation.md" },
    @{ Name = "Session checkpoint workflow"; Path = "$env:USERPROFILE\.agents\workflows\session_checkpoint.md" },
    @{ Name = "Spec Kit skill"; Path = "$env:USERPROFILE\.agents\skills\spec-kit\SKILL.md" },
    @{ Name = "AI production skill"; Path = "$env:USERPROFILE\.agents\skills\ai-production-architecture\SKILL.md" },
    @{ Name = "Marketing strategist agent"; Path = "$env:USERPROFILE\.agents\agents\agente-marketing-strategist.md" },
    @{ Name = "Capabilities ledger"; Path = "$env:USERPROFILE\config\capabilities.json" },
    @{ Name = "Routing rules ledger"; Path = "$env:USERPROFILE\config\routing-rules.json" },
    @{ Name = "nuevo-proyecto.ps1"; Path = "$env:USERPROFILE\bin\nuevo-proyecto.ps1" },
    @{ Name = "nuevo-proyecto.sh"; Path = "$env:USERPROFILE\bin\nuevo-proyecto.sh" },
    @{ Name = "OpenCode config"; Path = "$env:USERPROFILE\.config\opencode\opencode.jsonc" }
)
# Nota: project_types.md, spec_kit.md (workflow), ai_production.md, web_briefing.md,
# marketing.md (workflow), marketing_mcp_eval.md y la skill web-presentation-premium
# fueron archivados a propósito en una poda anterior (ver .agents/archive/) y su
# funcionalidad quedó cubierta por skills existentes (spec-kit, ai-production-architecture,
# seo-geo-growth). Se sacaron de este check para que no reporte falsos positivos.

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
Write-Host "=== Referencias rotas (workflows/*.md, skills/*/SKILL.md) ===" -ForegroundColor Cyan
$agentsRoot = "$env:USERPROFILE\.agents"
$scanFiles = @("$agentsRoot\AGENTS.md", "$agentsRoot\workflows\index.md") +
    (Get-ChildItem "$agentsRoot\rules" -Filter "*.md" -ErrorAction SilentlyContinue).FullName
$pattern = '(workflows/[a-zA-Z0-9_\-]+\.md|skills/[a-zA-Z0-9_\-]+/SKILL\.md)'
$brokenRefs = 0
foreach ($file in $scanFiles) {
    if (-not (Test-Path $file)) { continue }
    $matches = [regex]::Matches((Get-Content -Raw -Encoding utf8 -Path $file), $pattern)
    foreach ($m in $matches) {
        $refPath = Join-Path $agentsRoot $m.Value
        if (-not (Test-Path $refPath)) {
            Write-Host "[BROKEN] $($m.Value) referenciado en $file" -ForegroundColor Red
            $brokenRefs++
        }
    }
}
if ($brokenRefs -eq 0) {
    Write-Host "Sin referencias rotas detectadas." -ForegroundColor Green
} else {
    Write-Host "$brokenRefs referencia(s) rota(s) encontrada(s)." -ForegroundColor Red
    $missing += $brokenRefs
}

Write-Host ""
Write-Host "Tip: run 'nuevo-proyecto --help' to verify scaffold entrypoint." -ForegroundColor Gray
