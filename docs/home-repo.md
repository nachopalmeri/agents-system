# Home Repo, adaptado a agents-system

Fuente: [The Home Repo Pattern](https://www.aihero.dev/the-home-repo-pattern) (Matt Pocock, 12/11/2026) y los posts [2120838662254420341](https://x.com/mattpocockuk/status/2120838662254420341), [2120847219788308872](https://x.com/mattpocockuk/status/2120847219788308872) y el adelanto del 10/11 [2120260969750540327](https://x.com/mattpocockuk/status/2120260969750540327). El prompt de setup publicado se copia en `.agents/skills-library/home-repo/references/setup-prompt.md`.

## Qué es

Un Home Repo es **un** repo git con las skills compartidas, el `AGENTS.md` y los docs de steering. El agente arranca acá. Ese `AGENTS.md` (en este sistema, vía `.agents/repos.md`) tiene punteros a los demás repos, para abrirlos o clonarlos cuando haga falta.

Resuelve tres cosas: un solo lugar para steering y tooling, un solo lugar desde el que correr agentes, y cambios que cruzan repos en una sola sesión.

## Cómo encaja acá

`agents-system` ya era, en la práctica, el Home Repo: skills, adapters, `config/capabilities.json`, sync a `~/.agents`. Lo que faltaba era la **navegación explícita a los otros repos** y una regla clara de qué se queda en cada hijo.

- Punteros: `.agents/repos.md` (divulgación progresiva, para no inflar el `AGENTS.md` canónico).
- Skill: `.agents/skills-library/home-repo/SKILL.md`.
- Runtime Windows: `~/.agents` se sigue sincronizando desde este repo.
- Zentra / WSL se documenta en los punteros, pero **no se unifica a la fuerza** con las convenciones de Matt (el equipo ya tiene `CONTEXT.md` y el plugin `zentra@claude-zentra`).

## Cómo usarlo (plan corto)

1. En esta PC, trabajá sobre `D:\Dev\repos\agents-system` (no sobre `C:\Users\Nacho\agents-system`, que está atrasado).
2. Revisá y, si hace falta, ajustá las rutas de `.agents/repos.md`.
3. Para una tarea que cruza repos, abrí Claude Code u OpenCode **en el Home Repo**, pedile que lea `.agents/repos.md` y que trabaje en el checkout hijo (worktree en el hijo, como dijo Matt el 12/11).
4. Skills nuevas transversales: agragalas acá y sincrónizalas a `~/.agents`. Skills de un solo producto: en ese repo, o en el plugin del equipo si es Zentra.
5. No ejecutes el Paso 4 del prompt oficial (mover o borrar copias en los hijos) sin un plan aprobado por Nacho.

## Relación con un monorepo, `~/.claude/skills` y submodules

Matt: una carpeta de usuario es un parche; el Home Repo se versiona y se puede compartir en un equipo. Submodules son opcionales; con pocos repos alcanzan los punteros. Un monorepo es mejor cuando se puede; el Home Repo lo reemplaza cuando se mezclan repos públicos y privados, o cuando el equipo no va a un monorepo. Zentra ya es el repo de equipo (`leotocca/zentra-tiendanube` + plugin compartido); este Home Repo cubre el tooling personal de Nacho.
