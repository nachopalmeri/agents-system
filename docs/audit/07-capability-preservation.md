# Preservación de capacidades

Fecha de corte: 2026-07-15
Estado: decisión conservadora previa a cualquier migración
Alcance: 19 agentes actuales, sus skills, workflows y activos diferenciales

## Veredicto

La reducción inmediata a tres agentes es demasiado agresiva. Confunde dos decisiones distintas: cuántos perfiles deben cargarse o activarse automáticamente y cuánto conocimiento debe conservar el sistema. La recomendación operativa corregida es **3 agentes automáticos + 3 agentes explicit-only + 5 conversiones de bajo riesgo + 8 conversiones/candidatos que requieren evaluación**, preservando los 19 prompts originales hasta superar las compuertas de `10-safe-pruning-gates.md`. El target puede terminar sirviendo 11 capacidades mediante core/skills, pero hoy solo cinco tienen reemplazo suficientemente directo para llamarlas `SAFE_AS_SKILL`.

`SAFE_AS_SKILL` significa que la capacidad puede ejecutarse sin una persona separada; no significa que el archivo sea seguro de borrar hoy. En todos los casos debe conservarse primero un snapshot versionado y extraerse el contenido diferencial. `PRESERVE_AS_REFERENCE` se aplica a playbooks, templates, voz, datos y conocimiento que salen del camino crítico pero siguen recuperables. `UNKNOWN` se reserva para dependencias que esta pasada no pudo inspeccionar; nunca equivale a delete.

## Criterio agente versus executor + skill

Se mantiene un agente cuando al menos una de estas propiedades cambia materialmente el resultado: independencia maker/checker, contexto aislado, tools o permisos diferentes, memoria durable, workspace externo, efectos externos o continuidad conversacional especializada. Se prefiere executor + skill cuando el valor principal es un procedimiento cargable bajo demanda y el mismo actor puede ejecutarlo de punta a punta con los mismos permisos.

## Matriz de conservación de los 19 agentes

