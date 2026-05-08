---
name: lean-project-kickoff
description: Use when starting a new project, repo, feature branch, or greenfield initiative and you want a minimal kickoff workflow that avoids over-planning, excess documentation, and token waste while still defining a clear first milestone.
---

# Lean Project Kickoff

Use this skill at the beginning of a project or when a vague initiative needs a practical first slice.

## Goal

Start with enough structure to move fast, but not so much process that the project stalls before producing value.

## Workflow

1. Define the project in 3-5 lines:
   - problem
   - user
   - desired outcome
2. Pick the smallest meaningful milestone.
3. Decide the intensity level:
   - light
   - standard
   - deep
4. Create only the minimum scaffolding needed for that first milestone.
5. Verify something observable before adding more process.

## Rules

- Do not write a formal spec unless there is real ambiguity or architectural risk.
- Do not create broad task systems for a one-session change.
- Do not optimize folder structure before proving the first workflow.
- Prefer one thin end-to-end slice over multiple partial layers.

## Recommended First Deliverables

- one working screen
- one working endpoint
- one complete user flow
- one automated script that already solves a real task

## Escalation Triggers

Add more process only if one of these appears:

- repeated confusion about scope
- too many simultaneous concerns
- architecture decisions that will be expensive to change
- repeated regressions
- multiple contributors working in parallel

## Output

Return a short kickoff note with:

- project summary
- first milestone
- chosen intensity level
- immediate next steps
