---
name: using-superpowers
description: Discover and load the smallest relevant skill when a task clearly matches one or the user requests it. Use to coordinate skill selection without preloading the whole catalog.
---

# Using Skills Efficiently

Skills are progressive capabilities, not a checklist for every turn.

## Selection rule

1. Read the available skill metadata, not every skill body.
2. Activate a skill when the user names it or the task clearly matches its trigger.
3. Prefer the smallest set that covers the work. Do not activate overlapping skills for reassurance.
4. Load the selected `SKILL.md` completely, then only references directly needed for the current decision.
5. Announce a selected skill when the client policy asks for it.

A simple explanation, typo, localized edit, or direct command normally needs no workflow skill. Security, document formats, external systems, specialized domains, and material creative work often do.

## Platform adaptation

- Claude Code may expose a Skill tool.
- Gemini clients may expose skill activation.
- Codex and generic CLI clients may read the selected `SKILL.md` directly.
- Use `references/codex-tools.md` or `references/gemini-tools.md` only when a tool-name mapping is actually needed.

Never require a vendor-specific tool that the active client does not expose. Ask through the client's available input mechanism when a real user decision is necessary.

## Proportional process

- SIMPLE: execute directly; add one focused skill only if it materially improves correctness.
- SPECIALIZED: load one domain skill or role first.
- PARALLEL: dispatch only independent work with separate ownership.
- HIGH_RISK: load the safety/approval contract before acting.

Skill instructions do not override the user's explicit scope or higher-priority safety policy. If two skills conflict, use the narrower task-specific one and record the conflict instead of loading more process.
