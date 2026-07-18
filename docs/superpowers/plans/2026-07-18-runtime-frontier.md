# Runtime Frontier Hardening Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the existing single-agent-first runtime into a portable, capability-routed execution contract with explicit budgets, provider failure states, tool/MCP policy, and outcome/trajectory/cost evaluation, while preserving every existing agent, skill, adapter, and Obsidian capability.

**Architecture:** Keep `.agents/AGENTS.md`, `config/capabilities.json`, `agents.registry.json`, and the PowerShell runtime as the source of truth. Derive a machine-readable session contract from the existing task envelope and route; enforce finite budgets and policy at the loop boundary; normalize provider-specific outcomes into portable states; and expose only thin adapter pointers to Codex, Claude, Gemini, OpenCode, Devin, Cursor, Aider, Zed, and CLI. No provider SDK, MCP, plugin, or external dependency is added.

**Tech Stack:** PowerShell 7/Windows PowerShell-compatible scripts, JSON Schema 2020-12, existing JSONL traces, existing routing/eval scripts, Git hooks, and Markdown documentation.

---

## Evidence and constraints

The design incorporates the common, durable findings from Anthropic's *Building effective agents*, context engineering, long-running harnesses, and agent evals; OpenAI's Agents SDK orchestration, guardrails, tracing, and practical agent guide; Kimi Code/Kimi K3 reports on long context, Swarm, hooks, MCP, and ACP; Gemini stateful thought-signature guidance; Agent Skills conventions; OpenCode/Claude/Gemini instruction, skill, hook, and MCP layouts; MCP OAuth/security; OWASP Agentic Top 10; NIST's AI Agent Standards Initiative; OpenAI Evals; Harbor; and Terminal-Bench.

Model names are not runtime dependencies. Claims about unreleased, ambiguous, or provider-specific labels (for example “Fable 5”) must be verified against first-party documentation during implementation and represented as generic behaviors (`refusal`, `rate_limit`, `strict_tool_error`, `resume`) rather than hardcoded model names.

Existing strengths to preserve: SIMPLE/SPECIALIZED/PARALLEL/HIGH_RISK lanes; progressive disclosure through `config/capabilities.json`; `Invoke-RuntimeLoop`; sanitized JSONL events; cross-IDE canonical-hash adapters; sync/restore transactions; and 44/44 routing cases.

Non-goals: adding a permanent five-agent council, preloading all skills/MCPs, installing providers/plugins, making provider-specific prompt forks, changing the Obsidian vault, or merging/pushing `main` from the implementation worktree.

## File map

| File | Responsibility in this plan |
|---|---|
| `schemas/session-contract.schema.json` | Portable contract for objective, success criteria, invariants, route, budgets, policy, provider state, and stop reasons. |
| `schemas/provider-result.schema.json` | Provider-neutral result/status shape. |
| `config/execution-policy.json` | Lane defaults, tool/MCP allowlists, external-write gates, and denial reasons. |
| `config/routing-rules.json` | Add capability identifiers and budget class while retaining `primary` as a compatibility field. |
| `config/loop-registry.json` | Add time/token/tool/cost defaults and allowed terminal states. |
| `config/capabilities.json` | Add stable capability IDs and portable metadata without moving active components. |
| `bin/new-runtime-session.ps1` | Build and validate a session contract from a task envelope and route. |
| `bin/normalize-provider-result.ps1` | Normalize success, refusal, rate limit, tool denial, and retryable provider errors. |
| `bin/validate-runtime-policy.ps1` | Enforce route/session tool and MCP allowlists before execution. |
| `bin/invoke-runtime-loop.ps1` | Enforce cumulative budgets and explicit stop states. |
| `bin/record-runtime-event.ps1`, `config/runtime-event.schema.json` | Record usage and stop metadata without secrets. |
| `bin/install-hooks.ps1`, `bin/test-runtime-hooks.ps1` | Install opt-in managed hooks while preserving pre-existing hooks. |
| `evals/runtime-cases.json`, `bin/run-runtime-evals.ps1` | Add trajectory, loaded-component, usage, refusal, and budget assertions. |
| `bin/test-runtime-contract.ps1`, `bin/test-runtime-provider-states.ps1`, `bin/test-runtime-policy.ps1` | Focused regression tests. |
| `.agents/AGENTS.md`, `docs/architecture.md`, `docs/task-envelope.md`, `docs/world-class-workflow.md`, `README.md` | Document the contract and routing behavior; regenerate adapters afterward. |

