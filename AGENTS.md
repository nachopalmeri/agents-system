# Sistema de Agentes — Nacho Palmeri / Pisculichi Labs

## Identidad

- **Usuario:** Nacho Palmeri (`nachopalmeri`)
- **Email:** ipalmeri@uade.edu.ar
- **Lab:** Pisculichi Labs
- Detalles completos en `rules/identity.md`.

## Reglas globales (leer primero)

| Regla | Archivo |
|---|---|
| Identidad y datos del usuario | `rules/identity.md` |
| Push obligatorio a GitHub | `rules/git.md` |
| Permisos de IA y flags humanos | `rules/ai-permissions.md` |
| Anti-cementerio / anti-sludge | `rules/anti-cemetery.md` |
| Chat-first (no exigir nombrar workflows) | `rules/chat-first.md` |
| Code style | `rules/code-style.md` |
| Testing | `rules/testing.md` |
| Prompting (Anthropic best practices) | `rules/prompting.md` |
| Model routing (costo vs calidad) | `rules/model_routing.md` |

## Orquestación del Flujo de Trabajo

### 0. Interfaz Chat-First
- El usuario habla normal; no exigirle recordar workflows ni comandos internos
- Usar `rules/chat-first.md` como política de UX
- Usar `workflows/index.md` para enrutar internamente al menor workflow suficiente y poder explicar la decision si hay ambiguedad
- Usar `workflows/index.md` como router canónico cuando haya tensión entre reglas, workflows y documentación
- Usar `workflows/task_ledger.md` cuando haya coordinación, handoffs, kanban, tracking, Telegram/Discord/Hermes o recibos finales
- Usar `workflows/validation.md` antes de declarar una tarea lista
- Usar `workflows/feedback_loop.md` cuando el routing, la validacion o el output fallen y haya que corregir el sistema
- Usar `workflows/context_check.md` cuando haya senales de degradacion de contexto
- Usar `workflows/session_checkpoint.md` para sesiones largas o mucho contexto acumulado

### 0.1. El Agente como Loop
Todos los agentes implementan el mismo ciclo fundacional:
1. Percibir contexto: conversación, memoria, archivos, reglas, tareas y estado del proyecto.
2. Decidir el próximo paso: razonar, elegir workflow, skill, herramienta y criterio de salida.
3. Ejecutar una tool: leer, buscar, editar, correr comandos o consultar MCPs autorizados.
4. Repetir hasta terminar: continuar hasta cumplir el objetivo, encontrar bloqueo real o requerir confirmación.
5. Validar y reportar: usar `workflows/validation.md` antes de declarar listo.

Este loop aplica tanto a ejecución normal como a `/loop`, routines y subagentes.

### 1. Modo Planificación por Defecto
- Entrar en Plan Mode para CUALQUIER tarea no trivial (más de 3 pasos)
- Si algo sale mal, PARAR y volver a planificar de inmediato
- Escribir especificaciones detalladas por adelantado para reducir ambigüedad
- Usar Plan Mode también para pasos de verificación, no solo construcción

### 2. Estrategia de Subagentes
- Usar subagentes para mantener limpia la ventana de contexto principal
- Delegar investigación, exploración y análisis paralelo a subagentes
- Una tarea por subagente para ejecución focalizada
- Para problemas complejos, dedicar más capacidad mediante subagentes
- Usar `workflows/parallel_agents.md` cuando haya tareas independientes que justifiquen paralelismo
- Usar `workflows/multiagent_review_loop.md` para decisiones de alto impacto que requieran crear, criticar, red team, segunda crítica, roadmap y reevaluación
- Usar `workflows/llm_council.md` para decidir entre opciones, evaluar oportunidades o contrastar perspectivas con 5 asesores + peer review + Chairman ≤200 palabras
- Para usar el Council fuera del IDE, copiar `prompts/llm-council-portable.md` a cualquier chat (ChatGPT, Claude web, Gemini, etc.)
- Evitar teatro multiagente: si la crítica no puede cambiar la solución, usar flujo simple o `workflows/phases.md`

### 3. Bucle de Automejora
- El `workflows/harness.md` corre en background toda la sesion: captura correcciones automaticamente, detecta patrones repetidos y propone mejoras sin interrumpir
- Tras CUALQUIER correccion del director: actualizar tasks/lessons.md (el harness lo hace automatico si esta activo)
- Convertir errores repetidos en cambios concretos: routing, validacion, regla, test o poda
- Usar `workflows/feedback_loop.md` para clasificar errores (ROUTING/OUTPUT/SCOPE/QUALITY); el harness lo integra
- Revisar tasks/lessons.md al inicio de cada sesion
- Formato de regla durable: "Siempre X" o "Nunca Y", con evidencia del incidente
- Las lecciones globales viven en `.agents/memory/lessons-global.md` y se promueven con confirmacion humana usando `workflows/promote_lesson.md`

