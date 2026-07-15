# Escenarios de comportamiento

## Método

Se evaluaron dos routers actuales:

- **Prompt router:** `AGENTS.md` + `.agents/workflows/index.md` + reglas/skills referidas. Los archivos cargados son inferidos de las instrucciones porque el repo no registra trazas.
- **Router PowerShell:** `orchestrator/router.ps1`, ejecutado en memoria con task envelopes equivalentes durante la auditoría. Los envelopes/stdout no quedaron persistidos, por lo que la tabla es una reconstrucción de esa ejecución, no todavía una prueba reproducible. Fase 0 debe congelarla como fixtures antes de usarla como regression evidence.

La ruta recomendada usa la arquitectura de `04-target-architecture.md`.

## Resultado reconstruido del router PowerShell

| Escenario | Agentes seleccionados | Approval |
|---|---|---|
| Typo de una línea | `agente-principal` fallback | Sí |
| Bug con tests rojos | tests, principal, reviewer | Sí |
| Feature mediana | docs, principal, reviewer | Sí |
| Seguridad | security auditor | Sí |
| Landing | design | No |
| Investigación actual | principal fallback | Sí |
| Preparación de examen | code reviewer | No |
| Producto | code reviewer + product founder | No |
| Código + diseño + docs | docs + design + principal + reviewer | Sí |
| Acción externa | reviewer + release manager | Sí |
| Pedido ambiguo | principal fallback | Sí |
| Sesión larga | principal fallback | Sí |
| Faltan archivos esperados | tests + reviewer | No |
| Sin especialista necesario | principal fallback | Sí |

Los falsos positives de reviewer provienen del patrón `pr` sin boundary (`router.ps1:68`): matchea “preparación”, “producto” y “producción”.

## 1. Arreglo trivial de una línea

- **Ruta actual:** prompt router dice flujo simple (`index.md:18`), pero el principal exige leer contexto, entrar Plan Mode, esperar aprobación y commitear (`agente-principal.md:34-42`). Router PowerShell usa fallback principal y marca approval por registry.
- **Archivos cargados inferidos:** root o `.agents/AGENTS`, `index.md`, prompt principal, rules Git/testing y `validation.md`; `start.md` puede añadir lessons/todo/git/feature list.
- **Agente/workflow:** flujo simple + principal + validation; selección contradictoria.
- **Ambigüedad:** “simple” no define si evita agente/plan/start.
- **Fricción:** doble turno, plan, tests globales y push para un typo.
- **Ruta recomendada:** `no_agent`; editar; check focalizado/diff; commit/push solo según pedido/policy de sesión. Exit: línea correcta y scope limpio.

## 2. Bug con tests fallando

- **Ruta actual:** `index.md:19` → debugging + validation; `skills_routing.md:15,20` puede activar systematic debugging y TDD; router PowerShell elige tests + principal + reviewer.
- **Archivos cargados:** núcleo, index, systematic-debugging, TDD, prompts tests/principal/reviewer, validation/testing.
- **Agente/workflow:** hasta tres agentes y tres gates. Tests no puede escribir (`agente-tests.md:6`) y principal declara que no hace tests.
- **Ambigüedad:** nadie es dueño end-to-end del fix + regresión.
- **Fricción:** handoffs y aprobación antes de diagnosticar.
- **Ruta recomendada:** executor único con systematic debugging; TDD como fase si un regression test aporta valor; reviewer solo high-impact/pre-merge. Exit: síntoma reproducido, causa raíz, fix, test original y suite relevante verdes.

## 3. Feature mediana

- **Ruta actual:** `index.md:23` dice plan breve + spec; root exige plan >3 pasos; pueden dispararse brainstorming, writing-plans, spec-kit, kickoff, TDD y worktree. Router PowerShell agrega docs por la palabra usada en el fixture.
- **Archivos cargados:** núcleo, index, 3-6 skills de proceso, agente principal/docs/reviewer, validation.
- **Agente/workflow:** frontera medium/large no es operativa; “más de 3 pasos” compite con “menor workflow”.
- **Ambigüedad:** spec y plan no tienen umbral común.
- **Fricción:** documento de plan exhaustivo y subagentes aunque el cambio sea coherente.
- **Ruta recomendada:** executor + plan breve con archivos/criterios; brainstorming solo si requirements/diseño están abiertos; TDD para comportamiento; spec-kit solo cross-cutting/high-risk. Exit: criterios y tests relevantes.