| Agente actual | Capacidad y activo diferencial | Clasificación | Destino conservador | Condición antes de retirar el prompt |
|---|---|---|---|---|
| `agente-principal` | Ownership de lógica, routing, APIs, auth y DB; stack routing y cierre validado. | `SAFE_AS_SKILL` | Executor nativo + core mínimo; `astro`, `next`, `python`. | Probar ownership end-to-end y preservar matriz de scope; no heredar la separación artificial UI/tests/docs. |
| `agente-design` | Responsive, motion, contraste, foco, dark mode y QA visual. | `CANDIDATE_FOR_EVAL` | `frontend-design` + sus siete referencias; posible `visual-qa`. | Fixture responsive, accesibilidad, navegador/consola y evidencia visual. |
| `agente-tests` | Estrategia unit/E2E, mocks, fixtures, CI y regresión. | `SAFE_AS_SKILL` | `test-driven-development`, `systematic-debugging`, regla `testing` y checklist de review. | Executor demuestra escribir/ejecutar tests; reviewer conserva verificación independiente. |
| `agente-docs` | README, API docs, docstrings, changelog, setup y deploy. | `SAFE_AS_SKILL` | Docs simples al executor; `doc-coauthoring` para entregables complejos. | Fixtures para README/setup/API sin imponer coauthoring largo a cambios triviales. |
| `agente-seo` | SEO técnico/on-page: canonical, robots, sitemap, schema, metadata, OG, headings y alt. | `CANDIDATE_FOR_EVAL` | Crear `technical-seo`; mantener frontera negativa con `seo-geo-growth`. | La nueva skill debe existir y pasar fixture técnico; no fusionar silenciosamente con growth. |
| `agente-marketing-strategist` | GTM, positioning, CEP, CAC/LTV, canales, pricing ladder y GO/NO-GO/PIVOT. | `CANDIDATE_FOR_EVAL` | Crear `marketing-strategy`; referencias desde `archive/workflows/marketing.md`. | Extraer GTM, outbound, pricing y multicanal; comparar outputs estratégicos. |
| `agente-growth-seo-geo` | Adquisición SEO/GEO/AEO, local, programmatic seguro, backlinks, analytics y backlog 30/60/90. | `CANDIDATE_FOR_EVAL` | `seo-geo-growth` + referencias de presets, calidad y medición. | Conservar presets, briefs, analytics y reglas de poda/escala omitidas por la skill corta. |
| `agente-product-founder` | Money flows, portfolio, MVP patineta, founder fit, señales y kill/scale. | `CANDIDATE_FOR_EVAL` | `product-foundry` + referencias `product_foundry.md` y `venture_loop.md`. | Fixture idea→validación y etapa→distribución sin activar marketing/growth prematuramente. |
| `agente-ai-architect` | Capas AI/RAG, registry de prompts, evals, cache, tracing, costo y guards. | `CANDIDATE_FOR_EVAL` | Ejecución con `ai-production-architecture`; conservar temporalmente reviewer explícito. | A/B en diseño RAG de alto riesgo: calidad, omisiones, costo y correcciones humanas. |
| `agente-security-auditor` | Threat model, secretos, permisos, blast radius, least privilege y veredicto adversarial. | `KEEP_AUTOMATIC_AGENT` | `security-reviewer`, read-only, scanners seguros; alias temporal. | No convertir en checklist del autor; corregir tool contract y routing. |
| `agente-mcp-architect` | MCP portable/opt-in, auth, transporte, permisos, rollback y adopción read-only first. | `CANDIDATE_FOR_EVAL` | `mcp-adoption` + workflows `mcp_*` + bundle `archive/skills/mcp-integration`. | Extraer auth, transports, ejemplos y troubleshooting; security gate independiente. |
| `agente-obsidian-brain` | Vault externo, captura, inbox, Zettelkasten, MOCs, frontmatter, Dataview y memoria durable. | `KEEP_EXPLICIT_AGENT` | `obsidian-brain` + `obsidian-vault` + adapter privado de ruta/semestre. | Localizar vault real, corregir ruta stale, preview/confirmación y restore test. |
| `agente-code-reviewer` | Review independiente de bugs, regresiones, edge cases y evidencia P0/P1/P2. | `KEEP_AUTOMATIC_AGENT` | `code-reviewer` read-only + checklist asociado; alias temporal. | Activar por impacto/pre-merge, nunca por substring `pr`. |
| `agente-researcher` | Fuentes vigentes, jerarquía official/community, citas, fecha, incertidumbre y hype. | `KEEP_AUTOMATIC_AGENT` | `researcher` read-only con web/browser/citations; alias temporal. | Tools reales de investigación y fixture con claims temporales citados. |
| `agente-release-manager` | Commit/release, reproducibilidad, instalación cross-machine y frontera de publicación. | `KEEP_EXPLICIT_AGENT` | `release-operator` con action gate + `release-check.ps1` + checklist reusable. | Ensayo completo de preparación y publicación; autorización humana no delegable. |
| `agente-academic-tutor` | Método socrático, diagnóstico, ejercicios, simulacros, rúbrica, active recall y continuidad. | `KEEP_EXPLICIT_AGENT` | `academic-tutor`; submodos existentes; adapter privado académico actual. | Preservar pedagogía, NotebookLM y tracking; escritura en vault sigue separada y opt-in. |
| `agente-x-content-strategist` | Voz y positioning personal, edición anti-slop, decisión de canal y feedback. | `CANDIDATE_FOR_EVAL` | `content-strategist` explicit-only + futura `content-strategy` + adapter de voz. | Localizar dependencias externas y revalidar claims Phoenix; A/B de fidelidad de voz. |
| `kickoff-architect` | Inicio lean, primer milestone y escalamiento light/standard/deep. | `SAFE_AS_SKILL` | `lean-project-kickoff`; Venture Loop solo para producto. | Fixture de kickoff sin documentación ni workflow prematuros. |
| `workflow-pruner` | Economía de contexto, duplicación y separación core/on-demand. | `SAFE_AS_SKILL` | `token-efficiency-check`; prompt original como fixture de regresión. | `delete` exige no-loss, inbound refs cero, snapshot y rollback probado. |

