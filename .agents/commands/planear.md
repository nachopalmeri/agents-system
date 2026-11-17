---
description: Planear una tarea con el planner antes de implementar
argument-hint: <qué hay que hacer>
---
Planeá esta tarea con el subagente `planner`: {{args}}

Si este cliente no tiene subagentes, aplicá vos el rol leyendo `~/.agents/agents/planner.md`. Mostrame el plan (alcance, pasos verificables, riesgos, preguntas con tu recomendación) y esperá mi OK antes de implementar.

Esto es para planes chicos/medianos que entran en una sesión. Si el trabajo necesita varias sesiones, varias épicas o decisiones abiertas de producto, no lo planees acá: pasá a `/requirements-interview <nombre>` y después `/decompose-plan <nombre>` (ver `~/.agents/workflows/epic_plans.md`).
