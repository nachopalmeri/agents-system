---
description: Qué hacer al abrir una sesión en cualquier proyecto
---

# Workflow: Inicio de Sesión

## Cuándo usarlo
Al abrir OpenCode en cualquier proyecto, antes de cualquier acción.

## Pasos Obligatorios
1. Leer AGENTS.md del proyecto (raíz del proyecto actual)
2. Leer tasks/lessons.md → aplicar todas las reglas aprendidas
3. Leer tasks/todo.md → ver qué está en progreso
4. Ejecutar: git status
5. Ejecutar: git log --oneline -5
6. Ejecutar: git branch --show-current → confirmar en qué worktree estás
7. Leer feature_list.json → ver tareas pendientes

## Reporte al Director
Al terminar el inicio, reportar:
- En qué rama/worktree estás
- Qué tareas tienen status "pending" en feature_list.json
- Cuál es la de mayor prioridad (menor número)
- Si hay algo en tasks/todo.md "En progreso"

## Solo después de este reporte: esperar instrucción del director
