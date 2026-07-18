# Decisiones por componente

## Criterio

- **KEEP:** capacidad clara, contrato coherente y bajo costo.
- **SHORTEN:** sirve, pero carga más contexto del necesario.
- **MERGE:** la capacidad sobrevive dentro de otro componente.
- **MOVE:** conservar fuera del camino crítico/runtime.
- **MAKE CONDITIONAL:** activar solo por trigger verificable.
- **REWRITE:** propósito válido, implementación/contrato incorrecto.
- **DELETE:** no justifica capacidad o confunde activamente.
- **ADD:** falta una pieza que resuelve un hallazgo concreto.

Las decisiones no son cambios ejecutados; son el target de migración reversible de `05-migration-plan.md`.

## Convención de evidencia

Cada identificador corto se convierte en una cita de path + sección mediante estos selectores, aplicados a **cada fila**:

| Grupo | Path resuelto | Secciones/fields examinados por decisión | Hallazgos cruzados |
|---|---|---|---|
| Agente | `.agents/agents/<id>.md` + entrada `<id>` de `agents.registry.json` | YAML `description`, `tools`, `model`; headings `Scope/Responsibilities`, `Proceso/Core Playbook`, `Output Format/Quality Gates/Prompt`. Si el archivo no tiene H2, cuerpo desde su H1 hasta EOF. | F-04, F-05, F-06, F-09 |
| Workflow | `.agents/workflows/<nombre>.md` | YAML `description`; headings `Objetivo/Regla`, `Proceso/Router/Acciones`, `Validación/Criterio/Salida/Rollback`. | F-01, F-08, F-09 |
| Skill | `.agents/skills/<id>/SKILL.md` | YAML `name`, `description`; headings `When to Use/Cuándo usar/Trigger`, `Workflow/Proceso/Phases`, `Output/Validation/Definition of Done`. Si faltan, H1→EOF. | F-13, F-14 y matriz de solapamiento de `06` |
| Adapter/config | path literal de la fila | claves/lines citadas en el motivo y matriz de vigencia F-12. | F-02, F-03, F-12 |
| Script/schema/doc | path literal o grupo homogéneo de la fila | funciones/claves/headings nombrados en el motivo; evidencia detallada en F-07/F-10/F-17. | F-07, F-10, F-17 |

Por ejemplo, la fila `agente-principal` cita `.agents/agents/agente-principal.md` → YAML `description/tools` + `## Tu Scope Exclusivo`, `## Lo que NUNCA Tocás`, `## Proceso de Trabajo`; `systematic-debugging` cita su YAML `description` + `## When to Use` + `## The Four Phases`. `01-current-system-map.md` conserva el path exacto de los 667 entries. No se usa una etiqueta sin resolver a estas secciones.

## Entry points y configuración

| Componente | Decisión | Evidencia y destino |
|---|---|---|
| `AGENTS.md` raíz | REWRITE | Es el entry point real de Codex/Aider y tiene 14 rutas no activas (`:29-121`). Convertir en núcleo canónico corto. |
| `.agents/AGENTS.md` | MERGE | Diverge del root y es distribuido por setup. Generarlo como adapter o eliminar la duplicación. |
| `CLAUDE.md` | REWRITE | `:1` no usa `@AGENTS.md`; mantener solo import nativo + diferencias Claude demostradas. |
| `GEMINI.md` | SHORTEN | Bridge útil, pero afirmar solo behavior verificado; no prometer skills Antigravity. |
| `.gemini/settings.json` | KEEP | `context.fileName` coincide con docs vigentes; quitar `_note` temporal no verificable. |
| `.cursorrules` | MOVE | Legacy; mantener un stub de migración y usar `.cursor/rules`/User Rules. |
| `.aider.conf.yml` | KEEP | Entry point simple a `AGENTS.md`. |
| `.github/copilot-instructions.md` | REWRITE | No depender de una segunda lectura; generar resumen o pointer soportado. |
| `.zed/settings.json` | MAKE CONDITIONAL | Adapter específico; validar contra Zed antes de distribuir. |
| `opencode.json` | REWRITE | Bloquea OpenCode 1.17.9 por claves inválidas. |
| `config/opencode/AGENTS.md` | REWRITE | Lista rutas archivadas (`:10-20`); reducir a adapter. |
| `config/opencode/opencode.jsonc` | REWRITE | Nueve instrucciones no activas y carga ansiosa (`:66-92`). |
| `config/opencode/package-lock.json` | DELETE | No hay `package.json` ni flujo que lo consuma. |
| `.gitattributes` / `.gitignore` | KEEP | Infraestructura básica; revisar encoding y generated files en migración. |
| `agent-ecosystem-v3.html` | MOVE | Huérfano, presenta “10+” agentes frente a 19; llevar a archivo histórico o regenerar desde manifest. |
| `CHANGELOG.md` | KEEP | Registro corto; actualizar solo cuando se implemente migración. |
| `SECURITY.md` | KEEP | Principios concretos y alineados con permisos. |

