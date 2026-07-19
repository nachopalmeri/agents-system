# Vercel Eve Compatibility

El sistema de agentes de Pisculichi Labs (`.agents/`) implementa el patrón **filesystem-first** compatible con Vercel Eve y el estándar `skills.sh`.

## Arquitectura

| Eve Framework | Pisculichi Labs System |
|---------------|-------------------------|
| `agent/agent.ts` | Model routing / Config IDE (`.aider.conf.yml`, `.gemini`, `opencode.json`) |
| `agent/instructions.md` | `AGENTS.md` + `rules/` (Identity & Guardrails) |
| `agent/skills/` | `.agents/skills/` (On-demand Markdown playbooks) |
| `agent/tools/` | MCPs / Custom tools via IDE |
| `agent/channels/` | Handoffs, Telegram integrations, Webhooks |
| `agent/schedules/` | Cron jobs / Background tasks |

## Design Systems 2.0 (v0)

Nuestros skills de diseño (e.g. `design-system`) soportan el estándar v0:
- `SKILL.md`: Instrucciones operativas (reglas de tokens, do's/don'ts).
- `v0.json`: Registro de componentes (mapeo de props, paths y dependencias).
- `assets/starter/`: Plantillas listas para producción (scaffolds).
- `references/`: Documentación pesada con progressive disclosure.

Esta estructura permite que cualquier UI generada siga fielmente nuestro Design System.
