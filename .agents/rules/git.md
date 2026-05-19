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

## Push obligatorio (regla durable, no de cada minuto)

> Todo cambio relacionado con agentes, skills, workflows, prompts, templates, configuración del sistema, código o infraestructura DEBE pushearse a GitHub. La regla aplica al cierre de la sesión o cambio de contexto, no a cada cambio individual.

- **Usuario:** `nachopalmeri`
- **Responsabilidad:** si el entorno no permite pushear, dejar commit/diff listo y reportar el comando exacto pendiente; no decir que esta sincronizado si el push no ocurrio.
- **Email:** `ipalmeri@uade.edu.ar`
- **Flujo:**
  1. `git add -p` o `git add -A` (revisar con `git diff --cached --stat`)
  2. `git commit -m "tipo: descripción clara"` (commits agrupados por intención, no por edit)
  3. `git push origin main` antes de cerrar la sesión, cambiar de contexto o terminar el día
- **No aceptable:** dejar trabajo sin pushear de un día para otro, "ya lo commiteo después" como excusa permanente, ni "es chiquito" como motivo para no versionarlo.
- **Aceptable:** agrupar 5-10 micro-edits en un commit coherente durante una sesión de iteración rápida.
- **Backup antes de operaciones riesgosas:** crear rama `backup/pre-cambio-YYYYMMDD-HHMMSS`.
- **Antes de push:** correr `bin/check-secrets.ps1` o `git diff --cached` para evitar leakear credenciales.

### Qué cuenta como "cambio del sistema"
- Agentes, skills, workflows, prompts, templates nuevos o modificados.
- Cambios de schema, configuración, dependencias.
- Scripts, código, infraestructura, CI/CD.
- Documentación de sistema (no notas de contenido personal).

### Qué NO cuenta
- Notas de estudio, capturas, borradores personales (viven en el vault de Obsidian).
- Contenido generado para aprendizaje propio.