## Rules

| Componente | Decisión | Evidencia y destino |
|---|---|---|
| `rules/identity.md` | MOVE | Identidad/push personal no debe cargarse en todos los repos; config de usuario, no arquitectura compartida. |
| `rules/git.md` | SHORTEN | Conservar no-force-push/no-merge/secrets; commit/push no debe ser gate de toda respuesta. |
| `rules/ai-permissions.md` | KEEP | Es la mejor base: separa local, destructivo, externo y flags humanos (`:21-71`). |
| `rules/anti-cemetery.md` | MERGE | Integrar 6-8 líneas en gobernanza/deprecación; no necesita archivo global propio. |
| `rules/chat-first.md` | KEEP | Núcleo útil: lenguaje natural + mínimo workflow (`:5-40`). |
| `rules/code-style.md` | MOVE | Casi todo pertenece a linters/tsconfig o overrides por proyecto. |
| `rules/testing.md` | REWRITE | “Correr todos los tests” no aplica a docs/prompts; definir evidencia proporcional y delegar mecánica a CI. |
| `rules/prompting.md` | SHORTEN | Conservar objetivo/contexto/ejemplos/validación; quitar endorsements y absolutos (`:46-57`). |
| `rules/model_routing.md` | REWRITE | Tabla de familias genéricas sin evals/versiones (`:12-24`); usar capabilities + eval + riesgo. |

## Agentes activos

| Agente | Decisión | Motivo |
|---|---|---|
| `agente-principal` | MERGE | El executor es la capacidad nativa del runtime; absorber solo su contrato útil en core/validation y retirar la persona. |
| `agente-design` | MERGE | Solapa `frontend-design`; review visual es checklist del `code-reviewer`, no cuarto agente. |
| `agente-tests` | MERGE | Tests son responsabilidad del executor; estrategia de tests es modo/checklist del `code-reviewer`, no agente. |
| `agente-docs` | MERGE | Docs simples pertenecen al executor y documentos complejos a `doc-coauthoring`; no queda agente docs. |
| `agente-seo` | MERGE | La capacidad técnica/on-page sobrevive como skill `technical-seo`; no justifica una persona permanente. |
| `agente-marketing-strategist` | MERGE | La capacidad GTM sobrevive como skill `marketing-strategy`; no lanzar subagentes siempre (`:29-36`) ni depender de workflow archivado. |
| `agente-growth-seo-geo` | MERGE | Triplica `seo-geo-growth`; mantener un contrato único como skill, no agente. |
| `agente-product-founder` | MERGE | Triplica skill/workflows; conservar playbook único. |
| `agente-ai-architect` | MERGE | Triplica skill/workflow; usar la skill bajo demanda y `security-reviewer`/`code-reviewer` si el riesgo exige independencia. |
| `agente-security-auditor` | REWRITE | Sobrevive como agente canónico `security-reviewer`; alias viejo dura una release. |
| `agente-mcp-architect` | MERGE | Integrar adopción MCP en skill/checklist + security reviewer; no hace falta un agente y nunca debe activarse por palabra incidental. |
| `agente-obsidian-brain` | MERGE | La skill `obsidian-vault` cubre el dominio cuando vault/persistencia son explícitos; mover datos personales y rutas a adapter. |
| `agente-code-reviewer` | REWRITE | Sobrevive como `code-reviewer`; maker/checker por impacto/pre-merge, con alias viejo una release. |
| `agente-researcher` | REWRITE | Sobrevive como `researcher`; agregar web/browser y contrato de citas/fecha, con alias viejo una release. |
| `agente-release-manager` | MERGE | Conservar una skill de release bajo demanda; commit rutinario no necesita persona. |
| `agente-academic-tutor` | MERGE | Conservar pedagogía en skill `academic-tutor`; quitar vault siempre, Q1 2026 y `C:\Users\ignac`. |
| `agente-x-content-strategist` | MERGE | Conservar una skill `content-strategy` bajo demanda; quitar dependencias a `x_content_system` archivado y datos stale. |
| `kickoff-architect` | MERGE | Solapa `lean-project-kickoff`; conservar una sola skill de kickoff. |
| `workflow-pruner` | MERGE | Solapa `token-efficiency-check`; una sola skill. |

