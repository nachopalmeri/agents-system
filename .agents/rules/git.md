---
description: Convenciones de git para commits, ramas y merges
---

# Convenciones de Git

## Commits
Formato: tipo: descripción en español
- feat: nueva funcionalidad
- fix: corrección de bug
- chore: mantenimiento, dependencias, config
- style: cambios de estilo sin lógica
- docs: documentación
- test: agregado o corrección de tests

## Ramas
- main → producción, nunca tocar directamente
- agente/feature → lógica y funcionalidades
- agente/seo → optimización SEO
- agente/design → estilos y UI
- agente/tests → tests

## Reglas
- Nunca hacer merge de ramas propias → lo hace el director
- Nunca force push
- git add -p antes de cada commit (revisar cambio por cambio)
- git diff --stat antes de cualquier commit
