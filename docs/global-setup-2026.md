# Setup global y flujo de trabajo (septiembre 2026)

Objetivo: el sistema más completo posible sin gastar tokens de más. Lo que se usa todos los días se precarga. Lo de nicho (video, 3D, documentos, marketing…) queda a un paso, en `skills-library/`, sin costo hasta que se usa.

## Instalar en Windows (usuario `ignac`)

Requisitos: Git y PowerShell 7 (`winget install Microsoft.PowerShell`).

```powershell
# 1. Traer el repo (primera vez) o actualizarlo
gh repo clone nachopalmeri/agents-system C:\Users\ignac\agents-system   # o: git clone https://github.com/nachopalmeri/agents-system
cd C:\Users\ignac\agents-system
git pull

# 2. Ver qué hay hoy en tu PC (sólo lectura)
pwsh .\bin\inventory-agents.ps1          # agentes/subagentes en .claude, .config/opencode, .codex, .gemini, .hermes
pwsh .\bin\audit-skill-dirs.ps1          # skills sueltas y cuánto cuestan por sesión

# 3. Simular y aplicar
pwsh .\bin\sync-runtime.ps1 -WhatIf      # qué escribiría y qué conserva
pwsh .\bin\sync-runtime.ps1 -Force       # aplica: reemplaza sólo lo que gestiona el repo, con backup
pwsh .\bin\sync-runtime.ps1 -Check       # verifica que todo quedó igual al repo

# 4. Skills externas (video, documentos, arte, Vercel) desde su fuente oficial
pwsh .\bin\install-external-skills.ps1 -List
pwsh .\bin\install-external-skills.ps1                                        # las que no tienen términos propios
pwsh .\bin\install-external-skills.ps1 -AcceptTerms tesseract,anthropic-docs  # sólo después de leer los términos

# Volver atrás
pwsh .\bin\sync-runtime.ps1 -Restore C:\Users\ignac\.agents-system-sync\backups\<id>\manifest.json
```

Si `~/.agents` es un symlink o junction de una instalación vieja, el sync se detiene y te da el comando para borrar sólo el link (`cmd /c rmdir "C:\Users\ignac\.agents"`, que no toca el repo).

### Qué hace el sync (modo merge)

- Escribe sólo lo que existe en el repo, skill por skill y archivo por archivo. Lo tuyo que no está en el repo se conserva y aparece como `[keep]`.
- Sin `-Force` no reemplaza nada que ya exista con otro contenido. Con `-Force` reemplaza sólo eso, con backup.
- Copias viejas del repo (skills que pasaron a la library o se fusionaron, los 19 agentes anteriores) aparecen como `[stale]`: con `-Force` se quitan, con backup. Así Codex, Gemini y opencode dejan de precargar las 115 skills viejas de `~/.agents/skills`.
- Nunca pisa `~/.agents/memory`, `~/.agents/tasks` ni `~/.agents/projects-index.md`.
- En `~/.claude/settings.json` sólo agrega o actualiza sus hooks (los identifica por `/.agents/hooks/`). El resto de tu configuración no se toca. Para quitarlos: `pwsh .\bin\sync-claude-settings.ps1 -Remove`.
- No toca tu `opencode.jsonc`. `config/opencode/opencode.jsonc` es sólo una plantilla opcional.
- `-Restore` devuelve el home al estado exacto previo, incluido `settings.json`. Está probado con hash de cada archivo.
- Para el día a día: `pwsh .\bin\update-system.ps1` hace `git pull`, sync, `check-runtime-graph` y `-Check`.

## Qué recibe cada herramienta

✅ instalado · ⚠️ parcial · ❌ no aplica o falta

