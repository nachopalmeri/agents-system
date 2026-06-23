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
| `requesting-code-review` | Antes de mergear |
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
| `coding-exercises` / `exam-simulator` | Ejercicios de programación y parciales |
| `active-recall-engine` / `case-analysis` | Estudio y análisis |
| `study-progress-tracker` | Tracking académico |
| `obsidian-vault` / `obsidian-markdown` | Trabajar con el vault |
| `docx` / `xlsx` / `pptx` | Documentos Office |

## Invocación explícita
Nombrar la skill directamente: "Usá `systematic-debugging`". Para skills archivadas: "Buscá `[skill]` en archive/skills/".
