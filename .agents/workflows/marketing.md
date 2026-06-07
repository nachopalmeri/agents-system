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

## Pricing Ladder

### Insight
Ofrecer planes más caros sube la conversión general (efecto ancla), no solo el ARPU. Mantener el plan esencial igual y agregar escalera de planes premium.

### Táctica
1. Mantener el plan esencial/free sin cambios.
2. Agregar planes premium escalonados con más features, módulos o capacidad.
3. Plan IA + módulos premium como upsell natural.
4. El plan más caro hace que los planes intermedios parezcan razonables (efecto ancla).
5. No tener miedo a precios altos: si el producto resuelve un problema real, hay gente dispuesta a pagar.

### Métricas
- Tasa de conversión antes/después de agregar planes premium.
- ARPU (Average Revenue Per User).
- Distribución de usuarios por plan.
- Churn por plan.

### Regla
No subir precios del plan esencial para forzar upgrade. Agregar valor real en los planes premium.

## Distribución de contenido multi-canal

### Insight
Un video → 5 canales con mínimo ajuste. Reutilizar contenido en TODAS las redes multiplica reach sin multiplicar esfuerzo.

### Workflow
1. Crear contenido base (video, carrusel, hilo).
2. Adaptar por canal:
   - TikTok → video vertical 60s, hook fuerte.
   - IG Reels → mismo video, diferente caption/hashtags.
   - Facebook → video + texto descriptivo (audiencia menos tech).
   - X → hilo con key takeaways + link al video.
   - YouTube Shorts → video vertical + título SEO.
3. Programar publicación (Buffer MCP o manual).
4. Medir performance por canal.

### Canales subestimados
- Facebook: alto reach orgánico, audiencia no-tech, buen performance para productos B2C locales.
- YouTube Shorts: descubrimiento orgánico, long tail.

### Métricas
- Usuarios por canal.
- CAC por canal.
- Views orgánicos por canal.
- Conversión por canal (no solo views).

## Outbound para Freelancers / Agencias Chicas

### Insight (Tito @titobarri0nuevo + matiasdev_ar)

Los primeros clientes no llegan por inbound ni por producto perfecto. Llegan por servicios simples + prospección directa. Automatizaciones y software a medida no venden al principio. Auditoría gratis sí.

### Estrategia

1. **Ofertas simples primero.** No software a medida. Servicios que se entregan en días, no meses:
   - Auditoría digital gratis a pymes → puerta de entrada (matiasdev_ar).
   - Animaciones web CSS → servicio rápido y visible (ver skill `css-animations`).
   - Landing pages → demanda constante.
   - Automatizaciones con AI → alto valor percibido.
   - Incluso Excel funcionó como primer servicio (Tito).

2. **Prospección en frío.** No esperar que vengan.
   - LinkedIn directo a decisores.
   - WhatsApp a negocios locales.
   - Email personalizado (no template genérico).
   - Mostrar caso concreto, no promesas.

3. **Hook = auditoría gratis.** Ofrecer diagnóstico sin costo → demostrar valor → upsell a implementación.

4. **De servicio a producto.** Después de 5-10 clientes, detectar patrones repetidos → empaquetar como producto.

### Precios para arrancar

- Auditoría gratis: $0 (inversión en relación).
- Landing simple: USD 200-500.
- Animaciones web: USD 100-300 por sitio.
- Automatización AI: USD 500-2000 por proyecto.
- Consultoría + implementación: USD 1000+.

### Métricas

- Contactos por semana.
- Tasa de respuesta.
- Tasa de conversión (contacto → cliente).
- Ingreso por cliente.
- Tiempo de cierre (primer contacto → pago).

### Regla

No sobre-cotizar para los primeros clientes. Entrar rápido, cobrar algo, entregar bien, pedir referidos.
