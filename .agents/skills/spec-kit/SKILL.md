---
name: spec-kit
description: "Usar Spec-Driven Development (GitHub Spec Kit) en features medianas o grandes: constitution, spec, plan y tasks antes de codear. No para fixes chicos ni tareas de menos de 3 pasos."
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
- `.agents/tasks/todo.md`
- `.agents/tasks/lessons.md`
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
- Producto/alcance y arquitectura (incl. AI/RAG) → subagente `planner`
- Implementación por tramos → `implementador`
- Narrativa/docs/spec → skill `technical-docs`
- Tests y aceptación → `verificador`
- UI/experiencia → skill `frontend-design`

## Regla final
Usar Spec Kit cuando el costo de no tener especificación sea mayor que el costo de escribirla.
