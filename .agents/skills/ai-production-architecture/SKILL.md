---
name: ai-production-architecture
description: Diseñar y revisar aplicaciones AI/RAG production-ready con capas separadas para servicios, agentes, prompts, seguridad, evaluación y observabilidad. Usar cuando el proyecto involucre RAG, LLM apps, agentes, semantic cache, routing, prompt registry, evaluación o monitoreo de calidad/costos.
---

# AI Production Architecture

## Cuándo usar esta skill
- Apps AI/RAG que van más allá de una demo.
- Sistemas con retrieval, router, query rewriting, memory o semantic cache.
- Apps con agentes que toman decisiones o se autocorrigen.
- Proyectos que necesitan evaluación, trazabilidad, seguridad o control de costos.

## Cuándo NO usarla
- Landing pages, portfolios, sitios estáticos o CRUDs simples.
- Prototipos de una tarde donde la prioridad es aprender rápido.
- Features AI pequeñas dentro de una app no-AI, salvo que escalen a producto.

## Regla de diseño
La demo puede ser un archivo. Producción necesita capas explícitas.

## Capas recomendadas

### `services/`
Lógica de negocio AI:
- `rag_pipeline.py` — orquestación retrieval → rerank → answer
- `semantic_cache.py` — cache por similitud semántica
- `conversation.py` — memoria y estado conversacional
- `query_rewriter.py` — normalización y expansión de queries
- `query_router.py` — decide fuente/modelo/flujo

### `agents/`
Capa de inteligencia y autocorrección:
- `document_grader.py` — evalúa relevancia de documentos
- `query_decomposer.py` — divide consultas complejas
- `adaptive_router.py` — selecciona estrategia según contexto
- `tools/` — herramientas pluggeables (vector, web, code search)

### `prompts/`
Prompts versionados y registrados:
- `templates.py` — plantillas tipadas
- `registry.py` — registry central para no hardcodear prompts

### `security/`
Guardrails en tres niveles:
- `input_guard.py` — valida input del usuario
- `content_filter.py` — filtra contenido recuperado/generado
- `output_filter.py` — valida salida final

### `evaluation/`
Calidad medible:
- `golden_dataset.json` — dataset de referencia
- `offline_eval.py` — evaluación reproducible
- `online_monitor.py` — monitoreo en producción
- `eval_results/` — historial de resultados

### `observability/`
Trazabilidad y costos:
- `tracer.py` — trazas por etapa
- `feedback.py` — feedback unido a traces
- `cost_tracker.py` — costo por query/modelo/etapa

### `data/`
Datos separados por estado:
- `raw/`
- `processed/`
- `index_config/`

## Checklist production-ready
- [ ] RAG pipeline separado de API layer
- [ ] Prompts versionados, no hardcodeados
- [ ] Input/content/output guards
- [ ] Golden dataset mínimo
- [ ] Offline eval ejecutable
- [ ] Online monitor o feedback capture
- [ ] Tracing por etapa
- [ ] Cost tracking por request
- [ ] Tests de retrieval, cache y routing
- [ ] Docs de arquitectura, API y deploy

## Versión reducida para MVP
Si el proyecto está en MVP, usar mínimo:
- `services/rag_pipeline.py`
- `prompts/registry.py`
- `security/input_guard.py`
- `evaluation/golden_dataset.json`
- `observability/tracer.py`
- `tests/test_retrieval.py`

Agregar capas restantes cuando haya usuarios reales o costo operativo relevante.
