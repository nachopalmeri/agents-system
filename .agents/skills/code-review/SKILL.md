---
name: code-review
description: "Review a requested diff, material feature or release against spec and repo standards; tiny edits do not trigger automatic reviewers. Explicit judgment day selects blind dual review."
---

# Code review

Revisá desde un **punto fijo** (commit, rama, tag o merge-base) sobre dos ejes:

1. **Estándares:** ¿respeta las reglas documentadas del repo (AGENTS.md, CLAUDE.md, linters)? Lo documentado en el repo gana sobre cualquier heurística.
2. **Spec:** ¿implementa fielmente el issue, plan o pedido de origen, sin agregar alcance?

## Cuándo

- Obligatorio: antes de merge/PR y después de una feature grande; checkpoint integrado, no por cada checkbox del plan.
- Útil: cuando te trabás, antes de un refactor, después de un bug complejo.
- No: cambios triviales de una línea.

## Cómo

1. `BASE=$(git merge-base HEAD origin/main)`; revisá `git diff $BASE...HEAD`.
2. Hacé una revisión combinada de spec/calidad. Delegá un reviewer cuando riesgo, complejidad o independencia lo justifiquen, con `reviewer-prompt.md`: pedido/spec, BASE, HEAD y archivos propios. Nunca el historial completo; un modelo fuerte no es requisito de reviews rutinarias.
3. Salida por severidad: **P0** bloquea (bug, seguridad, pérdida de datos), **P1** antes de mergear, **P2** opcional. Cada hallazgo con `archivo:línea` y cómo verificarlo.
4. Arreglá P0 y P1. Si el reviewer se equivoca, respondé con evidencia (test, código), no con acuerdo performativo (ver `receiving-code-review`).
5. Una pasada y como máximo una correctiva; verificá checks afectados. Fallo idéntico o criterio incierto exige replan/bloqueo, no un loop abierto. Nunca declares aprobación humana ni mergees main automáticamente.

## Smells (heurísticas, no violaciones)

Nombre que no revela intención, código duplicado en el diff, feature envy, data clumps, primitive obsession, switches repetidos, shotgun surgery, divergent change, generalidad especulativa y cadenas de mensajes. Catálogo con remedios: `references/standards-and-smells.md` (adaptado de [mattpocock/skills](https://github.com/mattpocock/skills), MIT, © 2026 Matt Pocock).

## Modo "judgment day" (sólo si se pide explícito)

Dos reviewers ciegos en paralelo con el mismo alcance. Se arregla sólo lo severo que confirman ambos; lo que marca uno solo queda como sospecha. Máximo dos rondas y veredicto `APPROVED` o `ESCALATED`. Protocolo: `references/judgment-day.md` (adaptado de [Gentleman-Programming/gentle-ai](https://github.com/Gentleman-Programming/gentle-ai), MIT/Apache-2.0).
