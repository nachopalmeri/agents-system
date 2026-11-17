---
description: "Ver el estado de un plan por épicas (solo lectura)"
---
Mostrame el estado del plan: $ARGUMENTS

Solo lectura: no edites archivos, no cambies ramas ni corras validaciones.

1. Buscá `docs/plans/<nombre>/progress.json` en el repo y en las copias de worktrees (`git worktree list`, `.claude/worktrees/*/`, `.worktrees/*/`). Si hay más de una, la del worktree del plan gana; avisá si difieren.
2. Validá a ojo contra `~/.agents/workflows/templates/epic_plans/plan-progress.schema.json` y marcá inconsistencias (épica `blocked` sin `blockedReason`, `completed` sin `merged`, rama inexistente).
3. Mostrá: modo, rama base, integración, tabla de épicas (estado, rama, validaciones, merged, PR/commit), la próxima épica ejecutable y el "Próximo paso" del último bloque de `handoff.md`.
4. Cerrá con una línea: qué hace falta para avanzar.
