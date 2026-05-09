---
description: Guía práctica para decidir qué skills usar por defecto, cuáles dejar a demanda y cuándo invocarlas explícitamente
---

# Skills Routing

Esta guía ordena la colección de skills para que el agente no tenga que "pensar entre 59 opciones" en cada tarea.

## Regla Base

- Las skills `core` deberían activarse por contexto con facilidad.
- Las skills `specialized` se usan cuando el tipo de trabajo ya está claro.
- Las skills `rarely-use` conviene invocarlas de forma explícita cuando el caso lo amerita.

## Cómo se usan

### 1. Activación automática

Si la descripción de la skill está bien escrita y el pedido del usuario coincide, el agente debería activarla solo.

Ejemplos:

- "arreglá este bug" -> `systematic-debugging`
- "armá un plan" -> `writing-plans`
- "revisá este PR" -> `requesting-code-review`
- "arranquemos este proyecto" -> `lean-project-kickoff`

### 2. Invocación explícita por el usuario

También podés nombrarlas directamente cuando querés forzar comportamiento.

Ejemplos:

- "usá `token-efficiency-check` sobre este workflow"
- "aplicá `systematic-debugging` a este error"
- "quiero que uses `lean-project-kickoff`"

### 3. Invocación explícita por el sistema local

Si querés máxima consistencia, podés referenciar esta guía desde un `AGENTS.md` o skill global para reducir ambigüedad.

---

## Core

Estas son las más útiles como capa general.

| Skill | Cuándo usarla | Activación |
|---|---|---|
| `using-superpowers` | Al inicio de cualquier conversación | automática |
| `brainstorming` | Antes de diseñar algo nuevo o cambiar comportamiento | automática |
| `lean-project-kickoff` | Al arrancar proyecto, repo o iniciativa | automática o explícita |
| `token-efficiency-check` | Cuando un prompt, workflow o skill está pesado | automática o explícita |
| `systematic-debugging` | Para bugs, tests rojos, fallos raros | automática |
| `test-driven-development` | Para implementar cambios importantes o fixes con riesgo | automática |
| `writing-plans` | Cuando ya hay diseño aprobado y hace falta plan | automática |
| `dispatching-parallel-agents` | Cuando hay 2+ tareas independientes | automática |
| `verification-before-completion` | Antes de declarar que algo quedó listo | automática |
| `requesting-code-review` | Al cerrar trabajo importante o antes de merge | automática |
| `receiving-code-review` | Cuando llegan comentarios de review y hay que evaluarlos bien | automática |
| `using-git-worktrees` | Al iniciar trabajo que conviene aislar | automática o explícita |

## Specialized

Estas están buenas, pero solo para tipos de trabajo concretos.

### Desarrollo de agentes, plugins y tooling

| Skill | Cuándo usarla |
|---|---|
| `agent-development` | Crear o editar agentes |
| `command-development` | Crear slash commands |
| `hook-development` | Crear hooks |
| `mcp-integration` | Integrar servidores MCP |
| `plugin-settings` | Guardar configuración del plugin |
| `plugin-structure` | Armar estructura de plugin |
| `skill-development` | Mejorar una skill existente |
| `skill-creator` | Crear o rediseñar una skill |
| `writing-hookify-rules` | Escribir reglas hookify |

### Diseño y frontend

| Skill | Cuándo usarla |
|---|---|
| `frontend-design` | Crear UI o páginas |
| `web-presentation-premium` | Crear presentaciones web, pitch decks web, demos visuales, landings interactivas, Three.js/GSAP |
| `adapt` | Ajustar responsive o diferentes contextos |
| `animate` | Agregar motion con intención |
| `audit` | Auditar calidad de interfaz |
| `bolder` | Hacer un diseño más fuerte |
| `clarify` | Mejorar textos UX |
| `colorize` | Sumar color con criterio |
| `critique` | Evaluar calidad UX |
| `delight` | Añadir detalles memorables |
| `distill` | Simplificar una interfaz |
| `extract` | Sacar patrones reutilizables |
| `harden` | Mejorar resiliencia y edge cases UI |
| `normalize` | Alinear con design system |
| `onboard` | Mejorar onboarding |
| `optimize` | Mejorar performance UI |
| `polish` | Pasada final de calidad |
| `quieter` | Bajar intensidad visual |
| `theme-factory` | Aplicar o generar tema visual |

### Briefing obligatorio para webs

Antes de crear una web desde cero, landing, presentación web, pitch o demo visual:
- Leer `workflows/web_briefing.md`
- Preguntar qué busca el usuario si objetivo/audiencia/tono/stack no está claro
- Si el usuario dice "lo que vos digas", elegir el stack más simple que logre impacto
- Usar `web-presentation-premium` cuando se busque una experiencia memorable, premium o tipo frontend senior

### Documentos y archivos

| Skill | Cuándo usarla |
|---|---|
| `doc-coauthoring` | Escribir docs, specs o propuestas |
| `docx` | Trabajar con `.docx` |
| `pptx` | Trabajar con presentaciones |
| `xlsx` | Trabajar con planillas |

### Arte y assets

| Skill | Cuándo usarla |
|---|---|
| `algorithmic-art` | Generative art en código |
| `canvas-design` | Diseños visuales estáticos |
| `slack-gif-creator` | GIFs para Slack |

