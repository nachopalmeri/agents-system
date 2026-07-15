# Runtime Optimization v1 Implementation Plan

> **For agentic workers:** Execute in order. Use test-driven development for behavior changes, keep capabilities reachable, and commit each coherent phase. Do not merge.

**Goal:** Build a compact, portable, single-agent-first runtime with deterministic routing, finite loops, executable feedback/evals, and a subject-grounded frontend workflow without deleting specialized capabilities.

**Architecture:** `.agents/AGENTS.md` is the sole editable core. `config/runtime-manifest.json` describes thin adapters and context budgets. A deterministic PowerShell router consumes JSON rules and returns a versioned lane contract. Static graph/context checks plus a fixture evaluator protect progressive loading. A small file-backed event/receipt layer makes loops and feedback auditable. Existing skills, agents, and archive knowledge remain reachable through a capability ledger.

**Tech stack:** PowerShell 7, JSON/JSON Schema, Markdown, Git/GitHub.

---

## Phase A — Foundation Runtime

### Task 1: Add failing runtime contract fixtures

**Files:**

- Create: `evals/runtime-cases.json`
- Create: `bin/run-runtime-evals.ps1`
- Test: `evals/runtime-cases.json`

**Step 1: Write the failing fixture corpus**

Create at least 30 bilingual cases with exact expected `lane`, `primary`, `maxAgents`, `approvalRequired`, `requiredComponents`, and `forbiddenComponents`. Include:

- 12 SIMPLE: explanations, typo, one-file fix, script, documentation, and false-positive Spanish words such as “preparación”, “producto”, and “producción”;
- 8 SPECIALIZED: academic tutor, Obsidian, technical SEO, growth SEO/GEO, product, AI/RAG, frontend, current research;
- 4 PARALLEL: explicit independent research requests;
- 6 HIGH_RISK: secrets, production write, payment, external DM, destructive action, and release.

At least 40% of cases are Spanish and at least 40% English. Every SIMPLE case explicitly forbids the Council component and `agente-code-reviewer` support unless the user asked for review.

**Step 2: Write a minimal evaluator**

Load each case, call `Get-AgentRoute`, compare every declared expectation, print failures, compute weighted suite/category scores, and exit nonzero below threshold.

**Step 3: Run and observe failure**

Run: `pwsh -NoProfile -File bin/run-runtime-evals.ps1`  
Expected: FAIL because the existing router has no lane/primary/budget contract and over-selects agents.

**Step 4: Commit test scaffold**

Commit: `test: add runtime routing corpus`

### Task 2: Implement deterministic lane routing

**Files:**

- Create: `config/routing-rules.json`
- Modify: `orchestrator/router.ps1`
- Modify: `bin/route-task.ps1`
- Modify: `bin/release-check.ps1`
- Test: `evals/runtime-cases.json`

**Step 1: Define ordered rule data**

Store stable reason codes, bounded phrases, primary agent, optional component, and priority. Put high-risk rules first. Keep Council explicit-only.

**Step 2: Rewrite `Get-AgentRoute` to the v1 schema**

Apply precedence: risk gate → explicit agent → explicit parallel/council → specialist → SIMPLE fallback. Always choose one primary. Support agents require explicit parallel intent or risk/review policy. Attach lane budgets from configuration.

**Step 3: Preserve backward compatibility**

For one release, include a derived `selectedAgents` array matching `primary + support`, while consumers migrate to `primary`/`support`.

**Step 4: Fix release smoke tests and identity**

Change expected Git identity to `Nacho Palmeri <ipalmeri@uade.edu.ar>`. Replace the three weak route tests with calls to the runtime evaluator.

**Step 5: Run evaluator**

Run: `pwsh -NoProfile -File bin/run-runtime-evals.ps1 -Category routing`  
Expected: 100% routing fixtures pass.

**Step 6: Commit**

Commit: `feat: add deterministic runtime lanes`

### Task 3: Create canonical core and capability preservation ledger

**Files:**

- Modify: `.agents/AGENTS.md`
- Modify: `.agents/workflows/index.md`
- Create: `config/capability-baseline.json`
- Create: `config/capabilities.json`
- Create: `bin/check-runtime-graph.ps1`
- Modify: `.agents/SKILL.md`
- Modify: `.agents/rules/chat-first.md`
- Test: `evals/runtime-cases.json`

**Step 1: Add failing graph/reachability evaluator**

