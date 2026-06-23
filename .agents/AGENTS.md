# Sistema de Agentes — Nacho Palmeri / Pisculichi Labs

## Identidad

- **Usuario:** Nacho Palmeri (`nachopalmeri`)
- **Email:** ipalmeri@uade.edu.ar
- **Lab:** Pisculichi Labs
- Detalles completos en `rules/identity.md`.

## Reglas globales (leer primero)

| Regla | Archivo |
|---|---|
| Identidad y datos del usuario | `rules/identity.md` |
| Push obligatorio a GitHub | `rules/git.md` |
| Permisos de IA y flags humanos | `rules/ai-permissions.md` |
| Anti-cementerio / anti-sludge | `rules/anti-cemetery.md` |
| Chat-first (no exigir nombrar workflows) | `rules/chat-first.md` |
| Code style | `rules/code-style.md` |
| Testing | `rules/testing.md` |
| Prompting (Anthropic best practices) | `rules/prompting.md` |
| Model routing (costo vs calidad) | `rules/model_routing.md` |

## Orquestación del Flujo de Trabajo

### 0. Interfaz Chat-First
- El usuario habla normal; los workflows son motor interno
- Router: `workflows/index.md` para decidir el menor workflow suficiente
- Quality gate: `workflows/validation.md` antes de cerrar
- Contexto: `workflows/session_checkpoint.md` para sesiones largas
- Aprendizaje: cargar `tasks/lessons.md` al inicio, promover a `memory/lessons-global.md`

### 0.1. El Agente como Loop
Todos los agentes implementan el mismo ciclo fundacional:
1. Percibir contexto: conversación, memoria, archivos, reglas, tareas y estado del proyecto.
2. Decidir el próximo paso: razonar, elegir workflow, skill, herramienta y criterio de salida.
3. Ejecutar una tool: leer, buscar, editar, correr comandos o consultar MCPs autorizados.
4. Repetir hasta terminar: continuar hasta cumplir el objetivo, encontrar bloqueo real o requerir confirmación.
5. Validar y reportar: usar `workflows/validation.md` antes de declarar listo.

Este loop aplica tanto a ejecución normal como a `/loop`, routines y subagentes.

### 1. Modo Planificación por Defecto
- Entrar en Plan Mode para CUALQUIER tarea no trivial (más de 3 pasos)
- Si algo sale mal, PARAR y volver a planificar de inmediato
- Escribir especificaciones detalladas por adelantado para reducir ambigüedad
- Usar Plan Mode también para pasos de verificación, no solo construcción

### 2. Estrategia de Subagentes
- Usar subagentes para delegar investigación y tareas independientes
- Una tarea por subagente para ejecución focalizada
- Usar `workflows/multiagent_review_loop.md` para decisiones de alto impacto
- Evitar teatro multiagente: si la crítica no puede cambiar la solución, usar flujo simple

### 3. Bucle de Automejora
- Cada correccion del director: registrar en `tasks/lessons.md`
- Revisar `tasks/lessons.md` al inicio de cada sesion
- Lecciones con 2+ proyectos: promover a `memory/lessons-global.md` con confirmacion humana

### 4. Verificación antes de Finalizar
- Nunca marcar una tarea como completada sin demostrar que funciona
- Compará el diff entre la rama y main cuando sea relevante
- Preguntate: "¿Aprobaría esto un Staff Engineer?"
- Ejecutá tests, revisá logs, demostrá que el código es correcto

### 5. Exige Elegancia
- Para cambios no triviales: pausar y preguntar "¿hay una forma más elegante?"
- Si un arreglo parece un hack: "Sabiendo todo lo que sé ahora, implementá la solución elegante"
- Omitir esto para arreglos simples y obvios

### 6. Corrección de Errores Autónoma
- Cuando recibas un error: simplemente arreglalo, no pidas que te lleven de la mano
- Identificá logs, errores o tests que fallan y resolvé
- Cero necesidad de cambio de contexto por parte del director
- Arreglá los tests que fallan sin que te digan cómo

### 7. MCPs y Seguridad
- `workflows/mcp_catalog.md`, `mcp_security.md` como referencia antes de adoptar MCPs
- Nunca hardcodear API keys, tokens, OAuth secrets ni credenciales
- MCPs con escritura, pagos, DMs o datos personales requieren confirmación explícita

### 8. Checks Locales
- `workflows/hooks.md` para hooks opcionales
- Ejecutar `bin/check-secrets.ps1` antes de pushear cambios sensibles
- Ejecutar `bin/doctor.ps1` para validar instalación local o laptop nueva

### 11. Activadores Explícitos

Para forzar un workflow/agente/skill: `"Activá [nombre].md"` o `"Llamá al agente-[nombre]"`. El nombre del archivo es el comando. Ver lista completa en `workflows/index.md`.

### 11. Portabilidad Cross-IDE
Detalles en `docs/setup-guide.md` y `bin/setup-ide-pointers.ps1`. Entry points creados para 9 IDEs. `.agents/` es única fuente de verdad.

## Roles de Agentes

Definiciones completas en `.agents/agents/`. Registry:

- agente-principal, agente-design, agente-tests, agente-docs, agente-seo
- agente-marketing-strategist, agente-growth-seo-geo, agente-product-founder
- agente-ai-architect, agente-security-auditor, agente-mcp-architect
- agente-obsidian-brain, agente-code-reviewer, agente-researcher, agente-release-manager
- agente-academic-tutor, agente-x-content-strategist
- kickoff-architect, workflow-pruner

(Gloaguen et al. 2026: listar por nombre e invocación, definiciones en archivos separados, no inline.)

## Principios del sistema
- No sobre-abstractizar con capas de agentes. El Ralph Loop es el nivel correcto.
- Vendor lock-in: no depender de un solo proveedor de AI. AGENTS.md es portable.
- LLM-generated AGENTS.md reduce éxito ~3%. Siempre escrito por humanos.
- Comprehension debt: leer el código que el loop generó antes de declarar listo.
- Cognitive surrender: el loop es acelerador con juicio, no sustituto de entender el trabajo.

## Judgment Boundaries

### NEVER
- Nunca commitear secrets, tokens o .env files.
- Nunca agregar dependencias externas sin discusión.
- Nunca adivinar specs ambiguas — frenar y preguntar.
- Nunca dejar que un agente escriba directamente en AGENTS.md.

### ASK
- Preguntar antes de correr migraciones, eliminar archivos, instalar MCPs o mergear ramas.

### ALWAYS
- Explicar el plan antes de escribir código.
- Validar con evidencia antes de declarar listo.
- Toolchain First: si un linter lo enforcea, no escribirlo en AGENTS.md.
- Exit conditions más robustas de lo que el agente puede fakear.
