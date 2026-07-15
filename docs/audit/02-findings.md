# Hallazgos priorizados

## Diagnóstico ejecutivo

El problema principal no es la cantidad de archivos. Es que la poda de junio archivó componentes sin cortar sus referencias ni regenerar entry points, docs y checks. El sistema resultante tiene una arquitectura declarada y otra ejecutable: el prompt enruta hacia componentes retirados, el router programático usa una taxonomía propia, los agentes no siempre tienen tools compatibles con sus outputs y los validadores comprueban forma sin comprobar comportamiento.

La simplificación correcta no es borrar todo. Hay que conservar el núcleo útil —chat-first, mínimo proceso suficiente, permisos por riesgo, skills bajo demanda y evidencia antes de cerrar— y reemplazar la red de referencias manuales por un contrato pequeño, generado y testeado.

## Ranking

Escalas: impacto/frecuencia/costo de 1 (bajo) a 5 (alto); confianza alta/media/baja.

| ID | Severidad | Hallazgo | Impacto | Frecuencia | Costo | Confianza |
|---|---|---|---:|---:|---:|---|
| F-01 | P0 | Runtime activo referencia workflows archivados o inexistentes | 5 | 5 | 5 | Alta |
| F-02 | P0 | Dos fuentes de verdad divergentes cambian según el entry point | 5 | 5 | 5 | Alta |
| F-03 | P0 | `opencode.json` bloquea OpenCode actual | 5 | 5 en OpenCode | 3 | Alta |
| F-04 | P0 | Contratos de agentes imposibles: outputs de escritura con tools read-only | 5 | 4 | 4 | Alta |
| F-05 | P0 | Aprobación por agente contradice autonomía y permisos por acción | 5 | 5 | 4 | Alta |
| F-06 | P1 | Router regex ignora registry, no cubre 7 agentes y enruta falsos positivos | 4 | 4 | 4 | Alta |
| F-07 | P1 | Validadores e CI producen verde semánticamente falso | 5 | 4 | 5 | Alta |
| F-08 | P1 | `start.md` bloquea tareas que dice tolerar | 4 | 5 | 3 | Alta |
| F-09 | P1 | Planificación, paralelismo y cierre se disparan por capas duplicadas | 4 | 4 | 5 | Alta |
| F-10 | P1 | Instalación/actualización no es simétrica ni segura frente a drift | 5 | 3 | 5 | Alta |
| F-11 | P1 | Gitlink de Obsidian no reproducible | 4 | 3 | 3 | Alta |
| F-12 | P1 | Configuración cross-IDE mezcla hechos vigentes, workarounds y afirmaciones no demostradas | 4 | 4 | 4 | Alta |
| F-13 | P2 | Catálogo/lock de skills no representa el conjunto activo | 3 | 4 | 4 | Alta |
| F-14 | P2 | Contexto ansioso y duplicado compite con progressive disclosure | 3 | 5 | 5 | Alta |
| F-15 | P2 | Archivo vendorizado triplica 2,29 MB de contenido idéntico | 2 | 2 | 4 | Alta |
| F-16 | P2 | Contenido académico global está hardcodeado a usuario/semestre/rutas viejas | 3 | 3 | 3 | Alta |
| F-17 | P2 | Schemas existen pero no se aplican | 4 | 3 | 3 | Alta |
| F-18 | P2 | No existe observabilidad que pruebe utilidad del sistema | 4 | 5 | 5 | Alta |

## F-01 — Referencias activas a archivo y ausencia

**Evidencia.** `AGENTS.md:29-37,62-73,94,101,109-121` manda usar `task_ledger`, `feedback_loop`, `context_check`, `dreaming`, `outcomes`, `llm_council`, `phases`, `promote_lesson`, `opencode_ecosystem`, `seo_geo_growth`, `product_foundry`, `venture_loop` y `performance_audit`. Doce están en `.agents/archive/workflows`; `context_check.md` y `phases.md` no existen. `.agents/workflows/index.md:33` convierte el archive en fallback operativo. `config/opencode/opencode.jsonc:66-92` contiene nueve rutas no activas. `.agents/SKILL.md:19-24` añade `work_policy.md`, inexistente, y cuatro workflows archivados.

