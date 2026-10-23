# Runtime hardening

## Approved scope

Implement the five improvements approved in chat: fail-closed OpenCode guards,
privacy-preserving usage logs, effective non-destructive Git hooks, installed-runtime
checks, and a bounded free-worker evaluation. Repair the stale memory-review link
and reuse the existing security-review workflow rather than add another skill.
The user explicitly authorized commit, push, and integration into main for this work.
This is a one-off authorization, not a change to the default integration policy.

## Independent slices and acceptance

1. OpenCode guard + Node tests: absent/corrupt/invalid rules block protected tool
   execution with an actionable error; valid safe operations still work.
2. Usage hook + PowerShell tests: raw arguments/descriptions never reach the log;
   hostile multiline metadata cannot inject entries; logging failure stays nonblocking.
3. Git hooks + tests: existing unmanaged hooks survive; pre-push runs a bounded
   validation command and propagates failure; installation can be checked explicitly.
4. Runtime diagnostics + CI: run the existing global-entrypoint tests in CI and
   check installed artifacts without claiming that filesystem checks prove model
   activation. Extend existing diagnostics, not a second router.
5. Run representative non-sensitive free-worker tasks with fixed correctness
   checks; record real provider/model/time/usage and primary validation separately.
   Provider failure is evidence, not permission for paid fallback or repeated spins.

Example: if guard rules are invalid, a shell tool request fails before execution
and explains how to repair the rules; it never silently runs unguarded.

## Verification and closure

Observe red/green for changed behavior. Run Node guard tests, relevant PowerShell
tests and every command from `.github/workflows/validate-agents.yml`; review diff
and scan secrets before commit. Verify Git identity, remote CI and exact main SHA.
Preserve local overrides during global sync and document installed-state limits.
Update the existing project learning guide with a brief English explanation.

At most three concurrent workers, depth one. One corrective review/replan; repeated
identical external failure stops that experiment. No dependencies, permission
expansion, destructive cleanup, automatic publishing hooks, or unrelated PR merges.
