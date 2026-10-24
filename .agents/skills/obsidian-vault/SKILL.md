---
name: obsidian-vault
description: "Work in the configured UADE Obsidian vault, including project documentation, classes, concepts, and evaluations; follow its folder and approval rules."
---

# Vault de Obsidian — UADE (Q2 2026)

Read `uadeVault` in `~/.agents/local-paths.json` when present; otherwise test `D:\Facultad\UADE-Vault` directly. `Efforts` is inside the vault, not its root. `~/bin/resolve-vault.ps1` is a convenience, not a prerequisite: if nested `pwsh` cannot run, verify the candidate directory, `.obsidian/` and `AGENTS.md` with the available file tools. A shell denial does not prove the vault is missing. Ask for a path only after those checks fail; report a permission block separately. Never select backups or create a replacement vault. Read the vault's `AGENTS.md` and the relevant sections of `docs/FLUJO-IA.md` and `docs/ESTILO-NOTAS.md`. Process/review classes with `procesar-clase-vault`.

## Project documentation

Route by the requested artifact before applying the academic proposal workflow:

| Artifact | Destination and behavior |
|---|---|
| Project documentation or learning guide | `Efforts/Proyectos/<Project>/`; write/update the relevant guide when requested or at a substantial milestone. |
| New class/concept proposal | `+/Propuestas IA/`; keep proposal status and require approval for Atlas/MOC promotion. |

The academic proposal inbox is not a requirement for project guides. Read the project-specific rules if present. Infer the project from the active repository and task; do not ask what to document when that context already identifies it. Merely checking access to the vault does not require inventing a project or creating a guide.

Before documenting a project, inspect `Efforts/Proyectos/` for the matching project folder and relevant notes. Add the documentation to a relevant existing note there; if the project folder is missing, create a clearly named folder inside `Efforts/Proyectos/` and a descriptive note in it. Never overwrite unrelated notes. Do not update `Proyectos.md` or another MOC unless requested. Project documentation belongs with its project; concept/class proposals remain in `+/Propuestas IA/`.

For a substantial project learning guide or an explicit request to learn from a project, also load `skills-library/project-learning-guide/SKILL.md`. The user wants concise, visually engaging English teaching and evidence-based links to relevant UADE class notes. This does not mean documenting every small task.

## Estructura (PARA + Zettelkasten)

| Carpeta | Propósito |
|---|---|
| `Efforts/Universidad/2026/Q2/<Materia>/{Clases,Evaluaciones,MOC}` | Cursada actual: 5 materias |
| `Atlas/Dots` | Conceptos atómicos aprobados (`estado: validado`) |
| `Atlas/Utilities/{Figuras,Diapositivas}` | SVG generados y capturas de diapositivas |
| `+/Propuestas IA` | Bandeja de nuevos borradores académicos/conceptuales (`estado: propuesta`); documentación de proyectos va en `Efforts/Proyectos/<Project>/` |
| `+/Fotos` | Fotos del cuaderno o pizarrón para OCR |
| `Sources/Material Q2/<Materia>` | Texto extraído de PPTs y transcripciones |
| `Bases`, `Calendar`, `Templates`, `Archives`, `docs`, `scripts` | Vistas, daily notes, plantillas, archivo, documentación y herramientas |

Materias: Dirección de Proyectos de Tecnología (lun), Liderazgo y Negociación (mar), Ingeniería de Datos I (mié), Ingeniería de Software (jue), Diseño y Análisis de Algoritmos (vie). Material de cátedra: `D:\Q2 2026\<MATERIA>` y Drive `G:\Mi unidad\Facultad\Q2 2026`. Las fechas de evaluaciones están en el Google Calendar de Nacho.

## Reglas

- Nunca modificar `## Captura`; nunca borrar contenido; nunca `reviewed_by_user: true`.
- Nuevas propuestas académicas/conceptuales sólo en `+/Propuestas IA/`; las guías de proyectos se escriben en su carpeta de `Efforts/Proyectos/`. Nada al Atlas ni a los MOCs sin aprobación.
- Dataview **no** está instalado: usar Bases (bloques ```base) y Tasks. Mermaid nativo y LaTeX `$...$`.
- Herramientas: `descubrir_clase.py`, `verificar_clase.py`, `mapa_clases.py`, `repaso.py`, `prompt_materia.py`, `figuras.py`, `ocr_imagen.ps1`, `diapositivas.ps1`.

## Teaching requests

For teaching or creating study material, read `workflows/learning_protocol.md` on demand. Distinguish explanation, interactive practice and complete notes. Do not load it for filing, linking, renaming or ordinary vault maintenance; current vault rules govern writing and approval.