## Task 1: Define the portable session and provider contracts

**Files:**
- Create: `schemas/session-contract.schema.json`
- Create: `schemas/provider-result.schema.json`
- Create: `bin/new-runtime-session.ps1`
- Create: `bin/test-runtime-contract.ps1`
- Modify: `schemas/task.schema.json` (optional `objective`, `successCriteria`, `invariants`, `budget`, and `policy` fields; preserve existing fixtures)

- [ ] **Step 1: Write failing contract fixtures and schema tests.** Include a simple task, a specialized task, a high-risk task, a provider refusal, and a rate-limit result. Assert required `taskId`, `objective`, `lane`, `capabilities`, `budgets`, `policy`, `stopReasons`, and `provider` fields.
- [ ] **Step 2: Run the focused test and confirm it fails because the generator/schema are absent.**
  `pwsh -NoProfile -File bin/test-runtime-contract.ps1`
- [ ] **Step 3: Implement the minimum generator.** `new-runtime-session.ps1 -TaskPath <task> [-TraceDirectory <dir>]` must call the existing router, derive capability IDs from the manifest, copy explicit criteria when present, and otherwise set a bounded default (`route selected + validation evidence`). Never load all skill files.
- [ ] **Step 4: Validate JSON shape and backward compatibility.** Existing examples without optional fields must still route and generate a contract.
- [ ] **Step 5: Run the focused test and commit.** Expected: all contract fixtures pass; no existing routing case changes.

## Task 2: Make routing capability- and budget-driven

**Files:**
- Modify: `config/capabilities.json`
- Modify: `config/routing-rules.json`
- Modify: `orchestrator/router.ps1`
- Modify: `bin/route-task.ps1`
- Modify: `bin/check-runtime-graph.ps1`
- Modify: `bin/run-runtime-evals.ps1`
- Modify: `evals/runtime-cases.json`

- [ ] **Step 1: Add failing cases** for capability selection independent of agent naming, ambiguous specialist matches, explicit parallel requests, and a simple request that must remain one agent/zero extra components.
- [ ] **Step 2: Add stable capability IDs** such as `general-implementation`, `current-research`, `frontend-design`, `academic-tutoring`, `obsidian-knowledge`, `security-review`, and `release-publication`. Each route rule declares `capability`; the existing `primary` remains a compatibility alias only.
- [ ] **Step 3: Extend `Get-AgentRoute`** to return `primaryCapability`, `capabilities`, `budgetClass`, and `selectionBasis`; resolve the executor through the manifest/registry while retaining the current `primary.id` JSON shape.
- [ ] **Step 4: Add capability reachability checks** to `check-runtime-graph.ps1` and require every capability to resolve to an active agent/skill/workflow and fixture.
- [ ] **Step 5: Run all routing evals.** Expected: current 44/44 behavior remains green and new capability assertions pass; no council is selected unless explicitly requested.
- [ ] **Step 6: Commit the routing-only change.**

## Task 3: Enforce explicit budgets and stop reasons in the loop

**Files:**
- Modify: `config/loop-registry.json`
- Modify: `config/runtime-receipt.schema.json`
- Modify: `bin/invoke-runtime-loop.ps1`
- Modify: `bin/test-runtime-loop.ps1`
- Modify: `bin/record-runtime-event.ps1`
- Modify: `config/runtime-event.schema.json`

