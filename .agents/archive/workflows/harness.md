---
description: Meta-workflow de auto-mejora invisible - captura correcciones, detecta patrones y propone mejoras sin interrumpir el flujo
---

# Harness - Auto-Mejora Autónoma del Sistema

## Principio

El sistema no espera a que el usuario diga "guardá esta lección". Cada corrección, error o patrón repetido se captura automáticamente y se evalúa para mejora del sistema. El Harness corre en background durante toda la sesión sin interrumpir el flujo de trabajo.

## Ciclo Continuo (por interacción)

```
WORK   → ejecutar tarea normal
WATCH  → detectar señales de aprendizaje
CAPTURE→ registrar lección automática en tasks/lessons.md
ANALYZE→ evaluar si es patrón nuevo o repetido
IMPROVE→ proponer mejora sistémica si aplica (N>=3)
```

## Señales Automáticas de Aprendizaje

| Señal | Detección | Acción |
|---|---|---|
| Usuario corrige al agente | Cualquier corrección explícita | Capturar lección |
| Usuario repite instrucción | Misma petición dicha 2+ veces | Capturar como regla no aprendida |
| Test falla 2 veces igual | Mismo error en tests | Marcar como problema recurrente |
| Routing falla | Workflow elegido no existe o no aplica | `feedback_loop.md` + capturar |
| Validación detecta problema | `validation.md` encuentra déficit | Capturar lección de calidad |
| Loop genera >500 líneas sin intervención humana | Loop desatendido con output grande | Flag como comprehension debt risk |
| 3+ loops desatendidos consecutivos | Sin sesión de review manual entre loops | Alertar: sesión de review obligatoria |
| Misma pregunta se repite | Usuario pregunta lo mismo 2 veces | Capturar como documentación faltante |
| Director da instrucción que contradice regla | Regla existente vs. pedido actual | Capturar como candidato a cambio de regla |

## Captura Automática

Al detectar una señal, registrar en `.agents/tasks/lessons.md` del proyecto actual:

```markdown
## YYYY-MM-DD HH:mm - [ROUTING|OUTPUT|SCOPE|QUALITY] Título breve

- Señal: cómo se detectó (corrección del director / error repetido / routing / validación)
- Contexto: tarea al momento de la señal
- Corrección/error: lo que pasó textual
- Causa raíz: por qué ocurrió (no el síntoma)
- Lección: regla derivada (Siempre X / Nunca Y)
- Aplicación inmediata: qué cambia desde ahora en esta sesión
- Candidato global: no (requiere 3 apariciones)
```

## Análisis de Patrones (ANALYZE)

Al capturar una lección, el Harness verifica:

1. ¿Este mismo patrón ya apareció antes en `.agents/tasks/lessons.md`?
2. Si sí → incrementar contador de repeticiones
3. Si contador >= 3 → marcar como candidato a promoción global
4. Si contador >= 5 → preparar propuesta de cambio en regla/AGENTS.md

## Promoción (IMPROVE)

Cuando mismo patrón aparece 3+ veces en la sesión o proyecto:

1. Preparar propuesta de promoción a `.agents/memory/lessons-global.md`
2. Mostrar al usuario al final de la tarea o sesión:
   - Patrón detectado N veces
   - Lección local
   - Proyectos donde apareció
   - Regla global propuesta
   - Cambio sugerido en AGENTS.md o workflow (si aplica)
3. Esperar confirmación explícita del usuario
4. Si confirma: ejecutar `promote_lesson.md`

## Reporte de Cierre de Sesión

Al finalizar la sesión (antes de validation.md), el Harness reporta:

```text
Harness report:
- Lecciones capturadas: N
- Patrones repetidos: [lista]
- Candidatos a promoción global: [lista]
- Cambios de regla propuestos: [lista]
- Riesgos detectados: [lista]
```

## Integraciones

| Workflow | Rol en el Harness |
|---|---|
| `feedback_loop.md` | Clasificación de errores (ROUTING/OUTPUT/SCOPE/QUALITY) |
| `promote_lesson.md` | Promoción de lecciones locales → globales con confirmación |
| `obsidian_sync.md` | Archivo durable de decisiones y aprendizajes |
| `validation.md` | Detección de problemas de calidad al cierre |
| `session_checkpoint.md` | Estado entre sesiones para continuidad del Harness |

## Modos de Operación

| Modo | Comportamiento |
|---|---|
| **Normal** (default) | Captura automática, análisis, reporta al cierre |
| **Silent** | Solo captura, no reporta ni pregunta. Usar en sesiones de debugging intensivo |
| **Deep** | Captura + analiza activamente + pregunta por cada N=2. Usar en sesiones de refinamiento del sistema |

El modo se define en la primera señal de la sesión. Si el usuario está debuggeando → Silent. Si está refinando reglas → Deep. Si es trabajo normal → Normal.

## Hard Stops

- Nunca modificar `AGENTS.md`, workflows globales o `.agents/memory/lessons-global.md` sin confirmación explícita
- Nunca interrumpir el flujo de trabajo para capturar una lección - la captura es asíncrona
- Nunca capturar ruido: si no hay evidencia clara, no registrar
- Nunca promover con menos de 3 apariciones del mismo patrón
- Nunca acumular más de 10 lecciones sin reportar al usuario

## Token Awareness

El Harness trackea consumo de tokens durante la sesión:

### Tracking

| Señal | Acción |
|---|---|
| Sesión alcanza ~50K tokens consumidos | Reportar uso al usuario |
| Sesión alcanza ~80% del budget declarado | Alertar y pedir permiso para continuar |
| Loop desatendido sin budget declarado | Frenar y pedir budget |
| 3+ subagentes activos simultáneamente | Reportar costo estimado |

### En el reporte de cierre

Agregar al harness report:

```text
- Tokens estimados consumidos: ~XK
- Budget declarado: YK (si aplica)
- Subagentes usados: N
- Alertas de budget: [lista]
```

### Integración con `/goal`

En el `/goal` primitive, el checker también verifica:
- Si el budget está al 80% → reportar progreso y pedir permiso.
- Si el budget está al 100% → frenar el loop y reportar estado.

### Integración con session_checkpoint

El campo "tokens estimados consumidos" se incluye en cada checkpoint para continuidad entre sesiones.

## Regla final

El Harness no decide por el usuario. Acumula evidencia, detecta patrones y propone. La decisión final siempre es humana.