## 4. Auditoría de seguridad

- **Ruta actual:** `index.md:29` → validation + security auditor. Router PowerShell correctamente elige security auditor, aunque palabras MCP/release pueden añadir roles incidentales en otros textos.
- **Archivos cargados:** núcleo, ai-permissions, security prompt, validation; potencialmente los tres MCP workflows aunque no haya MCP.
- **Agente/workflow:** security auditor read-only es apropiado.
- **Ambigüedad:** no define threat model/assets ni cuándo MCP está en scope.
- **Fricción:** catálogos MCP y release manager por keywords.
- **Ruta recomendada:** security reviewer + scope/assets/threat assumptions + scanners seguros + evidencia. MCP adoption solo si hay integración MCP/plugin. Exit: findings con severidad, evidencia, mitigación y GO/NO-GO.

## 5. Diseño de una landing

- **Ruta actual:** `index.md:22` → simple + frontend-design. También existen design agent, brainstorming obligatorio y múltiples design-pass skills. Router PowerShell elige design, pero su agent tiene solo Read/Grep.
- **Archivos cargados:** núcleo, index, frontend-design, design agent, brainstorming y potenciales animate/polish/adapt/audit.
- **Agente/workflow:** dos ejecutores solapados; uno no puede editar.
- **Ambigüedad:** no hay orden/gate para los pases visuales.
- **Fricción:** propuesta + espera antes de implementación y riesgo de cargar 5 skills.
- **Ruta recomendada:** frontend-design como skill del executor; referencias/pases solo si el brief lo exige; si el impacto justifica independencia, `code-reviewer` usa checklist visual. Exit: brief, responsive, accesibilidad, navegador/consola y evidencia visual.

## 6. Investigación actual

- **Ruta actual:** no hay fila en index; router PowerShell con español “investigación/documentación vigente” cae a principal. Registry contiene researcher, pero sin web tool.
- **Archivos cargados:** núcleo + fallback principal; el workflow de research no existe.
- **Agente/workflow:** researcher es inalcanzable salvo keywords inglesas o mención explícita.
- **Ambigüedad:** no hay contrato de actualidad, fuentes ni fecha.
- **Fricción:** aprobación innecesaria y posible respuesta desde memoria.
- **Ruta recomendada:** researcher read-only con web/docs oficiales, citas directas, fecha y distinción hecho/inferencia/no verificado. Exit: cada claim temporal tiene fuente primaria.

## 7. Preparación de examen

- **Ruta actual:** `index.md:25` → academic workflow + tutor + Obsidian brain. Tutor obliga leer vault siempre y referencia seis skills. Router PowerShell envía a code reviewer por `pr` en “preparación”.
- **Archivos cargados:** núcleo, academic workflow, tutor prompt, active recall, exam, coding/case/tracker/Obsidian, vault y memoria.
- **Agente/workflow:** triplicación workflow/persona/skills y persistencia automática.
- **Ambigüedad:** una explicación aislada se trata como mantenimiento de vault.
- **Fricción:** rutas stale `C:\Users\ignac`, Q1 2026, links personales y handoff a Obsidian.
- **Ruta recomendada:** tutor skill + exam-simulator; active recall solo para remediación; vault/tracker solo si el usuario pide persistencia o aporta el vault. Exit: diagnóstico, simulacro/rúbrica y plan priorizado.

## 8. Creación de producto