Before modifying capabilities, snapshot the agent ids, active skill ids, paths, and SHA-256 values from the branch baseline into `config/capability-baseline.json`. The checker must:

- compare current registry agents and active skill directories against the versioned baseline so deleting both a capability and its ledger entry still fails;
- require one capability ledger entry and fixture id for each;
- scan active Markdown/config files while excluding archive, `.git`, generated docs, and dependencies;
- fail executable relative references that are missing or point into archive;
- allow clearly labeled historical/archive references.

Run: `pwsh -NoProfile -File bin/check-runtime-graph.ps1`  
Expected: FAIL on current missing/archive references and absent ledger.

**Step 2: Write the compact core**

Keep identity/safety pointers, chat-first behavior, T0–T3 loading, lane rules, proportional planning/validation, finite loop rule, and preservation rule. Target ≤6,000 characters.

**Step 3: Build `config/capabilities.json`**

Map all current registry agents and active skills to `automatic`, `on-demand`, `explicit-only`, or `evaluation`. Preserve unique archived playbooks as optional references, never preloads. Add aliases for old agent ids rather than deleting files.

**Step 4: Reduce the workflow index**

Convert it to intent → smallest component → escalation trigger. Remove executable references to missing/archived files or relabel archived material as optional historical reference through a reachable skill.

**Step 5: Repair active references**

Update root/core/skill references to existing active components. Add small active contracts only where required (`context_check.md`, `feedback_loop.md`) instead of reviving entire archived playbooks.

**Step 6: Run graph and capability checks**

Run: `pwsh -NoProfile -File bin/check-runtime-graph.ps1`  
Expected: PASS, 100% registry agents and active skills reachable, zero active→missing/archive executable edges.

**Step 7: Commit**

Commit: `refactor: make runtime core progressive`

### Task 4: Add runtime manifest, thin adapters, and context budget

**Files:**

- Create: `config/runtime-manifest.json`
- Create: `bin/render-runtime-adapters.ps1`
- Create: `bin/measure-runtime-context.ps1`
- Generate: `AGENTS.md`
- Modify: `CLAUDE.md`
- Create: `config/templates/root-AGENTS.md.tmpl`
- Modify: `GEMINI.md`
- Modify: `.cursorrules`
- Modify: `.aider.conf.yml`
- Modify: `.zed/settings.json`
- Modify: `opencode.json`
- Modify: `config/opencode/AGENTS.md`
- Modify: `config/opencode/opencode.jsonc`
- Test: `evals/runtime-cases.json`

**Step 1: Add failing adapter/context tests**

Assert every manifest entry exists, references the canonical path/hash marker, avoids archived workflow policy, and meets status-specific diagnostics. Measure canonical core and OpenCode instruction characters.

Run: `pwsh -NoProfile -File bin/measure-runtime-context.ps1 -Check`  
Expected: FAIL against 51,958-character preload baseline.

**Step 2: Write the manifest**

Record schema version, canonical path, active roots, exclusions, context budgets, client status/capability, repo adapter, and optional global target.

Create `config/templates/root-AGENTS.md.tmpl` with a canonical pointer and `{CANONICAL_SHA256}` placeholder. Repository/global generated copies come only from this template; no task manually copies policy text into them.

Implement `bin/render-runtime-adapters.ps1` and run it to generate repository `AGENTS.md` and other managed adapter bodies from the template/manifest. Adapter drift tests invoke the renderer in check mode. Task 3 never edits generated files.

**Step 3: Thin every adapter**

Keep only vendor import/discovery syntax and canonical pointer. Remove duplicated Council/routing/workflow prose. OpenCode instructions may load only the compact core and compact index.

**Step 4: Measure**

Run: `pwsh -NoProfile -File bin/measure-runtime-context.ps1 -Check`  
Expected: core ≤6,000 chars, OpenCode preload ≤8,000 chars, ≥80% reduction.

**Step 5: Commit**

Commit: `refactor: unify cross-ide runtime adapters`

### Task 5: Implement transactional sync and doctor parity

**Files:**

- Create: `bin/sync-runtime.ps1`
- Create: `bin/test-runtime-sync.ps1`
- Modify: `bin/setup-ide-pointers.ps1`
- Modify: `bin/sync-agents.ps1`
- Modify: `bin/doctor.ps1`
- Modify: `bin/test-system.ps1`
- Modify: `install.ps1`
- Modify: `update.ps1`
- Test: `evals/runtime-cases.json`

**Step 1: Add temp-home integration test**