- [ ] **Step 1: Write failing tests** for iteration, replan, wall-clock, tool-call, token-estimate, and cost limits; repeated identical failure; explicit `needs_user`; `provider_refusal`; `rate_limited`; and retryable vs non-retryable results.
- [ ] **Step 2: Extend lane defaults** with `maxWallSeconds`, `maxToolCalls`, `maxTokenEstimate`, and `maxCostUsd`, keeping current limits as safe defaults and allowing a session contract to lower them, never raise HIGH_RISK policy without approval.
- [ ] **Step 3: Implement cumulative accounting.** An action may return `usage = {toolCalls, inputTokens, outputTokens, costUsd}`. Missing usage is zero; invalid/negative usage is a blocked result. Stop before the next action when any limit is reached.
- [ ] **Step 4: Add explicit receipt fields** `stopReason`, `usage`, and `retryable`; extend terminal states with `PROVIDER_REFUSAL` and `RATE_LIMITED` while preserving existing states.
- [ ] **Step 5: Add bounded event fields** for usage and stop reason, keeping secret/redaction checks and 240-character detail limits.
- [ ] **Step 6: Run loop and event tests.** Expected: no infinite loop, deterministic terminal state, and valid receipt/event JSON.

## Task 4: Normalize provider outcomes without provider lock-in

**Files:**
- Create: `bin/normalize-provider-result.ps1`
- Create: `bin/test-runtime-provider-states.ps1`
- Modify: `schemas/provider-result.schema.json`
- Modify: `bin/invoke-runtime-loop.ps1`
- Modify: `docs/task-envelope.md`

- [ ] **Step 1: Write failing normalization fixtures** for provider success, refusal/safety stop, rate limit with retry-after, strict-tool rejection, unavailable tool/MCP, and malformed output.
- [ ] **Step 2: Implement a provider-neutral mapping** to `SUCCESS`, `PROVIDER_REFUSAL`, `RATE_LIMITED`, `BLOCKED`, or `NEEDS_USER`, including `provider`, `code`, `retryable`, `retryAfterSeconds`, and a redacted message. Do not inspect or store raw credentials.
- [ ] **Step 3: Make the loop consume normalized results** and stop/replan only when the contract permits it.
- [ ] **Step 4: Run provider-state tests and verify unknown provider payloads fail closed.**

## Task 5: Enforce tool/MCP allowlists and approval gates

**Files:**
- Create: `config/execution-policy.json`
- Create: `bin/validate-runtime-policy.ps1`
- Create: `bin/test-runtime-policy.ps1`
- Modify: `bin/new-runtime-session.ps1`
- Modify: `orchestrator/router.ps1`
- Modify: `config/opencode/opencode.jsonc`
- Modify: `SECURITY.md`

- [ ] **Step 1: Write failing policy tests** for SIMPLE read-only work, local edits, high-risk external writes, disabled MCPs, unknown tools, and explicit approval.
- [ ] **Step 2: Define generic tool names** (`Read`, `Grep`, `Edit`, `Write`, `Bash`, `Browser`) and MCP server IDs; default MCP allowlist is empty, and external writes/destructive actions require approval. Do not install or enable a server.
- [ ] **Step 3: Add policy to the session contract and route output** as `allowedTools`, `allowedMcpServers`, `requiresApproval`, and `denialReasons`.
- [ ] **Step 4: Implement fail-closed validation** before loop execution. An adapter that cannot enforce a policy must report `policy_unenforced` and require user confirmation; it must not silently broaden permissions.
- [ ] **Step 5: Keep OpenCode permissions aligned** with the policy and run the policy test plus existing sync/adapter tests.

## Task 6: Make hooks safe and portable

**Files:**
- Modify: `bin/install-hooks.ps1`
- Create: `bin/test-runtime-hooks.ps1`
- Create: `config/hooks-policy.json`
- Modify: `docs/world-class-workflow.md`

- [ ] **Step 1: Add failing tests** proving installation preserves an existing hook, writes a managed marker, is idempotent, and uninstall removes only the managed block.
- [ ] **Step 2: Implement marker-based hook composition.** Never overwrite an unmanaged hook; install only by explicit command; run the existing secret check and print a validation reminder. No network calls, plugin installation, or provider-specific hook assumptions.
- [ ] **Step 3: Run hook tests in a temporary git repository and document the opt-in behavior.**

## Task 7: Evaluate outcomes, trajectories, and cost

