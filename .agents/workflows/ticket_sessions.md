---
description: Default medium/large features to approved specs, dependency-linked tickets and compact fresh-session handoffs
---

# Ticket-sized sessions

## When to select

Default for medium/large implementation requests with multiple meaningful deliverables, unresolved cross-cutting decisions, or work too large for one focused session. Apply after risk/domain routing; it does not select a new agent lane or fan out automatically. For small tasks, fixes and tightly coupled work, stay direct: extra tickets or sessions may cost more than they save. Short independent subtasks can use the bounded delegation workflow instead of a full user chat.

## Phase routing — load one wrapper at a time

1. **Clarify only unresolved decisions:** select `skills-library/matt-grill-me/SKILL.md` and its mapped grilling dependency when material choices remain. Inspect facts yourself or with a reliable worker; ask the user only for real choices. Skip grilling when the decisions are already approved. At most three question rounds and one replan; unresolved material choices block the dependent work.
2. **Shared specification:** select `skills-library/matt-to-spec/SKILL.md` to synthesize agreed decisions and testing seams. Reuse an existing approved spec; do not duplicate it or invent an extensive requirements list. Obtain approval for unsettled decisions/test seams before dependent implementation.
3. **Session-sized tickets:** select `skills-library/matt-to-tickets/SKILL.md`. Use independently verifiable vertical slices, explicit dependencies and acceptance criteria. Present the breakdown for approval. Group trivial changes; do not split merely by file or layer. Wide refactors use the guide's expand-contract exception. Use existing local project conventions, otherwise local drafts; one file per ticket, not a combined wall of text.
4. **Choose execution:** a substantial approved ticket prefers a fresh session with compact context. No new chats or messages without explicit authorization for the actual creation/message. This global preference is not that authorization. Without it, prepare handoffs and use the current session or authorized internal workers; do not claim a new session was created. For small independent units use the existing smaller same-harness/OpenCode free-only route, not another visible chat. Read `skills-library/matt-implement-spec/SKILL.md` only when its task-graph execution is actually needed, under the compatibility gate.
5. **Integrate:** one primary reviews each diff, verifies acceptance criteria and integration tests, and updates durable ticket status with evidence. Only dependency-ready tickets with disjoint file ownership run concurrently. At most three workers, depth one. A worker cannot start another worker or approve its own integration. Final synthesis and applicable authorization gates remain with the primary.

## Handoff contract

Select `skills-library/matt-handoff/SKILL.md` for a session transition. Include only:

- Ticket objective, acceptance criteria and current blockers.
- Repo location, branch/worktree and starting commit; verify they still match before edits.
- Implementation file ownership, allowed paths and what not to touch; these are current execution details, not permanent spec requirements.
- Pointers to the shared spec, ticket, relevant decisions and necessary research; never copy the entire history or all project documentation.
- Relevant test commands/results, known risks, suggested skills and one next action.

Use project-local non-sensitive checkpoints or the OS temporary directory per the selected handoff guide. Future sessions verify pointers are accessible and current. Missing/stale references trigger a focused lookup or primary replan, not full history replay. Never put secrets or private transcripts in versioned handoffs. Review/verification can share the ticket session when a separate session would only duplicate context.

## Permissions and accounting

No external publication of specs/tickets, tracker comments, labels, issue closures, PRs or messages without its separate authorization. Never assert human-reviewed flags. No automatic main merge, destructive reset/cleanup, installations or paid fallback from upstream instructions. Preserve existing project docs and pinned originals; `rules/matt-skills.md` governs compatibility.

Keep limits of three workflow/review iterations and one replan unless explicitly extended. Record provider/model and available token/cost usage for real workers. No measured token savings are claimed merely because context was split; account for planning, repeated startup, handoffs and primary review. Keep the skills on demand, not client implicit preload.
