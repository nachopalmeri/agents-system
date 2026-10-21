# Engineering foundations — reviewed October 20, 2026

These additions turn selected ideas into task-specific decisions. They use public author/publisher material and local engineering judgment, not full-book ingestion, copied chapters or measured improvement claims.

| Task | Guidance selected | Concrete decision |
|---|---|---|
| Feature or bug | Existing TDD skill and implementer contract | Observe the expected failure, implement a passing slice, verify acceptance and affected boundaries. |
| Maintainability or design | Code review's `references/clean-code.md` | Use cohesive responsibilities, explicit side effects and useful names; justify abstractions with actual requirements. |
| AI architecture/model changes | AI production architecture's `references/ai-engineering.md` | Define evaluation cases and acceptance before comparing complexity, quality, latency and total cost. |
| Product differentiation/strategy | Product foundry's `references/zero-to-one.md` | Identify a narrow buyer, differentiated value and reachable distribution; test the riskiest assumption before expanding. |

Clean Code/Clean Coder informs maintainability and honest verification. AI Engineering informs evaluation and production tradeoffs. Zero to One informs differentiation; the falsifiable experiments and numeric thresholds are this runtime's practical adaptation. Existing project conventions and user decisions take precedence over these heuristics.

References load only through the relevant existing skill. The core skill count and top-level policy are unchanged. Product launch quotas become optional exploration tactics, and AI architecture folders become examples selected by need. The TDD recovery procedure preserves existing work rather than deleting code; delegated implementers inherit feature/bug testing requirements and commit only when authorized. The earlier Matt wiki refresh remains in this branch.

## Review and verification plan

Inspect the diff for scope, discoverable references, permission boundaries and contradictory instructions. Render generated agents from their canonical source, then check generated output, the Matt catalog and runtime graph. Run the release check and GitHub CI. Sync globals with managed backups, preserving existing local overrides. The user explicitly authorized committing, pushing and merging this update to main; this authorization does not change the runtime's default integration policy.

Documentation is maintained in the existing UADE project folder. Course links stay local to the private vault. Public repository content contains no course excerpts or private transcripts. No provider token savings or percentage quality gains have been measured.

## Public source context

- [Clean Code publisher page](https://www.informit.com/store/clean-code-a-handbook-of-agile-software-craftsmanship-9780132350884) and [Clean Code/Clean Coder publisher sample](https://ptgmedia.pearsoncmg.com/images/9780132928472/samplepages/0132928477.pdf).
- [Chip Huyen's AI Engineering companion resources](https://github.com/chiphuyen/aie-book).
- [Zero to One publisher page](https://www.penguinrandomhouse.com/books/234730/zero-to-one-by-peter-thiel-with-blake-masters/9780804139304/).
