---
description: Fases DDD de ejecución para tareas no triviales, integradas con routing chat-first y validación central
---

# Workflow: Fases DDD de Ejecución

## Principio
Usar estas fases para tareas no triviales. Para cambios chicos, usar el flujo simple según `workflows/index.md`.

## FASE 1 — DIRECT
El director define intención, prioridad y restricciones. Si el pedido está claro, no pedir rituales; actuar con el menor workflow suficiente.

## FASE 2 — PLAN
Antes de editar en tareas no triviales:
1. Describir qué se va a tocar y por qué.
2. Describir qué NO se va a tocar.
3. Definir validación esperada.
4. Esperar confirmación cuando el cambio sea riesgoso o amplio.

## FASE 3 — DISSECT
Si la tarea tiene más de 5 pasos o toca más de 3 archivos:
- Dividir en subtareas atómicas.
- Identificar dependencias.
- Usar subagentes/worktrees solo si reducen contexto o riesgo.

## FASE 4 — EXECUTE
- Editar solo dentro del scope.
- Si aparece algo roto fuera del scope, reportar antes de tocar.
- Mantener `tasks/todo.md` actualizado si existe.

## FASE 5 — VALIDATE
Usar `workflows/validation.md` como fuente única de validación.

## FASE 6 — REPORT
Reportar:
- Qué se hizo.
- Qué archivos se tocaron.
- Qué validación se ejecutó.
- Riesgos o pendientes.
- Lecciones capturadas si aplica.

## Regla final
No declarar completado sin evidencia de validación.
