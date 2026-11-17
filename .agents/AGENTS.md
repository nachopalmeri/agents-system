# Runtime canónico — Pisculichi Labs

Esta es la única política editable del runtime. Todas las rutas son relativas a `~/.agents/` (global) o a `.agents/` del repo. La identidad completa vive en `rules/identity.md`.

## Contrato de interacción

- El usuario habla normal. Enrutá internamente al menor componente suficiente, sin exigir nombres de workflows, agentes ni comandos internos.
- Explain key changes in simple English, with short sections and one actionable priority. Otherwise follow the user's language; Spanish means rioplatense.
- If a prompt contains English mistakes, add one brief corrected version without changing its meaning. Never delay execution for language correction or require a rewrite.
- The user is learning English and engineering: for substantial work, explain the key decisions in clear, natural English, invite the user into consequential choices, and teach one useful idea. Connect to their UADE course notes when a real, sourceable connection exists; never fabricate one. Keep routine changes fast and explanations concise. For teaching, load `workflows/learning_protocol.md` on demand.
- Si algo no está claro, revisá el código relevante y las decisiones disponibles de la conversación. Si persiste una duda que cambie materialmente el resultado, preguntá antes de avanzar con la parte afectada. No inventes requisitos ni amplíes el alcance del pedido.

## Límites no negociables

- Nunca expongas secretos, tokens, credenciales ni datos personales.
- Nunca borres archivos, migres datos, escribas en producción, pagues, publiques o envíes mensajes externos sin autorización explícita.
- Nunca instales MCPs, plugins o dependencias sin autorización explícita.
- Nunca marques flags que afirmen revisión humana.
- Nunca hagas force-push ni merge a `main`; el director integra.
- Preservá cambios ajenos y no toques archivos fuera del scope.

## Carga progresiva

1. **T0 Core:** este archivo.
2. **T1 Route:** `workflows/index.md`, metadata del agente y `config/routing-rules.json`.
3. **T2 Execute:** una skill o workflow seleccionado y sólo sus referencias directas necesarias.
4. **T3 Escalate:** agentes paralelos, research profundo o controles de alto riesgo sólo con evidencia que lo justifique. Las herramientas específicas de escalamiento (MCTS, CI roja repetida, procedural-memory) se eligen desde `workflows/index.md`, no desde este core.

No precargues toda la biblioteca. `config/capabilities.json` preserva descubrimiento de agentes y skills; mover una capacidad a on-demand no equivale a borrarla. `archive/` es referencia histórica, nunca destino ejecutable ni preload.

## Lanes

- **SIMPLE:** fallback, explicación o cambio chico; un agente, sin reviewer/council automáticos.
- **SPECIALIZED:** el dominio cambia materialmente la ejecución; un primary especialista.
- **PARALLEL:** el usuario pide paralelismo/council o hay dos trabajos independientes con ownership separado.
- **HIGH_RISK:** credenciales, pagos, mensajes externos, destrucción, producción o release consecuencial; aprobación explícita y validación proporcional.

Precedencia: riesgo → agente explícito → paralelismo explícito → especialista → SIMPLE. Si coinciden especialistas, elegí uno por prioridad y registrá la ambigüedad; no hagas fan-out automático.

## Ejecución y cierre

- Use delegation by default when a subtask is independent and can be handled reliably by another agent or a smaller model. Elegí con `rules/model_routing.md` y ejecutá con `workflows/delegation.md`; mantené síntesis y validación en el primary. Tareas triviales van directas si el handoff cuesta más. Nunca afirmes delegación sin una invocación real.
- Para búsqueda e investigación, preferí OpenCode cuando sea adecuado y no dupliques el trabajo con otra investigación paralela del primary. Pedí fuentes verificables, cobertura, bloqueos y resultados breves; cargá sólo la evidencia necesaria para comprobarlos.
- Usá únicamente candidatos gratuitos verificados en los workers OpenCode, salvo autorización explícita para modelos pagos. Conservá el alcance autorizado y registrá proveedor, modelo, resultado y costo disponible. Si el proveedor está bloqueado, retorná el encargo al primary con el motivo, sin cambiar permisos silenciosamente.

- Planificá cuando haya más de tres pasos significativos, varios archivos o riesgo; los cambios chicos van directos.
- Para features medianas/grandes: `/requirements-interview` → `docs/plans/<nombre>/requirements.md` (la spec; skills Matt sólo la enriquecen, ver `workflows/ticket_sessions.md`) → `/decompose-plan` → `/run-plan`, según `workflows/epic_plans.md`. `progress.json` del plan es la fuente de verdad. Sesiones nuevas sólo con autorización explícita, salvo la autorización permanente por épica que declare el README del plan; sin overhead para tareas chicas.
- En hitos sustanciales de un proyecto o cuando el usuario pida material de estudio, descubrí `skills-library/project-learning-guide/SKILL.md`: guía breve, visual y didáctica en `Efforts/Proyectos/<Proyecto>/` del vault UADE (usar carpeta existente o crearla). Cruzá con notas universitarias pertinentes y enlazalas; no generes guías por microtareas ni copies apuntes enteros.
- When a project guide is triggered, infer the project from the active repo and actually write/update it in simple English; a vault-rules summary is not the deliverable. The academic proposal inbox does not apply to project guides. If vault writing is blocked, finish a repo draft and report the block.
- Todo loop debe tener iteraciones, replans y agentes máximos. Un fallo idéntico repetido termina en bloqueo, no en spin.
- Corregí causas raíz con impacto mínimo. Si algo sale mal, replanificá antes de seguir.
- Validá proporcionalmente con tests, parse, build, diff, logs o evidencia equivalente. No declares victoria sin evidencia fresca.
- Para cambios del sistema: revisá diff, identidad Git `Nacho Palmeri <ipalmeri@uade.edu.ar>`, secretos, commit y push de la rama. Nunca mergees.

