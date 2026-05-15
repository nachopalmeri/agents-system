# Reglas Globales — Nacho Palmeri / Pisculichi Labs

## Fuente Principal de Reglas
Leer ~/.agents/AGENTS.md para las reglas completas del sistema de agentes.
Archivos clave:
- rules/chat-first.md → UX chat-first y workflows invisibles
- workflows/index.md → router principal
- workflows/validation.md → cierre con evidencia
- workflows/session_checkpoint.md → continuidad en sesiones largas
- workflows/project_types.md → simple, web premium, ai-prod, spec-kit
- workflows/skills_routing.md → selección de skills
- workflows/task_ledger.md → tareas trazables, kanban/ledger, progreso, evidencia y recibos finales
- workflows/multiagent_review_loop.md → crear, criticar, red team, roadmap y reevaluación para decisiones de alto impacto
- workflows/venture_loop.md → idea, MVP, landing, distribución, medición y kill/scale
- workflows/product_foundry.md → ideas de producto, MVPs, validación y portfolio indie/AI-first
- workflows/seo_geo_growth.md → SEO/GEO/AEO growth, keywords, landings, backlinks y AI search
- workflows/mcp_catalog.md, mcp_security.md, mcp_adoption.md → MCPs seguros y opt-in
- workflows/opencode_ecosystem.md → evaluación de plugins, themes, agents y OpenCode Studio
- workflows/parallel_agents.md → subagentes/worktrees cuando hay tareas independientes
- workflows/hooks.md → hooks locales opcionales
- rules/code-style.md, testing.md, git.md → reglas base

## Reglas Mínimas (resumen)
1. El usuario habla normal; el agente enruta internamente
2. Usar el menor workflow suficiente
3. No usar Spec Kit ni AI production para cambios chicos
4. Nunca marcar completado sin evidencia de validación
5. En sesiones largas, crear checkpoints compactos
6. Tras correcciones importantes, actualizar tasks/lessons.md
7. Commits en español: feat | fix | chore | style | docs
8. MCPs, plugins, ads, DMs, pagos, producción y datos personales requieren confirmación explícita
9. `awesome-opencode` y OpenCode Studio son opcionales: evaluar antes de adoptar
10. SEO/GEO/AEO growth usa `agente-growth-seo-geo`; SEO técnico usa `agente-seo`
11. Ideas de producto/MVP usan `agente-product-founder`, `product_foundry.md` y `venture_loop.md` si hay ciclo completo
12. Mejoras de workflows/agentes/arquitectura con alto impacto usan `multiagent_review_loop.md`, no teatro multiagente para fixes chicos
13. Coordinación, kanban, handoffs o tracking usan `task_ledger.md`; no crear tareas por cada conversación
