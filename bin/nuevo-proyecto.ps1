# Uso: nuevo-proyecto <nombre> [stack]
# Ejemplo: nuevo-proyecto mi-landing astro

param(
    [Parameter(Position=0)][string]$Nombre,
    [Parameter(Position=1)][string]$Stack = "html-css-js"
)

function Write-Utf8File {
    param(
        [string]$Path,
        [string]$Content
    )
    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

function Initialize-StandardTaskFiles {
    param(
        [string]$ProjectRoot,
        [string]$ProjectName
    )

    $tasksDir = Join-Path $ProjectRoot "tasks"
    New-Item -ItemType Directory -Path $tasksDir -Force | Out-Null

    Write-Utf8File (Join-Path $tasksDir "todo.md") @"
# Todo

## En progreso
(vacio)

## Pendiente
(agregar tareas aca)

## Completado
(vacio)
"@

    Write-Utf8File (Join-Path $tasksDir "lessons.md") @"
# Lecciones Aprendidas

Tras cualquier correccion del director, agregar una regla aca.
Formato: "Siempre X" o "Nunca Y"

## Reglas
(vacio por ahora)
"@

    Write-Utf8File (Join-Path $tasksDir "handoff.md") @"
# Handoff - $ProjectName

> Este archivo esta escrito para vos-del-futuro que no tiene contexto.
> El agente lo actualiza al cierre de cada sesion importante.

## Estado actual

## Ultima sesion
Fecha:
Que se hizo:
Que quedo sin terminar:

## Decisiones pendientes

## Proximo paso concreto

## Que NO tocar

## Contexto que no esta en el codigo
"@

    Write-Utf8File (Join-Path $tasksDir "decisions.md") @"
# Decisiones del Proyecto

## Formato
| Fecha | Decision | Alternativas evaluadas | Por que esta | Costo si me equivoque |
|---|---|---|---|---|
"@

    Write-Utf8File (Join-Path $tasksDir "tech-debt.md") @"
# Tech Debt

## Formato
Cada deuda tiene:
- Que es (una linea)
- Por que se tomo conscientemente (contexto de la decision)
- Costo si no se paga (impacto real)
- Cuando tiene sentido pagarla (trigger, no fecha)
- Prioridad: CRITICA / ALTA / MEDIA / BAJA

## Deudas activas

## Deudas pagadas
(mantener registro de que se resolvio y cuando)
"@
}

if (-not $Nombre -or $Nombre -in @("help", "--help", "-h")) {
    Write-Host @"
Uso: nuevo-proyecto <nombre> [stack]

Stacks:
- html-css-js     proyecto simple
- astro           landing estatica/SEO
- next            app web React/Next
- python          proyecto Python/CLI
- ai-prod         AI/RAG production-ready
- spec-kit        Spec-Driven Development opcional
- saas-mvp        producto SaaS validable con Venture Loop
- local-business  negocio local con oferta, landing y SEO local
- seo-growth      proyecto centrado en SEO/GEO/AEO growth
- product-foundry ideas, MVPs y validacion indie/AI-first
- client-work     trabajo de cliente con brief, propuesta, entrega y feedback

Ejemplos:
- nuevo-proyecto landing astro
- nuevo-proyecto jobbot-ai ai-prod
- nuevo-proyecto app-compleja spec-kit
- nuevo-proyecto mini-saas saas-mvp
- nuevo-proyecto dulces-creaciones local-business
- nuevo-proyecto defesfiesta client-work
"@
    exit 1
}

$base = Join-Path $HOME $Nombre

# ── Crear directorio e inicializar git ──
New-Item -ItemType Directory -Path $base -Force | Out-Null
Set-Location $base
git init
git commit --allow-empty -m "chore: init"

if ($Stack -eq "ai-prod") {
    $dirs = @(
        "app/components",
        "services",
        "prompts",
        "agents/tools",
        "security",
        "evaluation/eval_results",
        "observability",
        "data/raw",
        "data/processed",
        "data/index_config",
        "scripts",
        "frontend/static",
        "tests",
        "docs",
        ".claude/rules",
        ".github",
        "tasks"
    )

    foreach ($dir in $dirs) {
        New-Item -ItemType Directory -Path (Join-Path $base $dir) -Force | Out-Null
    }

    Initialize-StandardTaskFiles -ProjectRoot $base -ProjectName $Nombre

    $files = @{
        "app/main.py" = '"""FastAPI entrypoint for the AI production app."""'
        "app/config.py" = '"""Application configuration."""'
        "app/models.py" = '"""Shared API and domain models."""'
        "app/Dockerfile" = "FROM python:3.12-slim"
        "app/components/hybrid_retriever.py" = '"""Hybrid retrieval: keyword/vector search orchestration."""'
        "app/components/reranker.py" = '"""Document reranking component."""'
        "services/rag_pipeline.py" = '"""RAG pipeline orchestration."""'
        "services/semantic_cache.py" = '"""Semantic cache service."""'
        "services/conversation.py" = '"""Conversation memory and state service."""'
        "services/query_rewriter.py" = '"""Query rewriting service."""'
        "services/query_router.py" = '"""Query routing service."""'
        "prompts/templates.py" = '"""Versioned prompt templates."""'
        "prompts/registry.py" = '"""Prompt registry. Never hardcode prompts in services."""'
        "agents/document_grader.py" = '"""Document relevance grading agent."""'
        "agents/query_decomposer.py" = '"""Query decomposition agent."""'
        "agents/adaptive_router.py" = '"""Adaptive routing agent."""'
        "agents/tools/vector_search.py" = '"""Vector search tool."""'
        "agents/tools/web_search.py" = '"""Web search tool."""'
        "agents/tools/code_search.py" = '"""Code search tool."""'
        "security/input_guard.py" = '"""Input validation and prompt-injection guard."""'
        "security/content_filter.py" = '"""Retrieved/generated content filtering."""'
        "security/output_filter.py" = '"""Final output safety and quality filtering."""'
        "evaluation/golden_dataset.json" = "{`n  `"cases`": []`n}"
        "evaluation/offline_eval.py" = '"""Offline evaluation runner."""'
        "evaluation/online_monitor.py" = '"""Online quality monitor."""'
        "observability/tracer.py" = '"""Per-stage tracing utilities."""'
        "observability/feedback.py" = '"""User feedback linked to traces."""'
        "observability/cost_tracker.py" = '"""Cost tracking per query/model/stage."""'
        "scripts/seed.py" = '"""Seed development data."""'
        "scripts/migrate.py" = '"""Run migrations."""'
        "scripts/healthcheck.py" = '"""Healthcheck script."""'
        "frontend/app.py" = '"""Frontend entrypoint placeholder."""'
        "frontend/requirements.txt" = ""
        "frontend/Dockerfile" = "FROM python:3.12-slim"
        "tests/test_retrieval.py" = '"""Retrieval tests."""'
        "tests/test_cache.py" = '"""Semantic cache tests."""'
        "tests/test_routing.py" = '"""Routing tests."""'
        "docs/architecture.md" = "# Architecture`n`nAI production architecture: services, agents, prompts, security, evaluation and observability."
        "docs/api-reference.md" = "# API Reference`n"
        "docs/deployment.md" = "# Deployment`n"
        ".claude/rules/code-style.md" = "# Code Style`n`nFollow project AGENTS.md and global ~/.agents/rules/code-style.md."
        ".claude/rules/testing.md" = "# Testing`n`nFollow project AGENTS.md and global ~/.agents/rules/testing.md."
        "docker-compose.yml" = "services:`n  app:`n    build: ./app`n"
        "pyproject.toml" = "[project]`nname = `"$Nombre`"`nversion = `"0.1.0`"`nrequires-python = `">=3.12`"`n"
        "README.md" = "# $Nombre`n`nAI production-ready project scaffold."
        "tasks/todo.md" = "# Todo`n`n## En progreso`n(vacio)`n`n## Pendiente`n- [ ] Definir golden dataset inicial`n- [ ] Implementar RAG pipeline mínimo`n- [ ] Agregar tracing y cost tracking`n`n## Completado`n(vacio)`n"
        "tasks/lessons.md" = "# Lecciones Aprendidas`n`n## Reglas`n(vacio por ahora)`n"
        "feature_list.json" = "{`n  `"proyecto`": `"$Nombre`",`n  `"stack`": `"ai-prod`",`n  `"features`": []`n}"
        ".gitignore" = "node_modules/`n.env`n.env.local`ndist/`n__pycache__/`n*.pyc`n.DS_Store`n*.log`n"
    }

    foreach ($entry in $files.GetEnumerator()) {
        Set-Content -Path (Join-Path $base $entry.Key) -Value $entry.Value -Encoding UTF8
    }

    $agentsContent = @"
