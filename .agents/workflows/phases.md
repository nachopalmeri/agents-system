---
description: ⚠️ DEPRECATED — reemplazado por AGENTS.md secciones 1-4 y spec_kit.md. Fases DDD integradas en el flujo chat-first.
---

# ⚠️ DEPRECATED: Fases DDD de Ejecución

Este workflow está integrado en AGENTS.md secciones 1 (Plan Mode), 2 (Subagentes), 3 (Automejora) y 4 (Verificación). Para specs formales, usar `spec_kit.md`.

Contenido original archivado en `docs/archive/phases-v1.md`.

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

### Ejecución lineal normal
Usar ejecución lineal cuando:
- El objetivo está claro.
- Hay pocos pasos.
- La validación es simple.
- No hace falta iterar sobre resultados intermedios.

### `/loop`
Usar `/loop` cuando:
- La tarea es larga o iterativa.
- Hay un criterio de salida verificable.
- El agente debe repetir percibir → decidir → ejecutar → validar hasta terminar.
- Ejemplos: corregir tests hasta que pasen, limpiar errores de lint, completar una migración con validación, iterar una landing hasta cumplir checklist.

Contrato mínimo:
- Objetivo explícito.
- Criterio de salida verificable.
- Límite de iteraciones, tiempo o intentos si hay riesgo de atascarse.
- Validación a ejecutar en cada ciclo o al final.
- Condición de stop: éxito, bloqueo real o confirmación requerida.

Criterio de salida del loop:
- Objetivo cumplido y validado.
- Bloqueo real documentado.
- Riesgo detectado que requiere confirmación del usuario.

### Routine
Usar Routine cuando:
- La tarea es recurrente.
- Debe poder correr con límites claros.
- Debe ser idempotente o segura ante repetición.
- Ejemplos: health check semanal, reporte SEO mensual, revisión periódica de backlinks, actualización de métricas.

Las routines con credenciales, escritura externa, DMs, pagos, ads o datos personales deben quedar en modo draft/read-only hasta confirmación explícita.

Contrato mínimo:
- Frecuencia o disparador.
- Scope exacto.
- Modo: read-only, draft, local-write o external-write.
- Entradas y salidas esperadas.
- Acciones prohibidas.
- Evidencia que debe reportar.

Hard stops:
- No publicar.
- No gastar.
- No responder DMs.
- No modificar producción.
- No usar credenciales o datos personales sin confirmación explícita.

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
