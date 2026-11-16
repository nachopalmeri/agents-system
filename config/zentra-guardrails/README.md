# Guardrails de Zentra (instalación en la máquina, 2026-11-14)

Copias de referencia de los hooks instalados en la PC de Nacho. **No las instala** `bin/sync-runtime.ps1` ni `bin/sync-claude-settings.ps1`: esos scripts solo gestionan `.agents/hooks/` (PowerShell del runtime). Estos hooks viven en `~/.claude/hooks/` (Claude Code) y en el plugin de OpenCode.

Nada de este directorio contiene secretos; `secret-rules.json` solo tiene patrones de rutas y nombres de variables.

## Qué hace cada uno

- `hooks/zentra-confirm.py` — PreToolUse de Claude Code: pide confirmación antes de deploy, push a producción o cambios productivos (Tiendanube, Cloudflare, Supabase, git push a main, etc.).
- `hooks/secrets-guard.py` + `hooks/secret-rules.json` — PreToolUse: niega leer `.env*`, keys, credenciales y variables con tokens. Si falta Python, el hook de Windows puede fallar abierto (queda pendiente cerrarlo).
- `hooks/test_hooks.py` — tests locales de los dos hooks anteriores.
- `opencode/zentra-guard.js` — plugin de OpenCode: mismas reglas de secretos, y bloquea usar OpenCode sobre el repo de Zentra hasta que Leo lo apruebe.

También se instalaron en la máquina (no van en este repo, son tooling local):

- comandos `/perf-check` y `/smoke` (Lighthouse 12 + Playwright, 1366×900 y 390×844; nunca más allá del primer pantallazo de checkout);
- skill `zentra-tiendanube-theme`.

## Dónde quedan instalados

- WSL (cuenta de trabajo): `~/.claude/hooks/` y settings de `~/.claude/settings.json`.
- Windows: `C:\Users\Nacho\.claude\hooks\` (secrets-guard) y `C:\Users\Nacho\.config\opencode\plugins\zentra-guard.js` más `C:\Users\Nacho\.config\opencode\zentra-guard\secret-rules.json`.

## Rollback

- WSL: `/home/nacho/.claude/backups/guardrails-20261114/`
- Windows: `C:\Users\Nacho\.claude\settings.json.bak-20261114-guardrails` y `C:\Users\Nacho\.config\opencode\*.bak-20261114-guardrails`

El detalle está en `docs/global-setup-2026.md` (sección Diseño y guardrails).