# $Nombre

## Stack
ai-prod — AI/RAG production architecture

## Arquitectura
- app/ → entrypoint, config, models, Dockerfile
- services/ → RAG pipeline, semantic cache, conversation memory, query rewriting, routing
- prompts/ → templates versionados y registry
- agents/ → document grading, query decomposition, adaptive routing, tools
- security/ → input/content/output guards
- evaluation/ → golden dataset, offline eval, online monitor
- observability/ → tracing, feedback, cost tracking
- data/ → raw, processed, index_config

## Reglas Inmutables
1. Nunca hardcodear prompts en services: usar prompts/registry.py
2. Toda feature AI debe tener evaluación mínima o justificar por qué no
3. Toda llamada LLM debe ser trazable y tener cost tracking
4. Input/content/output guards antes de producción
5. No declarar production-ready sin golden dataset y offline eval
6. Commits en espanol: feat | fix | chore | docs | test
7. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md

## Agentes
- agente-ai-architect → arquitectura AI/RAG y capas production-ready
- agente-principal → lógica e implementación
- agente-tests → tests y evaluación
- agente-docs → docs de arquitectura/API/deploy

## Validación
1. git diff --stat
2. Ejecutar tests si existen
3. Ejecutar evaluación offline si existe
4. Revisar costos/traces si se tocó pipeline AI
"@
    Set-Content -Path (Join-Path $base "AGENTS.md") -Value $agentsContent -Encoding UTF8

    $copilotContent = @"
