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

## Regla final

Paralelizar para reducir riesgo/contexto, no para sumar teatro.
