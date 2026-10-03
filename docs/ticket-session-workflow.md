# Ticket session workflow

For medium or large features, use this default workflow. Load guidance on demand; do not open GUI chats automatically.

1. Clarify only unresolved decisions using Matt's grilling guidance. Record agreed choices in one shared spec; reuse existing approved decisions.
2. Turn the spec into dependency-linked tickets. Each ticket should be an independently testable vertical slice.
3. Prefer one fresh session per substantial ticket, but create or message chats only after explicit authorization for those actions. Otherwise prepare a handoff and continue in the current session or authorized internal workers. Reference the starting commit, owned files, relevant tests and shared artifacts—not the whole history.
4. The primary session integrates the completed tickets and checks that the feature fits the spec.

Keep small, trivial, or tightly coupled work direct. For bounded independent work, use an OpenCode or Luna worker when suitable; use at most three workers, with no nested delegation. The primary remains responsible for integration.

Draft locally first. Do not publish issues, apply labels, or close tickets without explicit authorization. This workflow aims to make work easier to review and coordinate; it does not guarantee time or token savings.
