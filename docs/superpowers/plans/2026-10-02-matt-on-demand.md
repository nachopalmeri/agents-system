# Matt Pocock On-Demand Discovery Implementation Plan

> **For agentic workers:** Use isolated, bounded subagents for independent review. Keep integration and validation in the primary; no nested delegation.

**Goal:** Make the complete pinned Matt skills catalog and reviewed tooling patterns globally discoverable without expanding core preload.

**Architecture:** Namespace imported skills as `matt-*` in the canonical skills-library, retain upstream material and license as references, and apply one shared runtime compatibility gate. Add on-demand Sandcastle/Evalite evaluation guides, not framework installations. Existing sync distributes the library to all supported global adapters.

**Tech Stack:** Markdown, JSON, existing PowerShell generators/sync, official skill-installer helper.

## Tasks

- [x] Add a failing catalog contract test: all pinned upstream entries discoverable, reference/license present, non-implicit metadata, unchanged core count, safe compatibility gate.
- [x] Install upstream sources into an isolated staging directory using the official installer, pinned to `d81f3a183412e71a5b1e84ca21bc1a35eea03a60`. Review risky instructions with a bounded worker.
- [x] Import all entries (27 promoted, 4 misc, 6 in-progress) with namespace, maturity, concise trigger descriptions and shared compatibility controls. Preserve existing adaptations and project skills.
- [x] Add Sandcastle/Evalite evaluation references without installing dependencies or changing model permissions. Regenerate the index and capability ledger; add conditional routing pointers.
- [x] Run catalog, graph, inventory, activation, secret and release checks; perform representative retrieval/safety checks, then sync with backup and verify no drift.
- [x] Review diff and Git identity; commit/push only the feature branch, verify remote parity, and record final state. Never merge main. Implementation commit 38053ce9cc28944a8ed623c434a85eba6e2fd3a1 was pushed and matched the remote branch.

Bound: one independent audit worker, at most one follow-up review; at most three repair rounds. No framework execution, automatic hooks, external issue writes, main merges, or paid workers.
