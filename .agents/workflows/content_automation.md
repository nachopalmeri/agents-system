---
description: Pipeline autónomo de contenido con 4 agentes (Scout→Writer→Poster→CMO). Producción escalable de contenido orgánico y pago para X, TikTok, LinkedIn y más.
---

# Content Automation Pipeline

## Principio

El contenido no se escribe a mano. Se observa, se produce, se distribuye y se mide en un loop autónomo. Inspirado en producción real de @maxirodr_ (4 agentes Claude en producción: Scout, Writer, Poster, CMO) y pipelines de contenido automatizado (@morfeoacademy).

## Cuándo usar

- El usuario quiere producir contenido a escala (3-5 posts/día) sin escribir manualmente.
- Tiene una marca personal, SaaS o negocio local que necesita presencia constante en redes.
- Ya hay una estrategia de contenido definida (usar `x_content_system.md` primero si no).
- El usuario dice "quiero automatizar mi contenido", "no puedo postear todos los días", "quiero un sistema de contenido que funcione solo".

## Cuándo NO usar

- El usuario no tiene claro su voz, nicho o audiencia. Primero hacer estrategia (`x_content_system.md`).
- Bug técnico → debugging + validation.
- SEO puntual → `agente-seo` o `seo_geo_growth.md`.
- Una sola pieza de contenido → usar `x_content_system.md` directamente.
- No hay presupuesto para APIs de terceros (MCPs de TikTok/Google Ads).

## Los 4 Agentes

### Scout

**Rol:** Observa el mercado y detecta oportunidades de contenido.

**Qué hace:**
- Monitorea trends de X, TikTok, Google Trends, Reddit.
- Analiza contenido de la competencia que funciona.
- Detecta preguntas recurrentes de usuarios/clientes.
- Identifica hooks virales y ángulos no explotados.
- Sugiere briefs de contenido priorizados.

**Produce:** `briefs/YYYY-MM-DD-scout-report.md`

**Frecuencia:** Diaria. Corre automático.

**Output:**
```markdown
## Scout Report — YYYY-MM-DD

### Trends detectados
- [Trend 1] — fuente, volumen, ángulo posible
- [Trend 2] — fuente, volumen, ángulo posible

### Competencia
- [Competidor] publicó [tema] → [engagement estimado]
- Gap detectado: [qué no están cubriendo]

### Preguntas de usuarios
- [Pregunta] → posible post/respuesta

### Briefs recomendados (priorizados)
1. [Título del post] — hook, ángulo, plataforma sugerida
2. [Título del post] — hook, ángulo, plataforma sugerida
3. [Título del post] — hook, ángulo, plataforma sugerida
```

### Writer

**Rol:** Toma un brief del Scout y produce la pieza de contenido.

**Qué hace:**
- Escribe el borrador en la voz del usuario.
- Adapta al formato de cada plataforma (X longpost, TikTok script, LinkedIn article, Substack).
- Genera variantes (versión directa + versión segura).
- Incluye hooks, estructura y CTAs.

**Input:** Brief del Scout.

**Output:** `content/drafts/YYYY-MM-DD-[topic]-[platform].md`

**Reglas:**
- Una idea por pieza. Sin relleno.
- Hook en primeros 280 caracteres (X) o primer segundo (TikTok).
- Voz auténtica: si suena a template de IA, reescribir.
- CTA claro al final.
- Siempre generar 2 variantes.

### Poster

**Rol:** Toma el contenido del Writer, lo adapta a cada plataforma y lo programa/publica.

**Qué hace:**
- Adapta formato: X longpost, TikTok script con timing, LinkedIn post, Substack.
- Genera assets visuales si aplica (imagen, video corto).
- Programa en Buffer/Hootsuite/Postiz si hay MCP conectado.
- Publica en modo DRAFT siempre (nunca directo sin revisión).

**Input:** Draft del Writer.

**Output:** `content/scheduled/YYYY-MM-DD-[topic]-[platform]-ready.md`

