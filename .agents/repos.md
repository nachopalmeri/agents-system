# Other Repos

Punteros del Home Repo. Cargá este archivo cuando la tarea cruce repos o necesite ubicar un checkout. No lo precargues en cada sesión.

Las rutas de abajo son las de **DESKTOP-7FF9TQ5** (Windows, usuario `Nacho`), relevadas el 13/11/2026. Si estás en otra máquina, confirmá el path o cloná el remote indicado.

## Cómo trabajar

- Arrancá la sesión en este repo (`agents-system`) cuando el trabajo cruce proyectos, o cuando haga falta una skill/steering compartido.
- El código vive en cada repo hijo. Ahí se hacen worktrees y branches; no adentro del Home Repo.
- Lo específico de un repo (build, tests, dominio, `AGENTS.md`/`CLAUDE.md` propios) se queda en ese repo.
- Lo compartido (skills transversales, este índice, docs de sistema) vive acá y se sincroniza a `~/.agents` en Windows.
- **Zentra en WSL es otro mundo:** las skills del equipo mandan sobre las de Matt. No corras `/setup-matt-pocock-skills` ni conviertas `CONTEXT.md` a `GLOSSARY.md` en esos repos.

## Repos personales (Windows)

**agents-system** (este Home Repo; sistema de agentes, skills y steering): hay dos checkouts.
- Preferido: `D:\Dev\repos\agents-system`. Remote: `https://github.com/nachopalmeri/agents-system`. Último `main` visto: 24/10/2026.
- Copia vieja: `C:\Users\Nacho\agents-system` (último commit 26/09/2026). No la uses como canónica.
- Si falta el preferido: `git clone https://github.com/nachopalmeri/agents-system D:\Dev\repos\agents-system`.
- Antes de editar: leé `AGENTS.md` y `.agents/AGENTS.md`.

**fubol** (app de fútbol, HLS, overlay, Vercel): `D:\Dev\fubol`. También hay un atajo en `C:\Users\Nacho\Desktop\fubol`. Remote típico: `https://github.com/nachopalmeri/fubol`. Si falta, cloná ahí.

**ignacio** (portfolio): `D:\Dev\ignacio`. Remote típico: `https://github.com/nachopalmeri/ignacio`. Hay un checkout de Codex/Orca en `C:\Users\Nacho\orca\workspaces\ignacio\…` que no es el canónico.

**Hackaton / HackaTwin**: `D:\Dev\Hackaton`.

## Zentra (no tratarlo como repo personal de Matt)

**zentra-tiendanube** (tema y app de Zentra en Tiendanube; repo del equipo): checkout canónico en WSL, `/home/nacho/projects/zentra`. Remote: `https://github.com/leotocca/zentra-tiendanube.git`. Tiene `CONTEXT.md`, `CLAUDE.md`, `DESIGN.md`, scripts `build-tiendanube.sh` y configs Vite de Tiendanube. Las skills del plugin `zentra@claude-zentra` (marketplace `leotocca/claude-zentra`) mandan acá.

**zentra-prototipos-nov** (prototipos locales de agenda, calendario, sillas, tablas; no es el repo de Tiendanube): `D:\Dev\zentra-prototipos-nov`. Leé su `README.md` primero.

**zentra-estudio** (guías de onboarding / setup de Nacho): `D:\Dev\zentra-estudio`. No es un git repo.

**Backup del theme Tiendanube** (layouts, snipplets, templates `.tpl`): `C:\Users\Nacho\Documents\zentra-dev-backup-2026-11-13`. Copia local, no un remote.

**Vault de relevamiento** (solo lectura desde Claude Code en WSL): `D:\Facultad\UADE-Vault\Zentra` (en WSL: `/mnt/d/Facultad/UADE-Vault/Zentra`). Entrada: `Benchmark experiencia de venta/Hoja de ruta.md`. El vault lo escribe otro agente.

**Repos públicos de prototipos** (si no están clonados en esta PC, cloná según haga falta):
- `https://github.com/nachopalmeri/zentra-agenda-showroom`
- `https://github.com/nachopalmeri/zentra-pods-prototipo`

## Consumo desde `~/.agents` y desde los hijos

- En Windows, `~/.agents` es la copia runtime sincronizada de este repo (`bin/sync-runtime.ps1`). Claude Code carga `@~/.agents/AGENTS.md` vía `~/.claude/CLAUDE.md`.
- En WSL no hay `~/.agents`. El trabajo de Zentra usa `~/.claude/CLAUDE.md` de WSL (preferencias del equipo + plugin de Leo).
- Un repo hijo no tiene que copiar las skills compartidas: el agente las encuentra en el Home Repo o en `~/.agents` / plugins ya instalados.
