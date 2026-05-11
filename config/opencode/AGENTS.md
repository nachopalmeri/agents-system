# Reglas Globales — Nacho Palmeri / Pisculichi Labs

## Fuente Principal de Reglas
Leer ~/.agents/AGENTS.md para las reglas completas del sistema de agentes.
Archivos clave:
- rules/chat-first.md → UX chat-first y workflows invisibles
- workflows/index.md → router principal
- workflows/validation.md → cierre con evidencia
- workflows/session_checkpoint.md → continuidad en sesiones largas
- workflows/project_types.md → simple, web premium, ai-prod, spec-kit
- workflows/skills_routing.md → selección de skills
- rules/code-style.md, testing.md, git.md → reglas base

## Reglas Mínimas (resumen)
1. El usuario habla normal; el agente enruta internamente
2. Usar el menor workflow suficiente
3. No usar Spec Kit ni AI production para cambios chicos
4. Nunca marcar completado sin evidencia de validación
5. En sesiones largas, crear checkpoints compactos
6. Tras correcciones importantes, actualizar tasks/lessons.md
7. Commits en español: feat | fix | chore | style | docs
