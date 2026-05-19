---
description: Architecture Decision Records para proyectos medianos y grandes
---

# Workflow: Architecture Decision Record (ADR)

## Cuándo se activa

Este workflow se dispara automáticamente cuando:

1. `irreversible_decision.md` se activa, Y
2. El proyecto tiene más de 2 semanas de duración estimada.

Si el proyecto es chico (< 2 semanas), alcanza con el registro en `tasks/decisions.md`.

## Dónde viven los ADRs

Los ADRs se guardan en `docs/adr/` dentro del proyecto, numerados secuencialmente:

```
docs/adr/
  ADR-001-eleccion-orm.md
  ADR-002-arquitectura-auth.md
  ADR-003-modelo-pricing.md
```

## Formato estándar

Cada ADR sigue esta estructura:

```markdown
# ADR-[número]: [título descriptivo]

**Fecha:** YYYY-MM-DD
**Estado:** Propuesta | Aceptada | Deprecada | Reemplazada por ADR-X

## Contexto

Qué problema resuelve esta decisión, por qué importa ahora, qué restricciones aplican.

## Opciones evaluadas

### Opción A: [nombre]
- **Pros:** ...
- **Contras:** ...

### Opción B: [nombre]
- **Pros:** ...
- **Contras:** ...

## Decisión

Cuál se eligió y por qué. Ser específico sobre el criterio de desempate.

## Consecuencias

- Qué se hace más fácil.
- Qué se hace más difícil.
- Qué hay que monitorear.
- Qué skills o herramientas requiere el equipo.

## Revisión

Cuándo tiene sentido revisar esta decisión (fecha, hito o condición).
```

## Reglas

- Los ADRs se numeran secuencialmente: ADR-001, ADR-002, etc.
- **Nunca se borran.** Si una decisión cambia, el ADR viejo se marca como `Deprecada` o `Reemplazada por ADR-X`.
- Al cierre del proyecto, los ADRs se sincronizan al vault vía `obsidian_sync.md`.
- Un ADR no reemplaza el registro en `tasks/decisions.md` — lo complementa con más contexto.

## Flujo

1. `irreversible_decision.md` se activa.
2. Si el proyecto dura más de 2 semanas → crear ADR.
3. Escribir el ADR siguiendo el formato estándar.
4. Numerar secuencialmente (buscar el último ADR existente).
5. Guardar en `docs/adr/ADR-XXX-titulo.md`.
6. Referenciar el ADR desde `tasks/decisions.md`.
7. Continuar con el flujo normal de `irreversible_decision.md`.

## Hard stops

- No crear ADR para decisiones triviales o reversibles en minutos.
- No saltear el ADR si el proyecto es grande y la decisión es arquitectónica.
- No borrar ADRs viejos — marcar como deprecados.
