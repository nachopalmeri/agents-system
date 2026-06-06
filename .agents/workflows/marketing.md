---
description: Workflow interno para estrategia de marketing, campañas, posicionamiento, lanzamiento, pricing y research de audiencia. Usar solo cuando el pedido claramente lo amerite.
---

# Workflow: Marketing

## Principio
El usuario habla normal. Si el pedido es de marketing, el agente enruta internamente y no pide nombres de workflows.

## Cuándo usar
- Lanzar producto/feature al mercado.
- Cambiar posicionamiento o mensaje.
- Evaluar campaña o canal.
- Ajustar pricing o monetización.
- Research de audiencia, competencia o Category Entry Points.
- Go-To-Market para productos AI/RAG.
- SEO/GEO/AEO growth cuando se conecta con adquisición, contenido, landings o demanda orgánica.

## Cuándo NO usar
- Cambiar CTA de un botón o copy puntual → hacer directo.
- Bug o fix técnico → usar debugging + validation.
- Hotfix de reputación o crisis → workflow específico de crisis (no este).
- Si el equipo ya decidió y busca solo validación → señalar sesgo de confirmación.

## Inputs mínimos
El agente extrae del pedido en lenguaje natural o pregunta brevemente:
1. Producto/servicio y etapa (idea / pre-lanzamiento / early traction / crecimiento / maduro).
2. Competencia o alternativas conocidas.
3. Presupuesto o recursos (si aplica).
4. Objetivo de negocio (awareness, acquisition, revenue, retention).

## Fases

### FASE 1 — Clasificar tipo de pedido
| Tipo de pedido | Enfoque interno | Salida esperada |
|---|---|---|
| Estrategia, posicionamiento, GTM | Subagentes paralelos (mercado + narrativa + crecimiento) | Veredicto GO / NO-GO / PIVOT |
| SEO técnico/on-page | Agente SEO | Auditoría + prioridades |
| SEO/GEO/AEO growth | `agente-growth-seo-geo` + `seo_geo_growth.md` | Keyword map + backlog + quality gates |
| Paid media, ads, Meta, LinkedIn | Marketing workflow + evaluación MCP | Plan + riesgos + datos necesarios |
| Social selling, DMs, leads | Marketing workflow + evaluación MCP | Flujo + handoff humano + seguridad |
| Research de competencia | Subagente exploración | Mapa + gaps + CEP |

### FASE 2 — Ejecutar según tipo

#### Estrategia / GTM / Posicionamiento
Usar subagentes paralelos:
- **Mercado & Cliente:** STP, TAM/SAM/SOM, Category Entry Points, disponibilidad mental/física (Byron Sharp).
- **Posicionamiento & Narrativa:** Purple Cow, elevator test (Jobs), storytelling, apelación emocional vs racional.
- **Crecimiento & Métricas:** North Star Metric, CAC/LTV, PMF signal, funnel, canales (owned/paid/earned), riesgos.

El agente principal sintetiza, detecta tensiones y emite veredicto con playbook en horizontes temporales.

#### SEO/GEO/AEO
Usar `agente-growth-seo-geo` para estrategia orgánica: keywords, landings, artículos, backlinks, local SEO, GEO/AEO, Search Console y medición.
Usar `agente-seo` solo para auditoría técnica/on-page: metadata, headings, sitemap, robots, schema, canonical y alt text.

#### Paid media / Ads / Social
1. Evaluar si se necesita MCP externo (ver `marketing_mcp_eval.md`).
2. Sin MCP: plan y copy con datos que tenga el usuario.
3. Con MCP: modo read-only/draft-only hasta validación manual.
4. Nunca ejecutar gasto automáticamente.

#### Research de competencia
- Sin scraper: usar datos públicos que el usuario proporcione.
- Con scraper: evaluar MCP primero, respetar ToS, no violar robots.txt.

### FASE 3 — Validación
Usar `workflows/validation.md` como cierre central.

Reportar:
- Veredicto (GO / NO-GO / PIVOT).
- Tensiones detectadas.
- Playbook con horizontes temporales (si GO).
- Riesgos pendientes.
- Datos faltantes para ejecutar.

## Regla final
No usar marketing workflow para todo. Elegir el enfoque más simple que mantenga claridad y seguridad.

## Automatización de contenido social

### Pain point real
El cuello de botella no es la distribución, es la creación: armar guion, grabar, editar, adaptar por canal. Los MCPs de marketing ayudan con la distribución, pero el tiempo de creación sigue siendo humano-servido.

### Workflow de contenido social automatizado
1. Guion/idea → agente genera guion para video/carrusel/hilo.
2. Creación → EditFrame/Higgsfield para video, agente para copy.
3. Adaptación por canal → un video → TikTok + IG Reels + Facebook + X + YouTube Shorts con mínimo ajuste.
4. Programación → Buffer MCP o vibiz MCP para programar publicación.
5. Medición → GA4 + eventos de producto por canal.

### MCPs disponibles
Ver `mcp_catalog.md` Nivel 2.5 — Marketing/social content:
- vibiz: postear en múltiples redes.
- Buffer: programación multi-canal.
- EditFrame: edición de video.
- Usefastlane: creación de contenido.
- Higgsfield: generación visual con AI.

### Reglas
- Nunca publicar sin confirmación humana. Modo draft-only.
- Empezar con un canal, validar, luego expandir.
- Medir usuarios por canal y CAC por canal antes de escalar.
- Facebook es canal subestimado: alto reach orgánico con poco esfuerzo.