## Mapa operativo completo

Esta tabla descompone lo que la matriz de decisión anterior resume. “Frecuencia” es una expectativa cualitativa basada en los casos de uso declarados, no telemetría.

| Agente | Identidad/interfaz | Tools y permisos actuales | Memoria/estado | Output y criterio de salida | Skills/workflows/assets | Duplicación, frecuencia y límite de una skill |
|---|---|---|---|---|---|---|
| principal | Executor general; chat de implementación. | Read/Grep/Edit/Write/Bash; workspace-write. | lessons/todo del repo. | Cambio funcional + tests/validación. | astro/next/python, planning, validation. | Alta; duplica core. Skill alcanza salvo que se mantenga el scope fragmentado. |
| design | Especialista UI con diálogo visual. | Read/Grep, aunque promete editar/browser: contrato roto. | Design system del proyecto. | UI responsive, a11y y evidencia visual. | frontend-design + siete references; adapt/audit/polish. | Media; skill alcanza para ejecución, pero visual QA independiente necesita browser/screenshots. |
| tests | Estratega unit/E2E. | Read/Grep, aunque promete escribir/ejecutar: contrato roto. | Fixtures y patrones del repo. | Regresión reproducida; suite relevante verde. | TDD, systematic-debugging, testing rule. | Alta; executor+skills alcanza; independencia queda en reviewer. |
| docs | Autor técnico. | Read/Grep, aunque promete escribir. | Convenciones del repo. | README/API/setup/deploy coherentes. | doc-coauthoring; templates existentes. | Media; skill alcanza, con modo simple para no sobreritualizar. |
| SEO técnico | Auditor/implementador on-page. | Read/Grep, aunque promete editar. | Estado del sitio/GSC si se aporta. | Canonical/robots/schema/meta validados. | Agente es hoy el activo principal; skill final ausente. | Media; `technical-seo` debe existir. Growth no reemplaza esta frontera. |
| marketing | Estratega GTM/positioning. | Read-only. | Contexto de oferta/mercado. | Memo de posicionamiento, canales y decisión. | marketing agent + archive workflow/templates. | Media/baja; una skill alcanza solo después de extraer GTM, pricing y outbound. |
| growth | Operador estratégico SEO/GEO/AEO. | Read/Grep/Write; no gasto/DMs. | Métricas, keywords y backlog. | Mapa, briefs y 30/60/90 medible. | seo-geo-growth + presets/workflow. | Media; skill alcanza si conserva analytics, programmatic quality y poda. |
| product founder | Facilitador de decisiones de producto. | Read/Grep/Write; no gasto/launch implícito. | Portfolio, señales y decisiones. | ICP, dolor, MVP, precio, experimento y kill/scale. | product-foundry + product/venture workflows. | Media; skill alcanza por etapa; Venture Loop es reference, no carga base. |
| AI architect | Arquitecto/posible checker. | Read/Grep/Edit/Write/Bash. | Decisiones, golden datasets, evals. | Diagrama/capas, threat assumptions, eval/ops plan. | ai-production-architecture + workflow. | Baja/media; skill sirve al executor; reviewer separado puede ganar en riesgo alto. |
| security auditor | Checker adversarial. | Read/Grep; read-only. | Findings/evidencia de la tarea. | Severidad, mitigación, GO/NO-GO/PIVOT. | ai-permissions, mcp-security, scanners. | Media; una skill del autor no preserva independencia. |
| MCP architect | Diseñador de integración. | Read/Grep/Write; instalación sensible gated. | Catálogo, auth y decisiones de adopción. | Diseño, permisos, setup/rollback. | tres workflows MCP + bundle de integración. | Baja/media; skill alcanza, security reviewer mantiene independencia. |
| Obsidian brain | Curador persistente del segundo cerebro. | Read/Grep/Edit/Write/Bash sobre vault externo. | Vault durable, frontmatter, links, tracker. | Preview, nota válida, links y recibo. | obsidian-vault, templates/Dataview; assets externos. | Media; skill sola no cubre workspace, permisos ni ownership durable. |
| code reviewer | Checker maker/checker. | Read/Grep; read-only. | Diff, tests y logs de la tarea. | P0/P1/P2 + approve/request changes/discuss. | requesting-code-review checklist. | Media; skill del executor no preserva independencia. |
| researcher | Investigador fechado. | Hoy Read/Grep; faltan web/browser/citations. | Fuentes y fecha, no memoria durable. | Hechos/inferencias/unknowns citados. | prompt y policy de fuentes. | Media; necesita toolset/contexto distinto y por eso sigue agente. |
| release manager | Operador de frontera externa. | Read/Grep/Write; faltan Git/check tools en contrato. | Branch, remote, changelog y recibos. | Checklist, blockers y acción separada. | release-check, Git/security rules. | Baja pero alto impacto; skill no debe fusionar prepare/publish. |
| academic tutor | Persona pedagógica socrática. | Read/Grep; no escribe vault. | Progreso, errores, materias y NotebookLM. | Diagnóstico, práctica, rúbrica y plan. | seis skills académicas + academic workflow. | Alta estacional; skill no garantiza continuidad/interfaz ni separación de persistencia. |
| X content | Voz/editor multicanal. | Read/Grep/Edit; no publica/gasta/DM. | Voz, positioning, feedback y vault externo. | Variantes X/LinkedIn/Substack + hipótesis de mejora. | x_content_system, x optimizer, archivos externos. | Media; skill+adapter puede alcanzar, pero fidelidad de voz requiere A/B. |
| kickoff architect | Facilitador lean. | Read/Grep. | Contexto inicial del proyecto. | Objetivo, slice, riesgos, tres pasos. | lean-project-kickoff. | Media/alta; duplicación casi total, skill suficiente. |
| workflow pruner | Auditor de contexto. | Read/Grep; read-only. | Baseline y findings de eficiencia. | Keep/shorten/on-demand/eval. | token-efficiency-check, anti-cemetery. | Baja; skill suficiente si delete queda detrás de gates. |

