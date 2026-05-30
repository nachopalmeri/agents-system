---
description: Sincronizacion accionable con Obsidian para decisiones, retros y aprendizajes
---

# Workflow: Obsidian Sync

## Principio

Obsidian guarda memoria durable, no dumps. Cada nota debe servir para retomar una decision, aprender de un error o preparar una accion futura.

## Vault

Ruta principal:

```text
C:\Users\nacho\OneDrive\Desktop\Q1\Q1-2026-UADE
```

Estructura esperada Ideaverse Lite:

- `Atlas/Maps/` para mapas, trackers y MOCs.
- `Atlas/Dots/` para notas atomicas.
- `Proyects/` para proyectos activos o retros por proyecto.
- `Efforts/` para areas sostenidas de aprendizaje.
- `Archives/` para material cerrado.

Si la estructura no existe, crear solo la carpeta necesaria para la nota pedida. Nunca borrar ni reorganizar el vault sin confirmacion.

## Triggers

- Cierre de proyecto usando `validation.md`.
- Fin de sesion larga con decisiones relevantes.
- El usuario pide "guarda esto en el vault".
- `growth_update.md` necesita dejar evidencia de crecimiento.
- Cierre de proyecto con ADRs en `docs/adr/`: sincronizar ADRs aceptados como decisiones tecnicas en el vault.

## Modo de escritura

- Si hay MCP de Obsidian disponible: crear la nota directamente.
- Si no hay MCP pero el filesystem esta disponible: crear/editar el archivo markdown directamente dentro del vault.
- Si no hay acceso al vault: mostrar el markdown listo para pegar.

## Decision tecnica importante

Ruta sugerida:

```text
Proyects/<proyecto>/Decisiones/YYYY-MM-DD - <titulo>.md
```

Template:

```markdown
---
tags: [decision, proyecto-<slug>, <fecha>]
fecha: YYYY-MM-DD
proyecto: nombre
tipo: decision-tecnica
---
# Titulo de la decision

## Contexto
Una o dos lineas.

## Opciones evaluadas
- Opcion A: ventajas / desventajas
- Opcion B: ventajas / desventajas

## Decision tomada
Que y por que.

## Consecuencias
Que implica hacia adelante.

## Leccion
Si aplica.
```

## Cierre de proyecto

Ruta sugerida:

```text
Proyects/<proyecto>/Retros/YYYY-MM-DD - Retro <proyecto>.md
```

Template:

```markdown
---
tags: [retro, proyecto-<slug>, <fecha>]
fecha: YYYY-MM-DD
proyecto: nombre
stack:
estado: completado
---
# Retro: nombre del proyecto

## Que se construyo

## Que funciono bien

## Que fallo
- [ROUTING|OUTPUT|SCOPE|QUALITY] ...

## Lecciones candidatas a global
- Si/no por cada una, con evidencia.

## Proxima accion relacionada
```

## Aprendizaje tecnico nuevo

Ruta sugerida:

```text
Atlas/Dots/YYYY-MM-DD - <concepto-o-skill>.md
```

Template:

```markdown
---
tags: [aprendizaje, tecnologia, <fecha>]
fecha: YYYY-MM-DD
tema:
fuente: proyecto
---
# Concepto o skill

## Que aprendi

## Como lo aplico

## Recursos
```

## Reglas

- Usar frontmatter consistente.
- Preferir notas cortas y accionables.
- Usar wikilinks cuando haya una nota relacionada clara.
- No crear nota si no hay decision, aprendizaje, retro o proxima accion.
- No duplicar: si ya existe una nota del mismo cierre, actualizarla con confirmacion.

## Patron raw/wiki para knowledge management

Para proyectos con mucha informacion de referencia (inversiones, research, documentacion tecnica):

```text
raw/    → archivos originales (pdf, xls, md, email, etc.)
          Solo se ingieren, no se modifican.
wiki/   → multiples .md sintetizados por el agente
          El agente debe citar raw/ como fuente.
```

Reglas del patron:

- `raw/` es inmutable: no tocar, solo leer y citar.
- `wiki/` es la capa de entendimiento: el agente sintetiza, conecta y estructura.
- Cada nota en `wiki/` debe indicar que `raw/` la respalda.
- Si no hay raw que respalde una afirmacion, marcarlo como supuesto.

## Principio: texto plano > RAG para la mayoria de los casos

No se necesitan bases de datos vectoriales, embeddings ni pipelines de RAG para la mayoria de los casos de uso. El enfoque mas efectivo:

1. Dividir la informacion en archivos de texto (.md, .txt, .json) con nombres informativos.
2. Agregar metadatos para que sea facilmente indexable por grep/ls/find.
3. Dejar que el agente se encargue del resto: búsqueda, síntesis, conexión.

Este patron (texto plano con nombres y metadata descriptivos) supera a RAG en la mayoria de los escenarios practicos porque:

- Cero infraestructura adicional.
- Los agentes ya pueden buscar y leer archivos directamente.
- Los nombres de archivo y la estructura de directorios actuan como indice semantico.
- Wikilinks en .md permiten conectar conceptos sin embeddings.

Solo considerar RAG/vector DB cuando:

- Hay 50TB+ de datos (casos reales de big data, no la mayoria de las apps).
- Se necesita busqueda semantica sobre datos estructurados con logica de negocio compleja.
- Se requiere baja latencia en produccion con muchos usuarios concurrentes.

## Salida esperada

```text
Obsidian sync:
- Tipo de nota:
- Ruta:
- Accion: creada / propuesta / no creada
- Motivo:
- Proxima accion:
```

