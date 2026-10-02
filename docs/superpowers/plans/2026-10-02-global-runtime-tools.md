# Global Runtime Tools Implementation Plan

> **For agentic workers:** Use bounded isolated review for independent installation coverage; primary owns tool installation, integration and validation.

**Goal:** Make the authorized runtime and selected tools usable outside Codex, with a supported global entrypoint and honest health evidence.

**Architecture:** Keep the canonical on-demand library. Install independent PowerShell/ripgrep/uv/pnpm plus Sandcastle/Evalite CLIs at verified pinned versions; do not enable paid providers, cloud sandboxes or automatic loops. A managed agents shim resolves a preserved local checkout pointer rather than treating repo-dependent scripts as standalone copies.

**Tech Stack:** PowerShell, Windows Package Manager, npm, existing managed sync.

- [x] Audit existing tools/adapters and external provider connectivity; bounded independent coverage review.
- [x] Write a failing entrypoint/installation contract test, then implement agents.cmd/agents.ps1, local checkout registration and pinned opt-in tool installation.
- [x] Install selected missing tools. Smoke-test independent PATH, CLI startup and an offline Evalite check; probe OpenCode within bounded time, report failures without paid fallback.
- [x] Document ordinary-language use and actual prerequisites; retire the destructive setup-local import path without deleting user data.
- [x] Run focused tests, release/secret/graph checks, managed sync, doctor and no-drift checks. Preserve existing personal configuration.
- [ ] Review diff/identity, commit and push only fix/runtime-setup-gaps, verify remote parity, record state. Never merge main.

Bounds: at most three workers concurrently, depth one, two provider smoke attempts at 45s each, three repair rounds per issue. No Docker daemon/startup policy changes, model downloads, billing, credentials, external publishing or global project dependency injection.
