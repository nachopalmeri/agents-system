# On-demand catalog verification — 2026-10-02

## Result

37 pinned upstream entries (27 promoted, 4 misc, 6 experimental) and two tooling evaluation guides are globally installed in the on-demand library. The 30 core skills and canonical policy/model permissions are unchanged. Existing global adapters reach the common index; no claim of native slash-command registration is made.

## Fresh evidence

- Official skill-installer imported mattpocock/skills at d81f3a183412e71a5b1e84ca21bc1a35eea03a60 into isolated staging; namespaced wrappers preserve original guides with SHA256 and MIT license, plus supporting resources. Supporting-doc backlinks were adapted from SKILL.md to GUIDE.md.
- Contract test initially failed for the missing catalog, then passed for all 37 entries: maturity/counts, namespace, guide hashes, license, disabled implicit invocation, reference links and index reachability. Markdown examples are excluded from bundled-link validation.
- test-matt-catalog passed against both the repo and C:/Users/nacho/.agents.
- Runtime graph passed: 5 registered agents, 137 repo skills reachable; inventory regression and proportional activation passed. This verifies discovery, not every workflow's end-to-end execution.
- release-check passed, including registry, catalog, graph, generated agents/commands, index, Git identity and secret scan. No critical secret findings; new warnings were reviewed as a wizard helper declaration and writing-guide prose, not credentials. Bash syntax was skipped because only the WSL launcher is available.
- PowerShell parse passed for changed scripts; git diff --check passed.
- One isolated gpt-6-luna worker audited hazardous upstream actions; a second checked three representative retrieval/safety scenarios. Both were read-only and closed. These were static application checks, not measured token-savings benchmarks.
- Managed global sync completed; -Check reports 314 destinations equal to the repo. Existing unmanaged obsidian-skills was preserved; Claude hooks were unchanged.
- Backup: C:/Users/nacho/.agents-system-sync/backups/20261002-190405479-2f2d8211/manifest.json.

## Boundaries

No framework/dependency installation, hook activation, external issue/PR writes, paid-worker fallback, main merge, prototype execution or rendering occurred. Sandcastle/Evalite are evaluation guides only. A real free OpenCode worker response remains unverified; this change does not resolve connectivity.

## Delivery

Feature branch: fix/runtime-setup-gaps. Implementation commit 38053ce9cc28944a8ed623c434a85eba6e2fd3a1 was pushed and verified equal to the remote branch. A final release-check passed after that push. Main is not merged by this task. Use this branch on another PC until the director integrates it.