## Activos de mayor riesgo de pérdida

1. Suite académica: `active-recall-engine`, `exam-simulator`, `coding-exercises`, `case-analysis` y `study-progress-tracker`.
2. Modelo del vault en `obsidian-vault`: PARA/Zettelkasten, frontmatter, templates, Dataview y reglas de preservación.
3. `archive/workflows/venture_loop.md`: idea → MVP → landing → distribución → medición → kill/keep/scale.
4. `archive/workflows/marketing.md`: GTM, CEP, pricing ladder, multicanal, outbound y auditoría gratis.
5. Voz y posicionamiento personal en `agente-x-content-strategist.md` y el ciclo de `x_content_system.md`.
6. Presets, programmatic quality, analytics y poda en growth agent/workflow.
7. Capas, golden dataset, eval, tracing y guards de AI production.
8. Auth, transports, tool usage, ejemplos y troubleshooting de `archive/skills/mcp-integration/`.
9. `bin/release-check.ps1` y la separación entre preparar y ejecutar una publicación.
10. Siete referencias de `frontend-design` y el circuito de evidencia visual.

También son importantes el checklist maker/checker de code review y la disciplina de fuentes/fecha/incertidumbre del researcher. No se eliminan por quedar fuera del top diez.

## Registro de activos únicos y recuperación

