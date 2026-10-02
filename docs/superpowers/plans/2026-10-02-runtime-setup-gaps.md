# Runtime setup gaps — Implementation Plan

> **For agentic workers:** Use subagent-driven-development if available; otherwise its sequential execution guidance. Do not delegate overlapping configuration writes.

**Goal:** Repair observed installation diagnostics and OpenCode startup without replacing credentials or inventing absent integrations.

**Architecture:** Keep the manifest authoritative, validate skills by SKILL.md in both tiers, export only plugin factories from auto-loaded OpenCode modules, discover models in pure mode, and inherit unsupported strong model defaults.

**Tech Stack:** PowerShell 7, Node.js built-in test runner, Git, OpenCode.

- [x] Reproduce doctor false negatives with a synthetic install; fix globalSourcePath and optional OpenCode preload handling.
- [x] Reproduce phantom skill counts and test empty SKILL.md detection; cover core and library.
- [x] Test every OpenCode plugin export as a factory returning hooks; repair helper export without changing safety rules.
- [x] Verify pure model discovery and generated agents with inherited model; remove unavailable hardcoded provider IDs.
- [x] Run regression suites, graph and release checks; primary diff review. Independent OpenCode review blocked by live API failures.
- [x] Commit and push feature branch, never merge. Implementation commit `0f2d676`; remote SHA parity verified.
- [x] Sync changes with backup and recheck actual local installation and OpenCode startup.
- [x] Install authorized optional skills and Tesseract CLI; configure vault locally and verify its root.
- [ ] Live free-worker response: blocked by connection/timeouts; do not represent fixtures as provider success.

Evidence and remaining limitations: `docs/runtime-setup-verification-2026-10-02.md`.
