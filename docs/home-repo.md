# Home Repo, adaptado a agents-system

Fuente: [The Home Repo Pattern](https://www.aihero.dev/the-home-repo-pattern) (Matt Pocock, 12/11/2026) y los posts [2120838662254420341](https://x.com/mattpocockuk/status/2120838662254420341), [2120847219788308872](https://x.com/mattpocockuk/status/2120847219788308872) y el adelanto del 10/11 [2120260969750540327](https://x.com/mattpocockuk/status/2120260969750540327). El prompt de setup publicado se copia en `.agents/skills-library/home-repo/references/setup-prompt.md`.

## Qué es

Un Home Repo es **un** repo git con las skills compartidas, el `AGENTS.md` y los docs de steering. El agente arranca acá. Ese `AGENTS.md` (en este sistema, vía `.agents/repos.md`) tiene punteros a los demás repos, para abrirlos o clonarlos cuando haga falta.

Resuelve tres cosas: un solo lugar para steering y tooling, un solo lugar desde el que correr agentes, y cambios que cruzan repos en una sola sesión.

## Cómo encaja acá

`agents-system` ya era, en la práctica, el Home Repo: skills, adapters, `config/capabilities.json`, sync a `~/.agents`. Lo que faltaba era la **navegación explícita a los otros repos** y una regla clara de qué se queda en cada hijo.

- Punteros: `.agents/repos.md` (divulgación progresiva, para no inflar el `AGENTS.md` canónico).
- Skill: `.agents/skills-library/home-repo/SKILL.md`.
- Runtime Windows: `~/.agents` se sigue sincronizando desde este repo con `bin/sync-runtime.ps1`.
- En WSL, `~/.agents` es un symlink a `/mnt/c/Users/Nacho/.agents`, así que las skills compartidas se ven igual.
- OpenCode usa oh-my-opencode-slim: preset `mix` en Windows (Opus orquesta; DeepSeek hace el grind) y `mix-work` en WSL. Los subagentes de Claude Code delegan con `opencode run --agent explorer|fixer|designer|reviewer|breaker`.
- Zentra / WSL se documenta en los punteros, pero **no se unifica a la fuerza** con las convenciones de Matt (el equipo ya tiene `CONTEXT.md` y el plugin `zentra@claude-zentra`).

Los adapters de raíz (`AGENTS.md` y `CLAUDE.md`) apuntan a `.agents/AGENTS.md` y, en una línea, a `.agents/repos.md`. No los edites a mano: se generan con `bin/render-runtime-adapters.ps1`.

## Quickstart (día a día)

1. **Tarea en un solo repo** (por ejemplo un bug de fubol): abrí Claude Code u OpenCode en ese repo (`D:\Dev\fubol`). Las skills compartidas ya están en `~/.agents`; no hace falta arrancar en el Home Repo.
2. **Tarea que cruza repos** (por ejemplo sumar HackaTwin al portfolio): abrí Claude Code u OpenCode en `D:\Dev\repos\agents-system`, pedile que lea `.agents/repos.md` y que trabaje en una rama o worktree de cada hijo. No copies el código de un hijo adentro del Home Repo.
3. **Skill nueva transversal**: agregala en este repo (`.agents/skills` o `.agents/skills-library`) y corré `pwsh bin/sync-runtime.ps1` para copiarla a `~/.agents` (Windows y, por el symlink, WSL). Skill de un solo producto: en ese repo. Skill de Zentra: en el plugin del equipo.
4. **Repo nuevo**: sumá una fila en `.agents/repos.md` (nombre, qué es, path, remote, rama por defecto, comando de test/build si es obvio). No inflés `.agents/AGENTS.md`.

**Excepción Zentra:** el día a día del theme arranca en `/home/nacho/projects/zentra`, con el plugin `zentra@claude-zentra` y las reglas de `CONTEXT.md`. No corras `/setup-matt-pocock-skills` ni conviertas `CONTEXT.md` a `GLOSSARY.md` ahí. El Home Repo solo sirve para ubicar ese checkout.

En esta PC, el checkout canónico es `D:\Dev\repos\agents-system`. No uses `C:\Users\Nacho\agents-system`, que está atrasado. No ejecutes el Paso 4 del prompt oficial (mover o borrar copias en los hijos) sin un plan aprobado por Nacho.

## Relación con un monorepo, `~/.claude/skills` y submodules

Matt: una carpeta de usuario es un parche; el Home Repo se versiona y se puede compartir en un equipo. Submodules son opcionales; con pocos repos alcanzan los punteros. Un monorepo es mejor cuando se puede; el Home Repo lo reemplaza cuando se mezclan repos públicos y privados, o cuando el equipo no va a un monorepo. Zentra ya es el repo de equipo (`leotocca/zentra-tiendanube` + plugin compartido); este Home Repo cubre el tooling personal de Nacho.