# $Nombre — Instrucciones para Copilot

Proyecto AI/RAG production-ready. Mantener separadas las capas:
services, agents, prompts, security, evaluation, observability.

Reglas:
1. No hardcodear prompts: usar prompts/registry.py
2. No saltear evaluación para cambios AI importantes
3. Agregar tracing y cost tracking a llamadas LLM
4. Validar input/content/output antes de producción
5. Tests mínimos: retrieval, cache, routing
"@
    Set-Content -Path (Join-Path $base ".github/copilot-instructions.md") -Value $copilotContent -Encoding UTF8

    git add -A
    git commit -m "chore: estructura ai production del proyecto"

    $wt1 = Join-Path $HOME "agente-1-$Nombre"
    $wt2 = Join-Path $HOME "agente-2-$Nombre"
    $wt3 = Join-Path $HOME "agente-3-$Nombre"
    git worktree add $wt1 -b agente/feature
    git worktree add $wt2 -b agente/design
    git worktree add $wt3 -b agente/tests

    Write-Host ""
    Write-Host "Proyecto AI production '$Nombre' listo" -ForegroundColor Green
    Write-Host "Estructura creada con services/, agents/, prompts/, security/, evaluation/ y observability/"
    exit 0
}

if ($Stack -eq "spec-kit") {
    $dirs = @(
        "tasks",
        ".github",
        ".specify/memory",
        ".specify/specs",
        ".specify/templates"
    )

    foreach ($dir in $dirs) {
        New-Item -ItemType Directory -Path (Join-Path $base $dir) -Force | Out-Null
    }

    Initialize-StandardTaskFiles -ProjectRoot $base -ProjectName $Nombre

    $agentsContent = @"
# $Nombre

## Stack
spec-kit — Spec-Driven Development opcional

## Modo de Trabajo
Este proyecto usa el scaffold base con una capa opcional `.specify/` para features medianas o grandes.

Para cambios chicos:
1. Leer AGENTS.md y tasks/todo.md
2. Plan Mode si hay más de 3 pasos
3. Implementar y validar

Para features medianas/grandes:
1. Revisar `.specify/memory/constitution.md`
2. Definir spec: qué y por qué
3. Crear plan técnico: cómo
4. Generar tasks verificables
5. Implementar contra criterios de aceptación

## Reglas Inmutables
1. No usar Spec Kit para fixes chicos
2. No implementar features grandes sin spec/plan/tasks
3. Commits en espanol: feat | fix | chore | docs | test
4. Nunca marcar tarea como completada sin demostrar que funciona
5. Tras cualquier correccion: actualizar tasks/lessons.md
6. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md

## Validación
1. git diff --stat
2. Correr tests si existen
3. Validar criterios de aceptación de `.specify/specs/` si aplica
"@
    Set-Content -Path (Join-Path $base "AGENTS.md") -Value $agentsContent -Encoding UTF8

    $constitutionContent = @"
# Constitution

## Principios
1. La especificación define el qué y el por qué antes del cómo.
2. El plan técnico debe respetar `AGENTS.md`.
3. Las tareas deben ser atómicas, verificables y ordenadas por dependencia.
4. No se declara completado sin validación.
5. Los cambios chicos pueden usar el flujo simple sin Spec Kit.

## Calidad
- Código simple y mantenible.
- Tests cuando exista lógica con riesgo.
- UX clara si hay interfaz.
- Performance razonable para el stack elegido.

## Gobernanza
Esta constitution complementa, no reemplaza, `AGENTS.md`.
"@
    Set-Content -Path (Join-Path $base ".specify/memory/constitution.md") -Value $constitutionContent -Encoding UTF8

    $specifyReadme = @"
# .specify/

Carpeta para Spec-Driven Development opcional.

## Flujo
1. Constitution: `.specify/memory/constitution.md`
2. Specify: crear spec en `.specify/specs/`
3. Plan: definir implementación técnica
4. Tasks: desglosar tareas verificables
5. Implement: ejecutar y validar

Usar solo para features medianas o grandes.
"@
    Set-Content -Path (Join-Path $base ".specify/README.md") -Value $specifyReadme -Encoding UTF8

    Set-Content -Path (Join-Path $base ".specify/templates/spec-template.md") -Value "# Spec`n`n## Problema`n`n## Usuarios`n`n## Requisitos`n`n## Criterios de aceptación`n`n## No objetivos`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base ".specify/templates/plan-template.md") -Value "# Plan`n`n## Stack`n`n## Arquitectura`n`n## Archivos a tocar`n`n## Riesgos`n`n## Validación`n`n## Qué NO se toca`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base ".specify/templates/tasks-template.md") -Value "# Tasks`n`n- [ ] Tarea verificable 1`n" -Encoding UTF8

    $todoContent = @"
# Todo

## En progreso
(vacio)

## Pendiente
- [ ] Definir primera spec si la feature lo amerita

## Completado
(vacio)
"@
    Set-Content -Path (Join-Path $base "tasks/todo.md") -Value $todoContent -Encoding UTF8
    Set-Content -Path (Join-Path $base "tasks/lessons.md") -Value "# Lecciones Aprendidas`n`n## Reglas`n(vacio por ahora)`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "feature_list.json") -Value "{`n  `"proyecto`": `"$Nombre`",`n  `"stack`": `"spec-kit`",`n  `"features`": []`n}" -Encoding UTF8
    Set-Content -Path (Join-Path $base ".gitignore") -Value "node_modules/`n.env`n.env.local`ndist/`n.DS_Store`n*.log`n" -Encoding UTF8

    $copilotContent = @"
# $Nombre — Instrucciones para Copilot

Proyecto con Spec-Driven Development opcional.

Reglas:
1. Para features medianas/grandes, usar `.specify/` antes de implementar
2. Para cambios chicos, usar el flujo simple de `AGENTS.md`
3. No marcar completado sin validar criterios de aceptación
4. No instalar dependencias sin confirmar
"@
    Set-Content -Path (Join-Path $base ".github/copilot-instructions.md") -Value $copilotContent -Encoding UTF8

    git add -A
    git commit -m "chore: estructura spec kit del proyecto"

    $wt1 = Join-Path $HOME "agente-1-$Nombre"
    $wt2 = Join-Path $HOME "agente-2-$Nombre"
    $wt3 = Join-Path $HOME "agente-3-$Nombre"
    git worktree add $wt1 -b agente/feature
    git worktree add $wt2 -b agente/design
    git worktree add $wt3 -b agente/tests

    Write-Host ""
    Write-Host "Proyecto Spec Kit '$Nombre' listo" -ForegroundColor Green
    Write-Host "Estructura creada con .specify/, AGENTS.md, tasks/ y Copilot instructions"
    exit 0
}

if ($Stack -in @("saas-mvp", "local-business", "seo-growth", "product-foundry")) {
    $dirs = @(
        "product",
        "growth",
        "landing",
        "metrics",
        "docs",
        "tasks",
        ".github"
    )

    foreach ($dir in $dirs) {
        New-Item -ItemType Directory -Path (Join-Path $base $dir) -Force | Out-Null
    }

    Initialize-StandardTaskFiles -ProjectRoot $base -ProjectName $Nombre

    $presetTitle = switch ($Stack) {
        "saas-mvp" { "SaaS MVP" }
        "local-business" { "Local Business" }
        "seo-growth" { "SEO/GEO Growth" }
        "product-foundry" { "Product Foundry" }
    }

    $primaryWorkflow = switch ($Stack) {
        "saas-mvp" { "venture_loop.md + product_foundry.md + web_briefing.md" }
        "local-business" { "venture_loop.md + seo_geo_growth.md + marketing.md" }
        "seo-growth" { "seo_geo_growth.md + validation.md" }
        "product-foundry" { "product_foundry.md + venture_loop.md" }
    }

    $primaryAgents = switch ($Stack) {
        "saas-mvp" { "agente-product-founder, agente-principal, agente-design, agente-growth-seo-geo" }
        "local-business" { "agente-product-founder, agente-growth-seo-geo, agente-marketing-strategist, agente-seo" }
        "seo-growth" { "agente-growth-seo-geo, agente-seo, agente-marketing-strategist" }
        "product-foundry" { "agente-product-founder, kickoff-architect, agente-growth-seo-geo" }
    }

    $agentsContent = @"
# $Nombre

## Preset
$presetTitle

## Workflow principal
$primaryWorkflow

## Workflow maestro
Seguir docs/world-class-workflow.md del sistema global si existe. Si no está disponible, usar AGENTS.md + start.md + index.md + phases.md + validation.md.

## Agentes sugeridos
$primaryAgents

## Reglas Inmutables
1. El usuario habla normal; enrutar internamente al menor workflow suficiente.
2. Usar venture_loop.md si el objetivo va de idea a producto validado.
3. Usar product_foundry.md para ideas, flujos de dinero, MVP patineta y kill/scale.
4. Usar seo_geo_growth.md si hay demanda buscable, landings, backlinks, GSC/GA4 o GEO/AEO.
5. Usar web_briefing.md antes de crear landing o web.
6. Programmatic SEO solo con páginas útiles, diferenciadas, medibles y con criterio de poda.
7. DataForSEO, PostHog, Mixpanel o analytics MCPs empiezan read-only/draft si usan credenciales o datos reales.
8. Nunca ejecutar gasto publicitario ni responder DMs sin confirmación explícita.
9. No declarar listo sin validation.md.
10. Mantener tasks/todo.md y tasks/lessons.md actualizados si aplica.
11. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md.

## Validación
1. Revisar scope y archivos tocados.
2. Ejecutar tests/build si existen.
3. Validar JSON/config si aplica.
4. Correr secret scan antes de publicar o conectar servicios externos.
5. Reportar riesgos y próximos pasos.
"@
    Set-Content -Path (Join-Path $base "AGENTS.md") -Value $agentsContent -Encoding UTF8

    Set-Content -Path (Join-Path $base "product/idea-scorecard.md") -Value "# Idea Scorecard`n`n## Ideas`n`n| Idea | Money flow | Pain | Buyer | Reachability | MVP | Channel | AI leverage | Retention | Founder fit | Total | Veredicto |`n|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "product/mvp.md") -Value "# MVP Patineta`n`n## Usuario`n`n## Dolor`n`n## Promesa`n`n## Flujo feliz mínimo`n`n## Qué se hace manualmente`n`n## Qué NO se construye todavía`n`n## Pricing hypothesis`n`n## Kill/scale criteria`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "growth/seo-backlog.md") -Value "# SEO/GEO Backlog`n`n## Keyword map`n`n| Keyword | Intent | Page type | Priority | Status |`n|---|---|---|---:|---|`n`n## Backlinks/Citations`n`n## GSC/GA4 learnings`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "growth/content-pruning.md") -Value "# Content Pruning`n`n## Regla`n`nReformar, fusionar, noindexar o borrar páginas sin interés real.`n`n## Revisión mensual`n`n| URL | Señal | Problema | Decisión | Próxima acción |`n|---|---|---|---|---|`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "growth/backlinks.md") -Value "# Backlinks & Authority`n`n## Principios`n`n- Backlinks legítimos, no spam.`n- Proyectos propios relacionados pueden ayudar.`n- Priorizar partnerships, directorios relevantes, PR real, casos y assets linkables.`n`n## Backlog`n`n| Fuente | Tipo | Prioridad | Estado | Nota |`n|---|---|---:|---|---|`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "landing/brief.md") -Value "# Landing Brief`n`n## ICP`n`n## Pain`n`n## Promise`n`n## Headline`n`n## CTA`n`n## Sections`n`n## Proof`n`n## SEO/GEO angle`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "metrics/validation.md") -Value "# Validation Metrics`n`n## Strong signals`n`n- Payment`n- Preorder`n- Repeated usage`n- Qualified lead`n`n## Weak signals`n`n- Likes`n- Compliments`n- Traffic without conversion`n`n## Decision`n`nKILL / KEEP / SCALE`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "metrics/events.md") -Value "# Product Events`n`n## Eventos críticos`n`n| Event | User intent | Success signal | Notes |`n|---|---|---|---|`n| visit | Usuario llega | Página vista | |`n| signup | Usuario se registra | Cuenta creada | |`n| activation | Usuario logra valor | Acción core completada | |`n| repeat_usage | Usuario vuelve | Uso repetido | |`n| payment | Usuario paga | Pago/preorden | |`n`n## Analytics`n`nUsar PostHog, Mixpanel, GA4 o base propia si ya existe. MCPs con credenciales empiezan read-only/draft y requieren confirmación.`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "docs/venture-loop.md") -Value "# Venture Loop`n`nIdea → MVP → landing → distribution → measurement → kill/scale.`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "tasks/todo.md") -Value "# Todo`n`n## En progreso`n(vacio)`n`n## Pendiente`n- [ ] Completar idea scorecard`n- [ ] Definir MVP patineta`n- [ ] Crear landing brief`n- [ ] Definir canal inicial`n- [ ] Definir métricas de validación`n- [ ] Definir eventos críticos de producto`n- [ ] Definir estrategia de backlinks/citations`n- [ ] Definir criterio de poda SEO`n`n## Completado`n(vacio)`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "tasks/lessons.md") -Value "# Lecciones Aprendidas`n`n## Reglas`n(vacio por ahora)`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "feature_list.json") -Value "{`n  `"proyecto`": `"$Nombre`",`n  `"stack`": `"$Stack`",`n  `"features`": []`n}" -Encoding UTF8
    Set-Content -Path (Join-Path $base ".gitignore") -Value "node_modules/`n.env`n.env.local`ndist/`n.DS_Store`n*.log`n" -Encoding UTF8

    $copilotContent = @"
# $Nombre — Instrucciones para Copilot

Preset: $presetTitle

Reglas:
1. Seguir AGENTS.md.
2. No sobredimensionar antes de validación.
3. No instalar dependencias sin confirmar.
4. No declarar listo sin evidencia.
5. Nunca hardcodear credenciales.
"@
    Set-Content -Path (Join-Path $base ".github/copilot-instructions.md") -Value $copilotContent -Encoding UTF8

    git add -A
    git commit -m "chore: estructura $Stack del proyecto"

    $wt1 = Join-Path $HOME "agente-1-$Nombre"
    $wt2 = Join-Path $HOME "agente-2-$Nombre"
    $wt3 = Join-Path $HOME "agente-3-$Nombre"

    git worktree add $wt1 -b agente/feature
    git worktree add $wt2 -b agente/design
    git worktree add $wt3 -b agente/tests

    Write-Host ""
    Write-Host "Proyecto '$Nombre' listo con preset '$Stack'" -ForegroundColor Green
    Write-Host "Estructura creada con product/, growth/, landing/, metrics/, docs/ y tasks/"
    exit 0
}

