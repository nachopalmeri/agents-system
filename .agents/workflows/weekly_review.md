---
description: Routine semanal breve para revisar avance, bloqueos, lecciones, deuda y crecimiento
---

# Workflow: Weekly Review

## Configuracion

- Frecuencia: semanal, preferentemente viernes o cuando el usuario lo pida.
- Duracion objetivo: 15 minutos.
- Modo: read-only + draft.

## Pasos

1. Revisar `tasks/todo.md` de proyectos activos:
   - Que avanzo.
   - Que se trabo.
   - Por que.
2. Revisar `tasks/lessons.md`:
   - Que errores se repitieron esta semana.
   - Si alguno es candidato a leccion global.
3. Revisar `tasks/handoff.md`:
   - Si refleja el estado real.
4. Revisar `tasks/tech-debt.md`:
   - Si alguna deuda se volvio urgente.
5. Proponer actualizacion a `developer_growth.md` si hay evidencia nueva.
6. Generar nota semanal en el vault:
   - Que avance.
   - Que aprendi.
   - Que me trabo y por que.
   - Foco principal de la proxima semana.
7. Si hay candidatos a leccion global, ejecutar `promote_lesson.md`.

## Salida

Resumen de 10 lineas maximo mas nota en vault si aplica.

## Hard stops

- No convertir la weekly review en retro larga.
- No inventar crecimiento sin evidencia.
- No promover lecciones globales sin confirmacion humana.
