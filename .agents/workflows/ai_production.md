---
description: Workflow para convertir una app AI/RAG en arquitectura production-ready sin sobredimensionar proyectos simples
---

# Workflow: AI Production Architecture

## FASE 1 — Clasificar el proyecto
Definir si el proyecto es:
- **Demo:** aprendizaje o prueba rápida
- **MVP:** producto inicial con flujo usable
- **Producción:** usuarios reales, costos, monitoreo y calidad medible

No aplicar arquitectura completa si el proyecto es demo.
Si además hay incertidumbre de producto o feature compleja, combinar con `spec_kit.md`.

## FASE 2 — Definir capas necesarias
Evaluar si hacen falta:
- `services/` para pipeline, cache, memory, rewriting, routing
- `agents/` para grading, decomposition, adaptive routing
- `prompts/` para templates versionados y registry
- `security/` para input/content/output guards
- `evaluation/` para golden dataset y evals
- `observability/` para traces, feedback y costos

Regla: agregar solo capas con responsabilidad clara.

## FASE 3 — Scaffold mínimo viable
Crear primero la estructura mínima que permita correr la app:
1. API/app entrypoint
2. Servicio principal (`rag_pipeline.py` o equivalente)
3. Prompt registry mínimo
4. Guard de input mínimo
5. Golden dataset inicial
6. Tracer básico

## FASE 4 — Evaluación antes de optimizar
Antes de optimizar prompts/modelos:
- Crear golden dataset
- Correr evaluación offline
- Guardar resultados
- Comparar cambios contra baseline

## FASE 5 — Observabilidad antes de deploy
Antes de producción:
- Trazas por etapa
- Feedback del usuario ligado a trace id
- Cost tracking por request/modelo/etapa
- Logs suficientes para debugging

## FASE 6 — Seguridad y calidad
Validar:
- Input guard
- Content filter
- Output filter
- Tests de retrieval/cache/routing
- README + docs de arquitectura/deploy

## FASE 7 — Reporte final
Antes de reportar, usar `workflows/validation.md` como cierre central.

Reportar:
- Capas creadas
- Capas omitidas por YAGNI
- Cómo correr tests/evals
- Riesgos pendientes
- Próximos pasos
