---
name: cli-essentials
description: CLIs esenciales para agentes de IA — Playwright, GitHub CLI, cloudflared, Context7, cloud provider CLIs. Usar cuando un agente necesite probar navegadores, hacer PRs, exponer localhost, buscar docs o desplegar.
---

# CLI Essentials for AI Agents

## Playwright CLI

Probar navegadores desde la terminal. La IA abre páginas, hace clic, captura screenshots, ve errores de consola.

```bash
npx playwright test
npx playwright open https://example.com
npx playwright codegen
```

Uso: QA visual, E2E, debugging de UI.
Ver skill `webapp-testing` para integración con agentes.

## GitHub CLI

PRs, issues, y review sin tocar la web.

```bash
gh pr create --fill
gh pr review --approve
gh issue list
gh run watch
```

Uso: flujo de PR/issue desde el agente.

## cloudflared

Tunel para exponer localhost público.

```bash
cloudflared tunnel --url http://localhost:3000
```

Uso: compartir preview, webhooks, demos desde localhost.
Alternativa: `handoff.host`.

## Context7

Docs actualizadas para LLMs. Busca documentación de librerías/frameworks actualizada.

```bash
npx context7 search "next.js middleware"
```

Uso: el agente busca documentación actual sin alucinar.
Ver MCP catalog Nivel 0.

## Cloud Provider CLIs

```bash
# Railway
railway login
railway up

# Vercel
vercel deploy --prod

# AWS
aws s3 ls
aws lambda invoke ...

# Google Cloud
gcloud run deploy
```

Uso: deploy y gestión de infra desde el agente.

## Conexiones

- `webapp-testing` skill — Playwright integrado con agentes.
- `mcp_catalog.md` — Context7 (Nivel 0), Playwright MCP (Nivel 2).
- `web-factory.md` — deploy via Vercel CLI.
