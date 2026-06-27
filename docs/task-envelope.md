# Task Envelope

The task envelope is the common input shape for workspace-native routing. A request can come from chat, CLI, GitHub, Notion, or Slack, but the router should receive the same fields every time.

## Shape

```json
{
  "id": "task-2026-06-27-001",
  "source": "github",
  "title": "Fix login token expiry",
  "body": "Users cannot log in after token expiry.",
  "repo": "nachopalmeri/example",
  "contextRefs": ["https://github.com/nachopalmeri/example/issues/1"],
  "labels": ["bug", "auth"],
  "requestedBy": "nachopalmeri",
  "riskLevel": "medium",
  "requiresApproval": true
}
```

## Sources

- `chat`: request came from an AI chat session.
- `cli`: request came from a local command.
- `github`: request came from an issue, PR, or review event.
- `notion`: request came from a Notion task database.
- `slack`: request came from a mention, slash command, or message action.

## Routing Fields

- `title` and `body` provide semantic intent.
- `labels` provide deterministic routing hints.
- `riskLevel` and `requiresApproval` define safety gates before execution.
- `contextRefs` preserve links to source artifacts such as issues, PRs, docs, files, or task cards.
- `repo` is optional because not every task is code-related.

## Current Router Behavior

`bin/route-task.ps1` reads a task envelope, loads `agents.registry.json`, selects agents, and prints a JSON route decision.

The first implementation is intentionally rule-based:

- explicit agent mentions win;
- security, secrets, auth, MCP, and permission tasks add security review;
- code changes add the principal agent and reviewer;
- docs tasks route to docs;
- tests route to tests;
- design/UI tasks route to design;
- product and growth language routes to product/growth agents;
- high-risk tasks force approval;
- unknown tasks fall back to `agente-principal`.

This keeps the system predictable before adding external integrations.