if ($Stack -eq "client-work") {
    $dirs = @(
        "brief",
        "propuesta",
        "entregas",
        "feedback",
        "tasks",
        ".github"
    )

    foreach ($dir in $dirs) {
        New-Item -ItemType Directory -Path (Join-Path $base $dir) -Force | Out-Null
    }

    Initialize-StandardTaskFiles -ProjectRoot $base -ProjectName $Nombre

    $agentsContent = @"
# $Nombre

## Preset
client-work

## Workflow principal
client_workflow.md

## Reglas especificas de client work
1. No hacer cambios de scope sin registrarlos en propuesta/.
2. Todo feedback del cliente va a feedback/ antes de implementar.
3. Al cierre generar retro con lecciones para el proximo cliente.
4. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md.
5. Si una decision comercial o tecnica es dificil de revertir, usar tasks/decisions.md.
"@
    Set-Content -Path (Join-Path $base "AGENTS.md") -Value $agentsContent -Encoding UTF8

    Set-Content -Path (Join-Path $base "brief/brief-template.md") -Value "# Brief del Cliente`n`n## Cliente`n`n## Negocio`n`n## Objetivo`n`n## Audiencia`n`n## Tono`n`n## Referencias`n`n## Restricciones`n`n## Deadline`n`n## Presupuesto acordado`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "propuesta/pricing.md") -Value "# Pricing de referencia`n`nTomar estructura y categorias de `.agents/skills/client-work/pricing.md` antes de completar esta propuesta.`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "propuesta/v1.md") -Value "# Propuesta v1`n`n## Alcance`n`n## Incluye`n`n## No incluye`n`n## Precio`n`n## Timeline`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "feedback/iteracion-1.md") -Value "# Feedback - Iteracion 1`n`n## Pedido del cliente`n`n## En scope?`n`n## Accion`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "tasks/todo.md") -Value "# Todo`n`n## En progreso`n(vacio)`n`n## Pendiente`n- [ ] Completar brief inicial`n- [ ] Generar propuesta v1`n- [ ] Definir primera entrega`n- [ ] Registrar feedback del cliente`n`n## Completado`n(vacio)`n" -Encoding UTF8
    Set-Content -Path (Join-Path $base "feature_list.json") -Value "{`n  `"proyecto`": `"$Nombre`",`n  `"stack`": `"client-work`",`n  `"features`": []`n}" -Encoding UTF8
    Set-Content -Path (Join-Path $base ".gitignore") -Value "node_modules/`n.env`n.env.local`ndist/`n.DS_Store`n*.log`n" -Encoding UTF8

    $copilotContent = @"
