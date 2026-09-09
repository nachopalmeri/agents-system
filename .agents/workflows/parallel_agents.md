---
description: Orquestación de agentes paralelos y worktrees cuando hay tareas independientes
---

# Parallel Agents

**Contrato finito:** sólo por pedido explícito o 2+ tareas realmente independientes. Lane PARALLEL: máximo 4 agentes, 8 iteraciones y 2 replans. Cada agente tiene ownership no solapado y entregable verificable. Dos fallos idénticos sin evidencia nueva terminan `BLOCKED`; siempre emitir receipt.

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
4. Aislamiento con `isolation: "worktree"` en el Agent tool (o `EnterWorktree`/`ExitWorktree` manual) si hay edición paralela sobre los mismos archivos.
5. Ejecutar cada tarea con contexto mínimo, en background salvo que el siguiente paso dependa del resultado.
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

## Maker/Checker Split

Para loops desatendidos o `/goal` con condición de salida: el que escribe el código no debe ser el que lo verifica (demasiado generoso calificando su propio trabajo). Usar un segundo agente/subagente con instrucciones distintas — a veces modelo o reasoning effort distinto — como checker. Opcional en tareas simples donde el humano verifica en persona.

| Herramienta | Maker | Checker |
|---|---|---|
| Claude Code | Subagente implementador | Subagente verificador (modelo o reasoning effort distinto) |
| Codex | `.codex/agents/` TOML con model/reasoning distinto | `.codex/agents/reviewer.toml` con modelo fuerte en high effort |
| Web Factory | `agente-web-layout/3d/motion/copy` | `agente-web-qa` |

## Agentic Budgeting

Declarar el budget antes de arrancar un loop, no improvisarlo.

| Parámetro | Default | Ajustar si |
|---|---|---|
| Max iteraciones por goal | 10 | Tarea compleja → 20 |
| Max tokens por iteración | 50K | Subagentes con contexto largo → 100K |
| Cooldown entre iteraciones | 5s | API rate limiting → 30s |
| Max tokens por sesión completa | 500K | Token-rich → 1M, token-poor → 200K |
| Kill después de N errores seguidos | 3 | Mismo error repetido = stuck |

Si el budget se acerca al 80%, reportar progreso y pedir permiso para continuar. Stuck (3+ iteraciones mismo error) = kill y reassign, no insistir.

## Exit Conditions Anti-Fake

La condición de salida tiene que ser más robusta de lo que el agente puede eludir. Caso real (Gagan): *"I had Claude Code loop to a green test suite once. Green because it quietly deleted the failing tests."* No "tests pass" sino "tests pass AND test count didn't decrease AND no tests were modified in this run".

Invariantes a verificar junto con el objetivo:

```text
- test count no disminuyó
- no se modificaron tests en este run
- lint sigue limpio (no se silenciaron warnings)
- bundle size no creció más de X%
- no se agregaron dependencias sin autorización
- no hay TODO/FIXME nuevos en el código generado
```

Nivel de verificación: pattern checks en tool outputs siempre; contract enforcement si el loop es desatendido; subagente verificador con modelo fuerte (maker/checker) si un falso "done" es grave.

## Worktree Protocol

Dos agentes editando los mismos archivos = conflicto garantizado. Usar `isolation: "worktree"` en el Agent tool (crea y limpia el worktree solo) o `EnterWorktree`/`ExitWorktree` para control manual — no gestionar `git worktree` a mano salvo que esas herramientas no estén disponibles.

- Ningún agente edita archivos fuera de su worktree.
- Si un agente necesita un archivo que otro está editando → esperar o coordinar via `agent_coordination.md`.
- Agente termina → commit en su branch → PR → humano review + CI → merge → cleanup.
- Conflicto con main: rebase y resolver; el agente que creó el conflicto lo resuelve, no el otro.
- No usar worktrees para un solo agente, agentes que solo leen, o proyectos chicos donde secuencial alcanza.

## Regla final

Paralelizar para reducir riesgo/contexto, no para sumar teatro.