**Por qué importa.** El modelo recibe instrucciones imposibles o debe descubrir el archive por intuición; distintos proveedores fallan de forma distinta.

**Actual.** La poda movió archivos en `d0edbbb` pero dejó entry points y documentación anteriores.

**Deseado.** Ningún archivo activo puede enrutar al archive. Una referencia activa debe resolver a un componente activo o fallar CI.

**Recomendación.** Cortar referencias en entry points, regenerar catálogo y crear un check de grafo con status `active|deprecated|archived`.

**Afectados.** `AGENTS.md`, `.agents/AGENTS.md`, `.agents/SKILL.md`, `.agents/workflows/*`, `config/opencode/*`, README, docs, agentes que citan workflows archivados.

## F-02 — Fuentes de verdad divergentes

**Evidencia.** `AGENTS.md` tiene 14.509 bytes; `.agents/AGENTS.md`, 6.061; hashes distintos. `docs/multi-ide-setup.md:7` declara la segunda como única fuente. Aider lee la raíz; `CLAUDE.md:1` apunta a la raíz; `setup-ide-pointers.ps1:60-133` distribuye `.agents/AGENTS.md`; `sync-agents.ps1:15-16` copia la raíz sobre la global.

**Actual.** Instalar, sincronizar o abrir otro IDE puede cambiar qué reglas ganan.

**Deseado.** Un solo núcleo fuente y adaptadores generados, nunca copias editables.

**Recomendación.** Hacer `AGENTS.md` raíz canónico y mínimo; generar bridges por proveedor desde él y un manifest. Eliminar sync bidireccional.

## F-03 — OpenCode bloqueado

