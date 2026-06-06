---
description: Catálogo de MCPs recomendados por nivel de riesgo y caso de uso
---

# MCP Catalog

## Principio

Los MCPs se adoptan por necesidad real, con el menor permiso posible y sin credenciales hardcodeadas.

## Niveles

### Nivel 0 — Docs/read-only

Usar primero. Bajo riesgo.

- `context7`: documentación actualizada por framework/librería.
- `gh_grep`: búsqueda de ejemplos públicos en GitHub.
- `fetch` / Jina Reader: convertir URLs públicas a contenido legible.

### Nivel 1 — Repo/dev read-heavy

Usar para ingeniería diaria con permisos acotados.

- Git MCP: estado, diffs, historial local.
- GitHub MCP: issues, PRs, búsqueda de código.
- Semgrep MCP: análisis estático y seguridad.
- Google Search Console MCP/API: queries, index coverage, sitemaps y URL inspection.
- GA4 MCP/API: tráfico orgánico, landing pages y conversiones.
- PageSpeed/CrUX: Core Web Vitals.

### Nivel 1.5 — SEO research read-only

Usar para `seo_geo_growth.md`, siempre opt-in y con credenciales fuera del repo.

- Ahrefs MCP: keyword research, backlinks y competencia.
- Semrush MCP: keywords, competidores y tendencias.
- DataForSEO MCP: SERP, keywords y datos SEO amplios.
- Google Sheets MCP: backlog editorial y reporting.

### Nivel 2 — Browser QA

Usar para validar UI y runtime.

- Playwright MCP: navegación y E2E por accessibility tree.
- Chrome DevTools MCP: consola, network, performance.

### Nivel 2.5 — Marketing/social content

Usar para creación y distribución de contenido social. Siempre requiere confirmación antes de publicar.

- vibiz MCP: postear en múltiples redes sociales desde el agente.
- Buffer MCP: programación de contenido en TikTok, Instagram, LinkedIn, X.
- EditFrame: edición de video para contenido social.
- Usefastlane: creación de contenido social automatizado.
- Higgsfield: generación de contenido visual/video con AI.

Regla: nunca publicar sin confirmación humana. Modo draft-only hasta validación manual.

### Nivel 3 — Observability

Usar para producción con OAuth y permisos mínimos.

- Sentry MCP: issues y errores.
- Datadog/Last9 si el proyecto lo usa.

### Nivel 4 — Sensitive/write

Siempre requiere confirmación explícita.

- Stripe, bancos, pagos.
- Bases de datos productivas.
- Slack/DMs/redes sociales.
- Ads/Meta/LinkedIn/Google Ads.
- Deploys o acciones productivas.

## Regla final

Read-only primero. Escritura solo con rollback y confirmación explícita.
