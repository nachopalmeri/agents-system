# Agent Contract Baseline

This document captures the current contract for agents in this repository before adding the workspace-native registry layer.

## Current Source Of Truth

- `.agents/AGENTS.md` defines the global operating model, routing principles, safety boundaries, and the human-readable agent list.
- `.agents/agents/*.md` contains the custom agent definitions.
- Each agent file uses YAML frontmatter followed by the agent prompt.
- `README.md` documents installation, multi-IDE setup, health checks, and daily usage.

## Current Agent File Shape

Agent files currently follow this shape:

```yaml
---
name: agente-principal
description: Short routing description and usage guidance.
model: inherit
color: cyan
tools: ["Read", "Grep", "Edit", "Write", "Bash"]
---
```

The body then defines identity, scope, process, output format, and activation guidance.

## Existing Required Fields

The practical required fields are:

- `name`: stable invocation id. Usually matches the filename without `.md`.
- `description`: routing guidance for when to use the agent.
- `model`: currently `inherit` for all custom agents.
- `color`: UI hint for compatible tools.
- `tools`: allowed tool names for that agent.

## Current Registry State

The repository already has a human-readable registry in `.agents/AGENTS.md` under `Roles de Agentes`.

Current custom agents:

- `agente-principal`
- `agente-design`
- `agente-tests`
- `agente-docs`
- `agente-seo`
- `agente-marketing-strategist`
- `agente-growth-seo-geo`
- `agente-product-founder`
- `agente-ai-architect`
- `agente-security-auditor`
- `agente-mcp-architect`
- `agente-obsidian-brain`
- `agente-code-reviewer`
- `agente-researcher`
- `agente-release-manager`
- `agente-academic-tutor`
- `agente-x-content-strategist`
- `kickoff-architect`
- `workflow-pruner`

## Gap

The current registry is useful for humans but not machine-checkable. There is no canonical metadata file for:

- deterministic routing;
- risk classification;
- approval gates;
- expected inputs and outputs;
- memory scopes;
- integration adapters such as GitHub, Notion, Slack, or CLI.

The next layer adds `agents.registry.json` and `bin/validate-agents.ps1` without changing the existing agent prompt format.