**Canales vía MCP (optativo):**
- TikTok: TikTok Ads MCP (Nivel 2.5, drafts only) + Symphony Agent para video.
- X: vía API de X (Nivel 2.5, drafts only).
- LinkedIn: Buffer MCP (Nivel 2.5) o LinkedIn API.
- Substack: RSS/API.

**Reglas duras:**
- NUNCA publicar directo. Siempre DRAFT.
- NUNCA gastar dinero en ads sin confirmación explícita.
- NUNCA responder DMs automáticamente.

### CMO

**Rol:** Mide resultados, optimiza estrategia y decide kill/scale.

**Qué hace:**
- Analiza engagement por pieza y plataforma.
- Detecta qué hooks, temas y formatos funcionan.
- Propone ajustes de estrategia.
- Decide qué briefs descartar y cuáles escalar.
- Genera reporte semanal.

**Input:** Reportes de publicación + métricas de cada plataforma.

**Output:** `reports/weekly/YYYY-MM-DD-cmo-report.md`

**Métricas que trackea:**
| Plataforma | Métrica primaria | Métrica secundaria |
|---|---|---|
| X | Dwell time estimado + replies | Likes, shares, profile clicks |
| TikTok | Completion rate + shares | Comments, saves, follower growth |
| LinkedIn | Engagement rate + DMs | Profile views, connection requests |
| Substack | Open rate + reply rate | New subscribers, referrals |

**Decisiones:**
- **SCALE:** un tema/hook funciona 3+ veces → producir más de eso.
- **KILL:** un tema no funciona en 5 intentos → dejar de producirlo.
- **PIVOT:** ajustar ángulo, formato o plataforma antes de kill.

## Pipeline Completo

```text
SCOUT (diario)
  → briefs/scout-report.md
  → WRITER selecciona top brief
    → content/drafts/[topic]-[platform].md
    → POSTER adapta + programa
      → content/scheduled/[topic]-ready.md
      → DRAFT en cada plataforma
      → CMO revisa semanalmente
        → reports/weekly/cmo-report.md
        → feedback al SCOUT
```

## Integración con MCPs

| MCP | Nivel | Uso en pipeline |
|---|---|---|
| TikTok Ads MCP | 2.5 | Publicar drafts en TikTok, analizar rendimiento |
| Google Ads MCP | 2.5 | Amplificación de contenido que funciona |
| Buffer MCP | 2.5 | Programación multiplataforma |
| vibiz MCP | 2.5 | Posteo cross-platform |
| EditFrame / Higgsfield | 2.5 | Generación de video/visual para acompañar posts |
| Google Trends (API) | 0 | Input para Scout |
| GA4 MCP | 1 | Analizar tráfico desde contenido social |

## Conexiones

- `x_content_system.md` — estrategia de contenido manual. Correr antes de activar el pipeline si no hay voz/niche definido.
- `seo_geo_growth.md` — amplificación orgánica del contenido producido.
- `marketing.md` — GTM y pricing. Usar cuando el pipeline genera leads.
- `product_foundry.md` — si el contenido revela oportunidades de producto.
- `mcp_catalog.md` — evaluar qué MCPs conectar.
- `mcp_security.md` — revisar seguridad de cada MCP antes de conectar.
- `validation.md` — antes de declarar pipeline listo.

## Hard stops

- Nunca publicar contenido sin revisión humana. Siempre DRAFT.
- Nunca gastar dinero en ads sin confirmación explícita y presupuesto definido.
- Nunca responder DMs automáticamente.
- Nunca conectar MCPs de TikTok/Google Ads sin pasar por `mcp_security.md`.
- Nunca generar contenido de nichos que el usuario no conoce (riesgo reputacional).
- Nunca operar el pipeline sin un CMO (agente o humano) revisando métricas semanalmente.

## Regla final

El contenido automatizado no reemplaza la voz del usuario. La amplifica. Si el pipeline produce contenido que no suena a la persona, está mal configurado.
