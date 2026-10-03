# Ticket Session Workflow Implementation Plan

> **For agentic workers:** Use bounded independent documentation and review; primary owns policy, contract tests, adapter generation and global sync.

**Goal:** Default medium/large features to reusable specs and session-sized tickets without chat creation, publishing or unnecessary process.

**Architecture:** Add one compact core pointer and intent route to an on-demand workflow. Select Matt wrappers by phase, retain original hashes and implicit-invocation settings, and preserve direct execution for small/coupled work.

**Tech Stack:** Markdown policy, PowerShell contract tests and existing managed adapters/sync.

- [x] Write/run a failing contract test for the route, workflow, safety gates and unchanged Matt metadata.
- [x] Add ticket_sessions workflow, core/index pointers, compatibility clarification and short user guide.
- [x] Generate adapters; run contract, graph, catalog, release and adapter checks; bounded independent review.
- [x] Sync globally and verify doctor/no drift. Commit/push the reviewed branch at close; no merge authorization carries over from the previous integration.

Evidence: red on missing workflow, then TICKET_SESSION_CONTRACT_OK; release/graph/catalog/adapter checks passed, system zero errors with one pre-existing metadata warning. Independent review's stale guide wording was corrected; guide/approval guards added to contract coverage. Global sync: 317 matching destinations, backup 20261002-195744244-2a60ab0b. No model compliance benchmark or measured savings claimed.

Bounds: two isolated workers, depth one, at most three repair rounds and one replan. No new user chats, tracker issues, dependencies, MCPs, paid calls or automatic merge. Tests validate policy wiring, not model compliance or measured token savings.
