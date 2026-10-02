---
description: Preparar el repaso de una materia UADE antes de un parcial o final
argument-hint: "<materia>"
---
Preparé el repaso de esta materia: {{args}}

Ejemplo: `/repaso datos` · `/repaso software`.

Resolvé la raíz con `pwsh -NoProfile -File ~/bin/resolve-vault.ps1` y seguí **"Repasar `<materia>`" en `AGENTS.md`** del vault.

1. Corré `python scripts/repaso.py <materia>` (proyectos, liderazgo, datos, software, daa).
2. Confirmá la fecha de la evaluación en Google Calendar. Si no está cargada, decilo; no la inventes.
3. Creá `Efforts/Universidad/2026/Q2/<Materia>/Evaluaciones/Repaso - <evaluación>.md` con: qué entra por clase (links a las notas), ejercicios tipo de exámenes reales de `Sources/`, puntos débiles y dudas abiertas, y un plan por días hasta la fecha.
4. No toques `## Captura` ni el Atlas; los conceptos nuevos van a `+/Propuestas IA/`. Nunca `reviewed_by_user: true`.
5. Verificá las notas de clase que toques con `python scripts/verificar_clase.py "<nota>"`. Commit sólo si Nacho lo pide. Español rioplatense.
