# Runtime integration — 2026-10-02

## Scope and authorization

Integrate `fix/runtime-setup-gaps` into `main` through [PR #7](https://github.com/nachopalmeri/agents-system/pull/7). The user explicitly authorized this merge in this chat, overriding the earlier no-merge default for this integration only. The permanent runtime policy is unchanged. Existing PR #6 was already merged; unrelated PR #2 is excluded. No human-review flags are asserted.

Base checked: `a2b89ed553c2f114d5945148a93bd88228cbe03a`. Implementation/evidence tip before this documentation: `86885a394dd10821657746f942eb0951c14635b7`. GitHub records the final merge SHA, timestamp and CI result on PR #7; this document does not predeclare a successful merge.

## Included changes

- Portable vault lookup and installation diagnostics, with personal configuration preserved.
- Default reliable bounded delegation; smaller same-harness models or verified-free OpenCode workers. Primary retains validation and synthesis. Simple English change explanations and brief prompt corrections.
- All 37 Matt entries pinned, namespaced and discoverable on demand. Thirty core skills remain; the repository graph reaches five roles and 137 skills. Original guides and MIT license provenance are retained.
- Global `agents` commands, managed checkout registration and pinned opt-in Windows tools. Destructive legacy setup-local import paths disabled.
- OpenCode refusal handling plus live evidence: normal scoped Muse bridge completed JSON and file-read/exact-file-edit tasks with reported $0 provider cost. No permission relaxation; all-denied probing still fails.

## Fresh pre-merge verification

- `bin/release-check.ps1`: passed, including secrets (no critical findings), Git identity, registry, graph, generated artifacts, Matt catalog and global entrypoint.
- `bin/test-system.ps1`: zero errors; one non-blocking warning for Matt compatibility rule frontmatter metadata.
- Delegation, model routing, installation diagnostics, vault resolution and OpenCode guard: passed.
- Diff whitespace validation: passed. GitHub Linux CI is checked before merging; local Bash syntax validation was skipped because only the WSL launcher was available.
- Global runtime previously checked: 316 managed destinations without drift. Post-merge validation and the local checkout/global pointer receipt are recorded in the closing task state.

One isolated Luna reviewer inspects executable and policy changes from the fixed base; the primary runs verification. A reviewer summary is not a human approval.

## Known limits and handoff

Docker's engine remains stopped. Evalite's deterministic in-memory smoke passed; SQLite persistence on this Node 24 PC needs C++ build tools and remains unavailable. OpenCode-internal multi-agent execution, other free models, web research and large implementations are not live-verified. No token-savings percentage is claimed.

Install from the integrated `main` checkout using `pwsh bin/setup-global-runtime.ps1`, adding `-InstallTools` only when tool installation is explicitly wanted. Preserve the checkout registered in `.agents/local-runtime.json`; `agents update` resolves through it. Local vault paths, tasks, memory and credentials do not belong in the public repository.

Details: [global setup](global-setup-2026.md), [Matt catalog](matt-on-demand.md), [live OpenCode evidence](opencode-live-verification-2026-10-02.md).