# $Nombre — Instrucciones para Copilot

Preset: client-work

Reglas:
1. No cambiar scope sin registrarlo en propuesta/.
2. Todo feedback del cliente entra primero en feedback/.
3. No sobreescribir propuestas anteriores; versionar.
4. Registrar deuda intencional en tasks/tech-debt.md.
5. Registrar decisiones dificiles de revertir en tasks/decisions.md.
"@
    Set-Content -Path (Join-Path $base ".github/copilot-instructions.md") -Value $copilotContent -Encoding UTF8

    git add -A
    git commit -m "chore: estructura client work del proyecto"

    $wt1 = Join-Path $HOME "agente-1-$Nombre"
    $wt2 = Join-Path $HOME "agente-2-$Nombre"
    $wt3 = Join-Path $HOME "agente-3-$Nombre"

    git worktree add $wt1 -b agente/feature
    git worktree add $wt2 -b agente/design
    git worktree add $wt3 -b agente/tests

    Write-Host ""
    Write-Host "Proyecto '$Nombre' listo con preset 'client-work'" -ForegroundColor Green
    Write-Host "Estructura creada con brief/, propuesta/, entregas/, feedback/ y tasks/"
    exit 0
}

# ── AGENTS.md (instrucciones globales del proyecto) ──
$agentsContent = @"
# $Nombre

