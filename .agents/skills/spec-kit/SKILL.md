---
name: spec-kit
description: Usar GitHub Spec Kit / Spec-Driven Development para proyectos o features medianas-grandes donde conviene definir constitution, spec, plan, tasks e implementación antes de codear. No usar para fixes chicos, SEO puntual, cambios visuales simples o tareas de menos de 3 pasos.
---

# Spec Kit — Spec-Driven Development

## Objetivo
Usar especificaciones como fuente de verdad ejecutable antes de implementar features complejas.

Spec Kit sirve para pasar de “vibe coding” a un flujo con intención, gobernanza, plan técnico, tareas verificables y ejecución controlada.

## Cuándo usarlo
- Proyecto nuevo con requisitos medianos o grandes.
- Feature compleja con varios archivos o módulos.
- Producto AI/RAG que necesita trazabilidad.
- Brownfield delicado donde hay riesgo de romper comportamiento existente.
- Trabajo donde el “qué” todavía no está claro.
- Cuando hace falta alinear producto, técnica, tests y documentación.

## Cuándo NO usarlo
- Fix chico y obvio.
- Cambio SEO puntual.
- Ajuste visual simple.
- Refactor menor.
- Hotfix urgente.
- Tarea de menos de 3 pasos.

## Flujo base

1. **Constitution** — principios y reglas del proyecto.
2. **Specify** — qué se quiere construir y por qué.
3. **Plan** — cómo se implementa técnicamente.
4. **Tasks** — tareas accionables y verificables.
5. **Implement** — ejecutar con validación.

Slash commands típicos:

```text
/speckit.constitution
/speckit.specify
/speckit.plan
/speckit.tasks
/speckit.implement
```

Si la herramienta no soporta slash commands, replicar el flujo manualmente usando archivos en `.specify/`.

## Convivencia con tu sistema

Spec Kit no reemplaza:
- `AGENTS.md`
- `tasks/todo.md`
- `tasks/lessons.md`
- agentes por rol
- workflows globales

Spec Kit agrega una capa de especificación para trabajos grandes.

## Estructura mínima local

```text
.specify/
├── memory/
│   └── constitution.md
├── specs/
├── templates/
└── README.md
```

## Routing recomendado
- Producto/alcance → `agente-principal` o `kickoff-architect`
- Arquitectura AI/RAG → `agente-ai-architect`
- Narrativa/docs/spec → `agente-docs`
- Tests y aceptación → `agente-tests`
- UI/experiencia → `agente-design`

## Regla final
Usar Spec Kit cuando el costo de no tener especificación sea mayor que el costo de escribirla.
