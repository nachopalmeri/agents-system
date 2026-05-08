---
name: obsidian-vault
description: Trabajar con el vault de Obsidian Q1-2026-UADE. Estructura PARA, Zettelkasten, Dataview, MOCs, templates de clase y daily notes. Usar cuando se trabaje en notas, clases, proyectos o cualquier contenido del vault.
---

# Obsidian Vault — Q1-2026-UADE

## Activación
- Cuando el usuario pida crear/editar notas en el vault
- Cuando se mencione Obsidian, notas, clases, MOC, flashcards
- Cuando se trabaje en la ruta `C:\Users\ignac\OneDrive\Desktop\Q1\Q1-2026-UADE\`

## Estructura del Vault (PARA + Zettelkasten)

| Carpeta | Propósito |
|---|---|
| `Proyects/` | Proyectos activos (JobBot, Dulces Creaciones) |
| `Efforts/A Q1 2026/` | Estudios universitarios (5 materias) |
| `Atlas/Maps/` | Mapas de contenido (MOCs globales) |
| `Atlas/Dots/` | Notas atómicas (Zettelkasten) |
| `Atlas/Utilities/` | Recursos (imágenes, etc) |
| `Archives/` | Archivados |
| `Calendar/` | Daily notes |
| `Clippings/` | Recortes web |
| `Templates/` | Plantillas (Clase, Daily Note, Checklist) |
| `+/` | Inbox (notas sin clasificar) |

## Materias Q1 2026
- Redes de Datos
- Paradigma Orientado a Objetos (POO)
- Algoritmos y Estructura de Datos II (AED II)
- Fundamentos de la Economía
- Gestión de Personas en Organizaciones

## Frontmatter Obligatorio

### Para clases:
```yaml
---
materia: [nombre]
fecha: YYYY-MM-DD
tipo: clase
estado: en-progreso|completada
relacion:
  - "[[Clase anterior]]"
  - "[[Clase siguiente]]"
notebooklm: [id o vacío]
---
```

### Para daily notes:
```yaml
---
date: YYYY-MM-DD
sleep: [horas]
exercise: [minutos]
study_hours: [horas]
mood: [1-5]
tags:
  - daily
  - habit-tracker
---
```

### Para proyectos:
```yaml
---
estado: activo|pausado|completado|abandonado
energia: profunda|superficial
fecha_inicio: YYYY-MM-DD
fecha_objetivo: YYYY-MM-DD
---
```

## Templates Disponibles
- `Templates/Template - Clase.md` — Notas de clase
- `Templates/Template - Daily Note.md` — Nota diaria con hábitos
- `Templates/PLUGINS Checklist.md` — Referencia de plugins

## Dataview Queries Comunes

### Clases recientes de una materia:
```dataview
TABLE fecha, estado
FROM "Efforts/A Q1 2026/[MATERIA]"
WHERE tipo = "clase"
SORT fecha DESC
```

### Proyectos activos:
```dataview
TABLE estado, energia, fecha_inicio, fecha_objetivo
FROM "Proyects"
WHERE estado = "activo"
SORT fecha_inicio DESC
```

### Inbox sin clasificar:
```dataview
TABLE file.folder AS "Ubicación"
FROM "+" OR "Clippings"
WHERE !contains(file.path, "Templates")
SORT file.mtime DESC
LIMIT 10
```

## Agentes del Vault (My Brain Is Full Crew)
- scribe → Captura y refine notas
- sorter → Triaje de inbox
- seeker → Búsqueda en vault
- connector → Conexiones y MOC
- librarian → Salud del vault
- transcriber → Transcripción
- postman → Email y calendario

## Reglas Inmutables
1. NUNCA borrar notas existentes — solo archivar o mover
2. Usar templates para nuevas notas
3. Frontmatter consistente en todas las notas
4. Wikilinks `[[nota]]` para conexiones, nunca links relativos
5. MOCs se actualizan automáticamente con Dataview
6. Flashcards: formato `Pregunta :: Respuesta` para Spaced Repetition
7. Notas atómicas en `Atlas/Dots/`, MOCs en `Atlas/Maps/`
8. Commit semántico: feat/fix/chore/docs

## Comandos Útiles (si obsidian-cli está instalado)
```bash
obsidian read file="Mi Nota"
obsidian create name="Nueva Nota" content="# Título" template="Template - Clase" silent
obsidian search query="término" limit=10
obsidian daily:read
obsidian daily:append content="- [ ] Nueva tarea"
obsidian property:set name="estado" value="completada" file="Mi Nota"
```
