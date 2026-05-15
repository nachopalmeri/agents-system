---
description: Qué hacer al abrir una sesión en cualquier proyecto sin fallar si faltan archivos
---

# Workflow: Inicio de Sesión

## Cuándo usarlo
Al abrir OpenCode en cualquier proyecto, antes de cualquier acción.

## Principio
El inicio de sesión nunca debe fallar por archivos faltantes. Si un archivo, comando o dato no existe, reportar `no encontrado` o `no disponible` y continuar.

## Pasos Obligatorios
1. Intentar leer `AGENTS.md` del proyecto actual.
   - Si existe: aplicar sus reglas.
   - Si no existe: reportar `AGENTS.md: no encontrado` y continuar con reglas globales.
2. Intentar leer `tasks/lessons.md`.
   - Si existe: aplicar todas las reglas aprendidas.
   - Si no existe: reportar `tasks/lessons.md: no encontrado`.
3. Intentar leer `tasks/todo.md`.
   - Si existe: ver qué está en progreso.
   - Si no existe: reportar `tasks/todo.md: no encontrado`.
4. Intentar ejecutar `git status`.
   - Si no es repo Git o falla: reportar `git status: no disponible`.
5. Intentar ejecutar `git log --oneline -5`.
   - Si falla: reportar `git log: no disponible`.
6. Intentar ejecutar `git branch --show-current`.
   - Si falla: reportar `branch actual: no disponible`.
7. Intentar leer `feature_list.json`.
   - Si existe: ver tareas pendientes.
   - Si no existe: reportar `feature_list.json: no encontrado`.

## Reporte al Director
Al terminar el inicio, reportar:
- En qué rama/worktree estás, o `no disponible`.
- Qué tareas tienen status `pending` en `feature_list.json`, o `feature_list.json no encontrado`.
- Cuál es la de mayor prioridad, o `no disponible`.
- Si hay algo en `tasks/todo.md` en progreso, o `tasks/todo.md no encontrado`.
- Archivos esperados que faltan.
- Riesgos detectados antes de operar.

## Regla de continuidad
Si faltan archivos estándar, no crearlos automáticamente durante el inicio salvo que el usuario lo pida o el workflow activo lo requiera.

## Solo después de este reporte
Esperar instrucción del director.