Create `bin/test-runtime-sync.ps1` first. Use a temporary root and assert dry-run has no writes, sync creates managed links/copies and backup manifest, doctor sees no drift, local edit triggers drift, restore recovers prior state, and final doctor passes. Add negative cases for path escape, backup hash tampering, restore ownership mismatch, drift without `-Force`, and injected failure after the first replacement with automatic rollback.

Run before implementation: `pwsh -NoProfile -File bin/test-runtime-sync.ps1`  
Expected: FAIL because `sync-runtime.ps1` and the transactional behaviors do not exist.

**Step 2: Implement manifest-driven sync**

Resolve and validate targets, stage content, back up hashes, replace transactionally, restore on partial failure, support `-WhatIf`, `-Force`, `-Restore`, and `-HomePath` for testing.

**Step 3: Remove hardcoded paths**

Make legacy setup/update scripts delegate to `sync-runtime.ps1`. Default `test-system.ps1` to repository `.agents` when executed from the repo, not stale global state.

**Step 4: Extend doctor**

Support `-Client` and `-HomePath`; return `supported`, `unsupported`, or `not-installed`; verify hashes and OpenCode preload.

**Step 5: Run temp-home flow**

Run: `pwsh -NoProfile -File bin/test-runtime-sync.ps1`  
Expected: PASS for sync → doctor → drift detection → restore → doctor.

**Step 6: Commit**

Commit: `feat: add transactional runtime sync`

---

## Phase B — Loop & Learning

### Task 6: Add loop registry and final receipts

**Files:**

- Create: `config/loop-registry.json`
- Create: `config/runtime-receipt.schema.json`
- Create: `bin/invoke-runtime-loop.ps1`
- Create: `bin/test-runtime-loop.ps1`
- Create: `.agents/workflows/context_check.md`
- Create: `.agents/workflows/feedback_loop.md`
- Modify: `.agents/workflows/session_checkpoint.md`
- Modify: `.agents/workflows/parallel_agents.md`
- Modify: `.agents/workflows/multiagent_review_loop.md`
- Modify: `.agents/workflows/start.md`
- Modify: `.agents/workflows/validation.md`
- Test: `bin/check-runtime-graph.ps1`

**Step 1: Add failing loop behavior and inventory validation**

Create `bin/test-runtime-loop.ps1`. Test success, iteration exhaustion, replan limit, same normalized failure twice, distinct observations, invalid receipt, and every active workflow inventory entry. Run it before implementation and expect FAIL because no executable controller exists.

**Step 2: Add the loop registry and receipt schema**

Use lane defaults from the spec. Register session checkpoint, feedback, parallel work, multi-agent review, and validation/replan loops.

Implement `bin/invoke-runtime-loop.ps1` as the shared finite controller. It accepts an action scriptblock/command adapter, enforces configured iteration/replan budgets, normalizes `action + target + errorCode`, stops repeated failures, and always emits a schema-valid terminal receipt.

**Step 3: Compact active workflows**

Remove provider tutorials and universal ceremony. Make start produce useful work rather than an empty probe turn. Make council explicit-only. Define `action + target + errorCode` repeated-failure behavior and final receipt.

**Step 4: Run graph/loop checks**

Run: `pwsh -NoProfile -File bin/check-runtime-graph.ps1`  
Run: `pwsh -NoProfile -File bin/test-runtime-loop.ps1`  
Expected: both PASS with all active iterative workflows registered and budgets enforced.

**Step 5: Commit**

Commit: `feat: bound runtime loops and replans`

### Task 7: Implement sanitized event recording

**Files:**

- Create: `config/runtime-event.schema.json`
- Create: `bin/record-runtime-event.ps1`
- Create: `bin/test-runtime-events.ps1`
- Modify: `orchestrator/router.ps1`
- Modify: `bin/route-task.ps1`
- Modify: `bin/invoke-runtime-loop.ps1`
- Create: `bin/invoke-runtime-component.ps1`
- Modify: `.gitignore`
- Test: `bin/test-runtime-events.ps1`

**Step 1: Write failing tests**

Cover valid event append, unknown field rejection, secret-like value rejection, newline/prompt-body rejection, concurrent writes, JSONL parseability, UTC daily file, and 30-day cleanup.

Run before implementation: `pwsh -NoProfile -File bin/test-runtime-events.ps1`  
Expected: FAIL because the event writer/call sites do not exist.

**Step 2: Implement strict writer**

