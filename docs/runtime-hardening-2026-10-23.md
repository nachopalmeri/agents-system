# Runtime hardening — 2026-10-23

## What changed

- OpenCode bash/read requests fail closed if guard rules are absent, unreadable,
  malformed or contain invalid regexes. Repair the rules and restart OpenCode.
  Other tools are not claimed to be protected by this plugin.
- Usage logs keep bounded component identifiers, kind and date, not arguments or
  task descriptions. Existing logs are not migrated or silently deleted.
- Managed Git hooks scan secrets before commit; pre-push validates the registry
  and scans secrets. Nonzero checks block publication. `bin/install-hooks.ps1
  -Check` verifies managed content. Unmanaged hooks and custom hooksPath are not
  overwritten; integrate with an existing hook manager explicitly.
- Doctor checks installed files and effective hook presence when requested with
  `-GlobalCommands`, and states that this does not prove client/model activation.
  Global-entrypoint, hook and usage tests now run in CI.
- Workers can reuse a preinstalled official OpenCode V1 CLI only when its version
  is exactly the verified 1.18.34, with isolated XDG state. Missing private copies
  no longer force a duplicate installation. V2 remains rejected by this adapter.
- Security checks extend the existing review reference only for relevant changes.
  The memory guide no longer points to a nonexistent vault-review workflow.

These controls are defense in depth, not an operating-system sandbox. Git hooks
can be bypassed; this change does not configure GitHub branch protection or claim
that all shell command variants are recognized by regex guards.

## Verification

Observed test-first failures before fixes for guard configuration, log privacy,
hook installation/failure propagation, and the existing-CLI fallback. Local gate:

- Node guard: 31 passed; usage privacy: 56 passed.
- Git hooks: missing/outdated installation, unmanaged hooks, custom hook paths,
  successful execution and failing validation/secret-check propagation.
- All commands in `.github/workflows/validate-agents.yml`, plus the new hook,
  usage and global-entrypoint tests: `FULL_RUNTIME_GATE_OK` locally on Windows.
- The first Linux CI run exposed a stale exit code after an expected negative
  Git-hook test. The test now exits zero after success, and the shared-shell
  regression contract also covers Git hooks, usage privacy and global entrypoints.
- Managed hooks installed and checked in this checkout. Runtime changes synced
  globally with recoverable backups; pre-existing local policy/class overrides
  preserved. The global checkout registration now points to the active checkout.

Doctor deliberately still reports the pre-existing canonical-policy mismatch.
It must not silently overwrite local instructions to manufacture a green result.
Filesystem checks and fixture tests are not proof of live activation in every client.

## Free-worker experiment: inconclusive, not a savings claim

Acceptance was defined first in `examples/worker-evaluation/README.md`. Fixtures
are deliberately broken and inert; copy them outside the repo before execution.

| Task | Observed result |
|---|---|
| Official Node assert documentation lookup | TIMEOUT after 180.18 seconds; no final answer |
| Exact-file clamp fix | Not run after the initial timeout |
| Synthetic authorization review | Not run after the initial timeout |

The existing CLI reported 1.18.34. Live discovery found configured candidates
`opencode/mimo-v2.6-flash-free` and `opencode/nemotron-3.5-lightning-free`; Muse Spark
was not available in that discovery. The normal route selected the first available
configured candidate (Mimo); the timeout receipt contains no completed attempt,
provider token counts or cost. Those measurements are **unknown**, not zero.
No model quality ranking, working web-search capability or subscription savings
is established. No paid fallback, dependency installation or blind retry occurred.
Primary work includes preparing fixtures, validating the expected failing test,
running discovery/bridge and inspecting the receipt; its token cost was unavailable.

## Reproduce

```powershell
node --test bin/test-opencode-guard.mjs
pwsh -NoProfile -File bin/test-usage-log.ps1
pwsh -NoProfile -File bin/test-git-hooks.ps1
pwsh -NoProfile -File bin/test-installation-diagnostics.ps1
pwsh -NoProfile -File bin/test-global-entrypoint.ps1
pwsh -NoProfile -File bin/test-opencode-worker.ps1
pwsh -NoProfile -File bin/install-hooks.ps1 -Check
```

Run remaining CI commands from the workflow before integration. Live providers
remain an external dependency. No test suite proves that every future task works.

## Sources and integration authority

Reviewed Santi's [harness article](https://x.com/santtiagom_/status/2098782814837543075),
[skills article](https://x.com/santtiagom_/status/2030305647535751338),
[Claude Code article](https://x.com/santtiagom_/status/2035736659010969856) and
[security checklist](https://x.com/santtiagom_/status/2113244824639881687).
Useful ideas were checked against this repository rather than copied wholesale.
The user explicitly requested implementation, verification and integration into
main in this chat; default runtime policy is unchanged.
