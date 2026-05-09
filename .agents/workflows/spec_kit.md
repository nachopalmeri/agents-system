---
description: Workflow opcional para usar GitHub Spec Kit / Spec-Driven Development en proyectos o features medianas-grandes
---

# Workflow: Spec Kit Opcional

## Regla principal
No usar Spec Kit para todo. Primero clasificar la tarea.

## FASE 1 — Clasificar tamaño

### Small
Usar flujo actual si:
- Es un fix claro.
- Toca pocos archivos.
- No cambia arquitectura.
- No requiere alinear producto/técnica/tests.

### Medium / Large
Usar Spec Kit si:
- Hay múltiples requisitos.
- Hay incertidumbre de producto.
- Toca arquitectura o varios módulos.
- Necesita trazabilidad entre requerimientos, plan y tasks.
- Puede beneficiarse de `/speckit.specify`, `/speckit.plan` y `/speckit.tasks`.

## FASE 2 — Constitution
Crear o revisar `.specify/memory/constitution.md`.

Debe incluir:
- Principios de calidad.
- Estándares de testing.
- Reglas de UX/performance.
- Restricciones técnicas.
- Relación con `AGENTS.md`.

## FASE 3 — Specify
Definir el qué y el por qué antes del cómo.

Evitar stack, librerías o implementación prematura salvo que sean restricciones reales.

Salida esperada:
- Problema.
- Usuarios.
- Historias/escenarios.
- Criterios de aceptación.
- No objetivos.

## FASE 4 — Plan
Crear plan técnico con:
- Stack elegido.
- Arquitectura.
- Archivos a tocar.
- Riesgos.
- Validación.
- Qué NO se va a tocar.

## FASE 5 — Tasks
Convertir el plan en tareas:
- Atómicas.
- Verificables.
- Ordenadas por dependencia.
- Separables por agente cuando aplique.

## FASE 6 — Implement
Implementar solo después de tener spec/plan/tasks suficientemente claros.

Durante implementación:
- Respetar `AGENTS.md`.
- Actualizar `tasks/todo.md` si aplica.
- Usar worktrees para tareas paralelas.
- No marcar completado sin validación.

## FASE 7 — Validate
Antes de cerrar:
- Revisar diff.
- Correr tests si existen.
- Validar criterios de aceptación.
- Registrar lecciones si hubo correcciones.

## Integración con AI production
Para apps AI/RAG complejas:
- Usar `ai-production-architecture` para arquitectura.
- Usar `spec-kit` para requisitos, plan y tareas.
- No declarar producción sin evaluación y observabilidad.

## Comandos útiles

```powershell
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
specify check
specify init . --integration copilot
```

No instalar herramientas sin confirmación explícita del director.
