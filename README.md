# Agents System — Pisculichi Labs

Runtime personal para Codex/ChatGPT, Claude, Gemini, OpenCode y otros clientes. El usuario habla normal; el agente carga sólo las capacidades necesarias, ejecuta la tarea y valida el resultado.

## Arquitectura

- `.agents/AGENTS.md`: política canónica, límites y routing por riesgo.
- `config/capabilities.json`: catálogo generado de 19 agentes y 115 skills.
- `agents.registry.json`: contratos y permisos de los agentes.
- `.agents/workflows/index.md`: intención → componente mínimo.
- `config/routing-rules.json`: reglas ejecutables de SIMPLE, SPECIALIZED, PARALLEL y HIGH_RISK.
- `config/model-routing.json`: modelos menores del mismo harness y candidatos gratuitos de OpenCode.
- `schemas/`: contratos portables de tareas, sesiones y proveedores.
- `bin/`: routing, ejecución, validación, instalación y sincronización.
- `orchestrator/router.ps1`: selección determinista por riesgo e intención.

Las skills cubren desarrollo, diseño, testing, AI/RAG, SEO/GEO, contenido, producto, estudio y Obsidian. Se descubren por metadata; no se carga la biblioteca completa. `.agents/archive/` conserva componentes históricos y no es una ruta ejecutable.

## Delegación interna

El primary elige entre ejecución directa, un worker menor del mismo harness o OpenCode. Ejemplo: Sol → Luna cuando la herramienta nativa permita seleccionar ese modelo; Sol/Claude → OpenCode → Muse Spark para tareas acotadas. Los nombres de modelos son preferencias configurables, no un ranking de calidad.

OpenCode puede investigar, escribir tests, editar documentación e implementar cambios locales en archivos declarados. Para unidades independientes, el bridge crea hasta tres subagentes con permisos y ownership separados. El primary revisa evidencia y diff, corre la validación final y sintetiza el resultado.

```powershell
pwsh -NoProfile -File bin/invoke-delegation.ps1 -RequestPath examples/tasks/delegation.json -DryRun
pwsh -NoProfile -File bin/invoke-delegation.ps1 -RequestPath examples/tasks/delegation.json
```

La solicitud declara objetivo, workspace, operación, riesgo y archivos permitidos. El bridge descubre modelos gratuitos disponibles, limita intentos y tiempo y devuelve un recibo con uso/costo reportados por el proveedor. No se usan candidatos pagos automáticamente. La interfaz web de ChatGPT necesita un entorno con terminal para ejecutar el puente.

Ver [guía completa y evidencia](docs/delegation.md), [workflow](.agents/workflows/delegation.md) y [política](config/model-routing.json). Los tests locales no demuestran ahorro de tokens; hay que medir el encargo completo y la revisión del primary.

## Workflows activos

Inicio y contexto: `start`, `context_check`, `skills_routing`.

Ejecución: `delegation`, `parallel_agents`, `agent_coordination`, `multiagent_review_loop`, `academic_tutor`.

Integraciones: `mcp_catalog`, `mcp_security`, `mcp_adoption`, `hooks`.

Cierre: `validation`, `feedback_loop`, `session_checkpoint`.

Los councils y revisiones múltiples requieren una razón concreta o un pedido explícito. Las tareas triviales evitan el overhead de delegación.

## Instalación y actualización

Requisitos: Git y PowerShell; OpenCode es opcional y sólo necesario para ese backend. No se instalan proveedores, plugins ni dependencias automáticamente.

```powershell
git clone https://github.com/nachopalmeri/agents-system.git
cd agents-system
pwsh -NoProfile -File bin/sync-runtime.ps1 -WhatIf
pwsh -NoProfile -File bin/sync-runtime.ps1
pwsh -NoProfile -File bin/doctor.ps1
```

La sincronización usa los destinos declarados en `config/runtime-manifest.json`, con backups y transacciones restaurables. Omite destinos no administrados y rechaza drift administrado antes de modificar archivos. Revisá diferencias antes de usar `-Force`. Las configuraciones personales y credenciales se conservan fuera del repo.

La instalación declara también `~/bin/invoke-delegation.ps1`, `~/bin/select-delegation.ps1` y `~/config/model-routing.json`. Los presets OpenCode son opcionales; el bridge configura cada solicitud en el proceso hijo.

Para actualizar el catálogo, ejecutar `bin/generate-capabilities.ps1` desde el checkout: genera metadata del repositorio y conserva campos adicionales existentes. Los adapters se regeneran con `bin/render-runtime-adapters.ps1`.

## Verificación

```powershell
pwsh -NoProfile -File bin/test-delegation.ps1
pwsh -NoProfile -File bin/test-model-routing.ps1
pwsh -NoProfile -File bin/run-runtime-evals.ps1
pwsh -NoProfile -File bin/test-runtime-sync.ps1
pwsh -NoProfile -File bin/release-check.ps1
```

El runtime tiene contratos de sesión, estados de proveedor, budgets, políticas MCP/tools, hooks y trazas. Los budgets del loop se aplican cuando se usa su runner; un documento de instrucciones por sí solo no impone límites al harness. El bridge aplica su propio límite de intentos, pasos y tiempo.

No se permiten secretos, producción, publicación, pagos o writes externos sin el gate correspondiente. La edición de workers se restringe a archivos declarados y se revisa en el primary; estos permisos no son un sandbox del sistema operativo.
