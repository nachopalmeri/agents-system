---
description: Workflow para adquisición orgánica por SEO, GEO, AEO, programmatic SEO seguro, local SEO, backlinks y medición
---

# SEO/GEO/AEO Growth

## Principio

El objetivo no es publicar más contenido. El objetivo es capturar demanda orgánica de alta intención con páginas útiles, diferenciadas y medibles.

Programmatic SEO solo sirve si es programático en producción, no programático en mediocridad: cada página debe tener valor único, diseño cuidado, intención clara, medición y criterio de poda.

## Cuándo usar

- Estrategia SEO para SaaS, servicios o negocios locales.
- SEO programático o landings por rubro, problema, ciudad o industria.
- Aparecer en ChatGPT, Perplexity, Gemini o Google AI Overviews.
- Keyword research con Ahrefs, Semrush o DataForSEO.
- Backlinks, citations, DR/autoridad o Google Business Profile.
- Backlogs SEO 30/60/90 días.

## Cuándo NO usar

- Solo cambiar meta tags, headings, sitemap, robots, schema o canonical → usar `agente-seo`.
- Solo escribir copy puntual → hacer directo o usar `agente-docs`.
- Ads o gasto pago → usar `marketing.md` + evaluación MCP.
- Scraping o automatización externa → pasar por `mcp_security.md`.

## Core loop

1. Buscar keywords con intención comercial.
2. Evaluar competencia, dificultad, SERP y valor.
3. Crear landings/artículos/tools que respondan demanda real.
4. Sumar backlinks/citations para autoridad.
5. Indexar y medir con Search Console/GA4.
6. Medir comportamiento real con eventos de producto si existe producto activo.
7. Iterar mensualmente: mejorar, reformar, noindexar o borrar según señales.

## Fase 0 — Brief mínimo

Extraer del pedido o preguntar brevemente:

1. Producto/servicio y país/ciudad objetivo.
2. Cliente ideal y momento de compra.
3. Conversión buscada: registro, WhatsApp, llamada, demo, compra.
4. Recursos disponibles: web, blog, GSC, GA4, Ahrefs/Semrush, capacidad mensual.

Si el usuario responde “como vos digas”, asumir el preset más útil y declarar supuestos.

## Fase 1 — Diagnóstico orgánico

Revisar:

- Sitio actual y arquitectura pública.
- Indexabilidad: robots, sitemap, canonical, status codes.
- Páginas existentes con tráfico o potencial.
- Competidores SERP.
- Presencia o ausencia en AI search.
- Gaps de contenido y autoridad.

## Fase 2 — Keyword/opportunity map

Mapear oportunidades por:

- Problema.
- Solución.
- Rubro/industria.
- Geografía.
- Alternativas/comparativas.
- Jobs-to-be-done.
- FAQs.
- Glosario.
- Tools/calculadoras.

Cada oportunidad debe incluir:

- intención,
- competencia/dificultad estimada,
- valor comercial,
- tipo de página,
- CTA,
- prioridad,
- datos únicos requeridos.

## Fase 3 — Priorización

Ordenar por:

- intención comercial,
- facilidad de rankear,
- cercanía a conversión,
- autoridad requerida,
- esfuerzo de producción,
- capacidad real de diferenciarse.

Preferir 5-10 páginas buenas por mes antes que 100 páginas thin.

## Fase 4 — Quality gate anti-spam

Antes de recomendar publicar o indexar:

- ¿La keyword tiene intención real?
- ¿La página ayuda a un usuario concreto?
- ¿Tiene valor único, datos, ejemplos, experiencia o prueba propia?
- ¿Está diferenciada de páginas hermanas?
- ¿No es doorway page?
- ¿No es solo keyword swap?
- ¿Tiene CTA coherente?
- ¿Sería útil aunque no rankee?
- ¿El front está cuidado y no huele a output low effort?
- ¿Existe criterio de medición y poda?

Hard stop si la estrategia depende de generar páginas masivas sin datos únicos.

