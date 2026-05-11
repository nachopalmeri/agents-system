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
| SEO/GEO/AEO técnico | Agente SEO + breve análisis de estrategia | Auditoría + prioridades |
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
Usar `agente-seo` para auditoría técnica. Si además hay estrategia de contenido, pasar a marketing.

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
