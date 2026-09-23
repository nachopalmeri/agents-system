# Setup global y flujo de trabajo (septiembre 2026)

Objetivo: gastar menos tokens en cada sesión sin perder capacidades. Aplica a Claude Code, Codex, Gemini CLI, Antigravity y opencode.

## Qué carga cada cliente al arrancar

| Cliente | Reglas globales | Skills que precarga (sólo metadata) |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` → importa `@~/.agents/AGENTS.md` | `~/.claude/skills` |
| Codex | `~/.codex/AGENTS.md` (copia canónica) | `~/.agents/skills` |
| Gemini CLI | `~/.gemini/GEMINI.md` (copia canónica) | `~/.gemini/skills` + `~/.agents/skills` |
| Antigravity | `~/.gemini/GEMINI.md` | `~/.gemini/antigravity/skills` |
| opencode | `~/.config/opencode/AGENTS.md` (copia canónica) | `~/.config/opencode/skills`, `~/.claude/skills`, `~/.agents/skills` |
| Chat web (claude.ai / ChatGPT) | Instrucciones del proyecto: pegar `.agents/AGENTS.md` | — |

Antes, los archivos globales eran punteros relativos (`.agents/AGENTS.md`). Desde un proyecto cualquiera esa ruta no existe, así que el modelo tenía que buscarla con una tool call o directamente ignoraba las reglas. Ahora el contenido llega completo: son ~4 KB, alrededor de 1k tokens.

## Skills: núcleo y biblioteca

- `.agents/skills/`: 30 skills de uso diario (dev, debugging, review, SEO/GEO, producto, estudio). Su metadata cuesta **~1,8k tokens por sesión**. Antes, con 115 skills, eran ~9,3k.
- `.agents/skills-library/`: 85 skills de nicho (contenido para redes, video, diseño de piezas, SDKs de inference.sh, microskills de UI). No se precargan. El agente las encuentra con `skills-library/INDEX.md`, que lee sólo si ninguna skill del núcleo encaja.
- Para pasar una skill de un lado al otro: `git mv .agents/skills-library/<x> .agents/skills/` y volver a correr la instalación.

Todos los clientes leen skills con el formato `SKILL.md` + frontmatter, así que la misma carpeta sirve para todos.

## Instalar / actualizar en la PC (Windows)

```powershell
cd ~\agents-system
git pull
pwsh .\bin\audit-skill-dirs.ps1          # ver qué skills sueltas hay hoy y cuánto cuestan
pwsh .\bin\sync-runtime.ps1 -WhatIf      # ver qué va a escribir
pwsh .\bin\sync-runtime.ps1 -Force       # escribir (hace backup de todo lo que reemplaza)
pwsh .\bin\sync-runtime.ps1 -Restore <manifest.json>   # volver atrás
```

`-Force` reemplaza `~/.claude/skills` y `~/.gemini/antigravity/skills` por el núcleo; lo que había queda en `~/.agents-system-sync/backups/`. Si ahí tenías skills propias, movelas antes a `.agents/skills` o `.agents/skills-library` del repo.

Las skills sueltas en `~/.gemini/skills`, `~/.config/opencode/skills` y `~/.hermes/skills` (grill-me, tdd, triage, judgment-day, etc.) repiten funciones del núcleo: `tdd` = `test-driven-development`, `diagnosing-bugs` = `systematic-debugging`, `code-review` = `requesting-code-review`. Además, esos clientes las precargan todas. `audit-skill-dirs.ps1` las lista; conviene mover a `skills-library` las que quieras conservar y borrar el resto.

## Flujo de trabajo que ahorra tokens

1. **Una tarea por sesión.** Al terminar, anotá el estado en `tasks/todo.md` y abrí una sesión nueva (`/clear`). Un historial largo se vuelve a pagar en cada turno.
2. **Planificá con el modelo fuerte y ejecutá con el medio.** Si la tarea tiene más de 3 pasos, primero plan mode (Opus 5.5) y después implementación (Sonnet 5). Las tareas chicas van directo.
3. **Subagentes, sólo en dos casos:**
   - búsqueda amplia cuyo resultado entra en un resumen (Explore/Haiku);
   - dos trabajos independientes con archivos separados.

   Cada subagente arranca en frío y relee el contexto, así que para tareas lineales cuesta 3–10× más.
4. **Buscá, no leas.** Usá grep/glob y leé por rangos. Nunca leas enteros `capabilities.json` (67 KB) ni `archive/`.
5. **MCPs apagados por defecto.** Los schemas de cada tool entran en todas las sesiones. Habilitalos en la config del proyecto que los usa.
6. **No edites las reglas globales en medio de una sesión.** Invalida el caché del prompt.
7. **Council o multiagente sólo si lo pedís explícitamente** (`workflows/multiagent_review_loop.md`).

## Qué herramienta usar para qué

| Tarea | Herramienta |
|---|---|
| Implementar, refactor, PRs, debugging | Claude Code |
| Tareas repetitivas o triviales sin costo | opencode + Ollama local |
| Verificación visual y en browser de UI | Antigravity |
| Tareas largas en background, en la nube | Codex / Claude Code web |
| Ideas, borradores, preguntas sin repo | Chat web con `AGENTS.md` en las instrucciones del proyecto |

## Pendiente

- Los tests `bin/test-runtime-*.ps1` y `check-runtime-graph.ps1` esperan un `capabilities.json` con esquema `capabilities[]` (kind/mode/triggers), pero `generate-capabilities.ps1` genera `{agents, skills}`. Fallan desde antes de este cambio y conviene alinearlos o podarlos.
