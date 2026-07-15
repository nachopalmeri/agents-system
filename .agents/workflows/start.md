---
description: Qué hacer al abrir una sesión en cualquier proyecto sin fallar si faltan archivos
---

# Workflow: Inicio de Sesión

## Cuándo usarlo
Sólo cuando el cliente solicita un diagnóstico de inicio o faltan contexto/estado para ejecutar la tarea. No crear un turno vacío de probes antes de trabajo simple.

## Principio
El inicio de sesión nunca debe fallar por archivos faltantes. Si un archivo, comando o dato no existe, reportar `no encontrado` o `no disponible` y continuar.

## Pasos Obligatorios
1. Intentar leer `AGENTS.md` del proyecto actual.
   - Si existe: aplicar sus reglas.
   - Si no existe: reportar `AGENTS.md: no encontrado` y continuar con reglas globales.
2. Intentar leer `.agents/tasks/lessons.md`.
   - Si existe: cada lección con estado `activa` se carga como contexto activo:
     - Leer cada entrada y extraer su regla derivada (Siempre X / Nunca Y).
     - Mantener las reglas en memoria durante toda la sesión para guiar routing,
       scope, output y validación.
     - Si una lección contradice una instrucción actual, reportarlo al director
       antes de decidir qué aplicar.
   - Si no existe: reportar `.agents/tasks/lessons.md: no encontrado`.
3. Intentar leer `.agents/memory/lessons-global.md`.
   - Si existe: extraer todas las reglas globales activas como contexto base.
     Las reglas globales tienen prioridad sobre lecciones locales de sesión.
   - Si no existe: reportar `.agents/memory/lessons-global.md: no encontrado`.
4. Intentar leer `.agents/tasks/todo.md`.
   - Si existe: ver qué está en progreso.
   - Si no existe: reportar `.agents/tasks/todo.md: no encontrado`.
5. Intentar ejecutar `git status`.
   - Si no es repo Git o falla: reportar `git status: no disponible`.
6. Intentar ejecutar `git log --oneline -5`.
   - Si falla: reportar `git log: no disponible`.
7. Intentar ejecutar `git branch --show-current`.
   - Si falla: reportar `branch actual: no disponible`.
8. Intentar leer `feature_list.json`.
   - Si existe: ver tareas pendientes.
   - Si no existe: reportar `feature_list.json: no encontrado`.

## Reporte al Director
Al terminar el inicio, reportar:
- En qué rama/worktree estás, o `no disponible`.
- Qué tareas tienen status `pending` en `feature_list.json`, o `feature_list.json no encontrado`.
- Cuál es la de mayor prioridad, o `no disponible`.
- Si hay algo en `.agents/tasks/todo.md` en progreso, o `.agents/tasks/todo.md no encontrado`.
- Lecciones activas (locales y globales): cuántas se cargaron como contexto.
- Archivos esperados que faltan.
- Riesgos detectados antes de operar.

## Regla de continuidad
Si faltan archivos estándar, no crearlos automáticamente durante el inicio salvo que el usuario lo pida o el workflow activo lo requiera.

## Solo después de este reporte
Esperar instrucción del director.
