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

### Nivel 1.7 — Self-updating app MCP

Patrón para apps que quieren que los agentes se desarrollen contra sus propias APIs.

Lo primero que le haces a tu app es un MCP con dos tools: `search` y `use_tool` (igual que Cloudflare).
Conectas ese MCP a tu agente (Claude/Codex/OpenCode).
El agente se actualiza sus propias APIs, que luego usa para conectar clientes.

Flujo:
1. App expone MCP con `search` (buscar recursos) y `use_tool` (ejecutar acciones).
2. Agente se conecta al MCP y entiende la API automáticamente.
3. Agente desarrolla contra la API, actualiza endpoints y los usa para integrar clientes.
4. Loop: agente → API → clientes → feedback → agente actualiza API.

Beneficios:
- El agente se ocupa del boilerplate de integración.
- La API se auto-documenta a través del MCP.
- Cambios en la API se propagan automáticamente al agente.

Reglas:
- MCP de la app propia = Nivel 1.7 (read + write controlado dentro de la app).
- Si el MCP toca datos de clientes o producción → subir a Nivel 4.
- Siempre pasar por `mcp_security.md` antes de deployar.

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

### Nivel 3 — Observability / Cloud infra

Usar para producción con OAuth y permisos mínimos.

- Sentry MCP: issues y errores.
- Datadog/Last9 si el proyecto lo usa.
- AWS MCP: gestión de infraestructura AWS (S3, Lambda, RDS, CloudFront, ECS, etc.).
  - Modo read-only para auditoría y diagnóstico.
  - Modo write solo con confirmación explícita y rollback plan.
  - Aplicar `mcp_security.md` antes de conectar credenciales AWS.

### Nivel 4 — Sensitive/write

Siempre requiere confirmación explícita.

- Stripe, bancos, pagos.
- Bases de datos productivas.
- Slack/DMs/redes sociales.
- Ads/Meta/LinkedIn/Google Ads.
- Deploys o acciones productivas.

## Regla final

Read-only primero. Escritura solo con rollback y confirmación explícita.
