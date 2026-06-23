# Developer Growth - Nacho Palmeri

## Como funciona este archivo

No es un diario. Es evidencia concreta de evolucion profesional. Se actualiza cuando hay hechos verificables en proyectos reales, no por calendario ni por sensacion.

Regla: `growth_update.md` requiere confirmacion explicita antes de editar este archivo.

## Skills tecnicas

### Dominadas

- Pendiente de evidencia. Una skill entra aca solo cuando Nacho puede usarla sin ayuda del agente y hay proyecto que lo demuestre.

### En desarrollo

- Sistemas de agentes personales: evidencia inicial en `agents-system`, donde se paso de scaffold de activacion a workflows con feedback, promocion de lecciones, memoria global, validacion y Obsidian sync.
- Loop Engineering: integración de los 5 bloques de Addy Osmani (automations, worktrees, skills, connectors, sub-agentes) + memory. Implementado en `parallel_agents.md`, `dreaming.md`, `outcomes.md`, `harness.md`, `validation.md`.
- Meta-crítica del sistema: aplicó los principios del sistema (Toolchain First, Judgment Boundaries, Comprehension Debt, Cognitive Surrender) para auditar el sistema mismo. Resultado: 7 GAPs identificados e implementados, AGENTS.md reducido 33%, 7 workflows deprecados.

### En backlog

- Evaluacion sistematica de agentes: definir datasets/checklists propios para medir si el agente mejora en routing, scope, output y calidad.
- Integracion Obsidian automatizada: conectar MCP/CLI cuando haya decision explicita de permisos y flujo seguro.

## Patrones de error que deje de cometer

- Pendiente de evidencia repetida. Registrar solo cuando haya comparacion clara entre antes/despues en proyectos reales.

## Decisiones que tomo mejor

- 2026-05-19 - Separar UX de activacion vs calidad de output: antes el sistema optimizaba mucho "como activar"; ahora agrega feedback loop, memoria y validacion para mejorar comportamiento real.
- 2026-06-09 - Toolchain First como principio rector: si un linter/tool/workflow puede enforzar una regla, sacarla de AGENTS.md. AGENTS.md pasó de 334 a 223 líneas.
- 2026-06-09 - Maker≠Checker como estructura de loop: el modelo que escribió el código no es el que lo verifica. Aplicado a /goal, outcomes.md, y comprehension debt check.

## Proyectos completados

| Proyecto | Stack | Aprendizaje principal | Fecha |
|---|---|---|---|
| agents-system | Markdown, PowerShell, Git, Obsidian workflow | Un sistema de agentes necesita feedback, promocion y evidencia; no alcanza con bootstrap prompts | 2026-05-19 |
| agents-system v2 | Loop Engineering, Meta-crítica, 7 GAPs | El sistema tiene que auditarse con sus propios principios. Lo que repite AGENTS.md no necesita workflow separado. | 2026-06-09 |

## Metricas reales

- Sin metricas suficientes todavia. No inventar tiempos ni porcentajes.

## Proxima evolucion

- Usar este sistema en 2+ proyectos reales y promover solo las lecciones que se repitan.
- Definir una rutina mensual de vault review para mantener memoria y growth tracker sin cementerio.
- Conectar Obsidian por MCP/CLI solo si aporta escritura segura y confirmable.

