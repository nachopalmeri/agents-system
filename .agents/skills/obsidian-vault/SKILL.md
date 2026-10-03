---
name: obsidian-vault
description: "Work in the configured UADE Obsidian vault, including project documentation, classes, concepts, and evaluations; follow its folder and approval rules."
---

# Vault de Obsidian — UADE (Q2 2026)

Resolvé la raíz con `pwsh -NoProfile -File ~/bin/resolve-vault.ps1`: usa `uadeVault` en `~/.agents/local-paths.json`; sin configuración prueba la ruta histórica `D:\Facultad\UADE-Vault`. `Efforts` es una carpeta interna, no la raíz. Si falla, pedí la ruta real; no elijas backups ni crees un vault. El contrato de agentes manda: **`AGENTS.md`** y `docs/FLUJO-IA.md`; el formato, `docs/ESTILO-NOTAS.md`. Procesar una clase o repasar: skill `procesar-clase-vault`.

## Project documentation

Before documenting a project, inspect `Efforts/Proyectos/` for the matching project folder and relevant notes. Add the documentation to a relevant existing note there; if the project folder is missing, create a clearly named folder inside `Efforts/Proyectos/` and a descriptive note in it. Never overwrite unrelated notes. Do not update `Proyectos.md` or another MOC unless requested. Project documentation belongs with its project; concept/class proposals remain in `+/Propuestas IA/`.

For a substantial project learning guide or an explicit request to learn from a project, also load `skills-library/project-learning-guide/SKILL.md`. The user wants concise, visually engaging English teaching and evidence-based links to relevant UADE class notes. This does not mean documenting every small task.

## Estructura (PARA + Zettelkasten)

| Carpeta | Propósito |
|---|---|
| `Efforts/Universidad/2026/Q2/<Materia>/{Clases,Evaluaciones,MOC}` | Cursada actual: 5 materias |
| `Atlas/Dots` | Conceptos atómicos aprobados (`estado: validado`) |
| `Atlas/Utilities/{Figuras,Diapositivas}` | SVG generados y capturas de diapositivas |
| `+/Propuestas IA` | Única bandeja de borradores (`estado: propuesta`) |
| `+/Fotos` | Fotos del cuaderno o pizarrón para OCR |
| `Sources/Material Q2/<Materia>` | Texto extraído de PPTs y transcripciones |
| `Bases`, `Calendar`, `Templates`, `Archives`, `docs`, `scripts` | Vistas, daily notes, plantillas, archivo, documentación y herramientas |

Materias: Dirección de Proyectos de Tecnología (lun), Liderazgo y Negociación (mar), Ingeniería de Datos I (mié), Ingeniería de Software (jue), Diseño y Análisis de Algoritmos (vie). Material de cátedra: `D:\Q2 2026\<MATERIA>` y Drive `G:\Mi unidad\Facultad\Q2 2026`. Las fechas de evaluaciones están en el Google Calendar de Nacho.

## Reglas

- Nunca modificar `## Captura`; nunca borrar contenido; nunca `reviewed_by_user: true`.
- Propuestas sólo en `+/Propuestas IA/`; nada al Atlas ni a los MOCs sin aprobación.
- Dataview **no** está instalado: usar Bases (bloques ```base) y Tasks. Mermaid nativo y LaTeX `$...$`.
- Herramientas: `descubrir_clase.py`, `verificar_clase.py`, `mapa_clases.py`, `repaso.py`, `prompt_materia.py`, `figuras.py`, `ocr_imagen.ps1`, `diapositivas.ps1`.
