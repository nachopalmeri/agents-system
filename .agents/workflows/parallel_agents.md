---
description: Orquestación de agentes paralelos y worktrees cuando hay tareas independientes
---

# Parallel Agents

## Cuándo usar

Usar subagentes o worktrees paralelos cuando:

- Hay 2+ tareas independientes.
- No tocan los mismos archivos.
- Cada tarea tiene output verificable.
- El costo de coordinación es menor que hacerlo secuencial.

## Cuándo NO usar

- Bug puntual.
- Proyecto chico.
- Tareas fuertemente dependientes.
- Todos tocarían el mismo archivo.
- Hace falta conversación iterativa constante.

## Roles típicos

- `agente-principal`: lógica e integraciones.
- `agente-design`: UI/CSS/responsive.
- `agente-seo`: SEO técnico.
- `agente-tests`: tests y E2E.
- `agente-docs`: documentación.
- `agente-ai-architect`: AI/RAG production.
- `agente-security-auditor`: secretos, permisos, supply-chain, MCP/plugin risk.

## Proceso

1. Definir objetivo y scope.
2. Dividir tareas por dominio.
3. Confirmar archivos esperados por agente.
4. Usar worktree separado si hay edición paralela.
5. Ejecutar cada tarea con contexto mínimo.
6. Integrar resultados en el agente principal.
7. Correr validación global.
8. Reportar riesgos y pendientes.

## Reglas de integración

- Un agente no modifica scope de otro.
- Si aparece conflicto, parar e integrar manualmente.
- Ningún subagente declara listo sin evidencia.
- El agente principal sintetiza y decide.

## Para proyectos con mas de 2 agentes simultaneos

Si hay 3 o mas agentes trabajando en paralelo con dependencias entre sus outputs, usar `agent_coordination.md` en lugar de este workflow. El coordination protocol agrega contratos explicitos, fases de integracion y signals (`ready:`, `blocked:`) que este workflow no cubre.

## Dynamic Workflows (Claude Code)

Claude Code soporta Dynamic Workflows: al mencionar "workflow" en el prompt, Claude crea automaticamente un plan de orquestacion completo, lo sigue estrictamente y lanza sub-agentes en paralelo donde sea posible, respetando el orden correcto.

Patron de uso:

1. Mencionar "workflow" o "dynamic workflow" en la instruccion.
2. Claude escribe el plan detallado de todo lo que hay que hacer.
3. Respeta ese plan de forma estricta durante toda la ejecucion.
4. Levanta sub-agentes automaticamente que trabajan en paralelo en las partes independientes.
5. Coordina para que nada se pise y todo salga en el orden correcto.

Ejemplo: revisar cientos de flags de A/B testing. En vez de ir uno por uno, Claude arma el plan y los procesa en paralelo en minutos.

Caveats:

- Consumo de tokens alto: puede quemar millones de tokens en tareas grandes. Considerar costo antes de usar.
- Solo funciona en Claude Code CLI, Desktop, VS Code extension y via API. No en la version web.
- Disponible en planes max, team y enterprise.
- Segun es research preview: probar y experimentar antes de depender de el.

## Auto-configuracion de proyecto (claude-code-setup)

El plugin oficial `claude-code-setup` analiza el repo, detecta frameworks y dependencias, y recomienda:

- Hooks
- Skills
- MCPs
- Subagents

Instalacion:

```text
/plugin install claude-code-setup@claude-plugins-official
```

Usar cuando se configura un proyecto nuevo o se quiere entender que automatizaciones y configuraciones convienen para un stack dado.

## Regla final

Paralelizar para reducir riesgo/contexto, no para sumar teatro.
