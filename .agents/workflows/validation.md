---
description: Validación central antes de declarar una tarea lista, hacer commit o cerrar una fase
---

# Workflow: Validation

## Regla principal
Nunca declarar victoria sin evidencia. Elegir validaciones proporcionales al cambio.

Validar no significa "me parece correcto". Significa contrastar el resultado contra un criterio observable: tests, build, lint, diff, criterios de aceptacion, captura/manual check, logs, health check, fuente externa o una limitacion explicitamente informada.

## Checklist base

1. **Scope**
   - Revisar archivos tocados.
   - Confirmar que no se modificó nada fuera del alcance.
   - Ejecutar `git diff --stat` si hay repo Git.
   - Si hubo cambios no relacionados preexistentes, mencionarlos sin revertirlos.

2. **Tests y build**
   - Correr tests si existen.
   - Correr lint/build si existen y el cambio puede afectarlos.
   - Si no hay tests, decir qué validación alternativa se hizo.

3. **UI/web**
   - Revisar responsive si aplica.
   - Revisar consola del navegador si aplica.
   - Revisar enlaces, navegación, formularios y estados vacíos si aplica.

4. **Spec Kit**
   - Si existe `.specify/`, validar contra criterios de aceptación.
   - No marcar tasks como completadas si no hay evidencia.

5. **AI/RAG**
   - Si existe `evaluation/`, correr o justificar evaluación offline.
   - Revisar trazas/costos si se tocó pipeline AI.
   - No declarar production-ready sin golden dataset o justificación explícita.

6. **Tareas y lecciones**
   - Actualizar `tasks/todo.md` si existe.
   - Actualizar `tasks/lessons.md` si hubo corrección o aprendizaje reusable.

## Reporte final mínimo

```text
Validación:
- Qué se verificó:
- Comandos ejecutados:
- Resultado:
- Riesgos pendientes:
```

## Feedback del sistema

- Si el usuario corrigio el enfoque, routing o calidad del output, usar `feedback_loop.md`.
- Si una regla fue demasiado vaga para validar, convertirla en criterio concreto o marcarla como riesgo.

## Niveles de evidencia

| Cambio | Evidencia minima |
|---|---|
| Docs/prompts/workflows | Diff revisado + referencias internas + `bin/test-system.ps1` si aplica |
| Codigo | Tests relevantes o reproduccion manual + build/lint si aplica |
| UI | Revision visual/responsive + consola sin errores si aplica |
| AI/RAG | Dataset/evals o limitacion explicita; no declarar production-ready sin evidencia |
| Decision estrategica | Supuestos, trade-offs, criterio de decision y siguiente paso falsable |

## Regla final
Si no se pudo validar, decirlo claramente y no presentar el trabajo como completo.
