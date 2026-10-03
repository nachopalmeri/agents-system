# Verified OpenCode worker — 2026-10-03

The worker bridge uses the repository-pinned official `opencode-ai@1.18.34` through `bin/opencode-worker.ps1`. OpenCode V2 remains the user's default CLI. The wrapper keeps V1 data, config, cache and state under `~/.agents-tools/opencode-v1/runtime` and restores the caller environment. This avoids opening the incompatible V2 database or inheriting its global MCP integrations.

Install location: `~/.agents-tools/opencode-v1`. Missing installation fails clearly and does not install automatically. Installation always requires explicit user authorization. Direct `-OpenCodeCommand` remains available for offline fixtures or an explicitly chosen client; V2 is rejected before inference because the current bridge does not supply a verified V2 configuration adapter.

Two real native Muse Spark Free calls succeeded on 2026-10-03. The second used the default bridge with no special CLI argument: SUCCESS, no changed files, no tool errors, 13.6 seconds, reported provider cost USD 0. The receipts cover streamed worker events only, not the primary's total token consumption.

The earlier empty catalog and authentication conclusions were too broad. The installed V2 native free call did receive a 403, but the compatible isolated V1 client completed the same synthetic task. No credential migration, provider login, billing, paid model, fake client identity or policy bypass was used.

Validation: existing delegation regression suite; V2 fails closed; wrapper preserves environment; source/install hashes match; diff check. Free availability can change, so retain the free-only selection gate and bounded attempts. A provider refusal returns work to the primary.
