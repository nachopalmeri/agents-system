# Changelog

## 2026-09-23
- Skills en dos niveles: 30 en `.agents/skills` (precargadas) y 85 en `.agents/skills-library` (on-demand vía `INDEX.md`). Metadata precargada: ~9,3k → ~1,8k tokens por sesión.
- Globales con contenido real: `~/.claude/CLAUDE.md` importa `@~/.agents/AGENTS.md`; Codex, Gemini/Antigravity y opencode reciben la copia canónica. Skills del núcleo sincronizadas a `~/.claude/skills` y `~/.gemini/antigravity/skills`.
- `bin/audit-skill-dirs.ps1`, `docs/global-setup-2026.md`, routing de modelos actualizado.

## Unreleased

- Preparar publicación privada del sistema de agentes.
- Agregar capa de seguridad para secretos, MCPs y plugins.
- Agregar documentación de instalación en laptop.
- Agregar workflows para MCP, OpenCode ecosystem, hooks y agentes paralelos.
