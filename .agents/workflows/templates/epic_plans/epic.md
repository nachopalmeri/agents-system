# Épica NN · <título>

> Plantilla de `docs/plans/<nombre>/epics/NN-<corto>.md`.

## Objetivo

<Una o dos líneas: qué cambia para el usuario o el sistema.>

## Dependencias

<Épicas que tienen que estar mergeadas antes; `ninguna` si es la primera.>

## Archivos principales

- `<ruta>` — <qué cambia>

## Terminado significa

<2-4 líneas observables, verificables desde afuera.>

## Parar y preguntar solo si

- <decisión de producto/arquitectura no cubierta por D#>
- <el diff va a superar 500 líneas>
- <una validación falla igual dos veces>

## Checkpoint pre-implementación

- [ ] Estoy en el worktree del plan (`git rev-parse --show-toplevel`).
- [ ] Árbol limpio (`git status --short` vacío).
- [ ] La épica anterior está mergeada en la integración (`progress.json` → `merged: true`).
- [ ] `git switch <integración> && git pull --ff-only` (en `local-only`, sin pull remoto).
- [ ] `git switch -c <usuario>/<nombre>-<corto>` desde la integración.
- [ ] Diff estimado < 500 líneas; si no, dividir antes de seguir.
- [ ] Cuota de cuenta < 90 % y contexto de la sesión < 30 %.

## Tareas

- [ ] <tarea verificable>

## Criterios de aceptación

- [ ] <criterio>

## Tests requeridos

Obligatorio. <Qué tests nuevos o modificados prueban los criterios; dónde viven.>

## Validaciones

| Validación | Requerida | Comando |
|---|---|---|
| tests | sí | `<comando>` |
| build | sí/no | `<comando>` |
| typecheck | sí/no | `<comando>` |

## Modo

`single` (una sesión) | `phased` (fases con checkpoint en `handoff.md` entre cada una).

## Notas

<Riesgos, links a H#/D#, pendientes para épicas siguientes.>
