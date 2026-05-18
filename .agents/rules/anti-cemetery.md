---
description: Reglas anti-cementerio y anti-sludge para evitar acumular información sin valor
---

# Anti-Cementerio / Anti-Sludge

## Principio

El objetivo de un sistema (vault, repo, biblioteca de prompts, backlog) no es guardar más información. Es producir **conexiones, contradicciones, acciones y outputs** que muevan el trabajo.

Si una nota, prompt, agente o workflow no genera acción concreta, no entra al sistema.

## Reglas

1. **No guardar por acumulación.** Cada artefacto debe tener: contexto, caso de uso, resultado esperado, criterio de mejora.
2. **Si no se usa en 30-60 días, revisarlo.** Mejorar, fusionar, archivar o borrar.
3. **No crear taxonomías nuevas si no resuelven un problema concreto.** Antes de crear una categoría nueva, verificar si una existente ya sirve.
4. **No duplicar.** Si un workflow/prompt/regla ya existe, reusar o extender. No paralelizar fuentes de verdad.
5. **No prompts genéricos.** Cada prompt debe tener input/output esperado y métrica de efectividad.
6. **Anti-teatro multiagente.** No usar pipelines de 7 fases para fixes chicos. Si la crítica no puede cambiar la solución, usar flujo simple.
7. **Validación obligatoria.** Nunca declarar listo sin evidencia (ver `workflows/validation.md`).

## Señales de cementerio

- Carpetas con archivos creados hace meses, sin uso ni referencia.
- Workflows que nadie ejecuta y nadie referencia.
- Prompts duplicados con nombres distintos.
- Notas marcadas `processed: true` que nadie procesó realmente.
- Tags que solo existen en una nota.
- Documentación de sistema que contradice al sistema.

## Acciones de poda

| Hallazgo | Acción |
|---|---|
| Archivo sin uso ≥60 días | Mover a `Archives/` o eliminar |
| Workflow no referenciado | Eliminar o mergear con otro |
| Prompt sin caso de uso | Eliminar |
| Duplicación | Mantener solo la fuente canónica, redirigir resto |
| Doc desactualizada | Actualizar o marcar histórica |

## Frecuencia de auditoría

- **Mensual:** revisión rápida de inbox, drafts, notas sin tags.
- **Trimestral:** auditoría completa con `multiagent_review_loop.md` o `llm-council.md`.
