---
name: openship-architect
description: Handles zero-config deployment and infrastructure provisioning via OpenShip MCP. Use when deploying apps to a VPS.
---

# OpenShip Architect Rules

## 1. Context Initialization
Before deploying, always verify the target OpenShip host and ensure the OpenShip MCP server is connected. Use the MCP `list_projects` tool to check for naming collisions.

## 2. Zero-Config First
Rely on OpenShip's native stack detection (Node, Python, Go, Rust, etc.). Do not generate `docker-compose.yml` or CI/CD YAML files unless explicitly required to override the default build process. OpenShip auto-provisions SSL, Domains, and CDN.

## 3. Infrastructure Provisioning
If the app requires a database (e.g., Postgres, Redis), use OpenShip's MCP provisioning tools to attach the service *before* triggering the application build. Store the injected environment variables in your context.

## 4. Environment Variables
Inject `.env` keys through the OpenShip MCP/API rather than writing them to the VPS filesystem directly.

## 5. Deployment Verification
After issuing a deployment command via MCP, poll the build logs. You must verify the final health check and return the active HTTPS deployment URL to the user.

## 6. Fallback to API
If the MCP context window is exceeded during large log reads, fallback to OpenShip's REST API or execute OpenShip CLI commands via SSH (`openship logs`).
