---
description: Ejecutar la próxima épica pendiente de un plan (checkpoint, tests, validaciones, progress.json, OK antes de mergear)
argument-hint: <nombre-del-plan>
---
Ejecutá la próxima épica del plan: {{args}}

Seguí `~/.agents/workflows/epic_plans.md`. Leé primero `docs/plans/<nombre>/handoff.md` (el último bloque "Continuación" manda) y después `progress.json`; si hay copia en el worktree del plan, esa gana.

1. **Cuota y contexto.** Revisá el uso de la cuenta: arriba del 90 % pará y avisame; nunca overage pago. Presupuesto por rol:

   | Rol | Checkpoint en `handoff.md` | Corte |
   |---|---|---|
   | Orquestador / sesión principal | ~40 % | ~50 %: nueva sesión principal con bloque "Continuación · sesión coordinadora N" + Prompt de continuación; la nueva lee sólo `handoff.md` primero |
   | Runner de épica (esta sesión) | ~30 % | ~40 %: bloque "Continuación · sesión N" + Prompt de continuación, y pará |
   | Worker | ~30 % | ~40 %: nota en `handoff.md` y resumen de 5 líneas |
2. **Elegí la épica.** La primera `pending` cuyas dependencias estén `completed` y `merged: true`. Si la anterior no está mergeada o no di OK, pará.
3. **Checkpoint pre-implementación** (de la épica): worktree correcto, árbol limpio, épica anterior mergeada, `git pull --ff-only` de la integración (salvo `local-only`), rama nueva `<usuario>/<nombre>-<corto>` desde la integración, diff estimado < 500 líneas (si no, proponé dividir).
4. Marcá la épica `in_progress` en `progress.json` (y `updated`).
5. **Implementá con tests**: los "Tests requeridos" son obligatorios. Leé sólo los archivos que la épica nombra. Workers: máximo 3, profundidad 1, con `~/.agents/workflows/templates/epic_plans/worker-rules.md`.
6. **Validá** cada `requiredValidations` y guardá `pass|fail|skipped` en `validations`. Máximo 3 iteraciones; un fallo idéntico repetido → `blocked` con `blockedReason`.
7. Hacé commit en la rama de la épica y registrá `commitHash`. Hallazgos y decisiones nuevas van a `hallazgos.md` con el próximo H#/D# libre.
8. **Cierre:** mostrame el resumen del diff y cómo probarlo localmente, y esperá mi OK. Con OK: en modo `pr`, push de la rama y PR épica → integración; en `local-only`, `git merge --no-ff` a la integración sin push. Recién ahí `completed`, `merged: true` y `pr`.
9. Agregá un bloque "Continuación · sesión N" en `handoff.md` con el próximo paso. Nunca merge a `main` ni force-push.
