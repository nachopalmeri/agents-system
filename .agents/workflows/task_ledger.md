---
description: Patrón opcional para convertir pedidos en lenguaje natural en tareas trazables con tablero/ledger, progreso, evidencia y recibo final
---

# Task Ledger

## Principio

El usuario habla en lenguaje natural. El coordinador interpreta intención, decide si corresponde crear una tarea, enruta al agente correcto, actualiza progreso y deja evidencia final en un ledger visible.

El chat es la interfaz. El kanban/ledger es la fuente de verdad operativa.

## Cuándo usar

- El usuario pide coordinar varias tareas o agentes.
- Hay handoffs entre roles: coordinador → agente técnico → QA/docs/release.
- Se necesita trazabilidad visible de estado, evidencia y resultado.
- El trabajo puede continuar fuera del desktop o necesita registro asincrónico.
- Hay múltiples tareas activas y conviene tablero.

## Cuándo NO usar

- Conversación exploratoria sin acción.
- Pregunta simple.
- Fix chico que se resuelve en una respuesta.
- Brainstorming temprano donde crear tasks generaría ruido.
- Cada mensaje del usuario: no todo diálogo merece tarjeta.

## Flujo

```text
Pedido en lenguaje natural
→ coordinador entiende intención
→ decide si crear task
→ clasifica tipo, prioridad y riesgo
→ enruta al agente/workflow correcto
→ crea/actualiza tarjeta en ledger
→ agente trabaja y reporta progreso
→ estado del tablero avanza
→ evidencia se adjunta
→ recibo final se publica
→ task queda done o blocked
```

## Ledger recomendado

El ledger puede ser:

- `tasks/todo.md` en repos chicos.
- GitHub Issues/Projects.
- Obsidian note/dataview.
- Kanban local.
- Discord task-board.
- Hermes Kanban u otra herramienta externa.

La herramienta importa menos que las invariantes: una task, un dueño, un estado, evidencia y un recibo final.

## Contrato de task

```text
ID:
Título:
Pedido original:
Intención interpretada:
Workflow:
Agente responsable:
Estado: backlog / todo / in-progress / blocked / review / done
Prioridad:
Riesgo:
Criterio de éxito:
Evidencia esperada:
Última actualización:
Recibo final:
```

## Estados

| Estado | Significado |
|---|---|
| backlog | Existe pero no está comprometida |
| todo | Lista para ejecutar |
| in-progress | Un agente está trabajando |
| blocked | Requiere dato, confirmación o dependencia |
| review | Trabajo hecho, falta validación/revisión |
| done | Validado y con recibo final |

## Reglas de creación

Crear task solo si:

- Hay un verbo accionable.
- Hay un resultado esperado.
- El trabajo no cabe en una respuesta simple.
- Necesita tracking, handoff, validación o continuidad.

No crear task si:

- Es solo charla.
- Es una aclaración.
- Es una idea sin intención de ejecutar.
- Duplicaría una task existente.

## Recibo final

Toda task cerrada debe tener:

```text
Resultado:
Archivos/notas tocadas:
Validación:
Evidencia:
Riesgos pendientes:
Próximo paso:
```

## Integración con workflows

- Usar `index.md` para decidir workflow.
- Usar `phases.md` para ejecución.
- Usar `/loop` si la task requiere iterar hasta criterio verificable.
- Usar Routine si la task es recurrente.
- Usar `validation.md` antes de mover a done.
- Usar `session_checkpoint.md` si el trabajo queda largo.

## Integración con herramientas externas

Discord, Hermes, GitHub Projects, Notion, Linear o cualquier tablero externo son opcionales.

Guardrails:

- Empezar local/read-only o draft.
- No publicar mensajes externos sin confirmación si hay riesgo reputacional.
- No conectar bots con permisos amplios sin `mcp_security.md`.
- No exponer secretos, rutas sensibles o datos personales en canales públicos.
- No crear ruido: el tablero debe aclarar, no duplicar conversación.

## Regla final

El mejor tablero no reemplaza al agente. Lo hace auditable: muestra qué se pidió, quién lo tomó, qué cambió, qué evidencia existe y qué queda pendiente.
