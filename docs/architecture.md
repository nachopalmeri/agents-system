# Arquitectura del sistema de agentes

Este documento describe cómo el sistema de agentes chat-first se apoya en capas tipo Claude Code/Cascade para recibir pedidos, razonar, usar memoria, ejecutar herramientas y reportar resultados.

## Resumen

```text
Input Layer
→ Model Layer
→ Memory Layer
→ Tools Layer
→ Output Layer
```

Todos los agentes implementan un loop fundamental:

```text
Percibir contexto
→ Decidir próximo paso
→ Ejecutar tool
→ Repetir hasta terminar
→ Validar
→ Reportar
```

## 1. Input Layer

La capa de entrada recibe el pedido del usuario y reúne el contexto inicial.

Incluye:

- Conversación actual.
- Archivos abiertos o metadata del IDE.
- `AGENTS.md` local del proyecto.
- Reglas globales en `.agents/AGENTS.md`.
- Workflows relevantes.
- Estado de tareas si existe `tasks/todo.md`.
- Lecciones si existe `tasks/lessons.md`.
- Estado Git si está disponible.

Workflow relacionado:

- `workflows/start.md`

Regla clave:

- Si un archivo esperado no existe, se reporta `no encontrado` y se continúa.

## 2. Model Layer

La capa de modelo razona sobre el pedido, elige el menor workflow suficiente y decide el próximo paso.

Incluye:

- Routing invisible según `workflows/index.md`.
- Fases de ejecución según `workflows/phases.md`.
- Selección de agente especializado.
- Selección de skill.
- Decisión entre ejecución lineal, `/loop` o Routine.
- Identificación de riesgo, scope y validación necesaria.

Workflows relacionados:

- `workflows/index.md`
- `workflows/phases.md`
- `workflows/skills_routing.md`
- `workflows/project_types.md`

Regla clave:

- El usuario no debe recordar nombres de workflows. La interfaz es chat; los workflows son motor interno.

## 3. Memory Layer

La capa de memoria mantiene continuidad entre pasos y sesiones.

Incluye:

- Memoria de sesión.
- Memorias persistentes relevantes.
- Checkpoints en sesiones largas.
- `tasks/lessons.md` del proyecto.
- `tasks/todo.md` del proyecto.
- Decisiones guardadas en documentación o specs.

Workflow relacionado:

- `workflows/session_checkpoint.md`

Reglas clave:

- Usar checkpoint cuando la sesión sea larga o haya muchas decisiones.
- Usar memoria solo si es relevante al pedido actual.
- Las lecciones del proyecto deben influir sobre tareas futuras.

## 4. Tools Layer

La capa de herramientas ejecuta acciones sobre el mundo externo.

Incluye:

- Lectura de archivos.
- Búsqueda en código.
- Edición de archivos.
- Comandos de terminal.
- MCPs.
- Browser/testing tools.
- Deploy tools.
- Git y GitHub cuando corresponda.

Workflows relacionados:

- `workflows/mcp_security.md`
- `workflows/mcp_adoption.md`
- `workflows/mcp_catalog.md`
- `workflows/opencode_ecosystem.md`
- `workflows/parallel_agents.md`

Reglas clave:

- Herramientas con credenciales, escritura externa, pagos, ads, DMs o datos personales requieren confirmación explícita.
- MCPs: read-only primero.
- Nunca hardcodear secretos.
- Ejecutar solo lo necesario para cumplir el objetivo.

## 5. Output Layer

La capa de salida comunica resultados, evidencia y próximos pasos.

Incluye:

- Resumen de lo hecho.
- Archivos tocados.
- Validación ejecutada.
- Riesgos pendientes.
- Próximo paso recomendado.
- Decisión si aplica: GO / NO-GO / PIVOT o KILL / KEEP / SCALE.

Workflow relacionado:

- `workflows/validation.md`

Regla clave:

- No declarar listo sin evidencia.

## Loop fundamental de cada agente

Todos los agentes operan con el mismo ciclo:

### 1. Percibir contexto

El agente lee:

- Pedido del usuario.
- Reglas relevantes.
- Archivos necesarios.
- Estado de tareas.
- Estado Git.
- Memorias relevantes.

