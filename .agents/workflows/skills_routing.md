---
description: Skills esenciales y cuándo usarlas
---

# Skills Routing

## Regla Base
Skills `core` se activan por contexto. Skills `specialized` se usan cuando el tipo de trabajo está claro. Skills archivadas en `.agents/archive/skills/` no se cargan en el prompt pero existen si se necesitan.

## Core (se activan automáticamente)

| Skill | Cuándo |
|---|---|
| `brainstorming` | Antes de diseñar algo nuevo |
| `systematic-debugging` | Bugs, tests rojos, fallos raros |
| `verification-before-completion` | Antes de declarar listo |
| `writing-plans` | Cuando hay diseño aprobado y falta plan |
| `token-efficiency-check` | Cuando un prompt/workflow está pesado |
| `lean-project-kickoff` | Al arrancar proyecto o repo |
| `test-driven-development` | Features o fixes con riesgo |
| `dispatching-parallel-agents` | 2+ tareas independientes |
| `code-review` | Antes de mergear |
| `receiving-code-review` | Cuando llegan comentarios de review |
| `using-git-worktrees` | Cuando conviene aislar trabajo |

## Specialized (tipo de trabajo concreto)

| Skill | Cuándo |
|---|---|
| `frontend-design` | UI, componentes, páginas web |
| `animate` / `polish` / `bolder` | Pasadas de diseño |
| `audit` / `critique` | Evaluar calidad de interfaz |
| `css-animations` | Animaciones CSS 2D |
| `seo-geo-growth` | Estrategia SEO/GEO/AEO |
| `product-foundry` | Ideas de producto, MVPs |
| `client-work` | Trabajo con clientes reales |
| `doc-coauthoring` | Docs, specs, propuestas |
| `exercise-generator` / `exam-simulator` | Ejercicios de programación y parciales |
| `exercise-generator` | Estudio y análisis |
| `study-progress-tracker` | Tracking académico |
| `obsidian-vault` | Trabajar con el vault |
| `docx` / `xlsx` / `pptx` | Documentos Office |

## Invocación explícita
Nombrar la skill directamente: "Usá `systematic-debugging`". No cargues skills desde `archive/`: una capacidad histórica debe revisarse, promoverse al catálogo activo y recibir un fixture antes de volver al runtime.

## Catálogo Matt Pocock (global, on demand)

Si el usuario pide una técnica de Matt o una capacidad que no cubre el core, buscá la entrada `matt-*` relevante en `skills-library/INDEX.md`; leé sólo su wrapper y referencias necesarias. No hace falta que el usuario recuerde el comando. Las 27 promovidas, 4 misc y 7 experimentales están namespaced y fuera del preload; estas últimas requieren un pedido claro para su propósito. La política canónica conserva permisos, límites y selección de modelos.

Sandcastle y Evalite son guías de evaluación on-demand (`sandcastle-evaluation`, `worker-quality-evaluation`), no frameworks instalados. El catálogo no ejecuta hooks, migraciones, publicación ni merges por descubrirlo.