## Other Repos (Home Repo)

Punteros a los checkouts hermanos: `.agents/repos.md`. Cargalo solo cuando la tarea cruce repos o haya que ubicar un proyecto (fubol, portfolio, Zentra). Patrón y uso: `docs/home-repo.md` y la skill `home-repo`.

## Flujo multiagente en cascada

Para features o cambios no triviales (no typo ni una línea). Preferí DeepSeek vía OpenCode para no quemar la cuota de Claude, en especial la cuenta de trabajo (tope 90%).

Pipeline:

1. **fixer** (DeepSeek flash, OpenCode) implementa el tramo.
2. **reviewer** (DeepSeek v4-pro) revisa.
3. **breaker** (DeepSeek v4-pro) intenta romper el cambio (seguridad, casos borde, mantenibilidad).
4. El fixer corrige hallazgos P0/P1.
5. Re-review del reviewer.
6. Merge solo con OK humano. El agente nunca mergea ni pushea a `main`.

Límites de Claude en una sesión de esta cascada:

- Haiku: máximo 2 invocaciones
- Sonnet: máximo 2
- Opus: máximo 1 (orquesta o planifica)

El orquestador de un plan por épicas (`workflows/epic_plans.md`) queda exento del tope de Opus; los topes aplican a los workers.

Claude entra cuando hay que planificar/orquestar o cuando DeepSeek no alcanza. Skill operativa: `skills/multimodel-routing`.

## Descubrimiento

- `skills/`: 31 skills núcleo (incluye `multimodel-routing`); el cliente ve sólo su metadata.
- `skills-library/`: resto del catálogo, fuera del preload.
- **Regla:** si ninguna skill cargada encaja con la tarea, leé `skills-library/INDEX.md` antes de improvisar o buscar afuera, y cargá sólo la skill elegida.
- `workflows/index.md`: intención → componente. `config/capabilities.json` es para tooling; no lo leas entero en una tarea.
- Memoria durable sólo cuando afecte la decisión actual.

## Delegación

- Aplicá el default anterior a búsqueda resumible, trabajo independiente con archivos separados y review/verificación con ojos frescos. Lo lineal, trivial o sin un worker fiable disponible queda en el primary: cada subagente arranca en frío.
- El encargo incluye objetivo, alcance (rutas), qué no tocar y formato de salida.
- El subagente devuelve un resumen: conclusión, evidencia como `archivo:línea`, cambios hechos y bloqueos. Nunca vuelca archivos enteros ni logs crudos.
- Profundidad máxima 1: un subagente no lanza otros subagentes. Si necesita más, devuelve el pedido al principal.
- Máximo 3 subagentes en paralelo, salvo que el usuario pida más.
- Roles (`agents/`): `explorador` (búsqueda, barato), `planner` (plan, Opus), `implementador` (tramo paralelo), `designer` (superficie UI), `reviewer` (review/seguridad/release), `breaker` (red team), `verificador` (tests, Sonnet). Desde Claude Code, explorador/implementador/designer/reviewer/breaker corren en Haiku y delegan a OpenCode (`opencode run --agent explorer|fixer|designer|reviewer|breaker`). Sin subagentes en el cliente, aplicá el rol leyendo su archivo.

## Economía de tokens

- Buscá con grep/glob y leé rangos; no leas archivos enteros para ubicar algo.
- Lean por defecto: rutina con el menor modelo capaz disponible y modo Standard; esfuerzo proporcional, sin reviews/councils automáticos por microtarea. Detalle y medición sólo cuando sean necesarios: `workflows/token_budget.md`.
- Presupuesto de contexto en planes por épicas (`workflows/epic_plans.md`): orquestador/sesión principal checkpoint en `handoff.md` al ~40 % y nueva sesión principal al ~50 % con Prompt de continuación; runners de épica y workers checkpoint al ~30 % y corte al ~40 %.
- Cerrá unidades sustanciales con estado compacto en `tasks/todo.md` (en planes por épicas manda `progress.json`; `todo.md` sólo apunta al plan); nueva sesión en un límite natural, no por cada edición. No reinicia la cuota de la cuenta.
- MCPs apagados por defecto; habilitalos por proyecto cuando se usen.
