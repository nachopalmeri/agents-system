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

## Ralph Loop (desarrollo iterativo stateless)

Patrón popularizado por Geoffrey Huntley y Ryan Carson. Desarrollo en loop stateless-but-iterativo: cada iteración es atómica y el contexto se resetea entre ciclos.

### 5 pasos del ciclo

1. **Pick** — seleccionar la próxima tarea de `tasks.json`.
2. **Implement** — hacer el cambio.
3. **Validate** — correr tests, types, lint.
4. **Commit** — si los checks pasan, commitear y actualizar estado de la tarea.
5. **Reset** — limpiar contexto del agente y empezar fresco con la próxima tarea.

### Insight clave

Stateless-but-iterative: al resetear cada iteración, el agente evita acumular confusión. Tareas chicas y acotadas producen código más limpio con menos alucinaciones que un prompt enorme.

### 4 canales de memoria persistente

- Git commit history (lo que ya se hizo).
- Progress log (avance general).
- `tasks.json` (estado de cada tarea).
- `AGENTS.md` (memoria semántica a largo plazo).

### Safeguards

- Feed errors back para auto-retry.
- Kill y reassign después de 3+ iteraciones stuck en el mismo error.
- Siempre trabajar en feature branches.
- Límites duros: iteraciones máximas, tiempo máximo, tokens máximos.
- El agente abre PR → humano review antes de merge.

### Escalamiento

Empezar con un loop overnight. Graduar a 10 loops en 10 branches cuando se confirme que funciona.
