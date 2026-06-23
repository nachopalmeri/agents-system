---
description: Outcomes con grader — define rubric antes de empezar, evalúa output con subagente separado (maker≠checker), trackea scores
---

# Outcomes — Quality Gate Automático

## Principio

El modelo que escribió el código es demasiado generoso calificando su propio trabajo. Outcomes define una rubric de éxito antes de empezar y un grader separado evalúa el output al finalizar. El maker no es el checker.

Equivalente manual de Claude Managed Agents outcomes. Cuando Managed Agents esté disponible, el grader nativo complementa este workflow.

## Cuándo usarlo

- Tareas con `/goal` primitive (el grader es el checker del goal).
- Loops desatendidos (no estás ahí para verificar).
- Features complejas donde "done" es ambiguo.
- Tareas con consecuencias graves si el output es incorrecto.
- Cuando el usuario pide "que quede perfecto" o "staff engineer quality".

## Cuándo NO usarlo

- Cambios chicos y obvios.
- Tareas donde el humano verifica en persona.
- Debugging simple con fix claro.

## Ciclo

```text
DEFINE  → escribir rubric de éxito antes de empezar
WORK    → ejecutar la tarea normalmente
GRADE   → subagente separado evalúa contra la rubric
SCORE   → calcular score + identificar gaps
FIX     → si score < threshold, iterar con feedback del grader
DONE    → si score ≥ threshold, declarar listo con evidencia
```

## FASE 1 — DEFINE (antes de empezar)

Antes de escribir código, definir la rubric:

```markdown
## Outcome Rubric: [título]

### Criterios obligatorios (deben ser todos true)
- [ ] [criterio 1 verificable]
- [ ] [criterio 2 verificable]
- [ ] [criterio 3 verificable]

### Criterios de calidad (score 0-10)
- Correctness: [qué significa correcto para esta tarea]
- Completeness: [qué significa completo]
- Elegance: [qué significa elegante]
- Performance: [qué significa performante si aplica]

### Invariantes (no se pueden romper)
- [invariante 1: ej. test count no disminuyó]
- [invariante 2: ej. no se agregaron deps sin autorización]
- [invariante 3: ej. lint sigue limpio]

### Threshold
- Mínimo para declarar listo: [score, ej. 8/10]
- Score perfecto: 10/10
```

Regla: la rubric se escribe ANTES de empezar. No se modifica después (si se descubre algo nuevo, agregar como amendment marcado).

## FASE 2 — WORK

Ejecutar la tarea normalmente, siguiendo el workflow correspondiente. El maker trabaja sin conocer los detalles de cómo será evaluado (solo conoce los criterios obligatorios).

## FASE 3 — GRADE

Un subagente separado evalúa el output:

### Configuración del grader

| Herramienta | Grader config |
|---|---|
| Claude Code | Subagente con `model: opus` o `reasoning_effort: high`, instrucciones de grading |
| Codex | `.codex/agents/grader.toml` con modelo fuerte en high effort |
| Manual | Pedir a otro modelo (Gemini, GPT) que evalue en chat separado |

### Instrucciones del grader

```markdown
Eres un grader estricto. Evalúa el siguiente output contra esta rubric.

Rubric:
[rubric completa]

Output a evaluar:
[resumen del código/cambios generados]

Evidencia disponible:
[tests results, lint output, screenshots, etc.]

Para cada criterio:
1. ¿Se cumple? (true/false con evidencia)
2. Si no, ¿qué falta específicamente?

Score final: X/10
Gaps: [lista]
Recomendaciones: [lista]
```

### Anti-fake checks

El grader también verifica:
- No se eliminaron tests para hacer pasar la suite.
- No se silenciaron warnings de lint.
- No se hardcodearon valores que deberían ser configurables.
- No se agregaron TODO/FIXME como solución.
- Los invariantes se mantienen.

## FASE 4 — SCORE

```markdown
## Outcome Score: [título]

### Criterios obligatorios
- [criterio 1]: ✅/❌ [evidencia]
- [criterio 2]: ✅/❌ [evidencia]
- [criterio 3]: ✅/❌ [evidencia]

### Score de calidad: X/10
- Correctness: X/10
- Completeness: X/10
- Elegance: X/10
- Performance: X/10 (N/A si no aplica)

### Invariantes: ✅ todos / ❌ [cuál falló]

### Gaps: [lista]
### Recomendaciones: [lista]

### Veredicto: PASS (≥threshold) / FAIL (<threshold)
```

## FASE 5 — FIX (si score < threshold)

1. Tomar los gaps del grader como input.
2. El maker trabaja en los gaps específicos (no reescribir todo).
3. Re-grading solo de los gaps (no re-evaluar lo que ya pasó).
4. Máximo 3 iteraciones de fix. Si después de 3 no pasa, escalar al humano.

## FASE 6 — DONE

Si score ≥ threshold y todos los criterios obligatorios son true:

1. Guardar score en `.agents/memory/outcome-scores.md` para tracking.
2. Declarar listo con evidencia (score + gaps resueltos).
3. Si score < 10, listar mejoras opcionales como "nice to have".

## Tracking de scores

En `.agents/memory/outcome-scores.md`:

```markdown
# Outcome Scores

| Fecha | Tarea | Score | Gaps | Iteraciones | Tipo |
|---|---|---|---|---|---|
| 2026-06-09 | Landing CTA | 9/10 | Ninguno | 1 | web |
| 2026-06-09 | Auth refactor | 7/10 → 9/10 | Missing edge case | 2 | backend |
```

Usar para detectar degradación: si el promedio de scores baja 2+ puntos en una semana, investigar causa.

## Integración con /goal

El grader es el checker del `/goal` primitive:

```text
/goal "condición verificable"
→ maker trabaja un turno
→ grader evalúa contra rubric + condition
→ si cumple: done (score + evidencia)
→ si no cumple: maker continúa con gaps del grader
→ repeat
```

Diferencia vs `/goal` solo: `/goal` verifica una condición. Outcomes verifica calidad contra rubric. Se pueden combinar: la condición es el criterio obligatorio, la rubric es la calidad.

## Integración con Dreaming

Los outcome scores se alimentan al dreaming loop:

- Scores bajos repetidos por tipo de tarea → candidato a regla o skill.
- Gaps frecuentes → candidato a check en validation.md.
- Degradación de scores → alerta en dream report.

## Hard Stops

- Nunca el maker es el grader (maker≠checker siempre).
- Nunca modificar la rubric después del grading (solo amendments marcados).
- Nunca declarar listo si algún criterio obligatorio es false.
- Nunca más de 3 iteraciones de fix sin escalar al humano.
- Nunca ignorar invariantes rotos (un invariante roto = fail automático).
