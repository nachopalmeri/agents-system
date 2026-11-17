---
description: Planes por épicas para trabajo mediano/grande - grill/spec, descomponer en docs/plans/<nombre>/, una sesión por épica y progress.json como fuente de verdad
---

# Planes por épicas

Flujo único para trabajo mediano/grande que no entra en una sesión enfocada. Reemplaza `to-tickets` y `/planear` para ese tamaño; los cambios chicos siguen directos y los planes chicos/medianos de una sesión siguen en `/planear`.

## Fases (en este orden)

1. **Entrevista de requisitos** (`/requirements-interview <nombre>`). Primero audita el repo destino y las referencias que dio el usuario (README, glosario `CONTEXT.md`/`GLOSSARY.md`, ADRs en `docs/adr/` o `docs/decisions/`, código relevante); después pregunta **de a una** sólo lo que el código y los docs no responden. Salida: `docs/plans/<nombre>/requirements.md` (plantilla `workflows/templates/epic_plans/requirements.md`), que es **la** spec del plan. Lo que falte confirmar se marca "a confirmar", nunca se inventa.
2. **Enriquecer y desriesgar** la misma spec con skills Matt (todas `promoted` en `skills-library/matt-catalog.json`), sólo las que hagan falta:
   - `skills-library/matt-prototype/SKILL.md` para UI o comportamiento desconocido; el prototipo es descartable y lo aprendido vuelve a `requirements.md` y `hallazgos.md`.
   - `skills-library/matt-grill-with-docs/SKILL.md` contra el glosario y los ADRs del repo.
   - `skills-library/matt-domain-modeling/SKILL.md` cuando el dominio está difuso.
   - `skills-library/matt-research/SKILL.md` u otras según necesidad.
   No crean una segunda spec: `to-spec` se mapea a `requirements.md` y `to-tickets` a `/decompose-plan`.
3. **Descomponer** (`/decompose-plan <nombre>`). Lee `requirements.md` (§ Épicas sugeridas) y genera en `docs/plans/<nombre>/`:
   - `README.md` (plantilla `workflows/templates/epic_plans/README.md`)
   - `progress.json` (plantilla `workflows/templates/epic_plans/progress.json`, schema `schemas/plan-progress.schema.json` del home repo)
   - `epics/NN-<corto>.md` (plantilla `workflows/templates/epic_plans/epic.md`), con `00-spikes` si hay supuestos sin verificar
   - `handoff.md` y `hallazgos.md` (plantillas `workflows/templates/epic_plans/handoff.md` y `workflows/templates/epic_plans/hallazgos.md`)
   Mostrá el desglose y esperá OK antes de crear worktree o ramas.
4. **Ejecutar** (`/run-plan <nombre>`): una sesión/terminal por épica, en orden de dependencias.
5. **Seguir** (`/plan-status <nombre>`, `/list-plans`): `progress.json` es la fuente de verdad del trabajo del plan; `tasks/todo.md` (raíz y `.agents/tasks/`) sólo apunta al plan, no duplica su estado.

## Git: un plan, un worktree, una rama de integración

- **Rama base:** configurable por proyecto (`baseBranch` en `progress.json`, p. ej. `dev`); si falta, la rama default del remoto (`git symbolic-ref refs/remotes/origin/HEAD`). Nunca `main` salvo que el proyecto lo declare como base.
- **Plan** = un worktree (`.claude/worktrees/<nombre>/` en Claude; en otros clientes `.worktrees/<nombre>/` o el equivalente que el proyecto ya use) = una rama de integración `<usuario>/<nombre>` cortada de la base actualizada.
- **Épica** = rama `<usuario>/<nombre>-<corto>`, siempre cortada de la integración recién pulleada (`git pull --ff-only`), nunca de la épica anterior. Una épica arranca sólo cuando la anterior está mergeada en la integración y el usuario dio OK.
- **PR:** épica → integración; el PR final va integración → base. Push y PR siguen la autorización vigente del proyecto; nunca merge a `main` ni force-push.
- **`executionMode: "local-only"`:** sin push ni PR. Al cerrar una épica mostrá resumen del diff y cómo probarla localmente; mergeá a la integración (`git merge --no-ff`) recién con el OK del usuario.

## Autorización permanente de sesiones

El README del plan tiene el campo **Autorización de sesiones**. Si dice `sí`, el usuario autorizó de antemano abrir una sesión/terminal nueva por épica de ese plan. Es la excepción explícita a "sesiones nuevas sólo con autorización explícita" (`.agents/AGENTS.md`, `workflows/ticket_sessions.md`); vale sólo para épicas de ese plan, no para publicar, mergear ni mensajes externos.

## Presupuesto de contexto (requisito duro)

Nunca pasar del 30-40 % de la ventana de contexto, en ninguna sesión (orquestador, runner de épica o worker).

- **~30 %:** escribí un checkpoint compacto en `docs/plans/<nombre>/handoff.md` (bloque "Continuación · sesión N": estado, archivos tocados, validaciones, próximo paso).
- **~40 %:** pará y entregá un **Prompt de continuación** listo para pegar en una sesión nueva. No sigas implementando.
- **Cuota de cuenta:** antes de empezar una épica revisá el uso de la cuenta (`/usage` o el panel del cliente). Arriba del 90 % pará y avisá. Nunca uses overage pago.
- Si el cliente no expone el porcentaje, estimalo por volumen leído/escrito y cortá antes.

## Patrón coordinador

- `handoff.md` es el único archivo que una sesión nueva lee primero. Secciones: **Dónde está todo**, **Decisiones (no rediscutir)** con D#, **Estado**, **Próximo paso**. Las sesiones siguientes agregan bloques fechados `## Continuación · sesión N (AAAA-MM-DD)` al final; el bloque más nuevo pisa el estado anterior.
- `hallazgos.md` es un log: H# (hallazgo) y D# (decisión) con fecha, evidencia (`archivo:línea` o link) y estado. Siempre se usa el próximo número libre; no se renumera.
- **Workers:** máximo 3 en paralelo, profundidad 1, cada uno con su scope de archivos. Reglas compartidas en `workflows/templates/epic_plans/worker-rules.md`, pegadas en cada encargo.

## Modelos

El orquestador del plan queda exento del tope "Opus ≤1 por tarea" de `.agents/AGENTS.md`: puede ser Opus durante todo el plan. Los topes por tarea (Haiku ≤2, Sonnet ≤2, Opus ≤1) aplican a los workers. Rutina sigue yendo al modelo más barato capaz.

## Límites

- Una épica apunta a un diff < 500 líneas; si no entra, se divide antes de implementar.
- Máximo 3 iteraciones de validación y 1 replan por épica; un fallo idéntico repetido marca `blocked` con `blockedReason`.
- Nada de esto autoriza publicar, mergear a `main`, borrar, migrar datos ni escribir en producción.
