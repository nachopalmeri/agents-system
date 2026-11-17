---
description: Descomponer requirements.md en un plan por épicas (README, epics/, progress.json, handoff, hallazgos)
argument-hint: <nombre-del-plan>
---
Descomponé el plan en épicas: {{args}}

Seguí `~/.agents/workflows/epic_plans.md` (fase 3). Reemplaza a `to-tickets` y a `/planear` para trabajo mediano/grande.

1. Leé `docs/plans/<nombre>/requirements.md`. Si no existe o su estado no es "spec lista para decomponer", pará y sugerí `/requirements-interview <nombre>`.
2. Detectá la rama base (la que declare el proyecto, p. ej. `dev`; si no, la default del remoto) y el usuario git para las ramas `<usuario>/<nombre>` y `<usuario>/<nombre>-<corto>`. Preguntá si el plan es `pr` o `local-only`.
3. Desde § Épicas sugeridas armá épicas verticales con dependencias explícitas, cada una con diff estimado < 500 líneas. Si hay supuestos "a confirmar", la primera es `00-spikes`.
4. Mostrame el desglose (tabla de épicas, dependencias, decisiones, supuestos) y esperá mi OK.
5. Con el OK, generá en `docs/plans/<nombre>/` usando las plantillas de `~/.agents/workflows/templates/epic_plans/`: `README.md` (con el campo "Autorización de sesiones" que yo confirme), `epics/NN-<corto>.md`, `progress.json` (válido contra `schemas/plan-progress.schema.json`), `handoff.md` y `hallazgos.md`.
6. Proponé el worktree y la rama de integración (`git worktree add <ruta> -b <usuario>/<nombre> <base>`) y crealos sólo si lo confirmo. No hagas push ni PR.
7. Cerrá con: "Para trabajar: `/run-plan <nombre>`".
