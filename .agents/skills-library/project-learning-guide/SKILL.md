---
name: project-learning-guide
description: "Use at a substantial project milestone or when the user wants to learn from a project. Create a concise, beautiful Obsidian learning guide that explains the product, UX, workflows, stack and code, and connects verified concepts to the user's UADE class notes."
---

# Project learning guide

Use when the user asks to understand a project, requests teaching while building, or reaches a meaningful project/feature milestone. Do not create or refresh a guide after routine edits, bug fixes, or every ticket. Keep implementation moving; teach through concise explanations at consequential decisions rather than transferring all responsibility to AI or turning work into a lecture.

## Destination

1. Resolve the configured UADE vault using `skills/obsidian-vault/SKILL.md`.
2. Inspect `Efforts/Proyectos/` for the project's existing folder and relevant notes.
3. Add/update a relevant project guide there; create a clearly named project folder and note only when none exists. Preserve unrelated notes and obey approval rules. Do not publish course notes or change MOCs/Atlas as a side effect.
4. Search university class notes and course material for concepts that genuinely illuminate this project's engineering, product or UX. Link the exact source notes with Obsidian links and briefly state the connection. Distinguish source-backed course concepts from the agent's explanation/inference. If no relevant source is found, say so; do not force a connection.

## Teaching and design

Write the guide in clear, approachable English (correct terminology, short sentences) so the user practices English while learning engineering. Teach like an excellent first-principles instructor: what problem a concept solves, intuition, how it appears in this project, a concrete example, and one useful tradeoff or improvement. Avoid claiming affiliation with any university or professor.

Keep the main guide short and scannable: a visual overview, product and user journey, key UX decisions, stack/code map, important workflows (how to run/test/deploy only when verified), 3–6 core concepts, relevant UADE connections, and a short "try this yourself" exercise or next learning priority. Aim for a compact guide, not exhaustive API documentation. Link to existing deeper docs instead of duplicating them.

Make it enjoyable and intuitive with a coherent, accessible color palette, strong hierarchy, whitespace, and purposeful visuals. Prefer original, lightweight SVG diagrams for architecture, flows, state, or concept connections; use screenshots/images only when they add real evidence or clarity. Use 3D or shader visuals, animation, or a small slide deck only when the subject benefits materially and the output remains lightweight and easy to view in Obsidian. Never add visual effects as decoration that obscures the lesson. Keep diagrams editable and colocated with the note; verify SVG rendering and links.

## Evidence and completion

- Inspect actual source code, README/project docs, scripts and tests before describing the stack or workflows; cite repo paths and relevant lines/sections where practical.
- Never invent commands, architecture, course connections, UX rationale, metrics, or implementation state. Mark uncertain points and ask only if they materially block a correct guide.
- Reuse existing diagrams and notes when accurate. Do not screenshot private/proprietary material into the vault without need.
- Verify every Obsidian link and visual target exists and that the note remains concise. Report the note path, visuals created, course notes linked, and any gaps in a short handoff.
