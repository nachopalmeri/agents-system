---
description: Flujo de trabajo para clientes reales con brief, propuesta, iteraciones, entrega y aprendizaje
---

# Workflow: Client Workflow

## Principio

El trabajo para cliente no se maneja como side project tecnico. Tiene brief, expectativas externas, entregas versionadas, feedback y control de scope.

## Flujo

```text
brief recibido
-> revisar .agents/skills/client-work/pricing.md
-> generar propuesta en propuesta/v1.md
-> cliente aprueba o pide cambios
-> cambios en propuesta/v2.md, v3.md, etc. Nunca sobreescribir
-> trabajo en entregas/iteracion-N/
-> feedback del cliente en feedback/iteracion-N.md
-> implementar feedback si esta en scope
-> si queda fuera de scope: registrar adicional en propuesta/
-> entrega final
-> retro en vault con lecciones para el proximo cliente
-> growth update si aplica
```

## Reglas

- No cambiar scope sin dejar rastro en `propuesta/`.
- Todo feedback del cliente entra primero en `feedback/`.
- No sobreescribir propuestas previas.
- Si el cliente pide algo fuera de scope, registrar como adicional antes de implementarlo.
- Al cierre, generar retro con lecciones reutilizables.

## Artefactos minimos

- `brief/brief-template.md`
- `propuesta/v1.md`, `v2.md`, etc.
- `entregas/iteracion-1/`
- `feedback/iteracion-1.md`
- `tasks/todo.md`, `lessons.md`, `handoff.md`, `decisions.md`, `tech-debt.md`