Accept only schema fields and enums; use an exclusive file handle with bounded retry; never accept arbitrary transcript fields. Add `runtime/traces/` to `.gitignore` while keeping synthetic fixtures.

Wire route events into `route-task.ps1` behind an optional `-TraceDirectory`, and iteration/replan/result events into `invoke-runtime-loop.ps1`. Tests must exercise these real call sites, not only the writer utility.

Add `bin/invoke-runtime-component.ps1` as the portable execution wrapper: it records `load` after resolving a routed component and `action` before invoking the supplied command/scriptblock. Event tests must execute the wrapper and assert all seven event types (`route`, `load`, `action`, `validation`, `replan`, `result`, plus iteration state) appear through real call sites.

**Step 3: Run**

Run: `pwsh -NoProfile -File bin/test-runtime-events.ps1`  
Expected: PASS including concurrent writer test.

**Step 4: Commit**

Commit: `feat: record sanitized runtime events`

### Task 8: Connect lessons, outcomes, and eval receipts

**Files:**

- Modify: `.agents/tasks/lessons.md`
- Modify: `.agents/memory/lessons-global.md`
- Modify: `.agents/memory/outcome-scores.md`
- Modify: `.agents/workflows/feedback_loop.md`
- Modify: `bin/run-runtime-evals.ps1`
- Modify: `bin/test-system.ps1`
- Test: `evals/runtime-cases.json`

**Step 1: Add failing feedback/outcome fixtures**

Add cases for correction→candidate, repeat+fixture link, promotion without confirmation rejection, outcome score, and unknown outcome. Run `pwsh -NoProfile -File bin/run-runtime-evals.ps1 -Category feedback` before implementation and expect FAIL.

**Step 2: Normalize lesson state**

Add candidate/active/promoted/rejected status and evidence/fixture fields. Preserve existing lessons; do not auto-promote.

**Step 3: Implement outcome reporting**

Report objective 40, evidence 25, no correction 20, budget 15, or `unscored` when the real outcome is unknown. Keep synthetic eval score separate.

**Step 4: Connect validation/result call sites**

Make the aggregate test/validation path record `validation` and `result` events when a trace directory is supplied. The feedback workflow consumes receipts/events and writes only candidate lesson records; promotion remains a human-reviewed file change.

**Step 5: Run full evals**

Run: `pwsh -NoProfile -File bin/run-runtime-evals.ps1`  
Expected: ≥95% overall and 100% safety/reference/adapter.

**Step 6: Commit**

Commit: `feat: connect feedback to runtime evals`

---

## Phase C — Visual Quality

### Task 9: Rewrite the frontend skill around subject grounding

**Files:**

- Modify: `.agents/skills/frontend-design/SKILL.md`
- Create: `.agents/skills/frontend-design/reference/visual-qa-rubric.md`
- Modify: `.agents/agents/agente-design.md`
- Modify: `config/capabilities.json`
- Test: `evals/runtime-cases.json`

**Step 1: Add failing visual contract fixtures**

Assert material requests require: subject/audience/job, two or three references, one subject-linked signature, system decisions, wireframe choice, 390×844 and 1440×900 screenshots, optional tablet breakpoint, 18-point rubric, and fixes. Assert a one-line style fix does not trigger the full workflow.

Run before editing the skill: `pwsh -NoProfile -File bin/run-runtime-evals.ps1 -Category visual`  
Expected: FAIL because the current skill has no enforceable grounding/evidence contract.

**Step 2: Compact and rewrite the skill**

Remove contradictory generic examples and nonportable `AskUserQuestionTool`/“STOP” language. Preserve the seven specialist reference files. State that glass, glow, gradients, cards, dark mode, 3D, and fashionable fonts are allowed only with subject rationale.

**Step 3: Add the rubric**

Score nine dimensions 0–2; every dimension ≥1 and total ≥14. Define evidence paths and iteration budget.

**Step 4: Align the design agent**

Make it a thin compatibility role pointing to the skill and actual available tools, without duplicating the workflow.

**Step 5: Run visual evals**

Run: `pwsh -NoProfile -File bin/run-runtime-evals.ps1 -Category visual`  
Expected: 100% visual contract fixtures pass.

**Step 6: Commit**

Commit: `refactor: ground frontend design in subject evidence`

### Task 10: Remove universal skill cascades and nonportable pauses

**Files:**

