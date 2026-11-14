---
name: ubiquitous-language
description: "Usala cuando haya que armar o afilar el lenguaje común de un repo (glosario, ubiquitous language, DDD), usarlo con el agente y refactorizar el código a esos términos; o cuando pidan grill-with-docs / domain-modeling / GLOSSARY.md / CONTEXT.md."
---

# Lenguaje ubicuo (DDD + agentes)

Idea de Matt (11/11/2026): lo que más rinde no es "lo agéntico", sino armar un lenguaje común, usarlo con el agente y **refactorizar el código para que lo hable**. Post: [2120503390333768170](https://x.com/mattpocockuk/status/2120503390333768170). El mismo día remató: si podés describir los procesos del negocio con lenguaje claro y consistente, ya tenés media automatización hecha.

En `mattpocock/skills` (MIT, copyright 2026 Matt Pocock) esto ya no es una skill `/ubiquitous-language` aparte: se fusionó en `/grill-with-docs` + `/domain-modeling`, que escriben `GLOSSARY.md` (antes `CONTEXT.md`) y ADRs. En este repo esas guías ya están vendorizadas como `matt-grill-with-docs` y `matt-domain-modeling`.

Esta skill es el **flujo adaptado** (glosario + uso + refactor). No reemplaza las guías de Matt: las apunta y agrega el paso de refactor y las reglas de Zentra.

## Dónde escribir el glosario

- **Repos personales** (`agents-system`, `fubol`, `ignacio`, prototipos propios): `GLOSSARY.md` en la raíz, formato de [matt-domain-modeling/references/upstream/GLOSSARY-FORMAT.md](../matt-domain-modeling/references/upstream/GLOSSARY-FORMAT.md). ADRs en `docs/adr/` solo si la decisión es difícil de revertir, sorprendente sin contexto, y resultado de un trade-off real.
- **Zentra** (`/home/nacho/projects/zentra` y cualquier repo del equipo): usá `zentra:domain-modeling` y `CONTEXT.md` / `docs/adr/`. **No** uses `mattpocock-skills:domain-modeling` ni `grill-with-docs` para requerimientos de producto (para eso va `zentra:requirements-interview`). **No** corras `/setup-matt-pocock-skills` ahí. Esto está escrito en el `~/.claude/CLAUDE.md` de WSL.

El glosario es solo vocabulario: definiciones cortas, término canónico + `_Avoid_`. Cero detalle de implementación, specs o notas de trabajo.

## Pasos (repos personales)

1. Leé el `GLOSSARY.md` existente, si hay, y el código que vas a tocar. No preguntes lo que el repo ya responde.
2. Entrevista en rondas (el grill): una ronda de preguntas, esperá, después la siguiente. Cuando un término se cierra, **escribilo al toque** en `GLOSSARY.md`, no al final. Para el ritual completo cargá `matt-grill-with-docs` y su `references/upstream/GUIDE.md`, más `matt-domain-modeling` si estás afinando el modelo.
3. Si un término que usa Nacho choca con el glosario, señalalo en el momento.
4. Cuando el vocabulario de ese cambio está acordado, **refactorizá el código** para usar esos nombres (archivos, tipos, funciones, comentarios de dominio). No es un rename ciego de strings de UI ni de APIs públicas sin OK.
5. Devolvé: términos agregados o cambiados, ADRs (si hubo), archivos refactorizados, y lo que quedó en el aire.

## Cascada de modelos

- Armar y discutir términos: Claude (Opus orquesta; Sonnet si hace falta afilar). Es trabajo de juicio, no de grind.
- El rename mecánico ya acordado: DeepSeek flash, con la tabla de términos canónicos en el encargo (`opencode run` solo si esa máquina tiene DeepSeek configurado).
- Review del refactor: DeepSeek v4-pro o el reviewer de la cascada, buscando nombres viejos que quedaron y APIs públicas tocadas de más.

## Validación

El `GLOSSARY.md` o `CONTEXT.md` que corresponda cambió término a término (o se explicó por qué no), el código nuevo habla esos términos, y no se mezclaron convenciones de Zentra con las de Matt.
