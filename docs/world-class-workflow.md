# World-Class Workflow

Este documento define el workflow maestro del sistema de agentes: una operación chat-first que enruta al menor proceso suficiente, ejecuta con tools seguras, aprende con evidencia y documenta solo lo que ayuda a continuar.

## Principio operativo

```text
El usuario habla normal.
El sistema percibe contexto.
El modelo decide el menor workflow suficiente.
El agente ejecuta tools con límites.
El resultado se valida con evidencia.
El progreso se documenta si permite continuar mejor.
```

## Fuente de verdad

Cuando haya tensión entre documentos, usar esta jerarquía:

1. `.agents/AGENTS.md` — reglas globales y guardrails.
2. `.agents/workflows/index.md` — router invisible.
3. `.agents/workflows/phases.md` — modo de ejecución.
4. Workflow específico activo — `venture_loop.md`, `seo_geo_growth.md`, `validation.md`, etc.
5. Skill o agente especializado.
6. Documentación en `docs/`.
7. Nota Obsidian o bitácora del proyecto.

La documentación nunca debe contradecir a los workflows. Si se detecta contradicción, actualizar la fuente más alta o marcar la doc inferior como referencia histórica.

## Flujo maestro

```text
start.md
→ index.md
→ phases.md si no trivial
→ modo: simple / plan / /loop / Routine / multiagent review / Venture Loop
→ agente o skill especializado
→ tools con matriz de riesgo
→ validation.md
→ session_checkpoint.md si hay mucha continuidad
→ docs/Obsidian si aporta trazabilidad
```

## Modos de ejecución

| Modo | Cuándo usar | Salida |
|---|---|---|
| Simple | Cambio chico, bajo riesgo, objetivo claro | Implementación mínima + validación proporcional |
| Plan | Más de 3 pasos, varios archivos o decisión relevante | Plan breve, scope, no-scope, validación |
| `/loop` | Trabajo iterativo con criterio verificable | Iteraciones hasta éxito, bloqueo real o confirmación necesaria |
| Routine | Tarea recurrente o automatizable | Procedimiento seguro, idempotente y limitado |
| Task Ledger | Coordinación, handoffs, kanban o recibos finales | Task con dueño, estado, evidencia y recibo final |
| Multiagent review | Mejoras estratégicas, arquitectura, workflows o decisiones de alto impacto | Crear → criticar → red team → segunda crítica → plan → roadmap → reevaluación |
| Venture Loop | Idea/producto/adquisición/validación | Idea → MVP → landing → distribución → medición → kill/keep/scale |

## Matriz de riesgo de tools

| Riesgo | Ejemplos | Política |
|---|---|---|
| Read-only local | Leer archivos, buscar código, revisar docs | Permitido si está dentro del objetivo |
| Write local | Editar código, docs, workflows, notas | Permitido si está en scope y se valida |
| Commands safe | Parse, tests, lint, status, diff | Permitido si no muta estado destructivamente |
| Commands mutating | install, migrate, deploy, delete, commit | Confirmación explícita salvo pasos ya aprobados y seguros |
| External read | Docs web, MCP read-only, APIs públicas | Confirmar si hay credenciales o datos sensibles |
| External write | publicar, crear issues, enviar mensajes, modificar servicios | Confirmación explícita |
| Sensitive | pagos, ads, DMs, producción, secretos, datos personales | Siempre confirmación explícita; preferir draft/read-only |

## Definition of Done por tipo de tarea

| Tipo | Done mínimo |
|---|---|
| Docs/workflow | Referencias consistentes, sin contradicción con `AGENTS.md`, revisión de links/rutas |
| Script | Parse/sintaxis, caso feliz documentado, riesgos claros |
| Código | Tests/build/lint proporcionales o validación alternativa explícita |
| Web/UI | Revisión visual/responsive si aplica, consola limpia si se prueba navegador |
| AI/RAG | Evals o justificación, trazabilidad/costos si toca pipeline |
| SEO/GEO | Quality gate anti-thin, intención real, valor único, medición definida |
| Marketing | No gastar ni contactar usuarios automáticamente; entregar plan/drafts |
| Obsidian | Frontmatter válido, wikilinks útiles, nota accionable, no duplicar cementerio |

## Programmatic SEO de calidad

El crecimiento orgánico programático solo es válido si cada página merece existir.

Reglas:

- Crear páginas con mimo: estructura clara, copy útil, diseño cuidado y sin “Claude smell”.
- Aumentar valor por página aunque sea generada: datos únicos, ejemplos, comparativas, FAQs reales, screenshots, experiencia propia o tooling útil.
- Evitar páginas thin, doorway pages y keyword swaps.
- Podar, noindexar o reformar páginas que no reciben interés ni ayudan al usuario.
- Backlinks son sistema, no accidente: proyectos propios, partnerships, directorios relevantes, PR real, comunidades y assets linkables.
- Probar, iterar, borrar y mejorar mensualmente.
- No monetizar antes de tiempo si reduce aprendizaje, confianza o velocidad de iteración.

## Product analytics como motor del Venture Loop

El workflow no termina en publicar. Termina en aprender de comportamiento real.

Fuentes posibles:

- Base propia de eventos.
- PostHog.
- Mixpanel.
- GA4.
- Logs de producto.
- Search Console.
- DataForSEO para demanda buscada.

Loop de aprendizaje:

```text
Qué busca la gente
→ qué página/producto ve
→ qué acción toma
→ dónde abandona
→ qué mejora se prioriza
→ qué se poda o escala
```

MCPs de DataForSEO, analytics o base de eventos deben empezar read-only y pasar por evaluación de seguridad si usan credenciales o datos reales.

## Anti-teatro multiagente

Usar multiagente solo si mejora calidad real.

No usar si:

- La tarea es un fix chico.
- La respuesta directa alcanza.
- Las fases solo repetirían lo mismo con palabras distintas.
- No hay criterio de salida verificable.

Usar si:

- Hay arquitectura, estrategia o workflow de alto impacto.
- Hay riesgos ocultos.
- Se necesita red team real.
- El costo de equivocarse es alto.

## Task ledger y coordinación visible

Cuando haya múltiples tareas, handoffs o necesidad de trazabilidad, usar `task_ledger.md`.

Patrón:

```text
plain English request
→ coordinador interpreta intención
→ crea task solo si hay acción real
→ enruta a agente/workflow
→ actualiza estado
→ adjunta evidencia
→ emite recibo final
```

Ledger posible:

- `tasks/todo.md`.
- Obsidian.
- GitHub Issues/Projects.
- Kanban local.
- Discord/Hermes u otra capa externa.

Regla clave: no crear una tarjeta por cada conversación. Crear task solo si hay resultado esperado, tracking necesario o handoff real.

## Checkpoint y documentación

Documentar cuando ayuda a continuar:

- Decisiones tomadas.
- Críticas resueltas.
- Riesgos residuales.
- Próximo paso.
- Qué no tocar.

No documentar ruido, narración larga ni razonamiento que no sirva para retomar trabajo.

## Regla final

El mejor workflow no es el más largo. Es el que convierte intención en resultado validado con el menor proceso suficiente, y escala la rigurosidad solo cuando el riesgo lo justifica.