## Workflows activos

| Workflow | Decisión | Motivo |
|---|---|---|
| `academic_tutor.md` | MERGE | Duplicado del agente y skills académicas; usar router de submodos. |
| `agent_coordination.md` | MAKE CONDITIONAL | Solo 3+ workers con dependencias reales; quitar claims temporales no verificados. |
| `hooks.md` | MOVE | Referencia operativa bajo demanda, no contexto de sesión. |
| `index.md` | REWRITE | Conservar “menor suficiente”; cubrir 14 rutas, precedencia y `no_agent`; nunca archive fallback. |
| `mcp_adoption.md` | MERGE | Integrar con security en un único checklist de adopción. |
| `mcp_catalog.md` | REWRITE | Sustituir nombres vagos por registros con URL/owner/version/auth/scopes/evidencia. |
| `mcp_security.md` | KEEP | Least privilege/read-only/rollback son principios universales. |
| `multiagent_review_loop.md` | MAKE CONDITIONAL | Solo decisiones cuyo resultado pueda cambiar; acortar secuencia. |
| `parallel_agents.md` | SHORTEN | Dejar dispatch/contratos; mover Ralph, goal, budgets y worktrees a referencias/skills. |
| `session_checkpoint.md` | SHORTEN | Checkpoint compacto por umbral; quitar “dreaming” y ritual manual fijo. |
| `skills_routing.md` | REWRITE | Generar desde manifest; actualmente omite 24 activas y lista inactivas. |
| `start.md` | REWRITE | Lazy, no reporte obligatorio ni doble turno. |
| `validation.md` | SHORTEN | Un único gate proporcional; handoff/debt/commit solo si aplica. |

## Skills activas

