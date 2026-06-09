# Setup Guide — Portabilidad Cross-IDE

Guía de instalación y portabilidad del agents-system. Este archivo no se carga en cada sesión.

## Para OpenCode / Codex / Antigravity CLI
Carga `AGENTS.md` automáticamente. No hace falta nada extra.

## Para Claude Code
`CLAUDE.md` importa `AGENTS.md` para evitar duplicación. Opción de symlink:
- Linux/Mac: `ln AGENTS.md CLAUDE.md`
- Windows: `mklink CLAUDE.md AGENTS.md` (requiere Developer Mode)

### CLAUDE.local.md
Overrides personales gitignored. Cada desarrollador pone sus preferencias ahí sin afectar al equipo.

### .claude/ structure
Claude Code soporta `.claude/agents/` y `.claude/skills/` como estructura nativa para subagents y skills con YAML frontmatter (name, description, tools, model, effort, isolation, etc.).
- Para proyectos que usen solo Claude Code: se puede usar `.claude/` directamente.
- Para portabilidad cross-IDE: mantener `.agents/` como fuente de verdad.

## Para Aider
El repo incluye `.aider.conf.yml` con `read: AGENTS.md`.

## Para Antigravity CLI (ex-Gemini CLI)
El repo incluye `.gemini/settings.json` con `{ "context": { "fileName": "AGENTS.md" } }`.
Skills migran de `.gemini/skills/` a `.agents/skills/` (ya compatible).
Gemini CLI se descontinúa Junio 18, 2026 → usar Antigravity CLI.

## Para Devin Desktop (ex-Windsurf)
ACP (Agent Client Protocol) permite correr Codex, Claude Agent, OpenCode en un mismo editor.
AGENTS.md es contexto compartido entre todos los agentes ACP.
Legacy `.windsurf/` paths siguen como fallback.

## Para ChatGPT, Claude web, Gemini, Copilot (chats web)
Copiar y pegar `prompts/activate-global.md` al iniciar la sesión. Modos disponibles:
- "Mode: Project | Goal: [que] | Stack: [tech]"
- "Mode: Study | Subject: [materia] | Level: [nivel]"
- "Mode: Notes | Class: [clase] | Goal: [organizar/flashcards]"
- "Mode: Explain | Topic: [concepto] | For: [audiencia]"
- "Mode: Debug | Stack: [tech] | Symptom: [error]"

## Para Cursor / Devin Desktop
El archivo `.cursorrules` ya contiene una versión concisa del sistema. Para sesiones completas, pegar `prompts/activate-global.md` al inicio.

## Vault de Prompts (Obsidian)
Si hay un prompt relevante para la tarea actual, el agente puede preguntar: "Querés que busque en tu vault?" solo con confirmación explícita. Usar `workflows/obsidian-prompt-search.md` para el flujo.

## Modo profesor / explicación
Usar "Mode: Explain | Topic: [concepto] | For: [audiencia]" para activar `workflows/harvard_teacher.md`.

## AGENTS.override.md (Codex CLI)
Override por directorio con precedencia sobre AGENTS.md. Gitignored para overrides personales.
Discovery chain: global (~/.codex/AGENTS.md) → project root → subdirectorios → override.

## Setup script
Correr `bin/setup-ide-pointers.ps1` para crear symlinks/copias a todos los IDEs.
Verificar con `bin/doctor.ps1`.
