---
description: Tipos de proyecto y cuándo usar cada modo de scaffolding o workflow interno
---

# Project Types

## Simple

Usar para:
- Cambios chicos.
- Landings simples.
- Scripts o proyectos sin arquitectura compleja.

Comando típico:

```powershell
nuevo-proyecto mi-landing astro
```

## Web Premium

Usar para:
- Presentaciones web.
- Pitch decks web.
- Demos visuales memorables.
- Landings con estética frontend senior.

Workflow interno:

```text
web_briefing.md + web-presentation-premium
```

## AI Production

Usar para:
- Apps AI/RAG con usuarios reales.
- Necesidad de evaluación, observabilidad, seguridad y costos.
- Pipelines con prompts, retrieval, agentes o LLM calls críticas.

Comando típico:

```powershell
nuevo-proyecto jobbot-ai ai-prod
```

## Spec Kit

Usar para:
- Features medianas/grandes.
- Producto incierto.
- Requisitos que necesitan spec, plan y tasks.

Comando típico:

```powershell
nuevo-proyecto app-compleja spec-kit
```

## AI Production + Spec Kit

Usar para:
- AI/RAG serio y además producto/alcance complejo.
- JobBot u otros sistemas donde haga falta arquitectura y trazabilidad.

Regla:
- `ai-production-architecture` define capas.
- `spec-kit` define requisitos, plan y tasks.

## Regla final
No sobredimensionar. Elegir el modo más simple que reduzca riesgo real.
