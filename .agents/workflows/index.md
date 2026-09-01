---
description: Mapa compacto de intención al menor componente ejecutable
---

# Capability index

Primero clasificá SIMPLE, SPECIALIZED, PARALLEL o HIGH_RISK con `../../config/routing-rules.json`. El ledger completo está en `../../config/capabilities.json`.

| Intención | Componente mínimo | Escalar sólo si |
|---|---|---|
| Cambio o explicación directa | `agents/agente-principal.md` | aparece riesgo o expertise material |
| Bug o test rojo | `skills/systematic-debugging/SKILL.md` | hay trabajos independientes |
| UI/landing material | `skills/frontend-design/SKILL.md` | requiere revisión visual separada |
| SEO técnico | `agents/agente-seo.md` | incluye adquisición/GEO |
| SEO/GEO/AEO growth | `skills/seo-geo-growth/SKILL.md` | hay investigación independiente |
| Producto/MVP | `skills/product-foundry/SKILL.md` | decisión irreversible o council explícito |
| AI/RAG productivo | `skills/ai-production-architecture/SKILL.md` | seguridad independiente necesaria |
| Obsidian | `skills/obsidian-vault/SKILL.md` | edición cruza otros repos |
| Estudio/examen | `workflows/academic_tutor.md` | se pide persistir al vault |
| Research actual | `agents/agente-researcher.md` | dos tracks independientes |
| Paralelismo explícito | `workflows/parallel_agents.md` | council fue pedido explícitamente |
| Council explícito | `workflows/multiagent_review_loop.md` | nunca automático |
| Acción sensible | `workflows/validation.md` + auditor/release | siempre requiere gate humano aplicable |
| Cierre | `workflows/validation.md` | evidencia insuficiente implica replan/bloqueo |

La lista de agentes/skills no se duplica acá: se descubre desde el ledger. `archive/` queda disponible sólo como historia opcional, nunca como ruta ejecutable.

## Escalamiento (T3)

| Situación | Herramienta |
|---|---|
| Refactor masivo o arquitectura nueva | `skills/mcts-planner/SKILL.md` en vez de razonamiento lineal |
| Test E2E falla repetido | `skills/self-healing-ci/SKILL.md` (Intent Re-resolution) antes de escalar a humano |
| Cierre de tarea con evidencia | `skills/procedural-memory/SKILL.md` para extraer lecciones |
