---
name: spec-kit
description: "Use GitHub Spec Kit when the user requests it or the repository already uses .specify. Default feature work uses lightweight specs and vertical tickets."
---

# Spec Kit — Spec-Driven Development

## Objetivo
Usar especificaciones como fuente de verdad ejecutable antes de implementar features complejas.

Spec Kit es una opción para equipos que ya usan sus artefactos o eligen adoptarlos. Para features habituales, seguir `../../workflows/ticket_sessions.md`: reutilizar decisiones aprobadas, spec breve y slices verticales verificables. Tener varios archivos o más de tres pasos no exige instalar Spec Kit ni crear una constitution nueva.

## Cuándo usarlo
- El usuario pide GitHub Spec Kit o sus comandos.
- El repositorio ya usa `.specify/` y hace falta continuar su proceso.
- Su gobernanza aporta a una necesidad concreta y se acuerda adoptarlo; no elegirlo por tamaño del diff solamente.

Una spec define el comportamiento esperado; un slice vertical entrega un camino completo y verificable para el usuario. Son complementarios. Priorizar una primera entrega observable y ajustar el plan con feedback; no crear tickets sólo por capa (UI, API, base de datos) si eso impide probar el resultado.

## Cuándo NO usarlo
- Fix chico y obvio.
- Cambio SEO puntual.
- Ajuste visual simple.
- Refactor menor.
- Hotfix urgente.
- Tarea de menos de 3 pasos.

## Flujo cuando Spec Kit está seleccionado

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

Si la herramienta no soporta slash commands, seguir los artefactos y convenciones existentes. No crear `.specify/`, instalar el CLI o duplicar specs sólo por cargar esta skill; respetar la autorización aplicable.

## Convivencia con tu sistema

Spec Kit no reemplaza:
- `AGENTS.md`
- `.agents/tasks/todo.md`
- `.agents/tasks/lessons.md`
- agentes por rol
- workflows globales

Spec Kit agrega una capa de especificación para trabajos grandes.

## Estructura habitual de un repo que lo adopta

Referencia, no scaffold obligatorio:

```text
.specify/
├── memory/
│   └── constitution.md
├── specs/
├── templates/
└── README.md
```

## Routing recomendado
- Producto/alcance y arquitectura (incl. AI/RAG) → primary o `planner` si la delegación aporta
- Implementación por tramos → primary o `implementador` para trabajo independiente
- Narrativa/docs/spec → skill `technical-docs`
- Tests y aceptación → `verificador`
- UI/experiencia → skill `frontend-design`

## Regla final
Necesitar una especificación no implica necesitar Spec Kit. Seleccionarlo según el pedido o la adopción del repo; conservar la documentación mínima que permita implementar y comprobar el comportamiento esperado.