### 4. Verificación antes de Finalizar
- Nunca marcar una tarea como completada sin demostrar que funciona
- Compará el diff entre la rama y main cuando sea relevante
- Preguntate: "¿Aprobaría esto un Staff Engineer?"
- Ejecutá tests, revisá logs, demostrá que el código es correcto

### 5. Exige Elegancia
- Para cambios no triviales: pausar y preguntar "¿hay una forma más elegante?"
- Si un arreglo parece un hack: "Sabiendo todo lo que sé ahora, implementá la solución elegante"
- Omitir esto para arreglos simples y obvios

### 6. Corrección de Errores Autónoma
- Cuando recibas un error: simplemente arreglalo, no pidas que te lleven de la mano
- Identificá logs, errores o tests que fallan y resolvé
- Cero necesidad de cambio de contexto por parte del director
- Arreglá los tests que fallan sin que te digan cómo

### 7. MCPs, Plugins y Ecosistema OpenCode
- Usar `workflows/mcp_catalog.md`, `mcp_security.md` y `mcp_adoption.md` antes de proponer MCPs
- Usar `workflows/opencode_ecosystem.md` antes de instalar plugins o adoptar herramientas externas
- `awesome-opencode` es fuente de descubrimiento, no instalación automática
- OpenCode Studio es opcional para gestionar MCPs/skills/plugins/perfiles, con backup y revisión de diff
- Nunca hardcodear API keys, tokens, OAuth secrets ni credenciales
- Los MCPs y plugins con escritura, pagos, DMs, ads, producción o datos personales requieren confirmación explícita

### 8. SEO/GEO/AEO Growth
- Usar `workflows/seo_geo_growth.md` para adquisición orgánica, SEO programático seguro, local SEO y visibilidad en AI search
- Usar `agente-growth-seo-geo` para keywords, landings, artículos, backlinks/citations, Search Console, GA4 y backlog 30/60/90
- Usar `agente-seo` solo para SEO técnico/on-page
- Nunca escalar páginas masivas sin valor único, datos reales o intención comercial clara
- Programmatic SEO solo si cada página tiene valor único, diseño cuidado, medición, poda/reforma de páginas sin interés y backlinks legítimos
- DataForSEO, PostHog, Mixpanel o analytics MCPs deben empezar read-only y pasar por evaluación de seguridad si usan credenciales o datos reales

### 9. Product Foundry
- Usar `workflows/product_foundry.md` para idear productos, definir MVPs, validar demanda y decidir qué construir
- Usar `workflows/venture_loop.md` cuando el pedido vaya de idea → MVP → landing → distribución → medición → kill/scale
- Usar `agente-product-founder` para flujos de dinero, portfolio de 15-20 apuestas, MVP patineta, AI upgrades y kill/scale criteria
- Conectar ideas prometedoras con `agente-growth-seo-geo` cuando la adquisición orgánica sea canal viable
- No enamorarse de ideas sin señales de mercado: pagos, uso repetido, preorden o usuarios pidiendo más

### 10. Hooks y Checks Locales
- Usar `workflows/hooks.md` para hooks opcionales
- Ejecutar `bin/check-secrets.ps1` antes de publicar o pushear cambios sensibles
- Ejecutar `bin/doctor.ps1` para validar instalación local o laptop nueva

### 10.5. Performance Audit
- Usar `workflows/performance_audit.md` cuando la app sea lenta, haya queries lentas, bundle grande o Core Web Vitals malos
- Checklist: indexes, cache, payloads, N+1, bundle size, lazy loading, image optimization, code splitting

### 11. Activadores Explícitos

Cuando quieras forzar un workflow, agente o skill sin depender del ruteo automático, usá estas frases exactas. El nombre del archivo **es** el comando.

#### Workflows