| Skill | Decisión | Motivo |
|---|---|---|
| `active-recall-engine` | KEEP | Submodo pedagógico distinguible. |
| `adapt` | MAKE CONDITIONAL | Pase visual específico; no auto. |
| `ai-production-architecture` | KEEP | Buen workflow reusable; absorber agente/workflow duplicado. |
| `animate` | MAKE CONDITIONAL | Pase de motion explícito. |
| `astro` | SHORTEN | Adapter de stack pequeño; mover comandos verificables a proyecto. |
| `audit` | MERGE | Solapa `critique`; una auditoría UI con modos. |
| `bolder` | MAKE CONDITIONAL | Transformación visual explícita. |
| `brainstorming` | REWRITE | Quitar MUST universal; activar si hay novedad o ambigüedad de diseño. |
| `case-analysis` | KEEP | Submodo académico claro. |
| `clarify` | KEEP | UX copy tiene output distinguible. |
| `client-work` | KEEP | Contrato de cliente real; cargar pricing solo bajo demanda. |
| `coding-exercises` | KEEP | Submodo académico claro. |
| `colorize` | MAKE CONDITIONAL | Pase visual explícito. |
| `critique` | KEEP | Reviewer UI; absorber `audit`. |
| `css-animations` | MERGE | Puede ser referencia de `animate`; evitar dos triggers. |
| `delight` | MAKE CONDITIONAL | Pase visual explícito. |
| `dispatching-parallel-agents` | KEEP | Contrato de dispatch enfocado; absorber núcleo de workflow paralelo. |
| `distill` | MAKE CONDITIONAL | Pase visual explícito. |
| `doc-coauthoring` | SHORTEN | Buen proceso para docs complejas, demasiado ritual para docs técnicas simples. |
| `exam-simulator` | KEEP | Trigger natural “modo parcial”. |
| `executing-plans` | MERGE | Integrar como modo de `writing-plans`; no skill separada si el runtime ya ejecuta. |
| `extract` | MAKE CONDITIONAL | Solo design-system explícito. |
| `find-skills` | MAKE CONDITIONAL | Solo descubrimiento/instalación; no ayuda a routing interno normal. |
| `finishing-a-development-branch` | SHORTEN | Mantener opciones de handoff; quitar ritual de merge que el usuario controla. |
| `frontend-design` | KEEP | Executor UI distinguible; absorber `agente-design`. |
| `harden` | MAKE CONDITIONAL | Pase de edge cases/i18n explícito. |
| `lean-project-kickoff` | KEEP | Absorber `kickoff-architect`; solo proyecto/greenfield real. |
| `next` | SHORTEN | Adapter de stack. |
| `normalize` | MAKE CONDITIONAL | Pase design-system explícito. |
| `obsidian-skills` gitlink | DELETE | No reproducible desde este checkout sin `.gitmodules`; eliminar si no se recuperan owner/URL y consumo demostrado. |
| `obsidian-vault` | MAKE CONDITIONAL | Solo cuando vault está en scope. |
| `onboard` | MAKE CONDITIONAL | Feature UX específica. |
| `optimize` | MAKE CONDITIONAL | Performance UI específica; requiere medición. |
| `polish` | MAKE CONDITIONAL | Quality pass final, no cada UI. |
| `product-foundry` | KEEP | Absorber agente y workflows product/venture para ideación/MVP. |
| `python` | SHORTEN | Adapter de stack. |
| `quieter` | MAKE CONDITIONAL | Transformación visual explícita. |
| `receiving-code-review` | KEEP | Proceso específico y útil. |
| `remembering-conversations` | MAKE CONDITIONAL | Solo con referencia a pasado/stuck; depende de tool disponible. |
| `requesting-code-review` | SHORTEN | Gate por impacto; absorber maker/checker de workflow paralelo. |
| `seo-geo-growth` | KEEP | Absorber agente/workflow de growth; separar claramente SEO técnico. |
| `skill-creator` | MOVE | Herramienta de mantenimiento del sistema, no runtime diario; conservar scripts/evals. |
| `spec-kit` | MAKE CONDITIONAL | Solo large/cross-cutting/high-risk; no “más de 3 pasos”. |
| `study-progress-tracker` | MAKE CONDITIONAL | Solo persistencia/spacing solicitado. |
| `subagent-driven-development` | MERGE | Integrar con dispatch + review; evita stack de tres skills paralelas. |
| `systematic-debugging` | KEEP | Causa raíz antes de fix; buen trigger. |
| `test-driven-development` | MAKE CONDITIONAL | Código de comportamiento; no docs/config/CSS ni hotfix trivial sin valor de regresión. |
| `token-efficiency-check` | KEEP | Absorber `workflow-pruner`. |
| `using-git-worktrees` | KEEP | Referencia especializada; eliminar duplicación de `parallel_agents.md`. |
| `using-superpowers` | REWRITE | “1% y antes de cualquier respuesta” fuerza sobre-routing; reemplazar por selección normal de skills. |
| `verification-before-completion` | MERGE | Integrar semántica en `validation`; puede quedar como alias fino. |
| `writing-plans` | REWRITE | Plan proporcional, sin plan documento/commit por cada tarea multi-step. |
| `writing-skills` | MOVE | Mantenimiento del sistema, no runtime común. |
| `x-algorithm-optimizer.md` | REWRITE | No cumple layout de skill; mover a directorio estándar o archivar si no hay uso. |

## Archive