**Files:**
- Modify: `evals/runtime-cases.json`
- Modify: `bin/run-runtime-evals.ps1`
- Modify: `bin/test-runtime-loop.ps1`
- Create: `evals/fixtures/runtime-traces/README.md`
- Modify: `docs/architecture.md`

- [ ] **Step 1: Add failing eval assertions** for outcome correctness, loaded component count, agent count, iterations, replans, tool calls, token estimate, cost, stop state, and invariant preservation (including test count not decreasing).
- [ ] **Step 2: Add a trace fixture format** using existing JSONL events; do not require external OpenAI Evals, Harbor, Terminal-Bench, or provider APIs to run local gates.
- [ ] **Step 3: Extend `run-runtime-evals.ps1`** with `trajectory` and `cost` categories and a weighted score; keep the current 95% routing threshold.
- [ ] **Step 4: Run the complete local suite and record fresh evidence.**

## Task 8: Document and regenerate every adapter

**Files:**
- Modify: `.agents/AGENTS.md`
- Modify: `docs/architecture.md`
- Modify: `docs/task-envelope.md`
- Modify: `docs/world-class-workflow.md`
- Modify: `README.md`
- Generated: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `config/opencode/AGENTS.md`, `.cursorrules`, `.aider.conf.yml`, `.zed/settings.json`

- [ ] **Step 1: Document single-agent-first escalation, capability routing, session contract, explicit budgets/stops, provider fallback, tool/MCP policy, and outcome/trajectory/cost evals.** State that model names are optional provider configuration, not routing keys.
- [ ] **Step 2: Run `pwsh -NoProfile -File bin/render-runtime-adapters.ps1`** and inspect the diff; never hand-edit generated adapters.
- [ ] **Step 3: Run `bin/check-runtime-graph.ps1`, `bin/test-runtime-adapters.ps1`, and `bin/measure-runtime-context.ps1 -Check`; ensure canonical hash parity.
- [ ] **Step 4: Update `.agents/tasks/handoff.md` and `.agents/tasks/lessons.md` only with durable, evidence-backed decisions.**

## Task 9: Full validation and implementation handoff

- [ ] **Step 1: Run focused tests:**
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-contract.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-policy.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-provider-states.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-hooks.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-loop.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-events.ps1`
- [ ] **Step 2: Run existing gates:**
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/run-runtime-evals.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/test-runtime-sync.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/doctor.ps1`
  `pwsh -NoProfile -ExecutionPolicy Bypass -File bin/release-check.ps1`
  `git diff --check`
- [ ] **Step 3: Verify no active capability points to `.agents/archive`, no test count decreased, no new dependency was added, and no secrets appear in diff/traces.
- [ ] **Step 4: Commit and push only the feature branch.** The implementation agent must attempt execution with `gpt-5.6-luna`; if unavailable, record the explicit fallback model in the handoff and continue only with the approved fallback.
- [ ] **Step 5: Request independent review before any integration into `main`; preserve the existing backup branch and do not force-push.**

## Definition of done

- Existing 44/44 routing behavior and all current sync/adapter/loop/event tests remain green.
- Every task can produce a valid session contract with objective, success criteria, invariants, capability route, budgets, policy, provider state, and explicit stop reason.
- SIMPLE tasks load one agent and no unnecessary skills/workflows; parallel/council paths require explicit intent or evidence-based escalation.
- Budgets stop execution deterministically on iterations, replans, wall time, tool calls, token estimate, or cost.
- Provider refusal, rate limit, tool denial, and malformed responses never spin or silently broaden permissions.
- MCPs remain disabled by default; no dependency/plugin/server is installed.
- Adapter hashes are regenerated and cross-IDE checks pass.
- Outcome, trajectory, and cost evidence is available locally and is honest about unmeasured provider usage.

## Implementation handoff

Implement this plan with `superpowers:subagent-driven-development` or `superpowers:executing-plans`. Use a fresh worktree/branch, keep each task TDD and independently committed, and stop/replan after any repeated identical failure. The implementation is not complete until the verification commands above produce fresh output.
