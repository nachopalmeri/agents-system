# Runtime additions reviewed — October 18, 2026

## Adopt

Keep Matt Pocock's 38 skills loaded on demand at `49dd158d1076134a641b33efb035946536778336`. Upstream main was still at this October 9 revision when checked. The repository already contains it; older local installations need synchronization rather than another skill collection.

The changes since `b0618bc` fix wizard dotenv decoding, update the shell variable after writing a value, provide a terminal-clear fallback, and wrap interactive stages so edits during execution do not interrupt parsing. The other commit explains why retro needs writing-for-agents even when evaluating rather than editing instructions. [Upstream comparison](https://github.com/mattpocock/skills/compare/b0618bc436ad893b3c5e84e55fba86586d34a404...49dd158d1076134a641b33efb035946536778336)

Run the focused regression fixture with an existing Bash:

```sh
bash evals/fixtures/matt-wizard.sh
```

It checks syntax, simple quoted dotenv decoding, refusal of ambiguous values, literal round trips, shell-variable assignment, idempotent updates and the stage wrapper. It extracts only the helper library; it never executes example credential or CI provisioning. It does not test interactive terminal behavior or editing a running script. No new dependency is needed.

## Keep as optional research

[Harness²](https://github.com/google-research/harness2) proposes harness changes, probes candidates and composes improvements. Its documented benchmark setup uses Linux and Python 3.12; model-backed execution incurs API costs. Its default Codex executor disables the sandbox. It is not an officially supported Google product. Do not add it to the daily runtime. [Setup](https://github.com/google-research/harness2/blob/main/docs/SETUP.md)

Borrow its baseline-comparison method: assess one proposed instruction change on representative tasks with fixed conditions, recording correctness, elapsed time and total token usage. Candidate runs and primary preparation/review count toward cost. A quality gain or a free provider does not establish token savings. This is an evaluation recommendation, not an installed recursive process. [Experiment guide](https://github.com/google-research/harness2/blob/main/docs/EXPERIMENTS.md)

[Skill Issue](https://skill-issue.in/) is a skill-discovery directory with an optional remote MCP. Use it as an occasional shortlist, then review the original upstream skill. Do not bulk-install its catalog or add an always-connected MCP: neither has demonstrated a benefit for this runtime. The site's source repository and MCP request retention were not verified. Its [privacy policy](https://skill-issue.in/privacy) claims no analytics, while the fetched homepage included a Cloudflare Insights script; actual collection was not independently established.

These decisions add no new active skills, plugins, MCP servers, paid providers or automatic loops. Existing local permission boundaries and compact core instructions remain in effect.

## Verification

The new fixture failed against the previously installed wizard and passed against the current source and both global wizard entry points. Source and global catalog checks passed with 38 references. The global runtime's existing 14 active skills were preserved. Reviewed library files and both existing wizard templates were synchronized with backups; no full-core sync was performed. Interactive terminal behavior remains outside the fixture's coverage.