## Stack
$Stack

## Reglas Inmutables
1. Leer AGENTS.md y tasks/todo.md antes de cualquier accion
2. Plan Mode obligatorio para cualquier tarea de mas de 3 pasos
3. Commits en espanol: feat | fix | chore | style | docs
4. Nunca marcar tarea como "passing" sin demostrar que funciona
5. No tocar archivos fuera de tu scope de worktree
6. No instalar dependencias sin confirmar con el director
7. Tras cualquier correccion: actualizar tasks/lessons.md
8. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md

## Archivos Sagrados (NO editar sin confirmacion explicita)
- AGENTS.md
- package.json / package-lock.json
- .env / .env.local
- archivos de config raiz (astro.config, next.config, etc)

## Validacion Obligatoria Antes de Commit
1. git diff --stat -> revisar exactamente que tocaste
2. Correr tests: npm run test (si existen)
3. Verificar visualmente que nada se rompio
4. Solo entonces: commit + actualizar tasks/todo.md

## Convenciones de Commit
- feat: nueva funcionalidad
- fix: correccion de bug
- chore: mantenimiento sin logica
- style: estilos sin logica
- docs: documentacion
"@
Set-Content -Path (Join-Path $base "AGENTS.md") -Value $agentsContent -Encoding UTF8

# ── Estructura de tasks/ ──
$tasksDir = Join-Path $base "tasks"
New-Item -ItemType Directory -Path $tasksDir -Force | Out-Null