| | Claude Code | opencode | Codex | Gemini CLI | Antigravity | Chat web |
|---|---|---|---|---|---|---|
| Reglas | ✅ `~/.claude/CLAUDE.md` → `@~/.agents/AGENTS.md` | ✅ `~/.config/opencode/AGENTS.md` | ✅ `~/.codex/AGENTS.md` | ✅ `~/.gemini/GEMINI.md` | ✅ `~/.gemini/GEMINI.md` | ⚠️ pegar `config/global/chat-web.md` (~230 tokens) |
| Skills núcleo (30) | ✅ `~/.claude/skills` | ⚠️ `~/.agents/skills` + `~/.claude/skills` (duplicadas) | ✅ `~/.agents/skills` | ✅ `~/.agents/skills` | ✅ `~/.gemini/antigravity/skills` | ❌ |
| Skills library (68 + 15 externas) | ✅ vía `INDEX.md` | ✅ | ✅ | ✅ | ✅ | ❌ |
| Agentes (5) | ✅ `~/.claude/agents` | ✅ `~/.config/opencode/agent` | ⚠️ roles vía `AGENTS.md` | ⚠️ `~/.gemini/agents` (verificar soporte) | ⚠️ roles vía `AGENTS.md` | ❌ |
| Comandos (3) | ✅ `~/.claude/commands` | ✅ `~/.config/opencode/command` | ⚠️ `~/.codex/prompts` (verificar soporte) | ✅ `~/.gemini/commands` | ❌ | ❌ |
| Hooks | ✅ 5 hooks en `settings.json` | ⚠️ sólo guardia (plugin) | ❌ | ❌ | ❌ | ❌ |
| MCPs | ❌ a propósito | ⚠️ plantilla, apagados | ❌ a propósito | ❌ a propósito | ❌ a propósito | ❌ |

Qué falta y cómo lo cubre cada herramienta:

- **Codex y Antigravity:** no conozco una forma estable de definir subagentes por archivo. `AGENTS.md` lista los roles y manda a leer `~/.agents/agents/<rol>.md` para aplicarlo. Para trabajo en paralelo, Codex usa tareas en la nube y Antigravity su Agent Manager.
- **Codex `prompts/` y Gemini `agents/`:** se instalan, pero conviene verificar que tu versión los lea. Si alguno no aparece, avisame y ajusto el formato en `bin/render-*.ps1`.
- **Hooks fuera de Claude:** opencode tiene la guardia como plugin. Codex, Gemini y Antigravity no reciben hooks.
- **Skills duplicadas en opencode:** opencode también lee `~/.claude/skills`, así que ve el núcleo dos veces. Se evita desactivando su compatibilidad con Claude Code; verificá el nombre de la opción en tu versión.
- **MCPs:** apagados por política. `config/mcp.example.json` tiene los servidores verificados, para activar por proyecto.

## Tokens: antes → después

| Por sesión | Antes | Después |
|---|---:|---:|
| Metadata de skills precargada | ~9.300 (115 skills) | ~1.475 (30) |
| Reglas globales | ~60 (puntero roto: no cargaba las reglas) | ~1.180 (`AGENTS.md` completo) |
| Descripciones de agentes | 0 (no estaban instalados) | ~245 (5) |
| Comandos | 0 | ~50 (3) |
| **Total fijo** | **~9.360** | **~2.950** |

Bajo demanda (sólo cuando se usan):

- `skills-library/INDEX.md`: ~2.400 tokens.
- Prompts de agentes: 1.308 tokens en total, contra 11.346 antes.
- `tasks/todo.md` al iniciar sesión: ≤200 tokens.

## Roles (subagentes)

| Rol | Modelo | Herramientas | Se usa | No se usa |
|---|---|---|---|---|
| `explorador` | Haiku | lectura + web | búsqueda en más de ~5 archivos o research externo | archivo ya conocido |
| `planner` | Opus | lectura + web | más de 3 pasos, varios archivos, arquitectura | cambios chicos |
| `implementador` | Sonnet | todas | tramos independientes de un plan, en paralelo | trabajo lineal (lo hace el principal) |
| `reviewer` | Opus | lectura + bash de lectura | antes de merge/PR, seguridad, release | cambios triviales |
| `verificador` | Sonnet | lectura + bash | antes de declarar listo trabajo multi-archivo | cambios de una línea |

- Se definen una sola vez en `.agents/agents/`. Los modelos se eligen en `config/model-tiers.json`, y `bin/render-agents.ps1` los genera para cada cliente.
- Reglas de delegación (en `AGENTS.md`): el subagente devuelve un resumen, nunca volcados; profundidad máxima 1; máximo 3 en paralelo.

## Comandos

