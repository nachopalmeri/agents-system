---
description: Empaquetar y distribuir el agents-system como plugin shareable para Claude Code y otros IDEs
---

# Plugin Distribution — Shareable System

## Principio

El sistema es personal pero los patrones son universales. Empaquetarlo como plugin permite que cualquier developer lo instale en 5 minutos y customice via AGENTS.override.md.

## Bundle core

Archivos que se distribuyen:

### Esenciales (siempre)
- `AGENTS.md` — constitución del sistema
- `.agents/rules/` — reglas globales (identity, git, ai-permissions, anti-cemetery, chat-first, code-style, testing, prompting, model_routing)
- `.agents/workflows/index.md` — router
- `.agents/workflows/validation.md` — quality gate
- `.agents/workflows/feedback_loop.md` — corrección de errores
- `.agents/workflows/session_checkpoint.md` — continuidad
- `.agents/workflows/harness.md` — auto-mejora
- `.agents/workflows/dreaming.md` — memory curation
- `.agents/workflows/outcomes.md` — quality gate con grader
- `.agents/workflows/parallel_agents.md` — loops y paralelismo
- `.agents/workflows/task_ledger.md` — tracking
- `.agents/workflows/context_check.md` — degradación de contexto
- `.agents/workflows/promote_lesson.md` — lecciones globales
- `.agents/workflows/irreversible_decision.md` — decisiones de alto costo
- `.agents/workflows/adr.md` — architecture decision records
- `.agents/workflows/spec_kit.md` — spec-driven development
- `.agents/workflows/project_kickoff_lean.md` — kickoff minimalista
- `.agents/workflows/web_briefing.md` — briefing web
- `.agents/workflows/web-factory.md` — web factory
- `.agents/workflows/world-class-web.md` — web 3D inmersiva
- `.agents/workflows/marketing.md` — estrategia
- `.agents/workflows/venture_loop.md` — idea a producto
- `.agents/workflows/product_foundry.md` — qué construir
- `.agents/workflows/seo_geo_growth.md` — SEO/GEO growth
- `.agents/workflows/mcp_catalog.md` — MCP discovery
- `.agents/workflows/mcp_adoption.md` — MCP evaluation
- `.agents/workflows/mcp_security.md` — MCP security
- `.agents/workflows/client_workflow.md` — trabajo para clientes
- `.agents/workflows/academic_tutor.md` — estudio y enseñanza
- `.agents/workflows/x_content_system.md` — contenido social
- `.agents/workflows/skills_routing.md` — skill routing
- `.agents/workflows/agent_coordination.md` — coordinación multi-agente
- `.agents/workflows/multiagent_review_loop.md` — red team
- `.agents/workflows/llm_council.md` — decisión entre opciones
- `.agents/workflows/performance_audit.md` — performance
- `.agents/workflows/hooks.md` — hooks
- `.agents/workflows/growth_update.md` — crecimiento
- `.agents/workflows/weekly_review.md` — review semanal
- `.agents/workflows/obsidian_sync.md` — Obsidian sync
- `.agents/workflows/obsidian-prompt-search.md` — prompt search
- `.agents/workflows/opencode_ecosystem.md` — ecosistema
- `.agents/workflows/pr_code_review.md` — PR review
- `.agents/workflows/pr_policy.md` — PR policy
- `.agents/workflows/start.md` — start guide

### Skills core (siempre)
- `.agents/skills/premium-web-stack/` — stack premium web
- `.agents/skills/web-presentation-premium/` — web premium
- `.agents/skills/seo-geo-growth/` — SEO growth
- `.agents/skills/product-foundry/` — product ideation
- `.agents/skills/spec-kit/` — spec-driven dev
- `.agents/skills/client-work/` — client work
- `.agents/skills/ai-production-architecture/` — AI production

### Opcionales (por dominio)
- `.agents/skills/academic*/` — estudio (solo si el usuario es estudiante)
- `.agents/skills/docx/`, `pptx/`, `xlsx/` — documentos
- `.agents/skills/coding-exercises/`, `exam-simulator/` — ejercicios
- `.agents/skills/frontend-design/`, `animate/`, etc. — diseño

### No se distribuyen
- `.agents/memory/` — personal, se genera con uso
- `.agents/docs/research-2026-06.md` — notas de investigación
- `.agents/docs/archive/` — archivos deprecados
- `AGENTS.override.md` — personal, gitignored
- `CLAUDE.local.md` — personal, gitignored
- `.agents/agents/` — definiciones de agentes (cada usuario define los suyos)
- `.agents/prompts/` — prompts portables (se regeneran)

## Formato de distribución

### Opción 1: GitHub Template Repo
- Repo template en `nachopalmeri/agents-system`
- `Use this template` → nuevo repo con todo incluido
- Customizar AGENTS.md y agents/ para cada usuario
- Ventaja: simple, familiar, git-native

### Opción 2: Claude Code Plugin
- Plugin en Claude Code registry: `agents-system@nachopalmeri`
- `/plugin install agents-system@nachopalmeri`
- Bundle con skills + workflows + rules
- Ventaja: integración nativa, auto-update

### Opción 3: NPM Package
- `npm init -y` con install script
- `npx create-agents-system` → scaffolding
- Ventaja: ecosistema npm, CI/CD

### Recomendación

Empezar con Opción 1 (template repo). Migrar a Opción 2 cuando Claude Code plugin registry esté maduro. Opción 3 solo si hay demanda.

## Install flow (5 minutos)

```bash
# 1. Crear repo desde template
gh repo create my-project --template nachopalmeri/agents-system

# 2. Clonar
git clone https://github.com/user/my-project && cd my-project

# 3. Setup IDE pointers
./bin/setup-ide-pointers.ps1  # o .sh

# 4. Customizar identidad
# Editar .agents/rules/identity.md con tus datos

# 5. Verificar
./bin/doctor.ps1
```

## Customización por usuario

Cada usuario customiza via:

1. **AGENTS.override.md** — overrides personales sin afectar al equipo.
2. **`.agents/rules/identity.md`** — datos personales.
3. **`.agents/agents/`** — definir sus propios agentes.
4. **`.agents/memory/`** — memoria que se genera con uso.
5. **GOTCHAS tech-specific** — mover a AGENTS.override.md del proyecto.

## Versionado

- Seguir semver: MAJOR (breaking changes en AGENTS.md structure), MINOR (new workflows/skills), PATCH (fixes).
- Changelog en `docs/CHANGELOG.md`.
- Tag de release en git: `v1.0.0`, `v1.1.0`, etc.