**Evidencia.** `opencode --version` devolvió `1.17.9`; `opencode debug config` terminó con exit 1: `Unrecognized keys: version, agents` en `opencode.json:2-8`. La documentación oficial usa `$schema` y `agent` singular: [OpenCode config](https://opencode.ai/docs/config/), [OpenCode agents](https://opencode.ai/docs/agents/).

**Actual.** El repo no abre en OpenCode; los checks locales no lo detectan.

**Deseado.** Config validada por el CLI soportado y versionada como adapter.

**Recomendación.** Reescribir `opencode.json`, validar con `opencode debug config` en CI opcional y reducir `instructions` a núcleo + router.

## F-04 — Agentes sin capacidad de cumplir

**Evidencia.** `agente-design.md:3,6,16-22,30-36`, `agente-tests.md:3,6,15-20,28-34` y `agente-docs.md:3,6,16-22,30-34` prometen implementar/escribir pero solo permiten `Read,Grep`. Registry repite esas tools mientras declara outputs de cambios (`agents.registry.json:19-58`). `agente-researcher.md:24,29-41` requiere fuentes actuales sin web/browser/network.

**Actual.** El router selecciona especialistas que deben delegar o violar su contrato.

**Deseado.** Cada rol es `executor` con tools necesarias o `reviewer` read-only con output analítico; nunca ambos.

**Recomendación.** Usar el executor nativo del runtime; mantener únicamente security/research/code-review como agentes read-only cuando independencia o toolset lo justifican.

## F-05 — Aprobación global por identidad del agente

**Evidencia.** `agents.registry.json:15` marca al principal `requiresApproval: true`; cualquier fallback/trivial queda bloqueado. Los prompts design/tests/docs exigen siempre Plan Mode + espera aunque registry diga `false`. `ai-permissions.md:21-43` correctamente distingue acciones destructivas/externas.

**Actual.** La selección de un agente modifica el gate incluso si la acción es local y reversible.

**Deseado.** Aprobación por acción: lectura/local reversible automática; dependencias, borrado, producción, pagos, DMs y external writes piden confirmación justo antes del efecto.

**Recomendación.** Quitar `requiresApproval` del agente o convertirlo en `defaultActionRisk`; calcular gates desde la operación concreta.

## F-06 — Router determinista pero incorrecto

**Evidencia.** `router.ps1:42-123` usa regex, no `whenToUse`. `pr` en `:68` carece de límites; en la reconstrucción no persistida “preparación de examen” fue a code reviewer e “investigación actual” cayó al principal. No hay ruta semántica para 7 de 19 agentes. Una mención explícita omite el bloque de selección por keywords (`:45-112`), aunque después sí corren reviewer/risk/approval/output (`:119-149`). SEO siempre va a growth (`:83-86`), nunca al SEO técnico.

**Actual.** Los smoke tests solo comprueban que haya agentes; no el agente correcto.

**Deseado.** Router pequeño con precedencia explícita: instrucción válida del usuario → gate de riesgo no-bypass → intención → dominio → necesidad real de especialista → fallback `no_agent`.

**Recomendación.** Reescribir y cubrir con los 14 escenarios de `06-behavior-scenarios.md`, negativos y conflictos multietiqueta.

## F-07 — Checks superficiales

**Evidencia.** `validate-agents.ps1:80-155` valida campos, enums, paths y nombre. `test-system.ps1:51-66` busca solo backticks en un AGENTS; `:79-114` acepta archivos por tamaño/directorio no vacío. CI corre solo registry (`.github/workflows/validate-agents.yml:16-18`). `check-agents-system.ps1:64-72` no hace `exit 1`. Release quedó rojo solo por identidad Git, no por arquitectura.

**Actual.** `test-system -AgentsRoot .\.agents` da 0/0 mientras hay rutas rotas; OpenCode es inválido.

**Deseado.** Gates de sintaxis + schema + grafo + contratos + fixtures de routing + adapters.

**Recomendación.** Unificar en `bin/validate-system` cross-platform y hacer que CI ejecute exactamente ese gate.

## F-08 — Inicio de sesión anti chat-first

**Evidencia.** `start.md:13-40` son ocho probes; `:42-50` exige reporte; `:55-56` espera nueva instrucción. Esto contradice `:10-11` y `:52-53`, que prometen no fallar por faltantes.

**Actual.** Un typo de una línea puede provocar inventario de sesión y doble turno.

**Deseado.** Lectura lazy: cargar solo reglas aplicables, estado Git y artefactos que afectan la tarea; reportar faltantes solo si bloquean.

**Recomendación.** Reescribir `start` en 5-10 líneas o absorberlo en el núcleo.

## F-09 — Explosión de procesos

**Evidencia.** Una feature mediana puede activar: regla global de plan (`AGENTS.md:49-53`), brainstorming obligatorio, writing-plans, spec-kit, lean kickoff, kickoff agent, TDD, worktree, code review y validation. `parallel_agents.md` también contiene dispatch, Ralph, maker/checker, budget, goal y worktrees; esos temas tienen skills propias.

**Actual.** Pasos condicionales se expresan como “siempre” en distintas capas.

**Deseado.** Una sola escala de intensidad con gates acumulativos y mutuamente comprensibles.

**Recomendación.** `small → direct`, `medium → brief plan`, `large/high-risk → spec`, `parallel only if independent`, `review only if impact justifies`.

## F-10 — Instalación y update con riesgo de pérdida/drift

**Evidencia.** `bin/update-system.ps1:99-130`, `update.ps1:41-62` y `update.sh:46-67` borran/copias globales; Unix no instala adapters multi-IDE; `sync-agents.ps1` usa ruta vieja; `README.md:69` mezcla `%USERNAME%` con PowerShell.

**Actual.** Un update puede borrar contenido local, alternar entre dos AGENTS o copiar config inválida.

**Deseado.** Instalación idempotente, dry-run, backup, manifest de archivos administrados y post-check por proveedor.

**Recomendación.** Un instalador cross-platform o dos adapters equivalentes respaldados por fixtures de filesystem.

## F-11 — Gitlink huérfano

**Evidencia.** `git ls-files -s` muestra `.agents/skills/obsidian-skills` con modo `160000` y commit `fa1e131...`; no existe `.gitmodules`; `git submodule status` falla.

**Actual.** El directorio queda vacío y `test-system` lo contabiliza como skill tolerable.

**Deseado.** Submódulo reproducible con URL o eliminación del gitlink.

**Recomendación.** DELETE si no hay consumo demostrado; si existe, restaurar `.gitmodules`, pin y test de clone recursivo.

## F-12 — Vigencia por proveedor

| Afirmación | Clasificación | Evidencia actual |
|---|---|---|
| Codex descubre `AGENTS.md` root→cwd y override cercano gana | Específica, vigente | [OpenAI: AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md.md) |
| Codex descubre `.agents/skills` con progressive disclosure | Específica, vigente | [OpenAI: skills](https://learn.chatgpt.com/docs/build-skills.md) |
| Claude importa AGENTS por texto natural | Incorrecta | Import nativo es `@AGENTS.md`: [Claude memory](https://code.claude.com/docs/en/memory) |
| Pronunciar “workflow” activa Dynamic Workflows | No demostrada | No aparece en docs oficiales de [subagents](https://code.claude.com/docs/en/sub-agents) o [agent teams](https://code.claude.com/docs/en/agents). |
| Cursor `.cursorrules` es el mecanismo recomendado | Workaround histórico | [Cursor Rules](https://cursor.com/docs/rules) lo marca legacy/deprecated y recomienda `.cursor/rules`/User Rules. |
| Gemini CLI transicionó a Antigravity | Específica, vigente | [Google announcement](https://developers.googleblog.com/en/an-important-update-transitioning-gemini-cli-to-antigravity-cli/) |
| Antigravity usa `.agents/skills` | No demostrada | No se encontró una fuente oficial directa que garantice esa migración; no debe publicarse como hecho. |
| Devin Desktop soporta ACP | Específica, vigente | [Cognition announcement](https://devin.ai/blog/windsurf-is-now-devin-desktop) |
| Un AGENTS es compartido automáticamente por todos los agentes ACP | Inferencia no demostrada | La fuente confirma ACP, no ese mecanismo de contexto. |

### Vigencia de capacidades, modelos y prompting (verificada 2026-07-15)

| Tema del repo | Estado frente a documentación oficial | Decisión |
|---|---|---|
| Familias fijas de modelos en `rules/model_routing.md:12-24` | Obsoleto/no portable: el catálogo cambia y la documentación vigente recomienda elegir por capacidad/costo; [OpenAI Models](https://developers.openai.com/api/docs/models) expone modelos y tools actuales, y OpenCode pide IDs `provider/model-id` consultables con `opencode models`: [OpenCode Agents](https://opencode.ai/docs/agents/). | No hardcodear familias globales; usar capability requirements, eval fecha/versionada y fallback del proveedor. |
| Prompt universal largo y cargado siempre | Contradice carga selectiva: Codex usa progressive disclosure para skills; Claude difiere MCP tools con Tool Search: [OpenAI skills](https://learn.chatgpt.com/docs/build-skills.md), [Claude MCP](https://code.claude.com/docs/en/mcp). | Núcleo corto, metadata breve y contenido completo solo bajo demanda. |
| “Prompting moderno” como endorsements/absolutos (`rules/prompting.md:46-57`) | No hay evidencia oficial de que slogans o MUST globales mejoren todas las tareas; los modelos actuales exponen reasoning/tool capabilities configurables. | Conservar objetivo, constraints, ejemplos y criterio de salida; evaluar instrucciones costosas por fixture, no por autoridad retórica. |
| MCP como catálogo que conviene cargar preventivamente | Incorrecto por costo/riesgo: Claude difiere schemas; OpenCode advierte costo de contexto y soporta permissions; [Claude MCP](https://code.claude.com/docs/en/mcp), [OpenCode MCP](https://opencode.ai/docs/mcp-servers/), [OpenCode tools](https://opencode.ai/docs/tools). | Discover/read-only primero, least privilege, tool allowlist, auth/owner/version y carga condicional. |
| Planificación y paralelismo siempre custom | Redundante al menos en Claude, que documenta Plan/Explore/subagents/teams/worktrees: [Claude subagents](https://code.claude.com/docs/en/sub-agents), [Claude parallel agents](https://code.claude.com/docs/en/agents). La equivalencia nativa de Codex no se presenta como claim oficial verificado en esta auditoría. | El repo define umbrales y outputs y usa capacidades nativas solo cuando el adapter las verifica; no presupone un scheduler uniforme. |
| Búsqueda/ejecución/validación requieren personas separadas | No necesariamente: Claude documenta `WebSearch`, edición, shell, Agent y Skill como tools nativas; OpenCode trae bash/edit/web y permissions; [Claude tools](https://code.claude.com/docs/en/tools-reference), [OpenCode tools](https://opencode.ai/docs/tools). | Crear agente solo si aislamiento, independencia o toolset cambia el resultado; validación sigue siendo gate de evidencia. |

## F-13 — Skills y lock desalineados

**Evidencia.** 53 directorios activos, 52 `SKILL.md` estándar. `.agents/.skill-lock.json` tiene 57 entradas: 35 activas, 21 archivadas y un folder incorrecto; 18 skills activas no aparecen. `skills_routing.md` omite 24 activas y nombra `obsidian-markdown`, `docx`, `xlsx`, `pptx` no activas.

**Recomendación.** Generar catálogo/lock desde un manifest único y validar nombre, path, status, owner, versión y trigger.

## F-14 — Economía de contexto mal enfocada

**Evidencia.** Ambos `AGENTS.md` + rules + router + start + validation suman ~11,8K tokens estimados si se leen juntos (~10,3K sin el `.agents/AGENTS.md` duplicado). OpenCode declara ~13K en archivos existentes. Las 52 skills completas suman ~84K, pero Codex solo carga metadatos inicialmente y puede truncar el catálogo a 8.000 caracteres/2% de contexto según [OpenAI skills](https://learn.chatgpt.com/docs/build-skills.md).

**Actual.** Se invierte contexto en routers duplicados y rituales generales, mientras descripciones de skills pueden truncarse.

**Deseado.** Núcleo <2K tokens aproximados, manifest/router breve, skill/agente completo solo bajo demanda y archive nunca automático.

## F-15 — Archivo vendorizado redundante

**Evidencia.** 53 grupos SHA-256 duplicados, 167 archivos y ~2.289.242 bytes de copias excedentes. Office schemas/utilidades están triplicados en docx/pptx/xlsx; 54 TTF ocupan ~5,4 MB.

**Actual.** El archive representa 434/666 archivos físicos (~65%) y ~89% de los bytes; distrae búsquedas/checks.

**Deseado.** Archive fuera del runtime/scan; paquetes originales con provenance o release asset.

**Recomendación.** MOVE a repo/branch de archivo o DELETE tras registrar origen/licencia/hash; no deduplicar con una abstracción runtime nueva.

## F-16 — Tutor global stale y personal

**Evidencia.** `agente-academic-tutor.md:66-106,171-176` hardcodea Q1 2026, links NotebookLM y `C:\Users\ignac`; `:110-121` obliga leer vault antes de cualquier respuesta. Identidad actual es `nacho` y fecha de auditoría 2026-07-15.

**Recomendación.** Mover contexto de semestre/vault a adapter de proyecto o memoria recuperada bajo demanda; conservar pedagogía como skill.

## F-17 — Schema decorativo

**Evidencia.** `validate-agents.ps1:65-69` solo parsea el schema; no lo aplica. `route-task.ps1:17-20` no usa `task.schema.json`. Un objeto incompleto llega al router y produce campos nulos.

**Recomendación.** Validador Draft 2020-12 real antes de routing; contratos versionados y fixtures inválidos que deben fallar.

## F-18 — Sin observabilidad ni evidencia de utilidad

**Evidencia.** `usage-log.md` es manual; no hay trace de decisión, componente cargado, override, aprobación, outcome, costo ni corrección. No se puede demostrar que 19 agentes o 52 skills mejoren resultados.

**Recomendación.** Log local mínimo y opt-in: `task_kind`, ruta, componentes cargados, gate, outcome, corrección y duración; sin prompts ni datos personales. Agregar reporte de componentes nunca usados y eval A/B de instrucciones costosas.

## Contrato completo por hallazgo

Esta matriz completa los seis campos obligatorios por hallazgo; las secciones anteriores aportan el detalle y las mediciones.

| ID | Evidencia concreta | Por qué importa | Actual | Deseado | Recomendación | Archivos afectados |
|---|---|---|---|---|---|---|
| F-01 | `AGENTS.md:29-121`; `.agents/workflows/index.md:33`; `.agents/SKILL.md:19-24`; `config/opencode/opencode.jsonc:66-92` | El runtime recibe destinos imposibles. | 12 rutas archivadas y 2 ausentes siguen activas. | Grafo activo resoluble, archive sin inbound refs. | Cortar refs y validar status/path en CI. | `AGENTS.md`, `.agents/SKILL.md`, workflows, OpenCode, docs. |
| F-02 | `AGENTS.md` 14.509 bytes vs `.agents/AGENTS.md` 6.061; `docs/multi-ide-setup.md:7`; `setup-ide-pointers.ps1:60-133` | El comportamiento cambia por IDE/instalación. | Copias editables divergentes. | Policy humana única + manifest metadata; adapters generados. | Canonizar root, generar bridges, eliminar sync bidireccional. | Ambos AGENTS, `CLAUDE.md`, setup/sync, adapters. |
| F-03 | `opencode debug config` 1.17.9: exit 1 por `version`/`agents`; `opencode.json:2-8` | Un proveedor declarado no abre. | Config inválida y checks verdes. | Adapter válido probado por CLI. | Reescribir schema/`agent` y agregar smoke. | `opencode.json`, `config/opencode/*`, CI. |
| F-04 | `agente-design.md`, `agente-tests.md`, `agente-docs.md` tools `Read,Grep`; `agents.registry.json:19-58`; researcher sin web | Roles no pueden producir sus outputs. | Writer semántico con permisos de reviewer. | Executor con tools o reviewer read-only. | Consolidar executors y validar tools↔outputs. | Prompts de agentes, registry/manifest, router. |
| F-05 | `agents.registry.json:15`; prompts design/tests/docs; `ai-permissions.md:21-43` | Bloquea lo trivial y puede confundir riesgos reales. | Approval depende del nombre del agente. | Gate justo antes de la operación. | Quitar `requiresApproval`; clasificar action risk. | Registry, prompts, router, permissions. |
| F-06 | `router.ps1:42-123`; `pr` sin boundary en `:68`; 7/19 sin ruta | Selección incorrecta añade costo o pierde capacidad. | Regex propia ignora `whenToUse`. | Precedencia única con `no_agent`, negativos y ES/EN. | Router puro + 14 positivos y ≥10 negativos. | Router, registry/manifest, fixtures. |
| F-07 | `validate-agents.ps1:80-155`; `test-system.ps1:51-114`; workflow CI `:16-18`; checker exit 0 | “Verde” no implica sistema ejecutable. | Forma/existencia sin semántica. | Schema+grafo+contratos+routes+adapters. | Un validador cross-platform usado por CI/release. | `bin/*check*`, validators, CI, schemas. |
| F-08 | `.agents/workflows/start.md:13-56` | Cada tarea puede pagar un turno improductivo. | Ocho probes, reporte y espera aunque falten irrelevantes. | Lectura lazy y bloqueo solo por artefacto necesario. | Absorber start en núcleo breve. | `start.md`, index, AGENTS. |
| F-09 | `AGENTS.md:49-53`; brainstorming, writing-plans, spec-kit, kickoff, TDD, worktree, review/validation | Capas acumulativas degradan velocidad y claridad. | Condicionales expresados como universales. | Escala small/medium/large/high-risk operativa. | Consolidar por fases y activar por umbral. | Root, skills de proceso, workflows, prompts. |
| F-10 | `bin/update-system.ps1:99-130`; `update.ps1:41-62`; `update.sh:46-67`; `sync-agents.ps1` | Update puede perder configuración local. | Copia/borrado no simétrico y drift. | Managed paths, backup, dry-run, idempotencia. | Instaladores equivalentes + home fixtures + restore test. | Install/update/setup/sync y docs. |
| F-11 | Git index modo `160000` SHA `fa1e131...`; sin `.gitmodules`; submodule falla | Clones no reproducen una skill declarada. | Gitlink vacío contado como skill. | Submodule completo o ausencia explícita. | DELETE salvo owner/URL/uso demostrado. | `.agents/skills/obsidian-skills`, `.gitmodules`, checks. |
| F-12 | Tabla de vigencia precedente + fuentes oficiales, verificadas 2026-07-15 | Claims stale rompen portabilidad y confianza. | Bridges mezclan soporte, workaround e inferencia. | Adapter con `lastVerified`, fuente, versión y estado. | Regenerar matriz por proveedor y testear solo claims demostrados. | CLAUDE/GEMINI/Cursor/OpenCode/Devin docs y configs; model/prompt/MCP rules. |
| F-13 | `.agents/.skill-lock.json`: 57 entradas (35 activas, 21 archive, 1 path erróneo); 18 activas ausentes; routing omite 24 | Lock/catalog no describe el runtime. | Tres inventarios incompatibles. | Catálogo generado desde manifest. | Validar nombre/path/status/version/trigger. | `.agents/.skill-lock.json`, `.agents/SKILL.md`, `skills_routing.md`, skills. |
| F-14 | Core estimado ~11,8K tokens; OpenCode ~13K; skills completas ~84K; límite catálogo Codex documentado | Contexto global compite con tarea y discovery. | Routers/rituales ansiosos; metadata puede truncarse. | Core 700-1.200 tokens y disclosure nativo. | Acortar core/descripciones y cargar refs por trigger. | AGENTS, rules, index/start/validation, skill metadata, OpenCode. |
| F-15 | 53 grupos SHA-256, 167 archivos, ~2.289.242 bytes excedentes; 54 TTF ~5,4 MB | Ruido ralentiza búsqueda/checks y oculta autoridad. | Archive es ~65% de archivos y ~89% de bytes. | Histórico fuera del runtime con provenance. | Mover/delete por lote tras hash/licencia/restore. | `.agents/archive/skills/*`, fonts/PDF/XSD/utils. |
| F-16 | `agente-academic-tutor.md:66-121,171-176`; Q1 2026, `C:\Users\ignac`, vault obligatorio | Datos stale/personales contaminan cualquier tutoría. | Contexto global fijo. | Pedagogía reusable; semestre/vault opt-in. | Convertir a skill y adapter de proyecto. | Tutor prompt, academic workflow/skills, memory. |
| F-17 | `validate-agents.ps1:65-69`; `route-task.ps1:17-20`; schemas no aplicados | Inputs inválidos llegan al router y aparentan contrato. | Schema decorativo. | Draft 2020-12 aplicado antes de routing. | Versionar schema y agregar invalid fixtures. | `schemas/*`, validator, route-task, examples. |
| F-18 | `tasks/usage-log.md`; ausencia de trace de route/gate/outcome/correction | No hay evidencia para conservar 19 agentes/52 skills. | Log manual y no evaluable. | Telemetría local mínima, opt-in y privada. | JSONL allowlist + reporte de unused/corrections + A/B. | Usage log, router, validation, privacy docs. |

## Diez conclusiones principales

1. El sistema está roto por drift posterior a la poda, no por falta de ideas.
2. Debe existir una fuente por concern: `AGENTS.md` para policy y manifest para metadata; hoy hay al menos siete competidoras.
3. Archive no puede ser fallback operativo.
4. Aprobación debe depender de la acción, no del nombre del agente.
5. Un agente sin tools compatibles no es un agente ejecutable.
6. El router machine-readable debe usar el mismo contrato que el router humano.
7. Los checks necesitan semántica y fixtures, no solo existencia.
8. Las skills sí son una buena unidad de progressive disclosure; deben podarse y catalogarse mejor.
9. Cross-IDE requiere adapters pequeños y testeados, no promesas uniformes.
10. Sin telemetría mínima no hay base para decidir qué conservar.
