# Clean Code in practice

Load for implementation or review where naming, responsibilities, coupling or error handling affect maintainability. These are local engineering heuristics informed by Robert C. Martin's *Clean Code* and *The Clean Coder*, not a claim that the full books were read in this session.

- Use domain names and cohesive units. Extract a function or module when it makes a responsibility, invariant or dependency easier to understand; avoid arbitrary line-count limits and wrappers that only add navigation.
- Separate business decisions from I/O where that creates a useful test boundary. Keep side effects and failure handling explicit. Preserve the framework's idioms; SOLID is a design lens, not a requirement for more classes.
- Consolidate duplicated knowledge when it has the same reason to change. Similar-looking code with different responsibilities does not automatically need a shared abstraction. Add flexibility only for a demonstrated requirement.
- Refactor in small steps with relevant tests green. Preserve behavior unless the approved task changes it; report the concrete maintenance problem and evidence that the change improves it.
- Use comments for intent, constraints and surprising tradeoffs. For learning, briefly explain one consequential decision; avoid narrating every statement.
- Apply *The Clean Coder* as accountability: state what was verified, expose uncertainty and limits, and do not promise evidence you do not have.

Use unit tests for logic, integration tests for real boundaries and a small number of E2E checks for critical journeys when warranted. Test public behavior against acceptance criteria; an agent can write code and tests with the same mistaken assumption. Independent expected examples, integration evidence or human clarification address that risk.

Prefer a modular monolith until independent deployment, scaling or ownership justifies services. If a distributed boundary is needed, specify contracts, failure handling and observability. Do not import distributed-system complexity just because a task mentions microservices.

Source context: [publisher's Clean Code page and contents](https://www.informit.com/store/clean-code-a-handbook-of-agile-software-craftsmanship-9780132350884) and [publisher's Clean Code/Clean Coder sample](https://ptgmedia.pearsoncmg.com/images/9780132928472/samplepages/0132928477.pdf), checked 2026-10-20. The operational rules above are this runtime's adaptation, not quotations or a complete book summary.
