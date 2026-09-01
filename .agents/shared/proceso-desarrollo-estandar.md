---
description: Proceso de trabajo estándar compartido por los agentes de desarrollo (docs, principal, seo, tests, obsidian-brain). Cada agente referencia esto y solo agrega su delta específico.
---

# Proceso de desarrollo estándar

1. Leer `AGENTS.md` y `tasks/lessons.md` del proyecto.
2. Leer la skill relevante para la tarea.
3. Plan Mode: describir qué se va a tocar y por qué, sin editar nada todavía.
4. Esperar aprobación explícita del director antes de implementar.
5. Implementar solo dentro del scope asignado a este agente.
6. Validar con evidencia fresca (git diff --stat, tests si existen).
7. Commit: `tipo: descripción en español`.
8. Actualizar `tasks/todo.md` y `tasks/lessons.md` si aplica.
