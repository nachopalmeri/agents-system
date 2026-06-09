---
description: Dreaming automático — loop de curación de memoria entre sesiones que detecta patrones, propone promociones y poda lecciones stale
---

# Dreaming — Memory Curation Loop

## Principio

El agente olvida entre sesiones. La memoria en disco no. Dreaming es el proceso que cura esa memoria: detecta patrones repetidos, propone promociones a reglas globales, poda lecciones stale y genera un reporte que el humano aprueba.

Es el equivalente manual del dreaming automático de Claude Managed Agents. Cuando Managed Agents esté disponible, este workflow complementa el dreaming nativo.

## Cuándo correrlo

- Cada 5 sesiones de trabajo.
- Al final de una semana laboral (viernes noche o domingo).
- Después de una sesión donde se capturaron 3+ lecciones.
- Cuando `memory/lessons-global.md` creció más de 50 líneas sin poda.
- Manualmente: "Activá dreaming.md".

## Ciclo

```text
READ    → leer toda la memoria (lessons-global, developer_growth, tasks/lessons)
PATTERN → detectar patrones repetidos (N≥3 apariciones del mismo tipo)
PROMOTE → proponer promociones a reglas/workflows
PRUNE   → identificar lecciones stale (sin mención en 30+ días)
REPORT  → generar dream report para aprobación humana
WRITE   → ejecutar cambios aprobados
```

## FASE 1 — READ

Leer en orden:

1. `memory/lessons-global.md` — lecciones ya promovidas.
2. `memory/developer_growth.md` — crecimiento y preferencias.
3. `tasks/lessons.md` (de cada proyecto activo) — lecciones de sesión.
4. `tasks/todo.md` (de cada proyecto activo) — estado de tareas.
5. Git log reciente (últimos 20 commits) — qué se hizo.

## FASE 2 — PATTERN

Para cada lección en `tasks/lessons.md`, verificar:

1. ¿Apareció el mismo patrón en otros proyectos? (buscar en otros `tasks/lessons.md`)
2. ¿Ya existe en `memory/lessons-global.md`?
3. Contar apariciones. Si N≥3 → candidato a promoción.

Categorías de patrones:

| Categoría | Señal | Promoción a |
|---|---|---|
| ROUTING | Misma confusión de workflow 3+ veces | Nueva entrada en `index.md` o regla en AGENTS.md |
| OUTPUT | Mismo tipo de error de calidad 3+ veces | Regla en `rules/` o skill específico |
| SCOPE | Mismo tipo de scope creep 3+ veces | Regla en Judgment Boundaries NEVER |
| QUALITY | Mismo déficit de validación 3+ veces | Check en `validation.md` |
| TECH | Mismo gotcha técnico 3+ veces | Entrada en GOTCHAS |
| PREFERENCE | Misma preferencia del usuario 3+ veces | Regla en `rules/identity.md` |

## FASE 3 — PROMOTE

Para cada candidato a promoción (N≥3):

```markdown
### Promoción propuesta: [título]

- Apariciones: N (proyectos: [lista])
- Lección local: [resumen]
- Regla global propuesta: "Siempre X" o "Nunca Y"
- Destino: [AGENTS.md / rules/ / validation.md / index.md]
- Evidencia: [resumen de los 3+ incidentes]
```

Reglas de promoción:
- Solo proponer, nunca ejecutar sin aprobación humana.
- Si la regla ya la enforcea una tool (Toolchain First), no proponerla para AGENTS.md.
- Si es específica de un proyecto, proponer para `AGENTS.override.md` de ese proyecto.

## FASE 4 — PRUNE

Identificar lecciones stale en `memory/lessons-global.md`:

1. Lecciones sin mención en ningún `tasks/lessons.md` en los últimos 30 días.
2. Lecciones que contradicen reglas más nuevas.
3. Lecciones sobre herramientas/versiones deprecadas.

Para cada stale:

```markdown
### Poda propuesta: [título]

- Última mención: [fecha]
- Razón: [sin uso / contradicción / deprecada]
- Acción: [eliminar / archivar en docs/archive/ / marcar como stale]
```

Regla: nunca eliminar sin aprobación. Archivar es más seguro que eliminar.

## FASE 5 — REPORT

Generar dream report:

```markdown
# Dream Report — [fecha]

## Patrones detectados: N
- [lista de patrones con apariciones]

## Promociones propuestas: N
- [lista de promociones con destino]

## Podas propuestas: N
- [lista de podas con razón]

## Métricas de memoria
- lessons-global.md: X líneas
- Lecciones activas (últimos 30 días): Y
- Lecciones stale: Z
- Proyectos con lessons: W

## Próximo dreaming sugerido: [fecha]
```

El reporte se guarda en `memory/dream-reports/[fecha].md` y se presenta al humano.

## FASE 6 — WRITE

Solo después de aprobación humana:

1. Ejecutar promociones aprobadas (agregar reglas, actualizar archivos).
2. Ejecutar podas aprobadas (archivar o eliminar).
3. Commit con mensaje "dreaming: [promociones/podas ejecutadas]".
4. Actualizar métricas en `memory/dream-reports/[fecha].md`.

## Integración con Claude Managed Agents

Cuando Claude Managed Agents esté disponible:

- **Dreaming nativo**: corre automáticamente entre sesiones, revisa patrones, cura memoria.
- **Este workflow**: complementa con análisis más profundo (cross-proyecto, poda, métricas).
- **Coexistencia**: dreaming nativo para memoria automática, este workflow para curación periódica profunda.
- El dreaming nativo puede requerir aprobación o ser automático (configurable).

## Integración con el Harness

El Harness captura lecciones durante la sesión. Dreaming las cura entre sesiones. Juntos forman el loop completo:

```text
Sesión:  Harness captura → tasks/lessons.md
Entre sesiones: Dreaming cura → lessons-global.md + rules + GOTCHAS
Próxima sesión: agente lee memoria curada → mejor routing y output
```

## Hard Stops

- Nunca ejecutar promociones o podas sin aprobación humana explícita.
- Nunca modificar AGENTS.md directamente (regla global: solo humanos escriben AGENTS.md).
- Nunca podar lecciones de seguridad o GOTCHAS sin revisión extra.
- Nunca correr dreaming más de una vez por día (evitar ruido).
- Si hay menos de 3 lecciones nuevas, no correr dreaming completo — solo actualizar métricas.