| Ubicación actual | Por qué es único | Consumidor | ¿Entra hoy al contexto? | Destino y recuperación bajo demanda | Riesgo |
|---|---|---|---|---|---|
| `skills/active-recall-engine/SKILL.md` | Protocolo cognitivo y formato de sesión refinado. | Tutor/exam/tracker. | Solo ruta académica; hoy se carga en bundle amplio. | Skill activa; tutor la recupera por intención de práctica. | Alto si se resume como “hacer preguntas”. |
| `skills/exam-simulator/SKILL.md` | Rúbricas por materia, semáforo y post-mortem. | Tutor. | Preparación de examen. | Skill explícita `exam-simulator`. | Alto. |
| `skills/{coding-exercises,case-analysis}/SKILL.md` | Progresión de cinco niveles y hints para código/teoría. | Tutor. | Según modo; hoy ambas pueden cargarse juntas. | Skills separadas seleccionadas por tipo de materia. | Alto. |
| `skills/study-progress-tracker/SKILL.md` | Estados de dominio, evidencia y spacing. | Tutor/Obsidian. | Académico con tracking. | Skill + adapter privado; carga solo si se pide seguimiento. | Alto. |
| `skills/obsidian-vault/SKILL.md` | PARA/Zettelkasten, frontmatter, Dataview y templates específicos. | Obsidian/tutor/content. | Vault y, hoy, examen aun sin persistencia. | Skill del vault + referencias/templates. | Muy alto. |
| `agente-academic-tutor.md` (NotebookLM/esquema) | Contexto personal construido durante el semestre. | Tutor. | Hoy entra con el prompt entero. | Adapter privado `academic-current`; lookup por materia. | Muy alto; privacidad y ruta stale. |
| `archive/workflows/venture_loop.md` | Pipeline completo, primeros clientes, distribución y kill/scale. | Product/marketing/growth/kickoff. | Puede entrar por refs de producto; archive no debería auto-cargar. | References por etapa (`validation`, `distribution`, `kill-scale`). | Alto. |
| `archive/workflows/marketing.md` | CEP, pricing ladder, outbound y multicanal específicos. | Marketing/product/content/growth. | Archive; acceso inconsistente. | References de futura marketing skill. | Alto. |
| `archive/workflows/x_content_system.md` | Árbol de canal y ciclo documentar→extraer→expandir. | Content strategist. | Referenciado pero archivado. | `content-strategy/references/channel-system.md`. | Alto. |
| `skills/x-algorithm-optimizer.md` | Matriz Phoenix y diagnóstico de métricas. | Content strategist. | Solo diagnóstico X. | Reference fechada y citada; recuperar por diagnóstico. | Alto por obsolescencia, no por falta de valor. |
| `agente-x-content-strategist.md` (voz) | Historia, tono, nicho y anti-slop personales. | Content strategist. | Entra con agente completo. | Adapter privado `nacho-content-voice`; lookup por creación/editorial. | Muy alto. |
| `skills/frontend-design/reference/*.md` | Siete guías de color, interacción, motion, responsive, espacio, tipo y UX writing. | Frontend/visual QA. | Potencialmente transitivo. | References individuales por necesidad del brief. | Alto si se aplastan en una checklist. |
| `archive/workflows/seo_geo_growth.md` | Presets, briefs, analytics, programmatic quality y poda. | Growth/technical SEO. | Archive; puede cargarse entero. | References `presets`, `measurement`, `programmatic-quality`. | Medio-alto. |
| `skills/ai-production-architecture` + `archive/workflows/ai_production.md` | Capas, golden dataset, eval, tracing, guards y versión MVP. | AI/executor/security. | Solo ruta AI, con duplicación. | Skill core + references `evals`, `ops`, `security`. | Medio-alto. |
| `archive/skills/mcp-integration/` | Auth, transports, examples, naming y troubleshooting. | MCP/security/release. | Archive, no debería entrar automáticamente. | References versionadas por provider/tema. | Alto si se elimina como “Claude-specific”. |
| `skills/requesting-code-review/code-reviewer.md` | Checklist maker/checker y git range. | Reviewer/dispatch. | Review high-impact. | Reference del reviewer. | Medio. |
| `skills/systematic-debugging/*` | Root-cause, defense-in-depth, polling y scripts/casos. | Executor/tests/reviewer. | Bug; hoy puede cargarse junto a TDD completo. | Skill core + references/scripts por fase. | Medio. |
| `bin/release-check.ps1` | Gate ejecutable de sintaxis, secretos, routing e instalación. | Release/CI. | No es prompt: se ejecuta. | Mantener código; invocar por prepare/release. | Muy alto si se reemplaza por prosa. |