### Calidad, datos y otros

| Skill | Cuándo usarla |
|---|---|
| `subagent-driven-development` | Ejecutar planes con varias tareas independientes |
| `executing-plans` | Seguir un plan ya escrito |
| `spec-kit` | Spec-Driven Development para proyectos/features medianas-grandes con constitution, spec, plan, tasks e implementación |
| `webapp-testing` | Probar apps web |
| `remembering-conversations` | Buscar contexto previo útil |
| `find-skills` | Descubrir skills apropiadas |
| `internal-comms` | Escribir comunicación interna |
| `finishing-a-development-branch` | Cerrar una rama ya terminada |
| `supabase-postgres-best-practices` | Revisar o escribir SQL/Postgres de Supabase |
| `teach-impeccable` | Configurar lineamientos persistentes de diseño |
| `claude-opus-4-5-migration` | Migraciones específicas de Claude |
| `web-artifacts-builder` | Artifacts web más complejos |

### Spec-Driven Development opcional

Usar `spec-kit` cuando:
- La tarea sea medium/large
- Haya varios requisitos o incertidumbre de producto
- Se necesite trazabilidad entre spec, plan, tasks e implementación
- Se trabaje en apps AI/RAG complejas junto con `ai-production-architecture`

No usar `spec-kit` para:
- fixes chicos
- SEO puntual
- cambios visuales simples
- tareas de menos de 3 pasos

## Rarely-Use

Estas no están mal, pero no deberían vivir en el camino por defecto salvo necesidad real.

| Skill | Motivo |
|---|---|
| `brand-guidelines` | Solo si aplica una marca específica |
| `theme-factory` | Más útil en entregables visuales que en desarrollo general |
| `teach-impeccable` | Setup ocasional, no workflow diario |
| `remembering-conversations` | Útil cuando realmente falta contexto previo |
| `find-skills` | Meta-skill, no hace falta en tareas normales |
| `internal-comms` | Solo para contenidos internos |
| `canvas-design` | Casos visuales puntuales |
| `algorithmic-art` | Casos muy específicos |
| `slack-gif-creator` | Caso muy específico |
| `claude-opus-4-5-migration` | Nicho |

---

## Recomendación Práctica

No hace falta que llames todo manualmente.

Usaría esta regla:

- confiar en activación automática para `core`
- nombrar explícitamente las `specialized` cuando el tipo de trabajo sea muy claro
- nombrar explícitamente casi siempre las `rarely-use`

## Frases Útiles para Forzar una Skill

- "Usá `lean-project-kickoff`"
- "Aplicá `token-efficiency-check` a esto"
- "Quiero `systematic-debugging`, no un fix rápido"
- "Usá `requesting-code-review` antes de cerrar"
- "Tomá `frontend-design` como skill principal"

## Routing de Agentes por Rol

### agente-principal
Activar cuando: lógica JS/TS, estructura HTML, configuración, integraciones, API calls, autenticación, base de datos
Worktree: main o agente/feature
Skill a leer: la del stack del proyecto (astro, next, etc)
NO hacer: estilos visuales, SEO puro, tests

### agente-seo
Activar cuando: meta tags, Open Graph, headings H1-H3, sitemap.xml, robots.txt, schema markup, alt texts, URLs canónicas
Worktree: agente/seo
Skill a leer: no requiere skill específico
NO hacer: JavaScript funcional, lógica, estilos de diseño

### agente-design
Activar cuando: CSS, Tailwind, responsive design, animaciones, accesibilidad visual, dark mode, componentes UI sin lógica
Worktree: agente/design
Skill a leer: la del stack del proyecto
NO hacer: lógica de negocio, SEO, tests

### agente-tests
Activar cuando: tests unitarios (Jest/Vitest), tests E2E (Playwright), coverage, mocks, fixtures, CI/CD tests
Worktree: agente/tests
Skill a leer: testing.md (rules/)
NO hacer: código de producción, estilos, SEO

### agente-docs
Activar cuando: README, JSDoc, comentarios en código, documentación de API, changelogs, guías de uso
Worktree: agente/docs o main (solo si es README)
NO hacer: código de producción, estilos, lógica

### agente-ai-architect
Activar cuando: apps AI/RAG, LLM apps, agentes, semantic cache, prompt registry, evaluación, observabilidad, guards, routing, query rewriting
Worktree: agente/feature o agente/architecture
Skill a leer: ai-production-architecture
NO hacer: CSS/UI, SEO, tests detallados, notas Obsidian

### agente-obsidian-brain
Activar cuando: notas Obsidian, clases, flashcards, MOCs, Dataview, Zettelkasten, triaje de inbox del vault
Worktree: no aplica; trabajar en el vault con cuidado
Skill a leer: obsidian-vault, obsidian-markdown
NO hacer: código de producción, CSS, SEO, tests

## Reglas de Paralelismo
Podés lanzar múltiples agentes cuando:
- Las tareas son independientes (no tocan los mismos archivos)
- Cada una está en su propio worktree
- Las tareas tardan más de 10 minutos cada una

Usá un solo agente cuando:
- Las tareas dependen entre sí
- El proyecto es chico (pocos archivos)
- Estás debuggeando algo específico

## Regla Final

Cuantas más skills haya instaladas, más importante es tener una capa de routing simple.
La colección puede ser grande; el camino por defecto no.