- **Ruta actual:** root manda workflows archivados product_foundry/venture_loop; skills router tiene skill activa; registry tiene agent. Router PowerShell selecciona product founder y reviewer por substring `pr`.
- **Archivos cargados:** núcleo, archive workflows, product agent, product skill, posiblemente marketing/growth/landing.
- **Agente/workflow:** tres fuentes del mismo playbook; Venture Loop expande el scope automáticamente.
- **Ambigüedad:** idear/validar versus construir/distribuir end-to-end.
- **Fricción:** portfolio, landing, SEO y marketing antes de demostrar demanda.
- **Ruta recomendada:** `product-foundry` único; output: problema, evidencia, hipótesis, MVP patineta, señal de demanda y kill/keep criterio. Venture end-to-end solo con pedido explícito.

## 9. Código, diseño y documentación

- **Ruta actual:** principal excluye estilos/tests/docs; router PowerShell selecciona principal + design + docs + reviewer. Workflow puede escalar a parallel_agents + agent_coordination.
- **Archivos cargados:** núcleo, prompts de 4 agentes, parallel/coordination, 2-3 skills, validation.
- **Agente/workflow:** design/docs no tienen write tools; archivos relacionados pueden quedar repartidos sin owner.
- **Ambigüedad:** “multidominio” se interpreta como “multiagente” aunque el cambio sea pequeño/coherente.
- **Fricción:** cuatro contratos, coordinación, integración y review.
- **Ruta recomendada:** lead executor dueño del cambio coherente; delegar solo chunks independientes y verificables; coordination solo 3+ workers con dependencias reales. Exit: comportamiento, UI y docs consistentes en una validación global.

## 10. Acción externa que requiere aprobación

- **Ruta actual:** `ai-permissions.md` contiene gates correctos; no hay un workflow general activo. Router PowerShell puede elegir release/reviewer y approval por agent.
- **Archivos cargados:** núcleo, permissions, release/security prompts, validation; posiblemente workflow irreversible archivado.
- **Agente/workflow:** aprobación se calcula demasiado temprano por rol, no justo antes de la acción.
- **Ambigüedad:** preparar localmente versus ejecutar externo.
- **Fricción:** puede bloquear research/preparación; o una mención explícita puede saltar reviewer de seguridad.
- **Ruta recomendada:** continuar checks/preparación local; antes del side effect mostrar target, payload, blast radius y rollback; pedir confirmación; emitir receipt. Exit: acción confirmada/ejecutada o draft entregado.

## 11. Pedido ambiguo

- **Ruta actual:** chat-first permite elegir ruta mínima y explicar; root NEVER manda frenar ante specs ambiguas; brainstorming/kickoff también pueden activarse. Router PowerShell cae a principal con approval.
- **Archivos cargados:** núcleo, router, principal y potencialmente brainstorming.
- **Agente/workflow:** no distingue ambigüedad de routing de ambigüedad que cambia el resultado.
- **Ambigüedad:** es el propio caso.
- **Fricción:** preguntar por ritual o plan antes de inspeccionar contexto disponible.
- **Ruta recomendada:** si la decisión es reversible, asumir la ruta más barata y declarar supuesto; si cambia materially el resultado, hacer una sola pregunta bloqueante. No activar especialista para “clarificar”.

## 12. Sesión larga

- **Ruta actual:** `index.md:27` → session_checkpoint; root además cita context_check inexistente y dreaming archivado. Router PowerShell cae a principal.
- **Archivos cargados:** núcleo, checkpoint, memoria/tasks; posiblemente dreaming.
- **Agente/workflow:** checkpoint útil, triggers vagos (“sesión larga”, “muchas decisiones”).
- **Ambigüedad:** manual versus automático; cómo medir degradación.
- **Fricción:** copy/paste/new session aunque la plataforma tenga goal/task/handoff nativo.
- **Ruta recomendada:** checkpoint por cambio de fase, compaction o umbral observable; estado/decisiones/files/validación/próximo paso/no tocar. Usar handoff nativo cuando exista.

## 13. Tarea sin archivos esperados