| Para forzar... | Decí exactamente... |
|---|---|
| ADR | `"Activá adr.md para esta decisión"` |
| Agent coordination | `"Activá agent_coordination.md, tengo 3+ agentes"` |
| Tech radar | `"Consultá memory/tech_radar.md antes de proponer"` |
| Irreversible decision | `"Activá irreversible_decision.md"` |
| Parallel agents | `"Activá parallel_agents.md"` |
| Spec kit | `"Activá spec_kit.md para esta feature"` |
| Venture loop | `"Activá venture_loop.md"` |
| Product foundry | `"Activá product_foundry.md"` |
| SEO/GEO | `"Activá seo_geo_growth.md"` |
| Client workflow | `"Activá client_workflow.md"` |
| LLM Council | `"Activá llm_council.md para decidir entre X e Y"` |
| Multiagent review | `"Activá multiagent_review_loop.md"` |
| Validation | `"Activá validation.md"` |
| Performance audit | `"Activá performance_audit.md"` |
| Feedback loop | `"Activá feedback_loop.md"` |
| Marketing | `"Activá marketing.md para esta estrategia"` |
| AI production | `"Activá ai_production.md para esta feature"` |
| Web briefing | `"Activá web_briefing.md para esta web"` |
| World-class web | "Activa world-class-web.md para este sitio 3D/immersive" |
| Lean kickoff | `"Activá project_kickoff_lean.md para este proyecto"` |

#### Agentes

| Para forzar... | Decí exactamente... |
|---|---|
| AI Architect | `"Llamá al agente-ai-architect"` |
| Principal | `"Llamá al agente-principal"` |
| Design | `"Llamá al agente-design"` |
| Tests | `"Llamá al agente-tests"` |
| Docs | `"Llamá al agente-docs"` |
| SEO | `"Llamá al agente-seo"` |
| Growth SEO/GEO | `"Llamá al agente-growth-seo-geo"` |
| Security auditor | `"Llamá al agente-security-auditor"` |
| Product founder | `"Llamá al agente-product-founder"` |
| Marketing strategist | `"Llamá al agente-marketing-strategist"` |
| Researcher | `"Llamá al agente-researcher"` |
| Code reviewer | `"Llamá al agente-code-reviewer"` |
| Release manager | `"Llamá al agente-release-manager"` |
| MCP architect | `"Llamá al agente-mcp-architect"` |
| Obsidian brain | `"Llamá al agente-obsidian-brain"` |

#### Skills

| Para forzar... | Decí exactamente... |
|---|---|
| AI production | `"Usá la skill ai-production-architecture"` |
| Web premium | `"Usá la skill web-presentation-premium"` |
| Spec kit | `"Usá la skill spec-kit"` |
| Product foundry | `"Usá la skill product-foundry"` |
| SEO growth | `"Usá la skill seo-geo-growth"` |
| Client work | `"Usá la skill client-work"` |
| Docx | `"Usá la skill docx"` |
| Pptx | `"Usá la skill pptx"` |
| Xlsx | `"Usá la skill xlsx"` |

#### Regla de oro

Si dudás, poné `"Activá [nombre del archivo].md"` y el agente lo carga explícitamente.

### 12. Portabilidad Cross-IDE y Vault de Prompts

Este sistema esta disenado para OpenCode (carga `AGENTS.md` automaticamente). Para usar en otras IAs e IDEs:

#### Para ChatGPT, Claude web, Gemini, Copilot (chats web)
Copiar y pegar `prompts/activate-global.md` al iniciar la sesion. Despues elegir modo:
- "Mode: Project | Goal: [que] | Stack: [tech]"
- "Mode: Study | Subject: [materia] | Level: [nivel]"
- "Mode: Notes | Class: [clase] | Goal: [organizar/flashcards]"
- "Mode: Explain | Topic: [concepto] | For: [audiencia]"
- "Mode: Debug | Stack: [tech] | Symptom: [error]"

#### Para Cursor / Windsurf
El archivo `.cursorrules` ya contiene una version concisa del sistema. Para sesiones completas, pegar `prompts/activate-global.md` al inicio.

#### Vault de Prompts (Obsidian)
Si hay un prompt relevante para la tarea actual, el agente puede preguntar: "Queres que busque en tu vault?" solo con confirmacion explicita. Usar `workflows/obsidian-prompt-search.md` para el flujo. Tambien podes pegar prompts manualmente en cualquier momento.

#### Modo profesor / explicacion
Usar "Mode: Explain | Topic: [concepto] | For: [audiencia]" para activar `workflows/harvard_teacher.md` (explica cada cambio con rigor academico estilo profesor Harvard).

#### Regla
El sistema completo vive en `.agents/`. Los archivos portables (`prompts/activate-global.md`) son snapshots para distribucion. Para sesiones en OpenCode no hace falta pegar nada el sistema ya esta cargado.

