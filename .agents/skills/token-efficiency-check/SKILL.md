---
name: token-efficiency-check
description: Use when a workflow, prompt, spec, skill, or agent feels too heavy and you want to reduce context usage, remove redundant process, and keep only high-leverage instructions.
---

# Token Efficiency Check

Use this skill to simplify instructions before they become a burden.

## Objective

Reduce token cost without losing decision quality.

## Review Order

1. Remove mandatory steps that do not apply to most tasks.
2. Collapse repeated principles into one rule.
3. Move details out of the default path and into optional references.
4. Replace universal mandates with escalation criteria.
5. Keep examples only when they prevent likely misuse.

## Questions to Ask

- Does this rule help on most tasks, or only rare ones?
- Can this be an escalation trigger instead of a default step?
- Is this teaching the model something it already knows?
- Would a shorter version produce nearly the same behavior?
- Does this instruction reduce mistakes enough to justify its cost?

## Good Compression Moves

- "Always do X" -> "Do X when risk is high"
- long checklists -> 3-5 decision rules
- duplicate docs -> one source of truth
- rich templates -> tiny template plus one example

## Output

When reviewing an artifact, return:

- what to keep
- what to shorten
- what to make optional
- what to delete
