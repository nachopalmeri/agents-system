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

## SaaS MVP

Usar para:
- Validar un SaaS pequeño.
- Definir MVP patineta, landing, canal inicial y métricas.
- Conectar Product Foundry con ejecución técnica.

Comando típico:

```powershell
nuevo-proyecto mi-saas saas-mvp
```

Workflow interno:

```text
venture_loop.md + product_foundry.md + web_briefing.md
```

## Local Business

Usar para:
- Negocios locales que necesitan oferta, web, SEO local y clientes de mejor calidad.
- Casos como pastelería, ferretería, clínica, estudio o servicio local.

Comando típico:

```powershell
nuevo-proyecto dulces-creaciones local-business
```

Workflow interno:

```text
venture_loop.md + seo_geo_growth.md + marketing.md
```

## SEO/GEO Growth

Usar para:
- Proyectos centrados en adquisición orgánica.
- Keyword maps, landings, backlinks, GSC/GA4 y AI search.

Comando típico:

```powershell
nuevo-proyecto seo-site seo-growth
```

Workflow interno:

```text
seo_geo_growth.md + validation.md
```

## Product Foundry

Usar para:
- Pensar ideas de producto.
- Rankear oportunidades.
- Definir MVPs de 1-2 semanas.
- Decidir kill / keep / scale.

Comando típico:

```powershell
nuevo-proyecto ideas-ai product-foundry
```

Workflow interno:

```text
product_foundry.md + venture_loop.md
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