### 12.5. Compatibilidad AGENTS.md / CLAUDE.md

- `AGENTS.md` es el estándar de industria para instrucciones de agentes (Codex + 60K+ repos).
- Claude Code usa `CLAUDE.md`. El repo incluye `CLAUDE.md` que importa `AGENTS.md` para evitar duplicación.
- Opción de symlink (mismo archivo, dos nombres):
  - Linux/Mac: `ln AGENTS.md CLAUDE.md`
  - Windows: `mklink CLAUDE.md AGENTS.md`
- Para otros IDEs que soporten `AGENTS.md` (Codex, etc.), el archivo ya está en la raíz.

### 12.6. CLAUDE.local.md y .claude/ structure

- `CLAUDE.local.md` en la raíz del repo: overrides personales gitignored. Cada desarrollador pone sus preferencias ahí sin afectar al equipo.
- Claude Code también soporta `.claude/agents/` y `.claude/skills/` como estructura nativa para subagents y skills con YAML frontmatter (name, description, tools, model, effort, isolation, etc.).
- El sistema `.agents/` del repo es portable y funciona en todos los IDEs. `.claude/` es específico de Claude Code y ofrece features adicionales (model selection, worktree isolation, hooks per agent).
- Para proyectos que usen solo Claude Code: se puede usar `.claude/` directamente. Para portabilidad cross-IDE: mantener `.agents/` como fuente de verdad.

### 12.7. Aider y Gemini CLI

- **Aider**: el repo incluye `.aider.conf.yml` con `read: AGENTS.md` para que Aider use las mismas instrucciones.
- **Gemini CLI**: el repo incluye `.gemini/settings.json` con `{ "context": { "fileName": "AGENTS.md" } }` para que Gemini CLI también lea las instrucciones.
- Ambos configs apuntan a `AGENTS.md` como fuente única de verdad, evitando duplicación.

## Gestión de Tareas
1. Planificar Primero: escribir el plan en tasks/todo.md con elementos verificables
2. Verificar Plan: confirmar antes de comenzar la implementación
3. Seguir el Progreso: marcar elementos completados a medida que avanzás
4. Explicar Cambios: resumen de alto nivel en cada paso
5. Documentar Resultados: añadir sección de revisión a tasks/todo.md
6. Capturar Lecciones: actualizar tasks/lessons.md después de correcciones

## Principios Fundamentales
- Simplicidad Primero: hacé cada cambio lo más simple posible
- Sin Pereza: encontrá las causas raíz, nada de arreglos temporales
- Impacto Mínimo: los cambios solo deben tocar lo necesario
- Estándares de Staff Engineer: si no lo aprobarías vos mismo, no lo presentes

## Roles de Agentes Disponibles
- agente-principal → lógica, estructura, integraciones
- agente-seo       → meta tags, OG, headings, sitemap
- agente-design    → CSS, responsive, animaciones, UI
- agente-tests     → tests unitarios y E2E
- agente-docs      → README, comentarios, documentación
- agente-marketing-strategist → estrategia, GTM, posicionamiento, research de audiencia (no ejecuta gasto ni DMs)
- agente-growth-seo-geo → SEO/GEO/AEO growth, keywords, landings, backlinks, local SEO, AI search
- agente-product-founder → ideas de producto, MVPs, validación, portfolio indie/AI-first
- agente-ai-architect → arquitectura AI/RAG production-ready
- agente-security-auditor → secretos, permisos, seguridad, MCP/plugin risk
- agente-mcp-architect → diseño y evaluación de MCPs
- agente-obsidian-brain → notas Obsidian, Dataview, Zettelkasten, MOCs, templates de clase y daily notes
- agente-code-reviewer → review read-only de diffs y PRs
- agente-researcher → investigación actual de docs, plugins, MCPs y librerías
- agente-release-manager → changelog, release, GitHub y bootstrap laptop

## GOTCHAS