| Componente | Decisión | Motivo |
|---|---|---|
| 33 workflows en `.agents/archive/workflows/` | MOVE | Conservar historia fuera del scan/runtime; ninguno puede ser referenciado activamente. |
| `feedback_loop`, `promote_lesson` | MERGE | Su capacidad útil ya pertenece a validation + lesson policy. |
| `product_foundry`, `seo_geo_growth`, `ai_production`, `project_kickoff_lean` | MERGE | Absorber en skills activas homónimas/equivalentes. |
| `pr_policy`, `pr_code_review` | MERGE | Absorber en git policy + code review skill. |
| `task_ledger`, `client_workflow`, `venture_loop` | MAKE CONDITIONAL | Recuperar solo como templates de proyectos con tracking real; no globales. |
| `dreaming`, `outcomes`, `harness`, `weekly_review`, `growth_update`, `vault_review` | MOVE | Rutinas/automatizaciones opcionales, no instrucciones globales. |
| `llm_council`, `multiagent` concepts | MERGE | Una sola ruta de revisión de alto impacto; eliminar ritual de cinco voces fijo. |
| `marketing`, `marketing_mcp_eval`, `x_content_system` | MERGE | Absorber contratos útiles en agentes/skills activos. |
| `world-class-web`, `web-factory`, `web_briefing`, `performance_audit` | MERGE | Reintegrar solo checklists diferenciales en frontend/optimize, no pipelines separados. |
| 27 bundles de skills archivadas | MOVE | Paquetes de referencia; fuera del repo runtime, con manifest de provenance. |
| `docx`, `pptx`, `xlsx` archivados | DELETE | Reemplazados por skills oficiales/bundled actuales; contienen 2,29 MB de duplicación exacta. |
| `canvas-design` fonts y `theme-factory` PDF | MOVE | Assets históricos pesados; release asset o repo de plantillas. |
| `claude-opus-4-5-migration` | DELETE | Obsoleto por definición temporal. |
| Plugin/command/hook development bundles | MOVE | Útiles solo al crear plugins Claude; conservar upstream/pin, no runtime global. |
| `webapp-testing`, `supabase-postgres-best-practices`, `theme-factory`, `slack-gif-creator` | MAKE CONDITIONAL | Recuperables como plugins/skills instalables cuando el caso lo exige. |

## Registry, schemas, router y ejemplos

| Componente | Decisión | Motivo |
|---|---|---|
| `agents.registry.json` | REWRITE | Convertir en manifest canónico de agentes/skills/workflows/adapters; eliminar aprobación global. |
| `.agents/SKILL.md` | REWRITE | Catálogo manual con refs archivadas/ausentes (`:19-24`); generarlo desde manifest y dejar solo metadata activa. |
| `.agents/.skill-lock.json` | REWRITE | 57 entradas no coinciden con activas (F-13); regenerar lock con path/status/version/provenance. |
| `schemas/agent.schema.json` | REWRITE | Versionar contrato nuevo y aplicarlo de verdad. |
| `schemas/task.schema.json` | REWRITE | El shape base sirve, pero agregar `intent`, `actionRisk`, `requestedOutcome` y validación real cambia el contrato versionado. |
| `orchestrator/router.ps1` | REWRITE | Usar manifest/precedencia y tests; regex actuales fallan en español. |
| `examples/tasks/bugfix.json` | KEEP | Convertir en fixture con expected route. |
| `examples/tasks/docs-update.json` | KEEP | Agregar expected route/no approval. |
| `examples/tasks/security-review.json` | REWRITE | Hoy palabras incidentales agregan MCP/release; expected route debe ser explícito. |
| Fixtures de 14 escenarios | ADD | Cubren rutas obligatorias, negativos y colisiones. |

## Scripts y CI

| Componente | Decisión | Motivo |
|---|---|---|
| `bin/validate-agents.ps1` | MERGE | Parte de un único validador; aplicar schema y semántica. |
| `bin/test-system.ps1` | REWRITE | Resolver repo por defecto y analizar todo el grafo activo. |
| `bin/check-agents-system.ps1` | DELETE | Lista stale y exit 0; reemplazado por validator único. |
| `bin/release-check.ps1` | REWRITE | Orquestar validator único + adapter checks; no listas duplicadas. |
| `bin/check-secrets.ps1` | KEEP | Scan básico útil; documentar falsos positivos y alcance. |
| `bin/doctor.ps1` | REWRITE | Score debe derivarse de checks reales, sin constante “78 skills”. |
| `bin/route-task.ps1` | REWRITE | Validar schema antes de enrutar y exponer versión de contrato. |
| `bin/setup-ide-pointers.ps1` | REWRITE | Generar adapters soportados y probar destino; no afirmar uniformidad. |
| `bin/sync-agents.ps1` | DELETE | Ruta personal y sync destructivo/bidireccional. |
| `bin/update-system.ps1` | REWRITE | Manifest, backup, dry-run, no borrado total. |
| `bin/nuevo-proyecto.ps1` / `.sh` | REWRITE | Scaffolds simétricos, sin workflows archivados; bridges reales. |
| `bin/install-hooks.ps1` | MAKE CONDITIONAL | Solo opt-in; hooks no globales por defecto. |
| `install.ps1` / `install.sh` | REWRITE | Misma semántica, idempotencia, backup y post-validación. |
| `install-private.ps1` | MOVE | Adapter privado separado y documentado. |
| `setup-local.ps1` / `.sh` | MERGE | Unificar con installer/update; evitar tres caminos. |
| `update.ps1` / `.sh` | MERGE | Un único update seguro; eliminar duplicación con `bin/update-system`. |
| `.github/workflows/validate-agents.yml` | REWRITE | Ejecutar gate completo en Windows y Linux cuando aplique. |

