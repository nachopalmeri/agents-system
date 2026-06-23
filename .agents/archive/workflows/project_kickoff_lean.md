---
description: Workflow general recomendado para arrancar proyectos sin desperdiciar tokens
---

# Project Kickoff Lean

Usá este workflow al empezar cualquier proyecto nuevo.

---

## Paso 1: Alinear el objetivo

Definir en 3-5 líneas:

- qué problema resolvemos
- para quién
- qué resultado mínimo valida avance

## Paso 2: Elegir el nivel correcto

- Si el proyecto es simple: ir a implementación directa con mini plan.
- Si hay incertidumbre: hacer una breve exploración y decidir alcance.
- Si hay alto riesgo: escribir spec y plan formal.

## Paso 3: Definir el primer entregable

Elegir un entregable chico, visible y verificable:

- una pantalla
- un endpoint
- un flujo completo mínimo
- una automatización puntual

Evitar arrancar con arquitectura abstracta si todavía no hay prueba de valor.

## Paso 4: Crear solo la estructura mínima necesaria

Al inicio, crear solo lo imprescindible:

- `README.md` o nota corta de objetivo
- `tasks/todo.md` si hay varias etapas
- carpetas base del proyecto

No crear documentación, checklists ni plantillas por default.

## Paso 5: Ejecutar en ciclos cortos

Ciclo recomendado:

`definir -> construir -> verificar -> ajustar`

Cada ciclo debería dejar algo observable.

## Paso 6: Escalar solo cuando duela

Agregar más proceso únicamente si aparece:

- confusión de alcance
- bugs repetidos
- PRs demasiado grandes
- demasiadas decisiones sin registrar
- trabajo paralelo real

## Regla Final

Primero tracción y claridad.
Después formalización.