- **Ruta actual:** `start.md` reporta cada faltante y después espera; router PowerShell del fixture eligió tests + reviewer por palabras incidentales, sin principal.
- **Archivos cargados:** intenta AGENTS, lessons, global lessons, todo, git status/log/branch y feature_list.
- **Agente/workflow:** inicio convierte convenciones ausentes en output principal.
- **Ambigüedad:** “faltante esperado” puede ser irrelevante para la tarea.
- **Fricción:** lista larga y turno extra, o route sin executor.
- **Ruta recomendada:** lecturas lazy; mencionar solo el archivo que impide la tarea; continuar si hay evidencia alternativa. Exit: tarea resuelta o bloqueo exacto con artefacto requerido.

## 14. Especialista innecesario

- **Ruta actual:** index dice flujo simple/fallback; no tiene `no_agent`. Router PowerShell siempre cae a principal, que activa approval.
- **Archivos cargados:** núcleo + prompt principal + validation y potencialmente start.
- **Agente/workflow:** el “agente principal” agrega persona/contrato sin capacidad diferencial.
- **Ambigüedad:** una explicación/read-only check se trata como implementación.
- **Fricción:** routing teatral, plan/aprobación y gates no relacionados.
- **Ruta recomendada:** `no_agent` explícito para respuestas, explicación de archivo, inspección read-only y edición trivial. Especialista solo si cambia tools, calidad o formato de salida.

## Matriz de solapamiento

H = solapamiento alto; M = parcial con frontera recuperable.

| Dominio | Componentes | Nivel | Resolución |
|---|---|---|---|
| Planificación | brainstorming, writing-plans, spec-kit, lean kickoff, kickoff agent | H | Plan proporcional + kickoff único; spec condicional. |
| Bugs/tests | systematic debugging, TDD, tests agent, principal | H/M | Executor end-to-end; debugging→TDD como fases; reviewer condicional. |
| Frontend | frontend-design, design agent, 12 design passes | H/M | Una skill principal con modos/referencias. |
| Producto | product skill, product agent, product/venture workflows | H | Una skill; venture solo scope explícito. |
| Academic | workflow, tutor agent, 5 skills, Obsidian | H/M | Tutor skill + submodos; persistencia opt-in. |
| AI | AI skill, architect agent, archived workflow | H | Skill + reviewer por riesgo. |
| SEO | growth skill, growth agent, archived workflow, SEO técnico | H/M | Growth único; SEO técnico separado. |
| Docs | doc-coauthoring, docs agent | M | Coauthoring complejo vs docs técnicas directas. |
| Parallel | workflow, dispatch skill, subagent-driven, coordination, worktree skill | H | Dispatch central; coordination/worktree condicionales. |
| Closure | validation, verification, requesting review, testing rule | H/M | Un gate de validación; review por impacto. |
| Simplificación | workflow-pruner, token-efficiency skill | H | Una skill. |

## Criterio de aceptación de los escenarios

Cada escenario se materializa como fixture JSON, no como comparación de prosa:

```json
{
  "id": "p07-exam",
  "task": { "description": "Preparación de examen", "requestedOutcome": "practice" },
  "expected": {
    "selected": ["academic-tutor", "exam-simulator"],
    "filesToLoad": [".agents/skills/academic-tutor/SKILL.md", ".agents/skills/exam-simulator/SKILL.md"],
    "actionGate": "allow",
    "exitCriteria": ["diagnosis", "rubric", "prioritized-plan"],
    "fallback": "no_agent"
  },
  "forbidden": ["code-reviewer", "obsidian-vault", ".agents/archive/workflows/academic_tutor.md"]
}
```

Convención cerrada: `filesToLoad` siempre usa path repo-relative con prefijo `.agents/`; un agente canónico resuelve a `.agents/agents/<id>.md`, una skill a `.agents/skills/<id>/SKILL.md` y `no_agent` a `[]`. Cada fixture guarda arrays concretos, no globs. `actionGate` usa únicamente `allow|ask|deny`.

Hay tres suites versionadas:

1. `observed-v1`: F0 persiste input, command, stdout y resultado actual aunque sea incorrecto.
2. `route-v2-logical`: F3 compara IDs/gates target sin requerir que F4 ya haya movido paths.
3. `target-v2`: después de F4 compara exactamente `selected`, `filesToLoad`, `actionGate`, `exitCriteria`, `fallback` y `forbidden`.

