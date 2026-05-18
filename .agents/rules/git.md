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

## Push obligatorio (regla inquebrantable)

> Todo cambio relacionado con agentes, skills, workflows, prompts, templates, configuración del sistema, código o infraestructura DEBE pushearse a GitHub.

- **Usuario:** `nachopalmeri`
- **Email:** `ipalmeri@uade.edu.ar`
- **Flujo obligatorio:**
  1. `git add -A` (o `git add -p` si querés revisar)
  2. `git commit -m "tipo: descripción clara"`
  3. `git push origin main`
- **Sin excepciones.** Ni "después lo commiteo", ni "es un cambio chico", ni "es temporal".
- **Backup antes de operaciones riesgosas:** crear rama `backup/pre-cambio-YYYYMMDD-HHMMSS`.

### Qué cuenta como "cambio del sistema"
- Agentes, skills, workflows, prompts, templates nuevos o modificados.
- Cambios de schema, configuración, dependencias.
- Scripts, código, infraestructura, CI/CD.
- Documentación de sistema (no notas de contenido personal).

### Qué NO cuenta
- Notas de estudio, capturas, borradores personales (viven en el vault de Obsidian).
- Contenido generado para aprendizaje propio.
