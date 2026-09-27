---
name: obsidian-vault
description: "Trabajar con el vault de Obsidian UADE-Vault (D:\Facultad\UADE-Vault): clases Q2 2026, propuestas IA, Atlas/Dots, MOCs, Bases y apoyo visual con Mermaid. Usar cuando se trabaje en notas, clases, conceptos, evaluaciones o cualquier contenido del vault."
---

# Vault de Obsidian — UADE (Q2 2026)

Vault único vigente: `D:\Facultad\UADE-Vault` (las copias en `D:\BACKUP*` y `D:\Windows11-Backup*` son viejas). El contrato de agentes manda: **`AGENTS.md`** y `docs/FLUJO-IA.md`; el formato, `docs/ESTILO-NOTAS.md`. Procesar una clase o repasar: skill `procesar-clase-vault`.

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
