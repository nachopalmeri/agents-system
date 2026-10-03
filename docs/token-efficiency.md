# Token efficiency

Use the smallest capable model available for routine work. Prefer Luna for straightforward tasks. Keep the current primary model unchanged unless the user chooses otherwise. Use a strong model only when the task needs difficult judgment, architecture, or synthesis. Tiny tasks stay with the primary when delegation would cost more context and coordination than it saves.

For interactive work, Standard mode is the default recommendation; Fast is a manual client choice when latency matters enough to justify higher allowance consumption. Model and speed settings belong to the user/client: policy can recommend them but must not silently change them. MCPs stay off unless needed; preserve active project-required integrations rather than disabling them blindly.

Use OpenCode workers only when the candidate model is verified free, the work is bounded, independent, and non-sensitive, and the result can be checked. Give each worker a compact objective, file scope, exclusions, and output format. Do not hand off microtasks, repeat research already done, or send conversation histories when short pointers and relevant evidence are enough. If no suitable free worker is available, do the work in the primary; do not switch permissions or incur paid usage silently.

## Spend and context defaults

- Default to one model attempt for free/fast workers and cheap models. Retry only for a concrete failure, with a bounded correction; escalate only when the task warrants stronger judgment.
- Advisory output targets: up to 2,000 tokens for free-fast workers and 4,000 for free-worker/cheap workers. These are guidance, not enforced adapter caps or guarantees; necessary evidence must not be truncated. Primary output remains task-dependent.
- Plan, grill, write a spec, create tickets, or request review only when complexity, risk, or independent ownership warrants it. Skip ceremony for small changes.
- Run relevant tests once per unchanged artifact. Rerun only checks affected by a later edit, then verify the final artifact set proportionally.
- Preserve approval gates and fresh verification. Token savings never authorize external writes, sensitive disclosure, or skipped safety checks.

## Measurement (not yet measured)

Fill one row per comparable ticket. Record actual provider-reported values where available; do not infer token or cost savings from output length alone.

| Ticket | Model/backend | Primary prep/verify | Provider tokens/cost | Account usage before → after | Retries | Acceptance result |
|---|---|---|---|---|---|---|
| 1 | Not measured | Not measured | Not measured | Not measured | Not measured | Not measured |
| 2 | Not measured | Not measured | Not measured | Not measured | Not measured | Not measured |
| 3 | Not measured | Not measured | Not measured | Not measured | Not measured | Not measured |

Concurrent unrelated account activity confounds before/after usage, so that measure is directional rather than attributable to a ticket. Quotas, usage percentages, and savings are not guaranteed.
