# Multi-IDE Setup

Reemplazado por `docs/global-setup-2026.md`, que tiene la tabla de qué recibe cada cliente y los comandos de `bin/sync-runtime.ps1`.

Las rutas que proponía este documento (`~/CLAUDE.md`, `~/GEMINI.md` y symlinks de `~/.agents` al repo) ya no se usan. Claude Code lee `~/.claude/CLAUDE.md` y Gemini/Antigravity leen `~/.gemini/GEMINI.md`, y el sync copia los archivos en vez de linkearlos.