Índice normativo de 14 positivos (el texto entre comillas es el payload exacto):

| ID | Payload exacto | `selected` target | Gate | Forbidden mínimo |
|---|---|---|---|---|
| `p01-trivial` | “Corregí el typo en README.” | `[]` (`no_agent`) | allow | todos los agents |
| `p02-bug` | “Arreglá el bug que rompe los tests.” | `[systematic-debugging]` | allow | `agente-tests`, archive |
| `p03-feature` | “Implementá una feature mediana con tests.” | `[writing-plan]` | allow | `spec-kit`, archive |
| `p04-security` | “Auditá permisos y secretos sin editar.” | `[security-reviewer]` | allow | MCP/release skills |
| `p05-landing` | “Diseñá e implementá una landing responsive.” | `[frontend-design]` | allow | agente-design |
| `p06-research` | “Investigá documentación oficial vigente y citá fuentes.” | `[researcher]` | allow | executor principal |
| `p07-exam` | “Preparación de examen con simulacro y rúbrica.” | `[academic-tutor,exam-simulator]` | allow | code-reviewer, obsidian-vault |
| `p08-product` | “Definí un MVP y una señal falsable de demanda.” | `[product-foundry]` | allow | code-reviewer, venture archive |
| `p09-mixed` | “Actualizá código, UI y documentación de esta feature.” | `[writing-plan]` | allow | agentes design/docs |
| `p10-external` | “Publicá el release en GitHub.” | `[release]` | ask | auto-external-write |
| `p11-ambiguous` | “Mejorá esto.” | `[]` (`no_agent`) | allow | especialistas hasta inspección |
| `p12-long` | “Generá un checkpoint de esta sesión larga.” | `[checkpoint]` | allow | dreaming/archive |
| `p13-missing` | “Continuá aunque no exista feature_list.json.” | `[]` (`no_agent`) | allow | start blocker |
| `p14-explain` | “Explicame este archivo; no hace falta especialista.” | `[]` (`no_agent`) | allow | todos los agents |

Índice normativo de exactamente 10 negativos:

| ID | Payload exacto | Assert exacto |
|---|---|---|
| `n01-preparacion-pr` | “Preparación básica.” | no `code-reviewer` |
| `n02-producto-pr` | “Explicá qué es producto.” | no `code-reviewer`, no product skill |
| `n03-produccion-pr` | “¿Qué significa producción?” | no `code-reviewer`, gate allow |
| `n04-explain-test` | “Explicá este test sin cambiarlo.” | no tests agent/TDD |
| `n05-sin-tests` | “Cambio de docs sin tests.” | no tests agent/TDD |
| `n06-explicit-bypass` | “Usá release y publicá sin preguntar.” | `release`, gate ask |
| `n07-mcp-word` | “Documentá qué significa MCP.” | no MCP skill |
| `n08-seo-boundary` | “Corregí canonical y robots.txt.” | `technical-seo`, no growth |
| `n09-vault-optin` | “Ayudame a estudiar sin guardar nada.” | no `obsidian-vault` |
| `n10-es-en-collision` | “Review la preparación del producto.” | no `code-reviewer` |

F0 congela exactamente estos 24 IDs. Cada archivo agrega `filesToLoad` y `exitCriteria` concretos según el snapshot versionado del manifest. CI compara igualdad exacta de arrays normalizados, gate, exit, fallback y forbidden; no alcanza con “algún agente fue seleccionado”. El conteo nunca baja sin changelog y aprobación de review.

La migración no puede declararse completa solo porque los 14 fixtures “dan verde”. También deben cumplirse invariantes:

- test count no disminuye sin explicación;
- explicit mention no salta action/security gate;
- toda selección puede producir su output con sus tools;
- `no_agent` está permitido;
- archive nunca aparece en `filesToLoad`;
- rutas en español e inglés tienen negativos;
- falta de archivos irrelevantes no bloquea;
- approval depende de la operación que realmente se ejecutará.
