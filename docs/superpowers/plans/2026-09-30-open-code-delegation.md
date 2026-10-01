# OpenCode Delegation and Model Routing v2 Implementation Plan

> **For agentic workers:** REQUIRED: Use subagent-driven-development (if subagents available) or executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let the primary choose a smaller native model or OpenCode free workers for bounded read and local implementation tasks.

**Architecture:** Provider-neutral model preferences, explicit request/result contracts, CLI bridge with dynamically discovered free candidates and scoped permissions. Parent owns validation and synthesis. Native model selection uses the calling harness tool when supported.

**Tech Stack:** PowerShell 7, JSON/JSON Schema, OpenCode CLI, existing runtime/evals.

---

## Delivered scope

- [x] Restore deterministic risk, specialist and parallel routing from repository history; 44/44 weighted cases pass.
- [x] Reconcile graph checker with generated catalog and declare skill rename.
- [x] Fix catalog generation defaults to the repository and preserve richer metadata.
- [x] Add model-tier policy with smaller native models and discovered free OpenCode candidates.
- [x] Add explicit bounded delegation request and result contracts.
- [x] Add executable bridge with safe argument passing, process timeout, attempts, structured results and usage evidence.
- [x] Support local edits to exact files, including OpenCode worktree-relative permission patterns.
- [x] Support up to three independent native OpenCode workers with separate ownership.
- [x] Handle trivial/high-risk/unknown tasks in primary and explicit provider refusal/rate limits.
- [x] Validate CLI event aggregation and refusal/malformed output with offline transport fixtures.
- [x] Verify real provider research, two-worker delegation and scoped file creation.
- [x] Update docs, active policy, adapters and CI checks.
- [x] Verify sync/restore and managed drift rejection; 50 assertions pass.
- [x] Install bridge and active policy locally with backups while preserving unrelated configuration.

## Handoff

The real execution evidence is in `docs/delegation-verification-2026-09-30.md`. Cost zero is reported by the provider, not an assertion of total token savings. Native harness model switching remains conditional on a tool supporting model choice; a web chat without a terminal cannot call OpenCode.

Future changes: configure additional verified free candidates (including DeepSeek when available), benchmark outcomes and review overhead, and add command-specific test execution permissions if required. No model-ranking benchmark or unlimited token budget is claimed.
