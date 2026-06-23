---
description: Búsqueda opt-in de prompts en vault de Obsidian
---

# Workflow: Obsidian Prompt Search

## Principio

El agente NO busca en el vault automáticamente. Solo cuando el usuario confirma explícitamente.

## Cuándo se activa

- El usuario menciona "tengo prompts en mi vault" o "busca en mi vault"
- La tarea actual coincidiría con contenido del vault y el agente pregunta
- El usuario pega contenido manualmente

## Flujo de Activación

1. El agente detecta que un prompt existente mejoraría la tarea actual
2. **Pregunta:** "¿Querés que busque en tu vault algún prompt relevante para esto?"
3. Solo si el usuario responde "sí" o equivalente → ejecutar búsqueda

## Estrategia de Búsqueda (ordenada por prioridad)

1. Tags: buscar por `#prompt`, `#workflow`, `#claude-code`, `#opencode`, `#agente`, `#template`
2. Frontmatter: buscar notas con `type: prompt` o `type: workflow`
3. Carpetas: `Prompts/`, `Templates/`, `Efforts/`, `Projects/`
4. Keywords: según la tarea actual (nombre del workflow, skill, stack)
5. Título: buscar notas cuyo título coincida parcialmente

## Respuesta al Usuario

```text
Encontré N notas relevantes en tu vault:
- [título 1]
- [título 2]
- ...

¿Querés que las lea o tengo suficiente?
```

## Hard Stops

- NO buscar sin confirmación explícita
- NO iterar automáticamente si no encuentra nada — preguntar
- NO leer notas personales no relacionadas con la tarea
- NO modificar el vault salvo que el usuario lo pida
- En sesiones urgentes o sin acceso al vault: no buscar, seguir

## Regla final

Opt-in forzado. El usuario siempre dice si quiere que se busque o no.
