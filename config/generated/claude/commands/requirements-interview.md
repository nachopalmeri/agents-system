---
description: "Entrevista de requisitos de a una pregunta; deja docs/plans/<nombre>/requirements.md como spec del plan"
argument-hint: "<nombre-del-plan> [contexto o referencias]"
---
Hacé la entrevista de requisitos para el plan: $ARGUMENTS

Seguí `~/.agents/workflows/epic_plans.md` (fase 1) y la plantilla `~/.agents/workflows/templates/epic_plans/requirements.md`.

1. **Auditá primero, preguntá después.** Leé por grep y rangos el README, el glosario (`CONTEXT.md`/`GLOSSARY.md`), los ADRs (`docs/adr/`, `docs/decisions/`), el código relevante y las referencias que te pasé. Anotá lo que ya está respondido con su fuente.
2. **Una pregunta por vez.** Preguntá sólo lo que el código y los docs no responden, con tu recomendación y el porqué. Esperá mi respuesta antes de la siguiente. Registrá cada decisión como D# en `requirements.md`.
3. **Nunca inventes datos.** Lo que no se pueda confirmar queda marcado "a confirmar" y pasa a Open questions con quién lo resuelve.
4. Escribí `docs/plans/<nombre>/requirements.md` con el encabezado (salida de `/requirements-interview` · fecha, fuentes usadas, estado) y las 9 secciones de la plantilla. Es **la** spec: no crees otra.
5. Si hay UI o comportamiento desconocido, proponé `matt-prototype` (descartable); si el dominio está difuso, `matt-domain-modeling`; para contrastar con glosario/ADRs, `matt-grill-with-docs`. Lo aprendido vuelve a este mismo archivo y a `hallazgos.md`.
6. Al cerrar, poné "Estado: spec lista para decomponer (`/decompose-plan <nombre>`)" y completá § Épicas sugeridas.

Presupuesto de contexto: checkpoint al ~30 % en `docs/plans/<nombre>/handoff.md`; al ~40 % pará y dejame un Prompt de continuación.
