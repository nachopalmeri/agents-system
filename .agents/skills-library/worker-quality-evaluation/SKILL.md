---
name: worker-quality-evaluation
description: "Use when comparing free OpenCode or smaller-model workers for quality, latency, token use and reliable delegation."
disable-model-invocation: true
---

# Worker quality evaluation (on demand)

Use a small benchmark to choose a reliable worker, not model reputation or an unverified free label. Evalite is a candidate tool, not installed by this skill.

1. Select 3 representative independent tasks: a primary-source lookup, a bounded local change and a verification/review. Use fixtures or approved public material; exclude credentials and private histories. Define expected answers, evidence and acceptance tests before execution.
2. Discover available candidates with the existing routing workflow. Verify free status immediately before OpenCode runs; respect authorized budgets. Set one run per candidate/task and at most one retry for a transient failure, with explicit timeout. Never silently fall back to paid models.
3. Compare correctness, source/test evidence, task-scope adherence, completion time and failure rate. Count primary validation and handoff effort, not only worker tokens. Record actual provider/model, versions, input/output/cached tokens and reported cost when available; missing telemetry is unknown, not zero.
4. Distinguish per-step usage from cumulative turn totals; never sum both. Matt's [Claude harness reproduction](https://github.com/mattpocock/harness-claude-code-usage-repro) reports a version-specific accounting issue for @ai-sdk/harness-claude-code 1.0.78. It is a caution for telemetry validation, not proof of an OpenCode bug or its current upstream status.
5. Prefer existing test tools and a compact result table first. For a TypeScript evaluation suite, consult [Evalite's official repository](https://github.com/mattpocock/evalite) and docs linked there. A new dependency/provider integration requires explicit approval; do not adopt the example's paid API calls implicitly.

Output: task/candidate results with pass/fail evidence, latency, total observed effort/cost, coverage limitations and recommended routing. Promote a worker only for task classes it passed. A successful benchmark does not guarantee all later tasks; the primary still validates.
