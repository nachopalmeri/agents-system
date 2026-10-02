# Matt Pocock: globally discoverable, on demand

All 37 upstream skills at commit d81f3a183412e71a5b1e84ca21bc1a35eea03a60 are installed as namespaced runtime references: 27 promoted, 4 misc and 6 experimental. They live in ~/.agents/skills-library/matt-<name>, outside the 30 core skills and client metadata preload. The existing global adapters discover them through the library index; their contents are loaded only for a matching requested task.

Use ordinary language: "review my last ten coding sessions for navigation problems", "prepare a PR body with evidence", or "make a compact handoff". The runtime selects matt-retro, matt-pr or matt-handoff; slash-command UI registration is not required or promised. Current chats may need a fresh turn/session to refresh client discovery.

## What is preserved

- Existing core adaptations and project-specific skills are unchanged.
- Original guides are stored as references/upstream/GUIDE.md with per-entry SHA256 and the upstream MIT license. Local backlinks from supporting docs are adapted to the renamed reference filename; these are not new autonomous workflows.
- Wrappers load one shared compatibility policy before the guide: bounded loops, max three workers, depth one, free-only OpenCode and no main merge. External writes, installs, hooks, destructive actions and migrations retain their approval requirements.
- Experimental entries are labeled and opt-in. Discovery does not execute bundled scripts or create issues, PRs, hooks or background processes.

## Reviewed tooling

sandcastle-evaluation and worker-quality-evaluation capture the reviewed Sandcastle/Evalite patterns. Neither framework is installed. Free OpenCode connectivity still requires a successful real worker response; catalog discovery does not fix that blocker.

## Verification and portability

Run bin/test-matt-catalog.ps1, bin/check-runtime-graph.ps1 and bin/release-check.ps1. Use the existing bin/sync-runtime.ps1 to distribute the canonical library and index globally with its managed backup/ownership checks, then -Check to verify drift. Another PC needs the branch containing this change until it is merged by the director; this task never merges main.
