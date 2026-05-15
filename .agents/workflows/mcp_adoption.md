---
description: Proceso para incorporar MCPs al sistema sin romper seguridad ni portabilidad
---

# MCP Adoption

## FASE 1 — Necesidad

Definir:

- Qué problema resuelve.
- Qué alternativa manual existe.
- Qué datos toca.
- Si necesita lectura, escritura o acciones externas.

## FASE 2 — Evaluación

Usar `mcp_security.md` y, si es marketing/ads/DMs, también `marketing_mcp_eval.md`.

## FASE 3 — Modo de adopción

- Docs/read-only: se puede proponer como opt-in.
- Dev local: limitar a paths/repos necesarios.
- Browser QA: usar contra localhost/staging.
- Observability: OAuth y scope mínimo.
- Sensitive/write: confirmación manual por acción.

## FASE 4 — Configuración

- Usar env vars.
- No commitear tokens.
- Preferir disabled-by-default para plantillas.
- Documentar setup y rollback.

## FASE 5 — Validación

- Confirmar que aparece en `/mcp` o equivalente.
- Ejecutar una acción read-only primero.
- Revisar logs/config generada.
- Registrar riesgos pendientes.

## Salida esperada

```text
MCP:
Caso de uso:
Nivel de riesgo:
Permisos:
Modo de auth:
Config propuesta:
Rollback:
Veredicto: GO / NO-GO / PIVOT
```
