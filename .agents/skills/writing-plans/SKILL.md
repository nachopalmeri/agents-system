---
name: writing-plans
description: Plan multi-file or multi-step implementation with material dependencies or risk; small direct changes do not need a saved plan.
---

# Writing plans

Announce this skill when selected. For more than three meaningful steps, multiple files or risk, record a compact plan in `docs/superpowers/plans/YYYY-MM-DD-<feature>.md` (user location wins). Reuse an approved spec; ask only unresolved material choices. Keep tiny changes direct.

Include goal, decisions/constraints, affected paths, dependency order, acceptance criteria, exact relevant test commands, and stopping conditions. Use meaningful vertical slices; do not create a ticket/session/commit for every 2–5 minute edit. Include code only where a fragile contract needs it, not an entire speculative implementation.

Review the plan once for missing prerequisites, permissions and testability. An independent reviewer is useful for unresolved architecture, substantial integration or risk—not mandatory per chunk. At most one corrective review before replan/block; never assert human approval from an agent review.

When execution is requested, continue without asking permission again for already-authorized local work. Delegate only independent, reliable units under the runtime policy; coupled work stays primary. No automatic worktree, visible chat, installation, external publication or main merge. Prefer a suitable existing checkout; isolate genuinely conflicting writes.

For medium/large features select `../../workflows/ticket_sessions.md`; for execution with independent workers select `../subagent-driven-development/SKILL.md`. Read only the selected guidance, not every workflow or template.