| Comando | Qué hace |
|---|---|
| `/planear <tarea>` | Plan con el `planner`; espera tu OK antes de implementar |
| `/revisar [foco]` | Review del diff de la rama con el `reviewer`: P0/P1/P2 y veredicto |
| `/cerrar [nota]` | Verifica, actualiza `tasks/todo.md` y `lessons.md`, y hace commit y push de la rama (nunca a main) |

Se llaman así, y no `/plan` o `/review`, porque Claude Code ya trae comandos con esos nombres.

## Hooks (Claude Code)

| Hook | Evento | Costo | Qué hace |
|---|---|---|---|
| `session-todo` | SessionStart | ≤200 tokens | inyecta las primeras 30 líneas de `tasks/todo.md` del proyecto |
| `guard` | PreToolUse (Bash, Read) | 0 salvo que bloquee | bloquea force-push, `rm -rf` sobre raíz/home/`..`, `Remove-Item -Recurse` sobre home o unidad, y lectura de `.env` |
| `lint-edited` | PostToolUse (Edit, Write) | 0 salvo error | valida el archivo tocado: JSON, PowerShell, Python o eslint del proyecto |
| `log-usage` | PostToolUse (Agent, Skill) | 0 | registra en `~/.agents/tasks/usage-log.md` qué se usa de verdad, para podar con datos |
| `stop-unpushed` | Stop | 0 (sólo te avisa a vos) | recuerda si quedaron commits sin pushear o cambios sin commitear |

Las reglas de la guardia están en un solo archivo, `~/.agents/hooks/guard-rules.json`, que usan el hook y el plugin de opencode.

## Capacidades a un paso (library, 0 tokens hasta usarlas)

- **Video:** `tesseract-video` y `tesseract-motion` (edición con motion graphics, render local) y `remotion-*` (video programático con React).
- **Web 3D:** `web-3d` (three.js/R3F con presupuesto de performance, fallback mobile y accesibilidad). También `ui-refine` (16 modos de refinamiento) y `react-view-transitions`.
- **Documentos:** `pdf`, `docx`, `xlsx`, `pptx`.
- **Arte:** `canvas-design`, `algorithmic-art`, `logo-design-guide`, `youtube-thumbnail-design`…
- **Deploy y calidad web:** `deploy-to-vercel`, `web-design-guidelines`.
- **Negocio y contenido:** `product-founder`, `marketing-strategist`, `x-content-strategist`, `technical-docs`, `linkedin-content`…
- **Estudio:** `academic-tutor`, `exercise-generator`, `grilling`.

Para sumar una skill:

1. Ponela en `.agents/skills-library/<nombre>/`, o si es de terceros, en `config/external-skills.json`.
2. Corré `pwsh .\bin\generate-skill-index.ps1` y `pwsh .\bin\generate-capabilities.ps1`.
3. Pasala al núcleo sólo si la usás todas las semanas.

## Flujo de trabajo que ahorra tokens

1. **Una tarea por sesión.** `/cerrar` al terminar y sesión nueva: el hook retoma desde `tasks/todo.md`.
2. **Plan con modelo fuerte, ejecución con el medio.** `/planear` para lo que tenga más de 3 pasos; las tareas chicas van directo.
3. **Subagentes sólo** para búsqueda amplia, tramos independientes o review/verificación con ojos frescos. Cada uno arranca en frío.
4. **Buscá, no leas:** grep/glob y lectura por rangos. Nunca leas `capabilities.json` entero ni `archive/`.
5. **MCPs apagados por defecto;** se prenden por proyecto.
6. **No edites las reglas globales en medio de una sesión:** invalida el caché del prompt.
7. **Council o multiagente sólo si lo pedís explícitamente.**

## Qué herramienta para qué

| Tarea | Herramienta |
|---|---|
| Implementar, refactor, PRs, debugging | Claude Code (sistema completo: agentes, comandos, hooks) |
| Tareas repetitivas o triviales sin costo | opencode + Ollama local |
| Verificación visual y en browser | Antigravity |
| Tareas largas en background | Codex / Claude Code en la web |
| Ideas y borradores sin repo | Chat web con `config/global/chat-web.md` |
