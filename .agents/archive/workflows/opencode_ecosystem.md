---
description: Evaluación y adopción segura de plugins, agents, themes y herramientas del ecosistema OpenCode
---

# OpenCode Ecosystem

## Principio

`awesome-opencode` sirve para descubrir. La instalación requiere evaluación y confirmación explícita.

## Fuentes

- `awesome-opencode/awesome-opencode`
- `awesomeopencode.com`
- documentación oficial de OpenCode
- repos individuales de cada plugin/agente/theme

## Checklist de plugin

1. Repo mantenido y README claro.
2. Licencia compatible.
3. Compatibilidad Windows si aplica.
4. Qué archivos lee/escribe.
5. Qué comandos ejecuta.
6. Si toca auth, tokens, `.env` o config.
7. Si agrega hooks, MCPs o procesos background.
8. Cómo se desinstala.
9. Riesgo de lock-in o fricción.

## Categorías candidatas

### Seguridad

- `cc-safety-net`
- `envsitter-guard`

### Contexto y tokens

- `context-analysis`
- `dynamic-context-pruning`
- `tokenscope`

### Sesiones

- `opencode-sessions`
- `smart-title`
- `handoff`

### Multiagente y worktrees

- `background-agents`
- `opencode-workspace`
- `opencode-worktree`

### Skills y sync

- `opencode-skills`
- `openskills`
- `opencode-synced`

## OpenCode Studio

Puede usarse como GUI opcional para gestionar MCPs, skills, plugins, agents, perfiles, usage y backup/restore.

Reglas:

- Hacer backup antes.
- No importar deep links no auditados.
- Revisar diff de config después.
- Mantener este repo como source of truth.

## Salida esperada

```text
Componente evaluado:
Tipo: plugin / agent / theme / GUI / MCP
Riesgo:
Beneficio:
Permisos:
Instalación:
Rollback:
Veredicto: GO / NO-GO / PIVOT
```
