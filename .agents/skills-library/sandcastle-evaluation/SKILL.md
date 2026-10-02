---
name: sandcastle-evaluation
description: "Use when evaluating Sandcastle for isolated multi-harness orchestration, OpenCode/Codex workers or reusable sandboxes."
disable-model-invocation: true
---

# Sandcastle evaluation (on demand)

This is an evaluation guide, not an installed framework or a replacement for the current delegation workflow.

1. Read the current delegation policy and inspect the existing launcher before adding infrastructure. Confirm the task needs isolation or environment reuse; small independent tasks can keep the direct launcher.
2. Verify current features against the [official README](https://github.com/mattpocock/sandcastle/blob/main/README.md). As reviewed on 2026-10-02, adapters include OpenCode and Codex; createSandbox reuses a container, dependencies and build artifacts between runs. OpenCode is non-resumable there, so structured-output maxRetries requiring resume is unavailable. Recheck rather than assuming versions match.
3. Propose an explicit feature branch, disjoint worker ownership, max 3 workers, depth 1, timeouts and at most 3 iterations/1 replan. Integration remains with the primary; no main merge. noSandbox is not OS isolation. Evaluate Windows/Docker/Podman prerequisites rather than claiming they work on this PC.
4. Before an authorized pilot, inspect scripts and obtain explicit approval for new dependencies, container setup, paid infrastructure or persistent hooks. Exclude credentials/private session histories from mounts and external prompts. Worktree/container cleanup must preserve user data and follow destructive-action approval.
5. Require one bounded real task, observed provider/model/free status, tests, diff and artifact evidence. A CLI listing is not a successful worker. If a verified-free worker fails, return the reason to the primary without paid fallback or expanded permissions.

Output: adopt/defer recommendation, evidence, prerequisites, cost when available, permission boundaries and one next step. Do not claim installed, connected, isolated or cost-free without actual verification.
