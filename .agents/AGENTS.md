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
- Usar `workflows/dreaming.md` para curar memoria entre sesiones (cada 5 sesiones o semanal)
- Usar `workflows/outcomes.md` para quality gate con grader separado en tareas complejas o loops desatendidos

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
- Para usar el Council fuera del IDE, copiar `.agents/prompts/llm-council-portable.md` a cualquier chat (ChatGPT, Claude web, Gemini, etc.)
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

Para forzar un workflow/agente/skill: `"Activá [nombre].md"` o `"Llamá al agente-[nombre]"`. El nombre del archivo es el comando. Ver lista completa en `workflows/index.md`.

### 12. Portabilidad Cross-IDE

Setup completo en `docs/setup-guide.md`. Resumen:
- OpenCode/Codex/Antigravity: carga AGENTS.md automáticamente.
- Claude Code: CLAUDE.md importa AGENTS.md. Symlinks con `bin/setup-ide-pointers.ps1`.
- Devin Desktop: ACP permite múltiples agentes. AGENTS.md es contexto compartido.
- ChatGPT/Claude web/Gemini: pegar `.agents/prompts/activate-global.md`.
- Aider: `.aider.conf.yml` apunta a AGENTS.md.
- AGENTS.override.md (Codex): override por directorio. Gitignored.

## Roles de Agentes

Definiciones completas en `.agents/agents/`. Registry:

- agente-principal, agente-design, agente-tests, agente-docs, agente-seo
- agente-marketing-strategist, agente-growth-seo-geo, agente-product-founder
- agente-ai-architect, agente-security-auditor, agente-mcp-architect
- agente-obsidian-brain, agente-code-reviewer, agente-researcher, agente-release-manager
- agente-academic-tutor, agente-x-content-strategist
- kickoff-architect, workflow-pruner

(Gloaguen et al. 2026: listar por nombre e invocación, definiciones en archivos separados, no inline.)

## GOTCHAS

### Entorno (Windows / Nacho)
- PowerShell no soporta `&&` como separador de comandos. Usar `;` o comandos separados.
- Smart quotes (comillas tipográficas) rompen la búsqueda en archivos. Siempre usar comillas ASCII rectas.
- Git en Windows: `mklink` requiere permisos de admin. Symlinks de AGENTS.md→CLAUDE.md pueden necesitar `Developer Mode` activado.

### Tech-specific (mover a AGENTS.override.md por proyecto)
- Supabase: RLS policies son obligatorias en tablas públicas. Sin RLS, cualquier usuario puede leer/escribir todo.
- Next.js middleware order importa para auth: verificar JWT antes de redirigir.

### Principios del sistema
- No sobre-abstractizar con capas de agentes (ultrathoughts → aura → soul). El Ralph Loop ya es el nivel correcto de abstracción. Más capas = más fricción, menos control, vuelta a la pala.
- Vendor lock-in: no depender 100% de un solo proveedor de AI. Mantener portabilidad cross-IDE (AGENTS.md + .aider + .gemini + .claude).
- LLM-generated AGENTS.md reduce éxito ~3% y aumenta costos >20% (Gloaguen et al. 2026). Siempre escrito por humanos.
- Comprehension debt: cuanto más code shippea un loop que no leíste, más se aleja tu entendimiento del código que existe. (Addy Osmani, Loop Engineering 2026).
- Cognitive surrender: diseñar loops para evitar pensar vs para moverse más rápido en trabajo que entendés profundamente. Misma acción, resultado opuesto. El loop no sabe la diferencia. Vos sí.

### Plataforma (Junio 2026)
- Windsurf → Devin Desktop (Junio 2): ACP permite múltiples agentes en un editor.
- Gemini CLI → Antigravity CLI (Junio 18): sigue leyendo GEMINI.md y AGENTS.md.
- AGENTS.override.md (Codex CLI): override por directorio. Gitignored.

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
- Diseñar loops como engineer, no como forma de evitar entender el trabajo. El loop es el acelerador cuando lo usás con juicio, y el acelerador de la mediocridad cuando lo usás para no pensar. (Cognitive surrender — Addy Osmani 2026).
- Definir exit conditions más robustas de lo que el agente puede fakear. No "tests pass" sino "tests pass AND test count didn't decrease".

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
- Token budget del sistema: AGENTS.md (~8K tokens) + index.md (~3K) + rules/ (~5K) + 1 workflow (~2K) = ~18K tokens base por sesión. Agregar subagentes, skills y contexto de proyecto puede sumar 50-100K+. Para sesiones con loops, declarar budget explícito (ver Agentic Budgeting en `parallel_agents.md`).

## TEST_STRATEGY

Reglas detalladas en `rules/testing.md`. Resumen ejecutivo:
- Un test por comportamiento, no por función.
- Nunca commitear con tests rotos (enforceable por CI).
- E2E con Playwright para flujos críticos.
- Integration tests sobre unit tests para API routes.

## Regla de Oro
Las reglas duras están en **Judgment Boundaries** (NEVER/ASK/ALWAYS). Esta sección es el resumen ejecutivo:
- Nunca declarés victoria antes de validar.
- Nunca toqués archivos fuera de tu scope.
- AGENTS.md es escrito por humanos. LLM-generated context reduce éxito ~3% y aumenta costos >20% (Gloaguen et al. 2026).
