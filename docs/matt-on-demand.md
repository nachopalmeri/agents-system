# Matt Pocock: globally discoverable, on demand

All 38 upstream skills at commit 49dd158d1076134a641b33efb035946536778336 are installed as namespaced runtime references: 27 promoted, 4 misc and 7 experimental. They live in ~/.agents/skills-library/matt-<name>, outside the 30 core skills and client metadata preload. The existing global adapters discover them through the library index; their contents are loaded only for a matching requested task.

Use ordinary language: "review my last ten coding sessions for navigation problems", "prepare a PR body with evidence", or "make a compact handoff". The runtime selects matt-retro, matt-pr or matt-handoff; slash-command UI registration is not required or promised. Current chats may need a fresh turn/session to refresh client discovery.

## What is preserved

- Existing core adaptations and project-specific skills are unchanged.
- Original guides are stored as references/upstream/GUIDE.md with per-entry SHA256 and the upstream MIT license. Local backlinks from supporting docs are adapted to the renamed reference filename; these are not new autonomous workflows.
- Wrappers load one shared compatibility policy before the guide: bounded loops, max three workers, depth one, free-only OpenCode and no main merge. External writes, installs, hooks, destructive actions and migrations retain their approval requirements.
- Experimental entries are labeled and opt-in. Discovery does not execute bundled scripts or create issues, PRs, hooks or background processes.

## Reviewed tooling

sandcastle-evaluation and worker-quality-evaluation capture the reviewed Sandcastle/Evalite patterns. Neither framework is installed. Free OpenCode connectivity still requires a successful real worker response; catalog discovery does not fix that blocker.

## Verification and portability

Run bin/test-matt-catalog.ps1, bin/check-runtime-graph.ps1 and bin/release-check.ps1. Use the existing bin/sync-runtime.ps1 to distribute the canonical library and index globally with its managed backup/ownership checks, then -Check to verify drift. System updates are committed and pushed only on a feature branch; the director integrates them. On another PC, update the checkout from the integrated branch and sync the managed library; preserve any compact local core/preload override.

## Update 2026-10-09

Refreshed nine changed skill guides plus wizard/setup references from upstream. No new skills were added; all 38 paths and their maturity remain unchanged. Clarified that upstream tracker operations, branch pushes and PRs require explicit user authorization. Updated per-guide hashes and source links. No new dependencies, hooks, scheduled tasks or paid routing.

## Update 2026-10-06

Pinned all upstream skills to 6fd947921b935b7e1e69293a200400f0fdd5c15f (version metadata 1.3.1, plus main-branch patches). Refreshed skill loading, ticket/sub-issue relationships, GitHub PR listing and safe handoff text. Added chief-of-staff as experimental, opt-in only. The compact local runtime retains 12 active skills; the source distribution retains 30. No new dependencies, hooks, scheduled tasks or paid routing. Existing project terminology is preserved.
