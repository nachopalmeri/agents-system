# Refresh Matt skill references to upstream

## Goal

Refresh the pinned Matt Pocock skill references to upstream `49dd158d1076134a641b33efb035946536778336` while preserving the local runtime's on-demand discovery, free-only delegation, and external-write authorization boundaries.

## Decisions and constraints

- Upstream has the same 38 skills; do not add skills or change preload/invocation policy.
- Refresh only upstream files changed since the current pin; preserve local wrapper adaptations and licenses.
- Wayfinder's new ticket/branch workflow remains gated: no tracker writes, labels, pushes, or PRs without explicit user authorization.
- Do not merge to `main`; validate and push only this feature branch as required by the runtime policy.

## Affected paths

- `.agents/skills-library/matt-*` changed upstream source references and `matt-catalog.json`
- `.agents/rules/matt-skills.md`, `.agents/workflows/skills_routing.md`, `.agents/skills-library/INDEX.md`, `bin/test-matt-catalog.ps1`
- `docs/matt-on-demand.md`, `docs/global-setup-2026.md`, and this plan

## Dependency order

1. Update the catalog test to require the new pinned ref and verify the exact manifest ref/hash invariants; observe the expected red result.
2. Refresh the upstream source files for changed existing skills, update per-skill hashes and source links, and add the Wayfinder permission guard.
3. Refresh catalog/runtime documentation and regenerate the skill index if its generated content requires it.
4. Run catalog, activation, graph, runtime, and release validations; inspect the diff and secrets before commit/push.

## Acceptance criteria

- Catalog pins `49dd158d1076134a641b33efb035946536778336`; all 38 upstream skill paths remain represented with matching local source hashes.
- Core-skill count, namespace, manual invocation, license, and index reachability checks stay intact.
- Refreshed upstream instructions cannot authorize external actions beyond the canonical runtime policy.
- Focused tests, runtime graph and release checks pass; branch contains no unrelated changes.

## Tests

- `pwsh -NoProfile -File bin/test-matt-catalog.ps1`
- `pwsh -NoProfile -File bin/test-skill-activation.ps1`
- `pwsh -NoProfile -File bin/check-runtime-graph.ps1`
- `pwsh -NoProfile -File bin/release-check.ps1`

## Stop conditions

Stop and report if an upstream change requires broader permissions, a destructive migration, or a new external integration. Do not merge the branch.