## Fase 4.5 — Programmatic SEO de calidad

Si se propone SEO programático, exigir:

- Plantilla con diseño cuidado, contenido útil y jerarquía clara.
- Datos únicos por página: ejemplos, comparativas, métricas, screenshots, casos, pricing, ubicación, industria o insights propios.
- Módulos que aumenten valor: FAQs reales, tablas, calculadoras, benchmarks, snippets, recursos descargables o workflows.
- Evitar páginas que solo cambian ciudad, industria o keyword.
- Sistema de poda: reformar, fusionar, noindexar o borrar páginas sin interés.
- Revisión mensual de páginas publicadas contra GSC, GA4 y eventos de producto si existen.
- No monetizar antes de tiempo si reduce confianza, UX, backlinks o velocidad de aprendizaje.

## Fase 5 — Producción de briefs

Para cada página priorizada, entregar:

- URL slug.
- Search intent.
- Title/meta description.
- H1/H2/H3.
- FAQ natural.
- Internal links.
- Schema recomendado.
- CTA.
- Assets/datos necesarios.
- Criterio index/noindex.

## Fase 6 — Technical SEO handoff

Si hay implementación técnica:

- Coordinar con `agente-seo`.
- Validar sitemap, robots, canonicals, metadata, structured data y Core Web Vitals.
- Usar `validation.md` antes de declarar listo.

## Fase 7 — GEO/AEO

Recomendar según corresponda:

- `llms.txt`.
- Página `about`/entity clara.
- Structured data.
- FAQs conversacionales.
- Respuestas concisas en secciones clave.
- Citas/fuentes.
- Prompt set para testear visibilidad en ChatGPT, Perplexity y Gemini.

## Fase 8 — Backlinks/citations

Recomendar autoridad sin spam:

- Google Business Profile.
- Directorios relevantes.
- PR local o vertical.
- Partnerships.
- Guest posts reales.
- Casos de clientes.
- Comunidades con aporte auténtico.
- Citations NAP para local SEO.
- Proyectos propios relacionados que puedan enlazar naturalmente.
- Assets linkables: tools, datasets, comparativas, reportes, rankings o estudios propios.
- Evitar granjas de enlaces, intercambios masivos y backlinks irrelevantes.

## Fase 9 — Product analytics y medición mensual

Si hay producto o app:

- Definir eventos críticos: visita, signup, activación, búsqueda, click CTA, uso repetido, pago, abandono.
- Conectar datos de demanda con comportamiento: qué busca la gente, qué página visita, qué hace dentro del producto.
- Usar PostHog, Mixpanel, GA4 o base propia de eventos si ya existen.
- MCPs de analytics, base de datos o DataForSEO deben empezar read-only y pasar por `mcp_security.md` si hay credenciales o datos reales.

La idea operativa:

```text
Demanda buscada
→ página visitada
→ evento de producto
→ mejora priorizada
→ página/producto podado o escalado
```

Reportar:

- URLs publicadas.
- URLs indexadas.
- GSC clicks/impressions/CTR/position.
- GA4 conversiones si existe.
- Eventos de producto si existen.
- Top queries.
- Páginas que suben/bajan.
- Páginas a reformar, fusionar, noindexar o borrar.
- Prompts AI donde aparece/no aparece.
- Backlog del mes siguiente.
- Decisión: escalar, mantener, reescribir, noindexar o podar.

## Output final

```text
Resumen ejecutivo:
Preset usado:
Supuestos:
Keyword/opportunity map:
Top 10 oportunidades:
Backlog 30/60/90 días:
Landings recomendadas:
Artículos recomendados:
Tools/calculadoras recomendadas:
Backlinks/citations:
GEO/AEO actions:
Technical SEO handoff:
MCPs opcionales:
Quality gates:
Páginas a podar/reformar:
Eventos de producto:
Métricas de éxito:
Próxima acción:
```

## Regla final

Orgánico no es gratis: se paga con criterio, paciencia y calidad. Nunca escalar contenido que no merezca existir.