$todoContent = @"
# Todo

## En progreso
(vacio)

## Pendiente
(agregar tareas aca)

## Completado
(vacio)
"@
Set-Content -Path (Join-Path $tasksDir "todo.md") -Value $todoContent -Encoding UTF8

$lessonsContent = @"
# Lecciones Aprendidas

Tras cualquier correccion del director, agregar una regla aca.
Formato: "Siempre X" o "Nunca Y"

## Reglas
(vacio por ahora)
"@
Set-Content -Path (Join-Path $tasksDir "lessons.md") -Value $lessonsContent -Encoding UTF8
Initialize-StandardTaskFiles -ProjectRoot $base -ProjectName $Nombre

# ── feature_list.json ──
$featureContent = @"
{
  "proyecto": "",
  "features": []
}
"@
Set-Content -Path (Join-Path $base "feature_list.json") -Value $featureContent -Encoding UTF8

# ── .github/copilot-instructions.md (para GitHub Copilot) ──
$githubDir = Join-Path $base ".github"
New-Item -ItemType Directory -Path $githubDir -Force | Out-Null

$copilotContent = @"
# $Nombre — Instrucciones para Copilot

## Stack
$Stack

## Reglas
1. Plan Mode obligatorio para tareas no triviales (>3 pasos)
2. Nunca marcar tarea como completada sin demostrar que funciona
3. Commits en espanol: feat | fix | chore | style | docs
4. No instalar dependencias sin confirmar
5. Tras cualquier correccion: actualizar tasks/lessons.md
6. Preguntarse: Aprobaria esto un Staff Engineer?
7. Corregir errores autonomamente, no pedir ayuda
8. Registrar deuda intencional en tasks/tech-debt.md

