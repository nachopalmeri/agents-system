# Uso: nuevo-proyecto <nombre> [stack]
# Ejemplo: nuevo-proyecto mi-landing astro

param(
    [Parameter(Position=0)][string]$Nombre,
    [Parameter(Position=1)][string]$Stack = "html-css-js"
)

if (-not $Nombre) {
    Write-Host "Uso: nuevo-proyecto <nombre> [stack]"
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
