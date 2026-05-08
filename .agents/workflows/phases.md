---
description: Fases DDD de ejecución para cualquier tarea no trivial
---

# Workflow: Fases DDD de Ejecución

## FASE 1 — DIRECT (el director define)
El director elige las tareas de la sesión.
El agente NO actúa hasta recibir instrucción explícita.
El director define: qué hacer, qué worktree usar, qué NO tocar.

## FASE 2 — PLAN MODE (siempre obligatorio para tareas no triviales)
Antes de editar cualquier archivo:
1. Describir exactamente qué archivos vas a tocar y por qué
2. Describir qué NO vas a tocar
3. Escribir el plan en tasks/todo.md
4. Esperar "adelante" del director

Si el director no responde "adelante" explícitamente → NO ejecutar.

## FASE 3 — DISSECT (dividir si la tarea es compleja)
Si la tarea tiene más de 5 pasos o toca más de 3 archivos:
- Dividirla en subtareas atómicas
- Identificar cuáles son independientes (pueden ir en paralelo)
- Identificar cuáles tienen dependencias (deben ir en secuencia)
- Proponer al director qué puede delegarse a un segundo agente

## FASE 4 — EXECUTE (dentro del scope)
- Solo editar archivos del scope asignado
- Si encontrás algo roto fuera de tu scope: reportar, no tocar
- Actualizar tasks/todo.md marcando el progreso

## FASE 5 — VALIDATE (RALF — nunca saltearse)
Antes del commit:
1. git diff --stat → revisar scope exacto
2. Correr tests si existen: npm run test
3. Verificar visualmente que nada se rompió
4. Preguntarse: "¿Aprobaría esto un Staff Engineer?"
5. Si algo falla → autocorregir sin interrumpir al director

## FASE 6 — COMMIT + REPORT
1. git add -p (revisar cambio por cambio)
2. git commit -m "tipo: descripción en español"
3. Actualizar feature_list.json → "passing"
4. Actualizar tasks/todo.md → mover a "Completado"
5. Si hubo correcciones → actualizar tasks/lessons.md
6. Reportar al director: qué hiciste, qué archivos tocaste, qué aprendiste