Todos estos activos tienen destino conceptual; donde el archivo destino aún no existe, G2 de `10` queda bloqueado y el original sigue activo/recuperable.

## Capacidades todavía sin reemplazo equivalente

| Gap | Estado | Acción conservadora |
|---|---|---|
| Skill activa `technical-seo` | No existe | Conservar agente; crear y evaluar antes de alias o retiro. |
| Skill activa `marketing-strategy` | No existe | Preservar agente y workflow archivado. |
| Skill completa `content-strategy` + adapter de voz | No existe | Mantener especialista en evaluación. |
| Operador de release con tools Git y gate de acción | Contrato actual incompleto | Mantener explicit-only y corregir, no fusionar. |
| Reviewer visual independiente con screenshots/browser | No está formalizado | Cubrir por fixture; mantener capacidad aunque cambie su forma. |
| Researcher con web/browser/citations | Prompt declara investigación pero tools actuales no alcanzan | Corregir toolset antes de usarlo como reemplazo. |
| Adapter académico/vault privado y vigente | Ruta y semestre stale | Localizar y migrar datos; jamás descartarlos por estar obsoletos. |

## Dependencias ausentes: `UNKNOWN`

No aparecieron en este checkout `linkedin.md`, `content-pipeline.md`, `x-content-feedback.md`, `x-playbook-ejecutable.md`, varios `github-readmes/*`, `Registro Errores - Ensayos.md`, `Atlas/Maps/Study Tracker.md`, la capacidad `obsidian-markdown` ni el contenido del gitlink `obsidian-skills`. La ausencia solo prueba que el checkout no es autocontenido. Hay que localizar origen, permisos, versión y consumidor antes de decidir.

## Política de no pérdida

1. Ningún prompt original se borra durante las primeras fases.
2. Toda conversión registra snapshot, hash, fecha, provenance, consumidores, destino y owner.
3. Datos personales pasan a adapters privados versionados; no se publican ni se descartan.
4. Playbooks largos pasan a referencias cargables por demanda, no a un archivo inaccesible.
5. Se comparan 30–60 tareas reales más fixtures adversariales antes de retirar una persona.
6. Solo se retira si el target no empeora success rate, correcciones humanas, seguridad de tools, fidelidad de formato ni continuidad, y si el especialista original tampoco demuestra una ventaja material en esas dimensiones.
7. El rollback restaura prompt, referencias, manifest y fixtures con un único revert probado.

## Fuentes y límites de esta pasada

Se reutilizaron `02-findings.md` a `06-behavior-scenarios.md`; se reabrieron completos 03–06 por contener decisiones, arquitectura, migración y fixtures que esta pasada corrige. `00-audit-plan.md`, `01-current-system-map.md` y `02-findings.md` no se releyeron completos: su inventario y findings ya estaban consolidados, y de `02` solo se verificaron headings/referencias necesarias. Se inspeccionaron los 19 prompts, headings/tamaños de las skills directamente asociadas, workflows activos y nombres del archive. No se releyeron linealmente los 667 archivos, scripts de terceros, schemas, fuentes ni assets binarios del archive: hacerlo habría recreado el mismo problema de contexto. Las dependencias externas ausentes permanecen `UNKNOWN`. No se ejecutó ninguna migración ni se modificó runtime.
