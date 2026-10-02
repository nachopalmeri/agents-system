# Lean Runtime Implementation Plan

> **For agentic workers:** Use subagent-driven-development for independent work; keep coupled policy edits in the primary. The user's request explicitly replaces automatic multi-review ceremony with proportionate review.

**Goal:** Apply lean defaults without weakening permissions, scope, verification or free-only worker gates.

**Architecture:** Keep a short core pointer, a selected token-budget workflow and concise planning/review skills. Reduce real worker candidate attempts; document what is policy versus executable enforcement. Do not change the current client's model, speed setting or MCP configuration blindly.

**Tech Stack:** Markdown, JSON, PowerShell and existing generators/sync.

## Chunk 1: One bounded change

- [x] Add a regression to `bin/test-model-routing.ps1` for one-attempt worker budgets; run it RED before changing `config/model-routing.json`.
- [x] Update `.agents/AGENTS.md`, `.agents/rules/model_routing.md`, `.agents/workflows/index.md`, and add `.agents/workflows/token_budget.md`. Shorten `.agents/skills/{writing-plans,subagent-driven-development,code-review}/SKILL.md` to conditional, bounded planning/review; preserve useful reference files and catalog availability. Update `docs/token-efficiency.md` with a three-ticket measurement template.
- [x] Run focused routing/delegation tests, regenerate affected metadata/adapters, perform one integrated review and release check, sync with backup, and verify drift. Commit/push follows these checks; the exact receipt is recorded in local task state. Never merge main or create user chats.

Acceptance: routine work prefers the smallest capable available model in Standard mode; tiny tasks stay direct; no duplicated research/full histories; no mandatory two-reviewer-per-task loop; test/safety gates remain; savings are measured, not promised.

Limits: one review pass, at most one corrective pass, one worker at a time for this change. Relevant checks rerun after fixes; the full suite runs once against the final artifact set. Static checks do not prove model compliance or allowance savings.

## Verification receipt

- Routing policy regression failed before budget changes. Delegation CLI fixture failed while the selector still hard-coded two attempts; after reading the tier budget, both focused tests passed. Actual malformed-output receipt now records one attempt.
- Release check, ticket contract, task routing (10 cases), generated adapters and system checks passed. System: zero errors, one pre-existing Matt metadata warning; Bash syntax unavailable through the WSL-only launcher. Secret scan: no critical findings, existing example-pattern warnings retained.
- Skill quick_validate.py unavailable: bundled Python lacks PyYAML. No dependency installed. Restricted two-scalar frontmatter, names, discovery fields and selected reference paths checked locally instead; not a general YAML parser or behavioral model evaluation.
- One Luna docs worker and one Luna integrated reviewer invoked without inherited history; both closed. Review found no P0/P1. An optional suggestion to prohibit a configured two-attempt override was not adopted: one attempt is the tested default, while an intentional policy edit can still select up to the existing safe ceiling of two.
- Global sync preserves personal configuration and unmanaged skills, with backups. Current model/speed/MCP settings unchanged. Final commit/push receipt lives in the local task state; main integration remains the director's action.
