---
description: Validación central antes de declarar una tarea lista, hacer commit o cerrar una fase
---

# Workflow: Validation

## Regla principal
Nunca declarar victoria sin evidencia. Elegir validaciones proporcionales al cambio.

## Checklist base

1. **Scope**
   - Revisar archivos tocados.
   - Confirmar que no se modificó nada fuera del alcance.
   - Ejecutar `git diff --stat` si hay repo Git.

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

## Regla final
Si no se pudo validar, decirlo claramente y no presentar el trabajo como completo.