## Docs, memoria y prompts

| Grupo/componente | Decisión | Motivo |
|---|---|---|
| `README.md` | REWRITE | Estructura y rutas pre-poda; debe generarse parcialmente desde manifest. |
| `docs/architecture.md` | REWRITE | Buena capa conceptual, rutas inexistentes (`:55-67`). |
| `docs/world-class-workflow.md` | SHORTEN | Conservar principios/precedencia; eliminar workflow maestro duplicado. |
| `docs/how-to-use-the-agent-system.md` | REWRITE | Publicita rutas archivadas (`:107-214`). |
| `docs/multi-ide-setup.md` | REWRITE | Tabla por proveedor actual y limitaciones reales. |
| `docs/activation-cheatsheet.md` | REWRITE | Generar desde manifest; hoy publicita componentes retirados. |
| `docs/agent-contract-baseline.md` | MOVE | Snapshot histórico anterior al registry. |
| `docs/task-envelope.md` | KEEP | Documento corto y correcto; añadir expected behavior. |
| `docs/bootstrap-laptop.md`, `private-repo-install.md`, `rollback.md` | REWRITE | Alinear paths/installer y rollback seguro. |
| `docs/opencode-*` | REWRITE | Alinear con config vigente; separar Studio opcional. |
| `.agents/docs/research-2026-06.md` | MOVE | Investigación temporal, nunca autoridad runtime. |
| `.agents/docs/roadmap-best-system.md` | MOVE | Roadmap histórico, no prompt. |
| `.agents/docs/plugin-distribution.md` | REWRITE | Lista esenciales archivados y path de changelog erróneo. |
| `.agents/docs/setup-guide.md` | REWRITE | Corregir Claude symlink/import, Cursor y Antigravity. |
| `.agents/memory/README.md` | SHORTEN | Mantener policy, quitar refs archivadas. |
| `lessons-global.md`, `lessons.md` | KEEP | Evidencia durable, carga bajo demanda; resolver contradicciones. |
| `developer_growth.md`, `outcome-scores.md`, `projects-index.md` | MOVE | Datos/observabilidad personal, no runtime global. |
| `tech_radar.md` | MAKE CONDITIONAL | Solo al proponer stack/herramienta. |
| `tasks/handoff.md`, `tech-debt.md`, `decisions.md` | MAKE CONDITIONAL | Solo si existen decisiones/deuda/handoff reales. |
| `tasks/usage-log.md` | REWRITE | Reemplazar log manual por trazas mínimas generadas. |
| `prompts/activate-global.md`, `activate-examples.md` | MOVE | Solo superficies web sin loader; generar desde núcleo. |
| `prompts/llm-council-portable.md` | MOVE | Herramienta manual opcional, no componente central. |

## Capacidades a agregar

| Componente nuevo | Decisión | Problema resuelto |
|---|---|---|
| `system.manifest.json` | ADD | Una fuente de status/path/trigger/owner/version para generar registry y docs. |
| `routing-fixtures/*.json` | ADD | Prueba 14 escenarios, falsos positivos y agentes inalcanzables. |
| `validate-system` cross-platform | ADD | Schema + grafo + contratos + adapters + fixtures. |
| `action-risk-gate.md` corto | ADD | Aprobación inmediata antes de side effects, independiente del agente. |
| Telemetría local opt-in | ADD | Ruta elegida, componentes cargados, outcome/corrección sin contenido sensible. |
| Política de deprecación | ADD | `active → deprecated → archived → removed`, sin refs entrantes. |
| Adapter tests por proveedor | ADD | Evita que OpenCode/Claude/Cursor drifteen silenciosamente. |
