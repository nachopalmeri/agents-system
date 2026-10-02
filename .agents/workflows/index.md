---
description: Mapa compacto de intención al menor componente ejecutable
---

# Capability index

Primero clasificá SIMPLE, SPECIALIZED, PARALLEL o HIGH_RISK con `../../config/routing-rules.json`. El ledger completo está en `../../config/capabilities.json`.

| Intención | Componente mínimo | Escalar sólo si |
|---|---|---|
| Cambio o explicación directa | el agente principal, sin subagentes | aparece riesgo o expertise material |
| Cuota que se agota, contexto pesado o medir ahorro | `workflows/token_budget.md` | medir tres tickets reales; no agregar infraestructura por rutina |
| Feature mediana/grande o trabajo que excede una sesión enfocada | `workflows/ticket_sessions.md` | Matt por fase; chats nuevos sólo con autorización explícita |
| Bug o test rojo | `skills/systematic-debugging/SKILL.md` | hay trabajos independientes |
| UI/landing material | `skills/frontend-design/SKILL.md` | requiere revisión visual separada |
| SEO técnico | `skills/seo-geo-growth/references/seo-tecnico.md` | incluye adquisición/GEO |
| SEO/GEO/AEO growth | `skills/seo-geo-growth/SKILL.md` | hay investigación independiente |
| Producto/MVP | `skills/product-foundry/SKILL.md` | decisión irreversible o council explícito |
| AI/RAG productivo | `skills/ai-production-architecture/SKILL.md` | seguridad independiente necesaria |
| Obsidian | `skills/obsidian-vault/SKILL.md` | edición cruza otros repos |
| Estudio/examen | `workflows/academic_tutor.md` | se pide persistir al vault |
| Research actual | subagente `agents/explorador.md` | dos tracks independientes |
| Paralelismo explícito | `workflows/parallel_agents.md` | council fue pedido explícitamente |
| Council explícito | `workflows/multiagent_review_loop.md` | nunca automático |
| Acción sensible | `workflows/validation.md` + auditor/release | siempre requiere gate humano aplicable |
| Cierre | `workflows/validation.md` | evidencia insuficiente implica replan/bloqueo |
| Trabajo acotado delegable | `workflows/delegation.md` | menor modelo nativo u OpenCode; costo de handoff justificado |
| Retro de sesiones / navegación difícil | `skills-library/matt-retro/SKILL.md` | sólo cuando se pide analizar sesiones; propuestas primero |
| Preparar cuerpo de PR con evidencia | `skills-library/matt-pr/SKILL.md` | publicar requiere autorización separada |
| Handoff compacto entre sesiones | `skills-library/matt-handoff/SKILL.md` | crear/mensajear otro chat requiere autorización |
| Implementar spec con tareas independientes | `skills-library/matt-implement-spec/SKILL.md` | sólo con spec aprobada y ownership separado |
| Evaluar aislamiento multi-harness | `skills-library/sandcastle-evaluation/SKILL.md` | no instala Sandcastle ni contenedores automáticamente |
| Comparar workers baratos / gratuitos | `skills-library/worker-quality-evaluation/SKILL.md` | benchmark acotado; no instala Evalite ni usa pagos |

La lista de agentes/skills no se duplica acá: se descubre desde el ledger. `archive/` queda disponible sólo como historia opcional, nunca como ruta ejecutable.

## Escalamiento (T3)

| Situación | Herramienta |
|---|---|
| Refactor masivo o arquitectura nueva | `skills-library/mcts-planner/SKILL.md` en vez de razonamiento lineal |
| Test E2E falla repetido | `skills/systematic-debugging/SKILL.md` → sección "CI roja repetida" antes de escalar a humano |
| Cierre de tarea con evidencia | `skills-library/procedural-memory/SKILL.md` para extraer lecciones |
