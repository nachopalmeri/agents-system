---
description: Guía de routing de modelos según tipo de tarea para optimizar costo y calidad
---

# Model Routing

## Principio
No toda tarea necesita el modelo más caro. Routear por tipo de tarea optimiza costo y calidad.

## Routing por tipo de tarea

Un plan malo se paga en todas las iteraciones siguientes: el modelo fuerte va al principio (plan) y al final (review de riesgo); la ejecución va al medio.

| Tipo de tarea | Modelo | Razón |
|---|---|---|
| Planning, arquitectura, specs | Opus 5.5 / Fable | Define todo lo demás; errores acá multiplican tokens |
| Implementación siguiendo un plan | Sonnet 5 | Mejor calidad/costo para código |
| Búsqueda en repo, exploración, resúmenes | Haiku 4.5 (subagente) | Lectura masiva barata; devuelve sólo la conclusión |
| Tests, fixes obvios, copy, docs | Sonnet 5 (effort bajo) | No requiere razonamiento profundo |
| Debugging que ya falló una vez | Opus 5.5 | Causa raíz, evita loops |
| Review de seguridad, release, pagos | Opus 5.5 | Máxima atención |
| Tareas triviales offline | Ollama local (opencode) | Costo cero |

## Effort levels (Claude Code)

| Effort | Cuándo usar |
|---|---|
| `low` | Cambios chicos, copy puntual, fixes triviales |
| `medium` | Tareas estándar, implementación directa |
| `high` | Tareas complejas, debugging, features con múltiples archivos |
| `xhigh` | Coding agentic, tareas con muchos pasos y dependencias |
| `max` | Problemas extremadamente complejos, arquitectura crítica |

## Configuración en subagents (Claude Code)

En `.claude/agents/` o `.agents/agents/`, usar el campo `model` en YAML frontmatter:

```yaml
---
name: security-reviewer
model: opus
effort: xhigh
tools: Read, Grep, Glob
---
```

```yaml
---
name: quick-researcher
model: haiku
effort: medium
tools: Read, Grep, Glob, WebSearch
---
```

## Regla
Empezar con el modelo más barato que pueda hacer el trabajo. Subir solo cuando la calidad no alcance. Medir costo vs resultado.
