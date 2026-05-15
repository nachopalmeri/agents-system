# OpenCode ecosystem

Este sistema puede apoyarse en el ecosistema OpenCode, pero no instala plugins externos automáticamente.

## Fuentes recomendadas

- `awesome-opencode/awesome-opencode`: lista curada de plugins, themes, agents, projects y recursos.
- `awesomeopencode.com`: catálogo visual del ecosistema.
- Documentación oficial de OpenCode para config, agents, permissions, MCP y plugins.

## Categorías útiles

### Seguridad

- `cc-safety-net`: safety net para comandos destructivos.
- `envsitter-guard`: prevención de leaks de `.env`.

### Contexto y tokens

- `context-analysis`: análisis de uso de contexto.
- `dynamic-context-pruning`: poda dinámica de contexto.
- `tokenscope`: análisis de tokens y costos.

### Sesiones y handoff

- `opencode-sessions`: gestión de sesiones.
- `smart-title`: títulos automáticos.
- `handoff`: prompts de handoff entre sesiones.

### Multiagente y worktrees

- `background-agents`: delegación async.
- `opencode-workspace`: orquestación multiagente.
- `opencode-worktree`: gestión de worktrees.

### Skills y sync

- `opencode-skills`: gestión de skills.
- `openskills`: alternativa de gestión de skills.
- `opencode-synced`: sync de configuración entre máquinas.

## Política de adopción

Antes de instalar cualquier plugin:

1. Revisar README y mantenimiento.
2. Revisar qué archivos toca.
3. Revisar permisos y comandos que ejecuta.
4. Confirmar si maneja auth, tokens o `.env`.
5. Confirmar cómo desinstalarlo.
6. Probar en entorno aislado o perfil separado.
7. Documentar decisión en `CHANGELOG.md` si se adopta.

## Regla final

`awesome-opencode` sirve para descubrir, no para instalar sin pensar. Todo plugin externo requiere evaluación y confirmación explícita.
