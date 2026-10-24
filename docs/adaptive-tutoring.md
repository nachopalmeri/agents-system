# Adaptive tutoring

## Plan and implementation

1. Keep one shared on-demand protocol at `.agents/workflows/learning_protocol.md`.
2. Route explanations, interactive practice and complete notes separately through the existing tutor, class-processing, exercise and project-guide entry points.
3. Preserve the old tutor/workflow under `.agents/archive/teaching/`, update the vault study-method extension and save a simple English project guide privately.
4. Check references, release gates and representative requests; synchronize installed copies with backups before publishing the reviewed changes.

The global policy adds only a short pointer. No new active skill, model, dependency, automatic schedule, quiz chain or background process is introduced. The existing source and installed skill inventories remain unchanged.

## Behavior acceptance

| Request | Expected behavior |
|---|---|
| “Explain recursion” | Complete mechanism and example; no mandatory vault lookup or quiz |
| “Train me, one problem at a time” | Wait for an attempt, identify its exact error and give feedback before the next problem |
| “Show the full solution” | Worked solution, with an optional fresh variant rather than continued withholding |
| “Prepare class notes” | Complete class/master-summary/exercise-guide outputs under current vault rules; no interactive gate |
| “I still don't understand” | Change representation or teach the missing prerequisite rather than repeat the same words |
| “Make a full mock exam” | Complete paper and correction after submission; no prediction of the real exam result |
| A short reply | No inferred cognitive diagnosis, mood or compulsory gamification |
| “Organize these files” | No teaching protocol load just because files belong to Obsidian |

These are acceptance scenarios for instruction review, not measured model-evaluation results. No live conversation benchmark or token-savings percentage is claimed. Evaluate actual behavior during future sessions and report a concrete mode mismatch when it occurs.

## Vault installation

The repository protocol is mirrored to `docs/PROTOCOLO-APRENDIZAJE.md` in the private configured vault. Its `docs/METODO-ESTUDIO.md` links the protocol only for teaching. The same shared method applies whether the request is explanation, practice or note creation; source conventions, complete class outputs and approval boundaries take precedence over presentation preferences.

The private project guide explains the user journey, routing and persistence with a small Mermaid flow. Private notes and course content are not copied into this repository. Existing Capture, Atlas, MOC and human-review state are preserved.

## Validation boundary

Release checks verify references, registry, rendering and repository contracts. A separate reviewer inspected the main modes and the exam entry point. The exam skill was corrected so feedback during guided practice is not blocked by a full-exam-only rule. These checks do not guarantee every future model response. Installed copies retain compact local policy and existing customizations; no full-distribution overwrite is required.
