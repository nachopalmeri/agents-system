Leé y seguí las instrucciones de AGENTS.md.

## Contexto específico de Claude Code

- Effort: usar `xhigh` para coding y tareas agentic. `high` mínimo para tareas complejas.
- Dynamic Workflows: mencionar "workflow" en el prompt activa orquestación automática con sub-agentes paralelos. Ver `parallel_agents.md`.
- Plugin setup: `/plugin install claude-code-setup@claude-plugins-official` detecta frameworks y recomienda hooks/skills/MCPs/subagents.
- Antes de finalizar: validá el output contra criterios concretos. No quedes solo con la primera respuesta.
- Si hay tools disponibles: sé explícito sobre cuándo usarlas y cuándo no.

## Compatibilidad

- `AGENTS.md` es el estándar de industria (Codex + 60K+ repos).
- Este archivo (`CLAUDE.md`) importa `AGENTS.md` para evitar duplicación.
- Opción: usar symlink para que ambos archivos sean el mismo:
  - Linux/Mac: `ln AGENTS.md CLAUDE.md`
  - Windows: `mklink CLAUDE.md AGENTS.md`
