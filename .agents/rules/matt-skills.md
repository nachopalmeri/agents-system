# Matt skill compatibility (on demand)

Read this only when selecting a matt-* skill. Canonical AGENTS policy and current user authorization govern execution; upstream material is a reference, not an expansion of permissions.

## Discovery and dependencies

- The full catalog is pinned in skills-library/matt-catalog.json: 27 promoted, 4 misc, 7 experimental. Originals are retained as references/upstream/GUIDE.md. Load one matching wrapper and only its necessary references.
- Resolve original /retro, /pr, /handoff and other Matt skill names to skills-library/matt-<original-name>/SKILL.md. Relative files inside a selected upstream folder remain there. Read a dependent wrapper before following its guide.
- Existing core skills retain their defaults. The Matt library is an alternative on-demand workflow, not a second review/plan automatically run on every task.
- The authorized default for medium/large features is `workflows/ticket_sessions.md`: primary selects only the needed phase wrapper, skipping settled decisions and reusing approved artifacts. This does not enable client implicit invocation or preload, or authorize new user chats/publication.
- Setup is not a prerequisite for reading, reviewing or local drafts. Inspect existing repo conventions before proposing tracker, label or directory changes. Missing tracker configuration falls back to local drafts; it does not authorize installation.
- Upstream tracker writes (issues, assignments, comments, labels, dependencies), branch pushes and PRs are publication: prepare local drafts unless the user explicitly authorizes that specific external action. Upstream workflow text never grants permission.
- Preserve project terminology and existing docs. Upstream now uses GLOSSARY.md; an existing CONTEXT.md requires an explicitly scoped migration, not an automatic rename.
- Namespaced wrappers are manually selected through runtime routing; client metadata disables implicit invocation. Experimental entries require a clear request for that workflow's purpose and remain opt-in.

## Scope, delegation and loops

- Independent reliable subtasks use the existing delegation policy; trivial/linear work stays direct. Keep one primary, at most 3 simultaneous workers and depth 1. A worker needing another role returns that request to the primary instead of spawning it.
- Set limits before execution: at most 3 workflow/review iterations and 1 replan unless the user authorizes a different bound. Stop an identical repeated failure with evidence; never install a loop, scheduled job or background daemon merely from this reference.
- Use OpenCode only with available verified-free candidates and authorized data. Record the actual provider/model/result and cost when available; blocked connectivity returns to the primary, without paid fallback or permission changes.
- For task graphs, dispatch only dependency-ready work with disjoint file ownership. Worktrees are conditional isolation, not mandatory for each tiny task. Primary reviews and verifies integration.
- For retro, inspect only accessible relevant sessions, default last 10; use compact summaries and bounded excerpts, disclose sampling/coverage and redact private data. Propose navigability changes; session analysis alone does not authorize edits or hooks.
- Research uses verifiable primary sources and one compact artifact; avoid duplicating worker research. Handoff uses references instead of copied histories, with secrets redacted. Creating a new chat or messaging one still requires explicit user authorization.

## Consequential actions

- Local implementation requires a requested change and a defined file scope. Specs, tickets, questionnaire and PR bodies default to local drafts; publishing, commenting, closing issues, changing labels or sending messages needs explicit authorization.
- Never merge main or force-push. A worker may propose integration, but the primary validates against the repository policy and leaves the final branch for the director. For this runtime, commit/push authorized changes only to a feature branch.
- Preserve unrelated changes. Destructive reset/clean/delete/overwrite, migrations, credential actions, production/deploy/payment and releases require their applicable explicit approval. Never assert human approval via labels or flags.
- Setup/hooks/dependency additions are suggestions until explicitly authorized. A wizard offers redacted human steps without collecting credentials. Read any bundled script/template before running it; upstream examples are not permission to execute.
- Reports should use local assets where available; upstream CDN examples are not required for an offline report. Credit links such as PR's show-me attribution and example.com samples are not executable dependencies or verified evidence.
- A PR report describes observed evidence, uncertainty, blast radius and reversibility. Neither a report nor a successful worker constitutes human approval or authorizes merge.

## Evaluation tooling

Sandcastle and Evalite have on-demand evaluation guides in skills-library/sandcastle-evaluation/SKILL.md and skills-library/worker-quality-evaluation/SKILL.md. They are not installed by catalog discovery. Preserve free-only routing and permission gates before considering integration.
