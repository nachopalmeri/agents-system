# Changelog

## 2026-09-24 (b) — propuestas 2, 7 y 12
- **Fusiones:** 11 grupos, 32 skills retiradas con `mergedInto`, contenido original en `references/`. `code-review` reemplaza a `requesting-code-review`; nuevas en library: `grilling`, `exercise-generator`, `ui-refine`.
- **Agentes:** 19 → 5 roles (`explorador`, `planner`, `implementador`, `reviewer`, `verificador`), definidos una vez y generados para Claude, opencode y Gemini (`render-agents.ps1`, `model-tiers.json`). El conocimiento de los viejos pasó a skills; los archivos originales, a `archive/agents/`.
- **Comandos:** `/planear`, `/revisar`, `/cerrar` para Claude, opencode, Codex y Gemini (`render-commands.ps1`).
- **Hooks de Claude** (merge en `settings.json`, `-Check`, `-Remove`): `session-todo`, `guard`, `lint-edited`, `log-usage`, `stop-unpushed`. Guardia también como plugin de opencode, con las mismas reglas.
- **Skills externas** (video Tesseract/Remotion, documentos, arte, Vercel) por manifiesto e instalador, sin copiarlas al repo. Nueva `web-3d`.
- **Sync:** ya no pisa `opencode.jsonc`; `-Restore` también revierte `~/.claude/settings.json`; `update-system` verifica después del sync.
- **Poda:** 17 scripts `test-runtime-*` / `invoke-runtime-*` rotos y sin uso.

## 2026-09-24
- `sync-runtime.ps1`: modo merge (conserva lo que no está en el repo y lo lista como `[keep]`), `preserveIfExists` para memoria/tareas, `-Check` de drift, `-Restore` que deja el home idéntico (borra carpetas creadas), rutas portables y aviso claro si `~/.agents` es un symlink viejo.
- `check-runtime-graph.ps1` reescrito para el ledger actual; en verde y en CI junto con `generate-skill-index.ps1 -Check`.
- Descripciones del núcleo ≤60 tokens; regla explícita de `skills-library/INDEX.md`; reglas de delegación en `AGENTS.md`.
- `inventory-agents.ps1`, `generate-skill-index.ps1`, `config/global/chat-web.md`, `docs/audit-2026-09.md`; `mcp.example.json` con servers existentes.

## 2026-09-23
- Skills en dos niveles: 30 en `.agents/skills` (precargadas) y 85 en `.agents/skills-library` (on-demand vía `INDEX.md`). Metadata precargada: ~9,3k → ~1,8k tokens por sesión.
- Globales con contenido real: `~/.claude/CLAUDE.md` importa `@~/.agents/AGENTS.md`; Codex, Gemini/Antigravity y opencode reciben la copia canónica. Skills del núcleo sincronizadas a `~/.claude/skills` y `~/.gemini/antigravity/skills`.
- `bin/audit-skill-dirs.ps1`, `docs/global-setup-2026.md`, routing de modelos actualizado.

## Unreleased

- Preparar publicación privada del sistema de agentes.
- Agregar capa de seguridad para secretos, MCPs y plugins.
- Agregar documentación de instalación en laptop.
- Agregar workflows para MCP, OpenCode ecosystem, hooks y agentes paralelos.
