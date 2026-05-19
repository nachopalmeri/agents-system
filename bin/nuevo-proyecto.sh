#!/bin/bash
# Uso: nuevo-proyecto <nombre> [stack]
# Ejemplo: nuevo-proyecto mi-landing astro

if [ -z "$1" ] || [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  cat << 'HEREDOC'
Uso: nuevo-proyecto <nombre> [stack]

Stacks:
- html-css-js     proyecto simple
- astro           landing estatica/SEO
- next            app web React/Next
- python          proyecto Python/CLI
- ai-prod         AI/RAG production-ready
- spec-kit        Spec-Driven Development opcional
- client-work     trabajo de cliente con brief, propuesta, entrega y feedback

Ejemplos:
- nuevo-proyecto landing astro
- nuevo-proyecto jobbot-ai ai-prod
- nuevo-proyecto app-compleja spec-kit
HEREDOC
  exit 1
fi

initialize_standard_tasks() {
  local project_root="$1"
  local project_name="$2"
  mkdir -p "$project_root/tasks"

  cat > "$project_root/tasks/todo.md" << 'HEREDOC'
# Todo

## En progreso
(vacio)

## Pendiente
(agregar tareas aca)

## Completado
(vacio)
HEREDOC

  cat > "$project_root/tasks/lessons.md" << 'HEREDOC'
# Lecciones Aprendidas

Tras cualquier correccion del director, agregar una regla aca.
Formato: "Siempre X" o "Nunca Y"

## Reglas
(vacio por ahora)
HEREDOC

  cat > "$project_root/tasks/handoff.md" << HEREDOC
# Handoff - $project_name

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
HEREDOC

  cat > "$project_root/tasks/decisions.md" << 'HEREDOC'
# Decisiones del Proyecto

## Formato
| Fecha | Decision | Alternativas evaluadas | Por que esta | Costo si me equivoque |
|---|---|---|---|---|
HEREDOC

  cat > "$project_root/tasks/tech-debt.md" << 'HEREDOC'
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
HEREDOC

  cat > "$project_root/tasks/agents-active.md" << 'HEREDOC'
# Agentes Activos

| Agente | Worktree | Produce | Consume | Estado |
|---|---|---|---|---|
HEREDOC
}

nombre="$1"
stack="${2:-html-css-js}"
base=~/"$nombre"

mkdir -p "$base" && cd "$base"
git init && git commit --allow-empty -m "chore: init"

if [ "$stack" = "ai-prod" ]; then
  mkdir -p app/components services prompts agents/tools security evaluation/eval_results observability data/raw data/processed data/index_config scripts frontend/static tests docs docs/adr .claude/rules .github tasks
  initialize_standard_tasks "$base" "$nombre"

  cat > app/main.py << 'HEREDOC'
"""FastAPI entrypoint for the AI production app."""
HEREDOC
  cat > app/config.py << 'HEREDOC'
"""Application configuration."""
HEREDOC
  cat > app/models.py << 'HEREDOC'
"""Shared API and domain models."""
HEREDOC
  cat > app/Dockerfile << 'HEREDOC'
FROM python:3.12-slim
HEREDOC
  cat > app/components/hybrid_retriever.py << 'HEREDOC'
"""Hybrid retrieval: keyword/vector search orchestration."""
HEREDOC
  cat > app/components/reranker.py << 'HEREDOC'
"""Document reranking component."""
HEREDOC

  for file in services/rag_pipeline.py services/semantic_cache.py services/conversation.py services/query_rewriter.py services/query_router.py prompts/templates.py prompts/registry.py agents/document_grader.py agents/query_decomposer.py agents/adaptive_router.py agents/tools/vector_search.py agents/tools/web_search.py agents/tools/code_search.py security/input_guard.py security/content_filter.py security/output_filter.py evaluation/offline_eval.py evaluation/online_monitor.py observability/tracer.py observability/feedback.py observability/cost_tracker.py scripts/seed.py scripts/migrate.py scripts/healthcheck.py frontend/app.py tests/test_retrieval.py tests/test_cache.py tests/test_routing.py; do
    echo '"""TODO: implement."""' > "$file"
  done

  cat > evaluation/golden_dataset.json << 'HEREDOC'
{
  "cases": []
}
HEREDOC
  echo "" > frontend/requirements.txt
  echo "FROM python:3.12-slim" > frontend/Dockerfile
  cat > docs/architecture.md << 'HEREDOC'
# Architecture

AI production architecture: services, agents, prompts, security, evaluation and observability.
HEREDOC
  echo "# API Reference" > docs/api-reference.md
  echo "# Deployment" > docs/deployment.md
  cat > .claude/rules/code-style.md << 'HEREDOC'
# Code Style

Follow project AGENTS.md and global ~/.agents/rules/code-style.md.
HEREDOC
  cat > .claude/rules/testing.md << 'HEREDOC'
# Testing

Follow project AGENTS.md and global ~/.agents/rules/testing.md.
HEREDOC
  cat > docker-compose.yml << 'HEREDOC'
services:
  app:
    build: ./app
HEREDOC
  cat > pyproject.toml << HEREDOC
[project]
name = "$nombre"
version = "0.1.0"
requires-python = ">=3.12"
HEREDOC
  cat > README.md << HEREDOC
# $nombre

AI production-ready project scaffold.
HEREDOC
  cat > tasks/todo.md << 'HEREDOC'
# Todo

## En progreso
(vacío)

## Pendiente
- [ ] Definir golden dataset inicial
- [ ] Implementar RAG pipeline mínimo
- [ ] Agregar tracing y cost tracking

## Completado
(vacío)
HEREDOC
  cat > tasks/lessons.md << 'HEREDOC'
# Lecciones Aprendidas

## Reglas
(vacío por ahora)
HEREDOC
  cat > feature_list.json << HEREDOC
{
  "proyecto": "$nombre",
  "stack": "ai-prod",
  "features": []
}
HEREDOC
  cat > .gitignore << 'HEREDOC'
node_modules/
.env
.env.local
dist/
__pycache__/
*.pyc
.DS_Store
*.log
HEREDOC

  cat > AGENTS.md << HEREDOC
# $nombre

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
6. Commits en español: feat | fix | chore | docs | test
7. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md
HEREDOC

  cat > .github/copilot-instructions.md << HEREDOC
# $nombre — Instrucciones para Copilot

Proyecto AI/RAG production-ready. Mantener separadas las capas:
services, agents, prompts, security, evaluation, observability.

Reglas:
1. No hardcodear prompts: usar prompts/registry.py
2. No saltear evaluación para cambios AI importantes
3. Agregar tracing y cost tracking a llamadas LLM
4. Validar input/content/output antes de producción
5. Tests mínimos: retrieval, cache, routing
HEREDOC

  git add -A && git commit -m "chore: estructura ai production del proyecto"
  git worktree add ~/agente-1-"$nombre" -b agente/feature
  git worktree add ~/agente-2-"$nombre" -b agente/design
  git worktree add ~/agente-3-"$nombre" -b agente/tests
  echo "✓ Proyecto AI production '$nombre' listo"
  exit 0
fi

if [ "$stack" = "spec-kit" ]; then
  mkdir -p tasks .github .specify/memory .specify/specs .specify/templates docs/adr
  initialize_standard_tasks "$base" "$nombre"

  cat > AGENTS.md << HEREDOC
# $nombre

## Stack
spec-kit — Spec-Driven Development opcional

## Modo de Trabajo
Este proyecto usa el scaffold base con una capa opcional \`.specify/\` para features medianas o grandes.

Para cambios chicos:
1. Leer AGENTS.md y tasks/todo.md
2. Plan Mode si hay más de 3 pasos
3. Implementar y validar

Para features medianas/grandes:
1. Revisar \`.specify/memory/constitution.md\`
2. Definir spec: qué y por qué
3. Crear plan técnico: cómo
4. Generar tasks verificables
5. Implementar contra criterios de aceptación

## Reglas Inmutables
1. No usar Spec Kit para fixes chicos
2. No implementar features grandes sin spec/plan/tasks
3. Commits en español: feat | fix | chore | docs | test
4. Nunca marcar tarea como completada sin demostrar que funciona
5. Tras cualquier corrección: actualizar tasks/lessons.md
6. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md

## Validación
1. git diff --stat
2. Correr tests si existen
3. Validar criterios de aceptación de \`.specify/specs/\` si aplica
HEREDOC

  cat > .specify/memory/constitution.md << 'HEREDOC'
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
HEREDOC

  cat > .specify/README.md << 'HEREDOC'
# .specify/

Carpeta para Spec-Driven Development opcional.

## Flujo
1. Constitution: `.specify/memory/constitution.md`
2. Specify: crear spec en `.specify/specs/`
3. Plan: definir implementación técnica
4. Tasks: desglosar tareas verificables
5. Implement: ejecutar y validar

Usar solo para features medianas o grandes.
HEREDOC

  cat > .specify/templates/spec-template.md << 'HEREDOC'
# Spec

## Problema

## Usuarios

## Requisitos

## Criterios de aceptación

## No objetivos
HEREDOC

  cat > .specify/templates/plan-template.md << 'HEREDOC'
# Plan

## Stack

## Arquitectura

## Archivos a tocar

## Riesgos

## Validación

## Qué NO se toca
HEREDOC

  cat > .specify/templates/tasks-template.md << 'HEREDOC'
# Tasks

- [ ] Tarea verificable 1
HEREDOC

  cat > tasks/todo.md << 'HEREDOC'
# Todo

## En progreso
(vacío)

## Pendiente
- [ ] Definir primera spec si la feature lo amerita

## Completado
(vacío)
HEREDOC

  cat > tasks/lessons.md << 'HEREDOC'
# Lecciones Aprendidas

## Reglas
(vacío por ahora)
HEREDOC

  cat > feature_list.json << HEREDOC
{
  "proyecto": "$nombre",
  "stack": "spec-kit",
  "features": []
}
HEREDOC

  cat > .gitignore << 'HEREDOC'
node_modules/
.env
.env.local
dist/
.DS_Store
*.log
HEREDOC

  cat > .github/copilot-instructions.md << HEREDOC
# $nombre — Instrucciones para Copilot

Proyecto con Spec-Driven Development opcional.

Reglas:
1. Para features medianas/grandes, usar \`.specify/\` antes de implementar
2. Para cambios chicos, usar el flujo simple de \`AGENTS.md\`
3. No marcar completado sin validar criterios de aceptación
4. No instalar dependencias sin confirmar
HEREDOC

  git add -A && git commit -m "chore: estructura spec kit del proyecto"
  git worktree add ~/agente-1-"$nombre" -b agente/feature
  git worktree add ~/agente-2-"$nombre" -b agente/design
  git worktree add ~/agente-3-"$nombre" -b agente/tests
  echo "✓ Proyecto Spec Kit '$nombre' listo"
  exit 0
fi

if [ "$stack" = "client-work" ]; then
  mkdir -p brief propuesta entregas feedback tasks .github
  initialize_standard_tasks "$base" "$nombre"

  cat > AGENTS.md << HEREDOC
# $nombre

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
HEREDOC

  cat > brief/brief-template.md << 'HEREDOC'
# Brief del Cliente

## Cliente

## Negocio

## Objetivo

## Audiencia

## Tono

## Referencias

## Restricciones

## Deadline

## Presupuesto acordado
HEREDOC

  cat > propuesta/pricing.md << 'HEREDOC'
# Pricing de referencia

Tomar estructura y categorias de `.agents/skills/client-work/pricing.md` antes de completar esta propuesta.
HEREDOC

  cat > propuesta/v1.md << 'HEREDOC'
# Propuesta v1

## Alcance

## Incluye

## No incluye

## Precio

## Timeline
HEREDOC

  cat > feedback/iteracion-1.md << 'HEREDOC'
# Feedback - Iteracion 1

## Pedido del cliente

## En scope?

## Accion
HEREDOC

  cat > tasks/todo.md << 'HEREDOC'
# Todo

## En progreso
(vacio)

## Pendiente
- [ ] Completar brief inicial
- [ ] Generar propuesta v1
- [ ] Definir primera entrega
- [ ] Registrar feedback del cliente

## Completado
(vacio)
HEREDOC

  cat > feature_list.json << HEREDOC
{
  "proyecto": "$nombre",
  "stack": "client-work",
  "features": []
}
HEREDOC

  cat > .gitignore << 'HEREDOC'
node_modules/
.env
.env.local
dist/
.DS_Store
*.log
HEREDOC

  cat > .github/copilot-instructions.md << 'HEREDOC'
# Instrucciones para Copilot

Preset: client-work

Reglas:
1. No cambiar scope sin registrarlo en propuesta/.
2. Todo feedback del cliente entra primero en feedback/.
3. No sobreescribir propuestas anteriores; versionar.
4. Registrar deuda intencional en tasks/tech-debt.md.
5. Registrar decisiones dificiles de revertir en tasks/decisions.md.
HEREDOC

  git add -A && git commit -m "chore: estructura client work del proyecto"
  git worktree add ~/agente-1-"$nombre" -b agente/feature
  git worktree add ~/agente-2-"$nombre" -b agente/design
  git worktree add ~/agente-3-"$nombre" -b agente/tests
  echo "Proyecto client-work '$nombre' listo"
  exit 0
fi

# ── AGENTS.md (instrucciones globales del proyecto) ──
cat > AGENTS.md << HEREDOC
# $nombre

## Stack
$stack

## Reglas Inmutables
1. Leer AGENTS.md y tasks/todo.md antes de cualquier acción
2. Plan Mode obligatorio para cualquier tarea de más de 3 pasos
3. Commits en español: feat | fix | chore | style | docs
4. Nunca marcar tarea como "passing" sin demostrar que funciona
5. No tocar archivos fuera de tu scope de worktree
6. No instalar dependencias sin confirmar con el director
7. Tras cualquier corrección: actualizar tasks/lessons.md
8. Antes de agregar una dependencia nueva o tomar un shortcut tecnico, registrar la deuda en tasks/tech-debt.md

## Archivos Sagrados (NO editar sin confirmación explícita)
- AGENTS.md
- package.json / package-lock.json
- .env / .env.local
- archivos de config raíz (astro.config, next.config, etc)

## Validación Obligatoria Antes de Commit
1. git diff --stat → revisar exactamente qué tocaste
2. Correr tests: npm run test (si existen)
3. Verificar visualmente que nada se rompió
4. Solo entonces: commit + actualizar tasks/todo.md

## Convenciones de Commit
- feat: nueva funcionalidad
- fix: corrección de bug
- chore: mantenimiento sin lógica
- style: estilos sin lógica
- docs: documentación
HEREDOC

# ── Estructura de tasks/ ──
mkdir -p tasks

cat > tasks/todo.md << 'HEREDOC'
# Todo

## En progreso
(vacío)

## Pendiente
(agregar tareas acá)

## Completado
(vacío)
HEREDOC

cat > tasks/lessons.md << 'HEREDOC'
# Lecciones Aprendidas

Tras cualquier corrección del director, agregar una regla acá.
Formato: "Siempre X" o "Nunca Y"

## Reglas
(vacío por ahora)
HEREDOC

initialize_standard_tasks "$base" "$nombre"

# ── feature_list.json ──
cat > feature_list.json << 'HEREDOC'
{
  "proyecto": "",
  "features": []
}
HEREDOC

# ── .github/copilot-instructions.md (para GitHub Copilot) ──
mkdir -p .github
cat > .github/copilot-instructions.md << HEREDOC
# $nombre — Instrucciones para Copilot

## Stack
$stack

## Reglas
1. Plan Mode obligatorio para tareas no triviales (>3 pasos)
2. Nunca marcar tarea como completada sin demostrar que funciona
3. Commits en español: feat | fix | chore | style | docs
4. No instalar dependencias sin confirmar
5. Tras cualquier corrección: actualizar tasks/lessons.md
6. Preguntarse: ¿Aprobaría esto un Staff Engineer?
7. Corregir errores autónomamente, no pedir ayuda

## Archivos Sagrados
- AGENTS.md, package.json, .env, archivos de config raíz

## Validación antes de commit
1. git diff --stat
2. Correr tests si existen
3. Verificar visualmente
HEREDOC

# ── .gitignore base ──
cat > .gitignore << 'HEREDOC'
node_modules/
.env
.env.local
dist/
.DS_Store
*.log
HEREDOC

# ── Worktrees para agentes ──
git add -A && git commit -m "chore: estructura base del proyecto"
git worktree add ~/agente-1-"$nombre" -b agente/feature
git worktree add ~/agente-2-"$nombre" -b agente/design
git worktree add ~/agente-3-"$nombre" -b agente/tests

echo ""
echo "✓ Proyecto '$nombre' listo con stack '$stack'"
echo ""
echo "Estructura creada:"
echo "  ~/$nombre/AGENTS.md"
echo "  ~/$nombre/tasks/todo.md"
echo "  ~/$nombre/tasks/lessons.md"
echo "  ~/$nombre/feature_list.json"
echo "  ~/$nombre/.github/copilot-instructions.md"
echo ""
echo "Worktrees:"
echo "  ~/agente-1-$nombre → agente/feature"
echo "  ~/agente-2-$nombre → agente/design"
echo "  ~/agente-3-$nombre → agente/tests"
echo ""
echo "Próximo paso: completar AGENTS.md con el stack real del proyecto."
