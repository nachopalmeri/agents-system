---
name: home-repo
description: "Usala cuando haya que armar, actualizar o explicar el Home Repo (punteros a otros repos, skills y steering compartidos, trabajo de agentes que cruza fubol, portfolio o Zentra), o cuando pidan el prompt de setup de Matt Pocock."
---

# Home Repo

Patrón de Matt Pocock: un repo con skills, AGENTS.md y docs compartidos, y punteros a los demás repos. El agente arranca acá.

Fuente: [The Home Repo Pattern](https://www.aihero.dev/the-home-repo-pattern). Prompt oficial en [references/setup-prompt.md](references/setup-prompt.md). Cómo está adaptado: [docs/home-repo.md](../../../../docs/home-repo.md). Punteros: [.agents/repos.md](../../../repos.md).

## Cuándo

- "armá el home repo", "dónde pongo las skills", "trabajar en varios repos".
- Hay que agregar, corregir o seguir un puntero a un checkout.
- Una tarea cruza `fubol`, `ignacio`, `agents-system` o Zentra.

## Qué no hacer

- No ejecutes el Paso 4 del prompt oficial (crear otro repo, mover o borrar archivos en los hijos, commit/push) sin un plan aprobado por Nacho.
- No leas `.env` ni archivos de secretos.
- No corras `/setup-matt-pocock-skills` en repos de Zentra. No conviertas `CONTEXT.md` a `GLOSSARY.md` ahí.
- No uses `C:\Users\Nacho\agents-system` como canónico: está atrasado respecto de `D:\Dev\repos\agents-system`.

## Pasos

1. Leé [docs/home-repo.md](../../../../docs/home-repo.md) y [.agents/repos.md](../../../repos.md).
2. Confirmá en qué máquina estás y si las rutas existen. Si un checkout falta, proponé el `git clone` del remote del puntero; no clones en silencio.
3. Si piden **armar** el patrón desde cero, usá el prompt oficial: solo lectura hasta el Paso 3, decisiones en rondas, "yes" acepta la recomendación. Recomendá adaptar **este** repo como Home Repo personal, no crear uno nuevo, salvo que Nacho pida otra cosa.
4. Si el trabajo es en un hijo, abrilo en su path (o un worktree **dentro del hijo**). Traé skills y steering de acá o de `~/.agents`.
5. Al agregar un repo, sumá una fila en `.agents/repos.md` (nombre, qué es, path, remote, rama por defecto, hint de test/build). No inflés `.agents/AGENTS.md`.
6. Devolvé: qué punteros usaste, qué abriste o qué faltó clonar, y qué quedó pendiente de aprobación.

## Claude Code y OpenCode

- Windows / trabajo personal: sesión en `D:\Dev\repos\agents-system` cuando el trabajo cruce repos. Claude Code ya importa `~/.agents/AGENTS.md`. OpenCode tiene oh-my-opencode-slim: preset `mix` en Windows (Opus orquesta; DeepSeek hace el grind) y `mix-work` en WSL. Los subagentes de Claude Code delegan con `opencode run --agent explorer|fixer|designer|reviewer|breaker`.
- WSL: `~/.agents` es un symlink a `/mnt/c/Users/Nacho/.agents`, así que las skills del Home Repo (incluida esta) se ven igual. El día a día de Zentra no arranca en el Home Repo: usá `/home/nacho/projects/zentra` y el plugin `zentra@claude-zentra`. El Home Repo sirve para ubicar ese checkout y para no mezclar convenciones.

## Validación

Existe `.agents/repos.md`, el puntero usado es real o se indicó cómo clonarlo, y no se movió nada en un hijo sin OK.
