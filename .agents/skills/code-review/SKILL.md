---
name: code-review
description: "Use before merge/PR, after a major feature or each plan task, or when asked to review a diff: review against repo standards and the spec from a fixed point. Explicit \"judgment day\" = blind dual review."
---

# Code review

Revisá desde un **punto fijo** (commit, rama, tag o merge-base) sobre dos ejes:

1. **Estándares:** ¿respeta las reglas documentadas del repo (AGENTS.md, CLAUDE.md, linters)? Lo documentado en el repo gana sobre cualquier heurística.
2. **Spec:** ¿implementa fielmente el issue, plan o pedido de origen, sin agregar alcance?

## Cuándo

- Obligatorio: antes de merge/PR, después de una feature grande y después de cada tarea en `subagent-driven-development`.
- Útil: cuando te trabás, antes de un refactor, después de un bug complejo.
- No: cambios triviales de una línea.

## Cómo

1. `BASE=$(git merge-base HEAD origin/main)`; revisá `git diff $BASE...HEAD`.
2. Delegá al subagente `reviewer` con el prompt de `reviewer-prompt.md`: qué se implementó, la spec, BASE y HEAD. El reviewer no ve tu historial, sólo el diff y la spec.
3. Salida por severidad: **P0** bloquea (bug, seguridad, pérdida de datos), **P1** antes de mergear, **P2** opcional. Cada hallazgo con `archivo:línea` y cómo verificarlo.
4. Arreglá P0 y P1. Si el reviewer se equivoca, respondé con evidencia (test, código), no con acuerdo performativo (ver `receiving-code-review`).

## Smells (heurísticas, no violaciones)

Nombre que no revela intención, código duplicado en el diff, feature envy, data clumps, primitive obsession, switches repetidos, shotgun surgery, divergent change, generalidad especulativa y cadenas de mensajes. Catálogo con remedios: `references/standards-and-smells.md` (adaptado de [mattpocock/skills](https://github.com/mattpocock/skills), MIT, © 2026 Matt Pocock).

## Modo "judgment day" (sólo si se pide explícito)

Dos reviewers ciegos en paralelo con el mismo alcance. Se arregla sólo lo severo que confirman ambos; lo que marca uno solo queda como sospecha. Máximo dos rondas y veredicto `APPROVED` o `ESCALATED`. Protocolo: `references/judgment-day.md` (adaptado de [Gentleman-Programming/gentle-ai](https://github.com/Gentleman-Programming/gentle-ai), MIT/Apache-2.0).
