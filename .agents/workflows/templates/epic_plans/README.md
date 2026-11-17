# Plan: <nombre>

> Plantilla de `docs/plans/<nombre>/README.md`. Reemplazá los `<...>` y borrá las líneas de ayuda.

## Resumen

<2-4 líneas: qué problema resuelve el plan y para quién. Link a la spec aprobada.>

## Ejecución

| Campo | Valor |
|---|---|
| Worktree | `.claude/worktrees/<nombre>/` (o el equivalente del cliente) |
| Rama base | `<dev / default del remoto>` |
| Rama de integración | `<usuario>/<nombre>` |
| Patrón de rama por épica | `<usuario>/<nombre>-<corto>` |
| Modo | `pr` \| `local-only` |
| Política de PR | épica → integración; final integración → base. Nunca `main` salvo que el proyecto lo declare. |
| Autorización de sesiones | `sí` — el usuario autoriza abrir una sesión/terminal nueva por épica de este plan (excepción explícita a "sesiones nuevas sólo con autorización"). No autoriza publicar ni mergear. |

## Reglas

- Una épica por vez; la siguiente arranca cuando la anterior está mergeada en la integración y hay OK.
- Cada épica sale de la integración recién pulleada, nunca de la épica anterior.
- `progress.json` es la fuente de verdad; `handoff.md` se lee primero; `hallazgos.md` registra H#/D#.
- Presupuesto de contexto: checkpoint al ~30 %, handoff al ~40 %. Cuota de cuenta > 90 %: parar.

## Mirada estratégica

<Por qué este orden de épicas, qué riesgo se ataca primero, qué queda fuera de alcance.>

## Épicas

| # | Épica | Depende de | Estado |
|---|---|---|---|
| 00 | [spikes](epics/00-spikes.md) | — | pending |
| 01 | [<corto>](epics/01-<corto>.md) | 00 | pending |

## Decisiones arquitectónicas

| D# | Decisión | Motivo | Alternativas descartadas |
|---|---|---|---|
| D1 | <...> | <...> | <...> |

## Supuestos sin verificar

Se resuelven en la épica `00-spikes`; cada resultado se registra en `hallazgos.md` y actualiza esta tabla.

| # | Supuesto | Cómo verificarlo | Estado |
|---|---|---|---|
| S1 | <...> | <...> | abierto |

## Para trabajar

Abrí una sesión en el worktree y corré `/run-plan <nombre>`. Para ver el estado: `/plan-status <nombre>`.
