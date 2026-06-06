---
description: Guía de routing de modelos según tipo de tarea para optimizar costo y calidad
---

# Model Routing

## Principio
No toda tarea necesita el modelo más caro. Routear por tipo de tarea optimiza costo y calidad.

## Routing por tipo de tarea

| Tipo de tarea | Modelo recomendado | Razón |
|---|---|---|
| Planning, arquitectura, specs | Haiku / Gemini Flash | Rápido, barato, suficiente para estructurar |
| Implementation, coding | Sonnet / Opus | Calidad de código, manejo de contexto |
| Review de seguridad | Opus | Máxima atención a vulnerabilidades |
| Review de código general | Sonnet | Buen balance calidad/costo |
| Tests unitarios | Sonnet | Generación de tests no requiere razonamiento profundo |
| Tests E2E | Sonnet | Playwright requiere contexto de app, no razonamiento extremo |
| Debugging complejo | Opus | Razonamiento profundo para causas raíz |
| Debugging simple | Sonnet | Fixes obvios no necesitan Opus |
| Explicación, docente | Sonnet | Claridad explicativa sin necesidad de razonamiento máximo |
| Copy, marketing, contenido | Sonnet | Creatividad balanceada |
| Research, búsqueda | Haiku / Gemini Flash | Velocidad sobre profundidad |

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
