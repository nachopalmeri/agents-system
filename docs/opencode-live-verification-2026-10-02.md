# OpenCode live verification — 2026-10-02

## Outcome

The existing scoped delegation bridge works with OpenCode 1.18.34 and `opencode/muse-spark-1.3-contributor-free`. No binary patch, permission expansion, spoofed headers, credential change, paid fallback or dependency installation was needed in this investigation. The previous conclusion that the provider was unavailable was too broad: it came from a different, all-denied test configuration.

## Fresh evidence

All probes used an isolated, public-data scratch directory. The two successful probes invoked the actual `bin/invoke-delegation.ps1`, not a mock or direct provider API.

| Probe | Result | Reported usage |
|---|---|---|
| Normal bridge, JSON answer to 21 × 2 | SUCCESS, answer 42, no changed files; one attempt, 85.4 s | $0; input 9,416, output 52, reasoning 488, cache-read 113 |
| Normal bridge, read input.txt and create only result.json | SUCCESS; result parsed as answer 42, input/protected files unchanged; one attempt, 25.36 s, three steps | $0; input 10,628, output 259, reasoning 223, cache-read 20,819 |
| Same CLI/model, all tools explicitly denied | Provider refusal, HTTP 403, no answer | No successful usage reported |

Usage is the bridge's sum over streamed events; do not interpret it as a benchmark or measured token savings. The tiny arithmetic task is diagnostic, not a reason to delegate trivial production tasks.

Scratch evidence: `C:/Users/nacho/AppData/Local/Temp/opencode-repro-20261002/`. Files were retained for inspection, not installed as skills. Live invocation: `pwsh -NoProfile -File bin/invoke-delegation.ps1 -RequestPath <scratch>/edit-request.json`. The primary checked actual file contents, the protected canary, directory inventory and `DELEGATION_TESTS_OK`.

## Diagnosis and limits

The observed difference is compatibility with the tool/permission configuration: normal scoped permissions succeed while the all-denied configuration fails on the same version/model. This does not identify which individual denied tool triggers the provider's closed-source validation, nor prove whether the version update contributed to the earlier difference.

OpenCode's [v1.18.34 request preparation source](https://github.com/anomalyco/opencode/blob/v1.18.34/packages/opencode/src/session/llm/request.ts#L195-L200) filters tool definitions using merged permissions. Upstream reports describe the same misleading origin error when tools are disabled: [read disabled](https://github.com/anomalyco/opencode/issues/51315), [shell denied](https://github.com/anomalyco/opencode/issues/50627). These reports support a compatibility hypothesis; the provider's exact origin-validation logic is not public in the reviewed sources.

Keep current runtime gates: exact edit paths, external-directory deny, depth one, bounded steps/time, parent review and free-only candidates. If a future provider refusal occurs, stop and return to the primary; do not broaden permissions to satisfy the provider. These are tool controls, not an OS sandbox. Internal OpenCode multi-agent execution, web research, larger implementations and alternative free models remain unverified.

One isolated native Luna worker reviewed upstream sources; the primary validated the relevant pinned-source function and ran the live probes. No measurable overall token savings claimed.
