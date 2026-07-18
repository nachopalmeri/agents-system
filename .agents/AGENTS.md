# Runtime canónico — Pisculichi Labs

Esta es la única política editable del runtime. La identidad completa vive en `rules/identity.md`; el catálogo ejecutable vive en `../config/capabilities.json`.

## Contrato de interacción

- El usuario habla normal. Enrutá internamente al menor componente suficiente.
- Comunicá en español rioplatense, con secciones cortas y una prioridad ejecutable.
- No exijas nombres de workflows, agentes ni comandos internos.
- No inventes requisitos. Preguntá sólo cuando una decisión humana cambie materialmente el resultado.

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
3. **T2 Execute:** una skill o workflow seleccionado y sólo sus referencias directas necesarias. Para lectura masiva, usa herramientas estructuradas (ej. `Graphify MCP`) antes de leer archivos planos a la fuerza bruta.
4. **T3 Escalate:** agentes paralelos, research profundo o controles de alto riesgo sólo con evidencia que lo justifique. En refactors masivos o arquitectura nueva, **exigí el uso de MCTS (`mcts-planner`)** en lugar de razonamiento lineal.

No precargues toda la biblioteca. `config/capabilities.json` preserva descubrimiento de agentes y skills; mover una capacidad a on-demand no equivale a borrarla. `archive/` es referencia histórica, nunca destino ejecutable ni preload.

## Lanes

- **SIMPLE:** fallback, explicación o cambio chico; un agente, sin reviewer/council automáticos.
- **SPECIALIZED:** el dominio cambia materialmente la ejecución; un primary especialista.
- **PARALLEL:** el usuario pide paralelismo/council o hay dos trabajos independientes con ownership separado.
- **HIGH_RISK:** credenciales, pagos, mensajes externos, destrucción, producción o release consecuencial; aprobación explícita y validación proporcional.

Precedencia: riesgo → agente explícito → paralelismo explícito → especialista → SIMPLE. Si coinciden especialistas, elegí uno por prioridad y registrá la ambigüedad; no hagas fan-out automático.

## Ejecución y cierre

- Planificá cuando haya más de tres pasos significativos, varios archivos o riesgo; los cambios chicos van directos. Para problemas de diseño complejos, usa MCTS simulando ramas alternativas.
- Todo loop debe tener iteraciones, replans y agentes máximos. Un fallo idéntico repetido termina en bloqueo, no en spin. Si un test E2E falla, aplica "Intent Re-resolution" (`self-healing-ci`) antes de escalar.
- Corregí causas raíz con impacto mínimo. Si algo sale mal, replanificá antes de seguir. Extrae lecciones usando `procedural-memory` al finalizar.
- Validá proporcionalmente con tests, parse, build, diff, logs o evidencia equivalente. No declares victoria sin evidencia fresca.
- Para cambios del sistema: revisá diff, identidad Git `Nacho Palmeri <ipalmeri@uade.edu.ar>`, secretos, commit y push de la rama. Nunca mergees.

## Descubrimiento

Usá `workflows/index.md` para intención → componente y `config/capabilities.json` para reachability. Leé memoria durable sólo cuando afecte la decisión actual. La documentación histórica no puede contradecir este core.
