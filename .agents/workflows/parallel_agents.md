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

> "I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops." — Boris Cherny, head of Claude Code at Anthropic.

Este quote valida el Ralph Loop como dirección oficial de la industria: el trabajo del developer pasa de "escribir prompts" a "escribir loops que promptean al AI".

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

## Goal Primitive (Addy Osmani / Loop Engineering)

El `/goal` primitive es diferente del Ralph Loop. Ralph Loop cicla tareas de una lista. `/goal` cicla hasta que una **condición verificable** es verdadera. Después de cada turno, un **modelo separado** (o subagente con instrucciones distintas) verifica si se cumple la condición — el agente que escribió el código no es el que evalúa si está listo.

### Patrón

```text
/goal "condición verificable"
→ agente trabaja un turno
→ checker separado evalúa condición
→ si cumple: done
→ si no cumple: agente continúa con feedback del checker
→ repeat
```

### Ejemplos de condiciones

- "all tests in test/auth pass and lint is clean"
- "Lighthouse score ≥ 90 and LCP < 2.5s"
- "la landing tiene CTA visible above the fold y no hay Lorem ipsum"
- "todos los endpoints del spec tienen integration test"

### Anti-pattern: el agente hace trampa

Caso real (Gagan): "I had Claude Code loop to a green test suite once. Green because it quietly deleted the failing tests."

**Regla:** la condición de salida debe ser más específica de lo que el agente puede fakear. No "tests pass" sino "tests pass AND test count didn't decrease AND no tests were modified in this run".

## Maker/Checker Split

El pattern más importante en loops: **el que escribe ≠ el que verifica**.

El modelo que escribió el código es demasiado generoso calificando su propio trabajo. Un segundo agente con instrucciones diferentes (y a veces un modelo diferente) atrapa lo que el primero se auto-convenció de que estaba bien.

### Implementación

| Herramienta | Maker | Checker |
|---|---|---|
| Claude Code | Subagente implementador | Subagente verificador (modelo diferente o reasoning effort alto) |
| Codex | `.codex/agents/` TOML con model/reasoning distinto | `.codex/agents/reviewer.toml` con modelo fuerte en high effort |
| Web Factory | `agente-web-layout/3d/motion/copy` | `agente-web-qa` |

### Cuándo vale la pena (token cost)

- Siempre para loops desatendidos (no estás ahí para verificar).
- Siempre para `/goal` (el checker es parte del primitive).
- Opcional para tareas simples donde el humano verifica en persona.
- Sub-agents queman más tokens: usar donde una segunda opinión vale el costo.

## Agentic Budgeting

Los loops pueden quemar tokens sin límite si no hay awareness. El budget se define antes de arrancar, no después.

### Parámetros por defecto

| Parámetro | Default | Ajustar si |
|---|---|---|
| Max iteraciones por goal | 10 | Tarea compleja → 20 |
| Max tokens por iteración | 50K | Subagentes con contexto largo → 100K |
| Cooldown entre iteraciones | 5s | API rate limiting → 30s |
| Max tokens por sesión completa | 500K | Token-rich → 1M, token-poor → 200K |
| Kill después de N errores seguidos | 3 | Mismo error repetido = stuck |

### Reglas

- Si el budget se acerca al 80%, el loop debe reportar progreso y pedir permiso para continuar.
- Si un loop está stuck (3+ iteraciones mismo error), kill y reassign, no insistir.
- El budget se declara explícitamente al inicio del loop, no se improvisa.
- Token-poor: loops cortos, checker barato (modelo chico), menos subagentes.
- Token-rich: loops largos, checker con modelo fuerte, más subagentes paralelos.

## Exit Conditions Anti-Fake

Definir "done" es la parte difícil del loop. La condición de salida tiene que ser más robusta de lo que el agente puede eludir.

### Pattern: condición + invariantes

No solo verificar el objetivo, sino también que no se rompió nada en el camino:

```text
Condición principal: [objetivo verificable]
Invariantes:
- test count no disminuyó
- no se modificaron tests en este run
- lint sigue limpio (no se silenciaron warnings)
- bundle size no creció más de X%
- no se agregaron dependencias sin autorización
- no hay TODO/FIXME nuevos en el código generado
```

### Niveles de verificación

1. **Barato:** pattern checks en tool outputs (grep por "skip", "TODO", "deleted test").
2. **Medio:** contract enforcement (el output tiene la forma esperada).
3. **Caro:** subagente verificador con modelo fuerte (maker/checker split).

Usar nivel 1 siempre. Nivel 2 si el loop es desatendido. Nivel 3 si las consecuencias de un falso "done" son graves.

## Worktree Protocol

Dos agentes editando los mismos archivos = conflicto garantizado. Git worktrees dan a cada agente su propio checkout aislado en una branch separada, compartiendo el mismo repo history.

### Setup

```bash
# Crear worktree para un agente
git worktree add ../feature-X -b feature/X

# O desde una branch existente
git worktree add ../feature-X feature/X
```

### Mapeo por herramienta

| Herramienta | Worktree support |
|---|---|
| Claude Code | `--worktree` flag, `isolation: worktree` en subagent YAML |
| Codex | Built-in worktree por thread (Automations tab) |
| Manual | `git worktree add` + `cd ../feature-X` |

### Reglas de aislamiento

1. Cada agente trabaja en su propio worktree/branch.
2. Ningún agente edita archivos fuera de su worktree.
3. Si un agente necesita un archivo que otro está editando → esperar o coordinar via `agent_coordination.md`.
4. Los worktrees se limpian después del merge (no acumular).

### Merge protocol

1. Agente termina → commit en su branch.
2. Abrir PR desde branch del agente → main.
3. Humano review + CI checks.
4. Merge → cleanup worktree: `git worktree remove ../feature-X`.

### Conflict resolution

Si hay conflictos al mergear:
1. No forzar merge. Identificar archivos en conflicto.
2. Si el conflicto es entre outputs de agentes → humano decide.
3. Si el conflicto es con main actual → rebase sobre main y resolver: `git rebase main`.
4. Regla: el agente que creó el conflicto lo resuelve, no el otro.

### Cleanup

```bash
# Listar worktrees activos
git worktree list

# Limpiar worktree después de merge
git worktree remove ../feature-X

# Limpiar worktrees huérfanos (branches ya mergeadas)
git worktree prune
```

### Cuándo NO usar worktrees

- Un solo agente trabajando (no hay colisión).
- Agentes que solo leen (no editan archivos).
- Proyecto chico donde sequential es más simple.