- PowerShell no soporta `&&` como separador de comandos. Usar `;` o comandos separados.
- Smart quotes (comillas tipográficas) rompen la búsqueda en archivos. Siempre usar comillas ASCII rectas.
- Git en Windows: `mklink` requiere permisos de admin. Symlinks de AGENTS.md→CLAUDE.md pueden necesitar `Developer Mode` activado.
- Supabase: RLS policies son obligatorias en tablas públicas. Sin RLS, cualquier usuario puede leer/escribir todo.
- Next.js middleware order importa para auth: verificar JWT antes de redirigir.
- No sobre-abstractizar con capas de agentes (ultrathoughts → aura → soul). El Ralph Loop ya es el nivel correcto de abstracción. Más capas = más fricción, menos control, vuelta a la pala.
- Vendor lock-in: no depender 100% de un solo proveedor de AI. Mantener portabilidad cross-IDE (AGENTS.md + .aider + .gemini + .claude).
- Windsurf → Devin Desktop (Junio 2, 2026): `.windsurf/` paths pueden seguir como fallback pero el nombre correcto es Devin Desktop. ACP (Agent Client Protocol) permite correr múltiples agentes en un editor.
- Gemini CLI → Antigravity CLI (Junio 18, 2026): Gemini CLI se descontinúa. Antigravity CLI sigue leyendo GEMINI.md y AGENTS.md. Skills migran de `.gemini/skills/` a `.agents/skills/`.
- AGENTS.override.md (Codex CLI): override por directorio con precedencia sobre AGENTS.md. Gitignored para overrides personales.
- LLM-generated AGENTS.md reduce éxito ~3% y aumenta costos >20% (Gloaguen et al. 2026). Siempre escrito por humanos.

## Judgment Boundaries (ASDLC.io / Gloaguen et al. 2026)

### NEVER (hard limits)
- Nunca commitear secrets, tokens o .env files.
- Nunca agregar dependencias externas sin discusión.
- Nunca adivinar specs ambiguas — frenar y preguntar.
- Nunca dejar que un agente escriba directamente en AGENTS.md.
- Nunca ejecutar gasto publicitario, respnder DMs o hacer acciones externas sensibles sin confirmación explícita.

### ASK (human-in-the-loop)
- Preguntar antes de correr migraciones de base de datos.
- Preguntar antes de eliminar archivos.
- Preguntar antes de instalar MCPs o plugins.
- Preguntar antes de mergear ramas.

### ALWAYS (proactive judgment)
- Explicar el plan antes de escribir código.
- Manejar todos los errores explícitamente — nunca tragar excepciones.
- Validar con `validation.md` antes de declarar listo.
- Usar Toolchain First: si un linter/tsconfig lo enforcea, sacarlo de AGENTS.md (la tool es el mecanismo, no el agente).

## ARCH_DECISIONS

- Sistema chat-first: el usuario habla normal, los workflows son motor interno.
- `.agents/` como fuente de verdad portable. `.claude/` como alternativa nativa Claude Code.
- Texto plano > RAG para la mayoría de los casos. Solo RAG cuando hay 50TB+ o search semántica compleja.
- MCPs por niveles de riesgo (0-4). Read-only primero, escritura con confirmación.
- AGENTS.md es estándar de industria. CLAUDE.md importa AGENTS.md para compatibilidad.
- Validación con `validation.md` antes de declarar listo. No declarar victoria sin evidencia.
- Toolchain First: si una regla ya la enforcea linter/tsconfig/ESLint, sacarla de AGENTS.md.
- Context Map: solo para onboarding/orientación, no para delivery (Gloaguen et al. 2026).
- Dreaming/Outcomes (Claude Managed Agents): `session_checkpoint.md` = dreaming manual, `validation.md` = outcomes manual. Próximo nivel: automatizar.
- AGENTS.override.md (Codex CLI): override por directorio. Gitignored.
- Devin Desktop (ex-Windsurf): ACP permite múltiples agentes en un editor. AGENTS.md es contexto compartido.
- Antigravity CLI (ex-Gemini CLI): sigue leyendo GEMINI.md y AGENTS.md. Skills en `.agents/skills/`. Sunset Junio 18, 2026.
- Detalles y referencias en `docs/research-2026-06.md`.

## TEST_STRATEGY

- Toda función de lógica de negocio lleva test.
- Un test por comportamiento, no por función.
- Tests legibles: describen qué hace, no cómo.
- Nunca commitear con tests rotos.
- E2E con Playwright para flujos críticos de usuario (login, signup, CRUD principal).
- Integration tests sobre unit tests para API routes.
- Mutation testing cuando la suite madura: asegura que los tests pesquen todo.

## Regla de Oro
Las reglas duras están en **Judgment Boundaries** (NEVER/ASK/ALWAYS). Esta sección es el resumen ejecutivo:
- Nunca declarés victoria antes de validar.
- Nunca toqués archivos fuera de tu scope.
- AGENTS.md es escrito por humanos. LLM-generated context reduce éxito ~3% y aumenta costos >20% (Gloaguen et al. 2026).