### 2. Decidir próximo paso

El agente decide:

- Workflow mínimo suficiente.
- Skill necesaria.
- Tool necesaria.
- Si debe pedir confirmación.
- Si debe delegar a otro agente.
- Criterio de salida.

### 3. Ejecutar tool

El agente usa herramientas para:

- Leer.
- Buscar.
- Editar.
- Ejecutar comandos.
- Validar.
- Consultar MCPs si están autorizados.

### 4. Repetir

El agente repite el ciclo hasta que:

- El objetivo esté cumplido.
- Aparezca un bloqueo real.
- Haya riesgo que requiere confirmación.
- Se alcance el criterio de salida del `/loop`.
- Se complete una Routine segura.

### 5. Validar

Antes de cerrar:

- Revisar scope.
- Validar tests/build/config si aplica.
- Revisar riesgos.
- Correr secret scan si aplica.
- Confirmar que no se tocaron archivos fuera del alcance.

### 6. Reportar

El agente entrega:

```text
Qué se hizo:
Archivos tocados:
Validación:
Resultado:
Riesgos:
Próximo paso:
```

## Capas aplicadas a agentes principales

| Agente | Input principal | Decisión principal | Tools típicas | Output |
|---|---|---|---|---|
| `agente-product-founder` | Idea, mercado, problema | BUILD / PARK / KILL | Read, research, docs | MVP patineta + kill/scale |
| `agente-growth-seo-geo` | Producto, ICP, búsquedas | Keyword map y backlog | Read, research, MCPs SEO | Plan SEO/GEO + métricas |
| `agente-seo` | Web/código | Prioridades técnicas SEO | Read/Edit | Auditoría técnica |
| `agente-marketing-strategist` | Producto/canal | GO / NO-GO / PIVOT | Research/docs | Playbook GTM |
| `agente-ai-architect` | App AI/RAG | Demo/MVP/producción | Read/Edit | Capas, evals, observabilidad |
| `agente-security-auditor` | Config/diffs/secrets | Riesgo y mitigación | Read/Grep/commands seguros | Auditoría seguridad |
| `agente-principal` | Código y tarea | Implementación mínima | Read/Edit/commands | Cambio funcional |
| `agente-design` | UI/brief | Dirección visual | Read/Edit/browser | UI pulida |
| `agente-tests` | Código y criterios | Cobertura necesaria | Read/Edit/commands | Tests/evidencia |
| `agente-docs` | Sistema/cambio | Documentación necesaria | Read/Edit | README/docs |

## Loop, `/loop` y Routine

### Ejecución normal

Usar cuando la tarea tiene pocos pasos y un final claro.

### `/loop`

Usar cuando el agente debe iterar hasta un criterio verificable:

- Tests pasan.
- Build pasa.
- Lint queda limpio.
- Checklist completo.
- Landing cumple brief.
- Migración queda validada.

Contrato mínimo:

```text
Objetivo:
Criterio de salida:
Límite:
Validación:
Condición de stop:
```

### Routine

Usar para tareas recurrentes:

- Health check semanal.
- Reporte SEO mensual.
- Revisión periódica de backlinks.
- Revisión de ideas/productos.
- Actualización de métricas.

Las Routines deben ser:

- Seguras.
- Idempotentes.
- Con límites claros.
- Draft/read-only si hay acciones externas sensibles.

Contrato mínimo:

```text
Frecuencia:
Scope:
Modo: read-only / draft / local-write / external-write
Entradas:
Salidas:
Acciones prohibidas:
Evidencia:
```

Hard stops:

- No gastar.
- No publicar.
- No responder DMs.
- No modificar producción.
- No usar credenciales o datos personales sin confirmación explícita.

## Relación con Venture Loop

Para proyectos emprendedores:

```text
Product Foundry
→ Venture Loop
→ Web Briefing
→ SEO/GEO Growth
→ Validation
```

La arquitectura completa permite pasar de:

```text
idea
→ producto validable
→ adquisición
→ medición
→ decisión
```

sin perder seguridad ni trazabilidad.

## Regla final

El sistema no es una colección de agentes sueltos. Es un loop de decisión y ejecución con capas: entrada, razonamiento, memoria, herramientas y salida validada.
