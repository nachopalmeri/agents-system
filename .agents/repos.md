# Other Repos

Punteros del Home Repo. Cargá este archivo cuando la tarea cruce repos o necesite ubicar un checkout. No lo precargues en cada sesión.

Las rutas de abajo son las de **DESKTOP-7FF9TQ5** (Windows, usuario `Nacho`; WSL usuario `nacho`), relevadas el 14/11/2026. Si estás en otra máquina, confirmá el path o cloná el remote indicado.

## Cómo trabajar

- Arrancá la sesión en este repo (`agents-system`) cuando el trabajo cruce proyectos, o cuando haga falta una skill/steering compartido.
- El código vive en cada repo hijo. Ahí se hacen worktrees y branches; no adentro del Home Repo.
- Lo específico de un repo (build, tests, dominio, `AGENTS.md`/`CLAUDE.md` propios) se queda en ese repo.
- Lo compartido (skills transversales, este índice, docs de sistema) vive acá y se sincroniza a `~/.agents` en Windows (y a WSL por el symlink).
- **Zentra en WSL es otro mundo:** las skills del equipo mandan sobre las de Matt. No corras `/setup-matt-pocock-skills` ni conviertas `CONTEXT.md` a `GLOSSARY.md` en esos repos.

## Repos personales (Windows)

**agents-system** (este Home Repo; sistema de agentes, skills y steering): hay dos checkouts.
- Preferido: `D:\Dev\repos\agents-system`. Remote: `https://github.com/nachopalmeri/agents-system`. Rama por defecto: `main`.
- Copia vieja: `C:\Users\Nacho\agents-system` (último commit visto: 26/09/2026). No la uses como canónica.
- Si falta el preferido: `git clone https://github.com/nachopalmeri/agents-system D:\Dev\repos\agents-system`.
- Antes de editar: leé `AGENTS.md` y `.agents/AGENTS.md`.
- Validación: no hay `package.json`; corré los scripts de `bin/` (por ejemplo `pwsh bin/validate-agents.ps1` y el resto de `.github/workflows/validate-agents.yml`). Sync: `pwsh bin/sync-runtime.ps1`.

**fubol** (app de fútbol, HLS, overlay, Vercel; la app familiar vive en `web/`): `D:\Dev\fubol`. Remote: `https://github.com/nachopalmeri/fubol.git`. Rama por defecto: `main`. Si falta: `git clone https://github.com/nachopalmeri/fubol.git D:\Dev\fubol`. Build/test: `cd web && npm run check && npm run build`. Dev: `cd web && npm run dev` (puerto 3001). En el Desktop hay una carpeta y un acceso `fubol` que **no** son el checkout; no los uses.

**ignacio** (portfolio, HTML/CSS/JS vanilla): `D:\Dev\ignacio`. Remote: `https://github.com/nachopalmeri/ignacio`. Rama por defecto: `main`. Si falta: `git clone https://github.com/nachopalmeri/ignacio D:\Dev\ignacio`. Tests: `npm run verify` (syntax + unit). E2E: `npm run test:e2e`. Hay un checkout de Codex/Orca en `C:\Users\Nacho\orca\workspaces\ignacio\…` que no es el canónico.

**Hackaton / HackaTwin**: `D:\Dev\Hackaton` es un git local en `main`, sin `remote` configurado. El proyecto de la hackathon está en el checkout anidado `D:\Dev\Hackaton\beca-modular` (Beca Modular, LABITCONF 2026). Remote: `https://github.com/nachopalmeri/beca-modular.git`. Rama por defecto: `main`. Si falta ese checkout: `git clone https://github.com/nachopalmeri/beca-modular.git D:\Dev\Hackaton\beca-modular`.

## Zentra (no tratarlo como repo personal de Matt)

**zentra-tiendanube** (tema y app de Zentra en Tiendanube; repo del equipo): checkout canónico en WSL, `/home/nacho/projects/zentra`. Remote: `https://github.com/leotocca/zentra-tiendanube.git`. Rama por defecto: `main` (el checkout local puede estar en una rama de trabajo). Tiene `CONTEXT.md`, `CLAUDE.md`, `DESIGN.md`, `build-tiendanube.sh` y configs Vite de Tiendanube. Build/test: `bun test`, `vite` (`npm run dev` / `npm run build` / `npm run preview`). Las skills del plugin `zentra@claude-zentra` (marketplace `leotocca/claude-zentra`) mandan acá.

**zentra-prototipos-nov** (prototipos locales descartables de agenda, calendario, sillas y tablas; no es el repo de Tiendanube ni un git repo): `D:\Dev\zentra-prototipos-nov`. Leé su `README.md` primero. Para verlos: `npx --yes serve -p 4173` o `python3 -m http.server 4173` desde esa carpeta.

**zentra-estudio** (guías de onboarding / setup de Nacho): `D:\Dev\zentra-estudio`. No es un git repo.

**Aprendizajes de Zentra** (wiki privada de decisiones y resultados propios, no fuentes): carpeta `Efforts/Trabajo/Zentra/08 Aprendizajes/` del vault UADE. Leé solo su `index.md`, y solo cuando una tarea de Zentra lo pida (skill `consult-intelligence-core`). Es privada: no copies su contenido a este repo público.

**Backup del theme Tiendanube** (layouts, snipplets, templates `.tpl`): `C:\Users\Nacho\Documents\zentra-dev-backup-2026-11-13`. Copia local, no un remote.

**Vault de relevamiento** (solo lectura desde Claude Code en WSL): `D:\Facultad\UADE-Vault\Zentra` (en WSL: `/mnt/d/Facultad/UADE-Vault/Zentra`). Entrada: `Benchmark experiencia de venta/Hoja de ruta.md`. El vault lo escribe otro agente.

**Repos de prototipos en GitHub** (no hay checkout en esta PC; cloná solo si hace falta):
- **zentra-agenda-showroom**: remote `https://github.com/nachopalmeri/zentra-agenda-showroom` (privado, rama `main`). Si hace falta: `git clone https://github.com/nachopalmeri/zentra-agenda-showroom.git D:\Dev\zentra-agenda-showroom`.
- **zentra-pods-prototipo**: remote `https://github.com/nachopalmeri/zentra-pods-prototipo` (privado, rama `main`). Si hace falta: `git clone https://github.com/nachopalmeri/zentra-pods-prototipo.git D:\Dev\zentra-pods-prototipo`.

## Consumo desde `~/.agents` y desde los hijos

- En Windows, `~/.agents` es la copia runtime sincronizada de este repo (`bin/sync-runtime.ps1`). Claude Code carga `@~/.agents/AGENTS.md` vía `~/.claude/CLAUDE.md`.
- En WSL, `~/.agents` es un symlink a `/mnt/c/Users/Nacho/.agents`, así que las skills del Home Repo (incluida `home-repo`) se ven igual. El trabajo diario de Zentra igual arranca en `/home/nacho/projects/zentra`, con `~/.claude/CLAUDE.md` de WSL y el plugin de Leo.
- Un repo hijo no tiene que copiar las skills compartidas: el agente las encuentra en el Home Repo o en `~/.agents` / plugins ya instalados.
