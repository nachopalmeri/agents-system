---
description: ⚠️ DEPRECATED — reemplazado por AGENTS.md secciones 1 (Plan Mode), 4 (Verificación), 5 (Elegancia), 6 (Corrección autónoma) y chat-first.md. Política integrada en el flujo chat-first.
---

# ⚠️ DEPRECATED: Política Global de Trabajo

Este workflow está integrado en `AGENTS.md` secciones 1, 4, 5 y 6. Para niveles de intensidad, usar `chat-first.md` (liviano) y `index.md` (routing por tamaño).

Contenido original archivado en `docs/archive/work_policy-v1.md`.

- Si la tarea es chica, clara y de bajo riesgo: ejecutar directo.
- No crear planes largos, specs ni checklists para cambios obvios.
- Explicar el trabajo en pocas líneas: objetivo, acción, verificación.
- Mantener el contexto activo enfocado solo en lo necesario para resolver la tarea actual.

## 2. Cuándo Planificar

Planificar antes de implementar solo si ocurre al menos una de estas condiciones:

- La tarea tiene varias etapas dependientes.
- Hay ambigüedad real en el alcance.
- Involucra decisiones de arquitectura.
- Puede romper flujos importantes.
- Requiere coordinación entre varios archivos o sistemas.

Si no se cumple ninguna, no fuerces un plan formal.

## 3. Planificación Proporcional

- Tarea simple: una mini-lista mental o 2-4 pasos breves.
- Tarea mediana: plan corto en el mensaje o en `tasks/todo.md` si aporta claridad.
- Tarea grande: plan escrito con hitos verificables.
- No escribir documentación intermedia si no ayuda a decidir o verificar.

## 4. Uso de Subagentes

Usar subagentes solo cuando reduzcan trabajo real o limpien contexto. No por reflejo.

Buenos casos:

- Investigación paralela sobre áreas independientes.
- Code review de diffs grandes.
- Análisis de un problema acotado mientras el agente principal implementa otra parte.

Evitar subagentes cuando:

- La tarea es corta.
- El siguiente paso depende inmediatamente de esa respuesta.
- La coordinación costaría más tokens que hacer el trabajo directo.

## 5. Verificación Antes de Cerrar

- Nunca dar por terminado un cambio sin alguna forma de verificación.
- Elegir la verificación más barata que demuestre confianza suficiente:
  - lectura del diff
  - test puntual
  - build/lint del módulo tocado
  - reproducción manual breve
- Reservar verificaciones pesadas para cambios pesados.

## 6. Lecciones y Memoria

- Actualizar `tasks/lessons.md` solo cuando haya un aprendizaje no obvio y reusable.
- No registrar lecciones triviales ni ruido de sesión.
- Usar formato corto:
  - problema
  - patrón aprendido
  - regla reusable

## 7. Elegancia sin Sobreingeniería

- Buscar la solución más simple que resuelva bien el problema.
- Preguntar “¿hay una forma más elegante?” solo en cambios no triviales.
- Evitar abstraer antes de tiempo.
- Preferir mínimo impacto sobre reescrituras innecesarias.

## 8. Manejo de Bugs

- Ante un bug conocido: investigar, reproducir, corregir y verificar.
- Pedir más contexto solo si realmente bloquea.
- Priorizar causa raíz antes que parche temporal.

---

## Niveles de Intensidad

### Nivel 1 — Liviano
Usar para:

- typos
- cambios de copy
- ajustes chicos
- bugs localizados

Flujo:

`entender -> cambiar -> verificar -> resumir`

### Nivel 2 — Estándar
Usar para:

- features medianas
- refactors acotados
- bugs con varias causas posibles

Flujo:

`explorar -> mini plan -> cambiar -> verificar -> resumir`

### Nivel 3 — Profundo
Usar para:

- cambios de arquitectura
- tareas de varias sesiones
- PRs grandes
- decisiones con alto riesgo

Flujo:

`explorar -> plan formal -> ejecutar por etapas -> verificar fuerte -> documentar`

---

## Checklist Mínimo

1. Entender el objetivo real.
2. Elegir el nivel de intensidad correcto.
3. Hacer el cambio con el menor impacto posible.
4. Verificar con evidencia suficiente.
5. Documentar solo si deja valor futuro.

---

## Regla Final

Si una regla del workflow agrega más fricción que claridad para la tarea actual, bajar la intensidad del proceso.
El workflow debe ahorrar contexto, no consumirlo.
