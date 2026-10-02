# Global runtime setup (October 2026)

This repository provides one shared global runtime for supported local coding harnesses. It keeps 30 core skills available by default and the remaining skills on demand in `skills-library/`, including 37 Matt entries (27 promoted, 4 miscellaneous, and 6 experimental). Shared adapters expose the runtime through each harness's supported conventions. Web ChatGPT cannot read this filesystem or run its CLI tools; use the local runtime from a local harness.

## Register this checkout on Windows

Use PowerShell 7 and run the setup script from this checkout:

```powershell
pwsh bin/setup-global-runtime.ps1
```

This is a local Windows installer. It backs up the local checkout pointer and managed files it replaces, and adds `~/bin` to the current user's PATH. It does not initialize projects automatically. Keep the registered checkout in place: global commands resolve repository-dependent actions through it.

To install the pinned global tools as part of setup, opt in:

```powershell
pwsh bin/setup-global-runtime.ps1 -InstallTools
```

Pinned versions: PowerShell 7.6.6, ripgrep 15.2.0, uv 0.12.22, pnpm 12.8.1, sandcastle 0.12.0, evalite 0.19.0, Vitest 4.1.2, OpenCode 1.18.34. Dependency lifecycle scripts are disabled by default; only reviewed pnpm/OpenCode native CLI hooks are explicitly rebuilt. Docker is installed but stopped; setup does not start its daemon or promise sandbox execution.

Evalite's SQLite addon cannot build on this PC's Node 24 without the C++ build toolchain. Explicit in-memory storage is available; persistent SQLite is not verified. CLI help alone does not prove live LLM evaluation or sandbox execution.

After registration, the primary `agents` shim provides `help`, `doctor`, `check`, `catalog`, `route`, `delegate`, `update`, and `tools` actions. Use `agents help` for current usage and `agents doctor` or `agents check` to inspect the local setup.

## Runtime inventory and delegation

The canonical runtime has 30 core skills plus an on-demand library. Five role files are registered. A role file describes how to perform a role; it does not create a native subagent. Native subagents are available only when the active harness exposes them. Do not create cloud chats as a substitute for delegation.

OpenCode 1.18.33's Muse free-tier probe was rejected with “free tier can only be used from within OpenCode.” Permissions were not relaxed and there is no paid fallback. Updated OpenCode 1.18.34 starts successfully; that does not establish free-provider access. The bridge recognizes this refusal even with HTTP 400, stops after one attempt and returns the task to the primary.

## Verified on this PC

Global `agents doctor`, `agents check`, `agents catalog retro` and `agents tools` passed from a PATH reconstructed only from Windows machine/user settings. All eight pinned tool commands resolve independently of Codex's bundled tools; pnpm and OpenCode report their pinned versions. Managed sync reports 316 matching destinations, preserving the unmanaged Obsidian skill and personal OpenCode configuration.

Release, global entrypoint, installation diagnostics, delegation, model-routing, Matt catalog and graph checks passed. Evalite ran one deterministic offline evaluation with explicit in-memory storage: 21 → 42, score 100%, no LLM call. Fixture: `%APPDATA%/npm/node_modules/agents-runtime-smoke`; run `evalite run --threshold 100` there. This is a smoke test, not a model-quality benchmark. Isolated Luna workers performed bounded coverage, implementation and review; no token-savings percentage is claimed.

Windows registration was exercised; other-platform installers were not. Legacy `setup-local` imports are disabled because they could overwrite canonical files or import personal configuration. Other legacy shell installers remain unverified; do not use them as a workaround.

## Current branch and safety

The current working branch is `fix/runtime-setup-gaps`; a human handles the merge. Do not use old setup examples that point to a different branch. Do not remove a checkout or a `.agents` path as a setup workaround. Inspect the installer output and use its managed backup/recovery path if repair is needed.

Never expose credentials, install unpinned tools, or write to production as part of runtime setup. Global tool installation is optional and explicitly selected with `-InstallTools`.