## Archivos Sagrados
- AGENTS.md, package.json, .env, archivos de config raiz

## Validacion antes de commit
1. git diff --stat
2. Correr tests si existen
3. Verificar visualmente
"@
Set-Content -Path (Join-Path $githubDir "copilot-instructions.md") -Value $copilotContent -Encoding UTF8

# ── .gitignore base ──
$gitignoreContent = @"
node_modules/
.env
.env.local
dist/
.DS_Store
*.log
"@
Set-Content -Path (Join-Path $base ".gitignore") -Value $gitignoreContent -Encoding UTF8

# ── Commit estructura base ──
git add -A
git commit -m "chore: estructura base del proyecto"

# ── Worktrees para agentes ──
$wt1 = Join-Path $HOME "agente-1-$Nombre"
$wt2 = Join-Path $HOME "agente-2-$Nombre"
$wt3 = Join-Path $HOME "agente-3-$Nombre"

git worktree add $wt1 -b agente/feature
git worktree add $wt2 -b agente/design
git worktree add $wt3 -b agente/tests

Write-Host ""
Write-Host "Proyecto '$Nombre' listo con stack '$Stack'" -ForegroundColor Green
Write-Host ""
Write-Host "Estructura creada:"
Write-Host "  $base\AGENTS.md"
Write-Host "  $base\tasks\todo.md"
Write-Host "  $base\tasks\lessons.md"
Write-Host "  $base\feature_list.json"
Write-Host "  $base\.github\copilot-instructions.md"
Write-Host ""
Write-Host "Worktrees:"
Write-Host "  $wt1 -> agente/feature"
Write-Host "  $wt2 -> agente/design"
Write-Host "  $wt3 -> agente/tests"
Write-Host ""
Write-Host "Proximo paso: completar AGENTS.md con el stack real del proyecto."
