# Handoff · <nombre>

> Único archivo que una sesión nueva lee primero. Los bloques "Continuación" del final pisan el estado anterior.

## Dónde está todo

- Plan: `docs/plans/<nombre>/README.md`
- Estado: `docs/plans/<nombre>/progress.json` (fuente de verdad)
- Hallazgos: `docs/plans/<nombre>/hallazgos.md`
- Worktree: `<ruta>` · Integración: `<usuario>/<nombre>` · Base: `<rama>`
- Spec: `<ruta o link>`

## Decisiones (no rediscutir)

- D1 — <decisión> (ver `hallazgos.md`)

## Estado

<Épica actual, rama, último commit, validaciones corridas.>

## Próximo paso

<Una sola acción concreta.>

<!-- Presupuesto: orquestador checkpoint ~40 % / nueva sesión principal ~50 %;
     runner de épica y workers checkpoint ~30 % / corte ~40 %. -->

<!-- Plantilla de bloque para la sesión principal siguiente:

## Continuación · sesión coordinadora N (AAAA-MM-DD)

- Épicas cerradas / en curso:
- Decisiones nuevas (D#):
- Próximo paso:

### Prompt de continuación

```
Sos el orquestador del plan <nombre> en <worktree>. Leé sólo docs/plans/<nombre>/handoff.md
(el último bloque manda) y seguí desde "Próximo paso". Presupuesto: checkpoint 40 %, corte 50 %.
```
-->

<!-- Plantilla de bloque para sesiones siguientes:

## Continuación · sesión N (AAAA-MM-DD)

- Épica / rama / commit:
- Hecho:
- Validaciones:
- Bloqueos:
- Próximo paso:

### Prompt de continuación

```
Seguí el plan <nombre> en <worktree>. Leé primero docs/plans/<nombre>/handoff.md
(el último bloque manda) y después corré /run-plan <nombre>. Épica en curso: <NN>.
Próximo paso: <...>. Respetá el presupuesto de contexto (checkpoint 30 %, corte 40 %).
```
-->
