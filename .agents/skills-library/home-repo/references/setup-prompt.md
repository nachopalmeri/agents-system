# Prompt oficial para armar un Home Repo

Fuente: [The Home Repo Pattern](https://www.aihero.dev/the-home-repo-pattern), Matt Pocock, publicado para copiar y pegar en una sesión del agente. Reproducido acá para uso local. No es código de `mattpocock/skills` (MIT); es el texto del artículo. No lo presentes como propio.

**Uso en este repo:** pegalo en una sesión nueva, arrancada en la carpeta que contiene los repos. El prompt manda inventariar y preguntar en rondas, y **no cambiar nada hasta que apruebes el plan (Paso 3)**. El Paso 4 (crear repo, mover archivos, borrar copias en hijos, commitear) queda bloqueado hasta ese OK. En agents-system el Home Repo ya existe: el inventario debería proponer **adaptar este repo**, no crear otro, salvo que Nacho pida lo contrario. En repos de Zentra, no mover `CONTEXT.md` ni skills del plugin del equipo.

---

Set up a Home Repo with me: one git repo that holds my shared skills,
AGENTS.md and shared docs, and points at my other repos. I'll run my agent
from it.

## How to work

- Look up every fact yourself (filesystem, git, gh), using subagents for
  wide searches. Bring me only decisions.
- Put decisions to me in rounds. Number each question, give your
  recommended answer, and word it so "yes" accepts it. A question that
  depends on one still open waits for a later round.
- Until I approve the plan in Step 3, only read.
- Secrets stay where they are: leave .env and other secret files unread.

## Step 1: Inventory the repos

Find every git repo under my home directory, skipping dependency folders.
For each, record its path, remote, visibility (public or private) and
last commit date.

In the first round, ask:
- which repos the Home Repo points at (recommend those with recent commits)
- where it lives, and whether it's new or an existing repo (recommend a
  new private repo beside the others)
- whether it's personal or shared with a team
- which file my harness loads at session start: AGENTS.md, CLAUDE.md or
  both (recommend what my setup shows)

Done when every repo found is marked in or out, and the other three
questions are answered.

## Step 2: Inventory the shared material

Across the chosen repos and my user-level skill folders (such as
~/.claude/skills), list every skill (a folder with a SKILL.md), every
AGENTS.md and CLAUDE.md, and every doc written for agents: coding
standards, glossaries, ADRs.

Sort each item into one bucket:
- shared: true across repos
- duplicate: the same item in several places; diff the copies and mark
  the newest
- repo-specific: about one repo's code, commands or domain
- installed: from a published skills repo or marketplace

Done when every item sits in exactly one bucket.

## Step 3: Agree the plan

Show a table of every item, where it is now, and its destination:
- shared and duplicate: move to the Home Repo, one copy, newest version
- repo-specific: stays in its repo
- installed: stays installed

Under it, show the Home Repo's AGENTS.md: a short intro, then an
"Other Repos" section with one pointer per repo:

  <name> (<what it is>): <local path>. Clone from <remote> if missing.

Add a hint where a repo needs one, such as "read its AGENTS.md first".
Past about 20 repos, group the pointers into one file per area and point
at those files instead.

Settle open items in further rounds. Done when I approve the table and
the AGENTS.md.

## Step 4: Apply the plan

1. Create the Home Repo and its AGENTS.md. If my harness loads a
   different file, add that file as a one-line pointer to AGENTS.md.
2. Copy each shared item in, keeping skill folders whole.
3. In each child repo, on a new local branch, remove the copies that
   moved. Repo-specific material stays.
4. Commit in the Home Repo. Pushing is my call.

Done when every row of the table is applied. Report each row's outcome,
the branches you created in each repo, and anything you skipped, with
the reason.