- Modify: `.agents/skills/using-superpowers/SKILL.md`
- Modify: `.agents/skills/brainstorming/SKILL.md`
- Modify: `.agents/skills/*/SKILL.md` only where nonportable pause syntax is present
- Modify: `.agents/workflows/skills_routing.md`
- Test: `bin/check-runtime-graph.ps1`

**Step 1: Add lint fixtures**

Fail universal “use before any response”, one-percent trigger thresholds, unavailable tool names, and unconditional stop/approval language outside high-risk policy.

Run before editing skills: `pwsh -NoProfile -File bin/check-runtime-graph.ps1`  
Expected: FAIL on existing universal triggers and nonportable pause syntax.

**Step 2: Make triggering proportional**

Use skill metadata/discovery first. Brainstorming is required for ambiguous or material creative/product behavior, not typo/simple fixes. Planning is required by complexity/risk, not all work.

**Step 3: Replace vendor-specific interactions**

Use portable prose such as “ask the user through the client’s available input mechanism” and allow autonomous continuation when prior authorization exists.

**Step 4: Run lint and full evals**

Run: `pwsh -NoProfile -File bin/check-runtime-graph.ps1`  
Run: `pwsh -NoProfile -File bin/run-runtime-evals.ps1`  
Expected: both PASS.

**Step 5: Commit**

Commit: `refactor: make skill activation proportional`

---

## Phase D — Integration, Local/Remote Delivery

### Task 11: Consolidate checks and validate rollback

**Files:**

- Modify: `bin/test-system.ps1`
- Modify: `bin/release-check.ps1`
- Modify: `bin/check-agents-system.ps1`
- Modify: `bin/README.md`
- Modify: `.agents/docs/setup-guide.md`
- Modify: `.agents/tasks/todo.md`

**Step 1: Make one aggregate gate**

Run graph, capability, context, route eval, event tests, sync temp-home test, agent validation, PowerShell parse, and secrets. Avoid running the same check twice.

**Step 2: Validate rollback in a temporary home**

Run dry-run → sync → doctor → drift test → restore → doctor, including the negative tampering/path/partial-failure cases. Store only temporary evidence, not personal config content.

Create a temporary local clone from the branch and run `git revert --no-edit` for each coherent Foundation, Loop & Learning, and Visual Quality commit group in reverse order, executing the pre-v1 baseline checks after each group. Delete the temporary clone after evidence is captured; never revert the real branch.

**Step 3: Run full gate**

Run: `pwsh -NoProfile -File bin/release-check.ps1`  
Expected: exit 0 with named evidence for every acceptance criterion.

**Step 4: Perform managed real local sync**

Run: `pwsh -NoProfile -File bin/sync-runtime.ps1 -WhatIf`  
Inspect targets, then run real sync and `pwsh -NoProfile -File bin/doctor.ps1`.

**Step 5: Update task review**

Mark completed items and record metrics, commands, residual experimental adapters, backup manifest, and rollback command in `.agents/tasks/todo.md`.

**Step 6: Commit**

Commit: `chore: integrate runtime release checks`

### Task 12: Independent review, final verification, and remote parity

**Files:**

- Review: all changes against `main`
- Modify only if review finds defects

**Step 1: Run independent code/spec review**

Reviewer checks preservation, security, routing false positives, sync path safety, event sanitization, and acceptance evidence. Fix every blocking finding and rerun affected tests.

**Step 2: Execute final commands**

```powershell
pwsh -NoProfile -File bin/check-runtime-graph.ps1
pwsh -NoProfile -File bin/measure-runtime-context.ps1 -Check
pwsh -NoProfile -File bin/run-runtime-evals.ps1
pwsh -NoProfile -File bin/test-runtime-events.ps1
pwsh -NoProfile -File bin/test-runtime-sync.ps1
pwsh -NoProfile -File bin/validate-agents.ps1
pwsh -NoProfile -File bin/test-system.ps1 -AgentsRoot .agents
pwsh -NoProfile -File bin/check-secrets.ps1
pwsh -NoProfile -File bin/release-check.ps1
git diff --check
```

Expected: all exit 0; runtime score meets thresholds; no critical secret finding.

**Step 3: Commit final review fixes**

Commit: `fix: address runtime optimization review`

**Step 4: Push and verify exact SHA**

```powershell
git push -u origin agente/runtime-optimization-v1
git fetch origin agente/runtime-optimization-v1
git rev-parse HEAD
git rev-parse origin/agente/runtime-optimization-v1
```

Expected: both SHAs are identical. Do not merge.
