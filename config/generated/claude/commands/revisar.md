---
description: "Revisar los cambios de la rama con el reviewer (P0/P1/P2 + veredicto)"
argument-hint: "[foco opcional: seguridad, release, archivo…]"
---
Revisá los cambios de la rama actual con el subagente `reviewer`, siguiendo la skill `code-review`.

- Base: `git merge-base HEAD origin/main` (o `HEAD~1` si no hay remoto).
- Foco adicional: $ARGUMENTS
- Si este cliente no tiene subagentes, aplicá vos el rol leyendo `~/.agents/agents/reviewer.md`.

Devolvé P0/P1/P2 con `archivo:línea` y el veredicto. No edites nada.
