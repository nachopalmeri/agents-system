# Plan Definitivo — El Mejor Sistema de Agentes del Mundo

Roadmap para llevar el agents-system de "bueno" a "el mejor", basado en la meta-crítica del sistema contra sus propios principios.

## Estado actual (Junio 9, 2026)

### Lo que tiene (fortalezas)
- ✅ AGENTS.md portable (223 líneas, -33% vs original)
- ✅ 5 bloques de Loop Engineering (Automations, Worktrees, Skills, Connectors, Sub-agents)
- ✅ 6to bloque: Memory (task_ledger, session_checkpoint, memory/)
- ✅ Goal Primitive + Maker/Checker Split + Agentic Budgeting
- ✅ Exit Conditions Anti-Fake
- ✅ Judgment Boundaries (NEVER/ASK/ALWAYS)
- ✅ Toolchain First aplicado (deduplicado, research en docs/)
- ✅ Comprehension Debt + Cognitive Surrender como GOTCHAS
- ✅ Chat-first con router invisible
- ✅ Multi-IDE (Devin Desktop/ACP, Antigravity CLI, Codex, Claude Code, Aider)
- ✅ Dreaming manual (session_checkpoint) con referencia a dreaming automático
- ✅ Web Factory (5 agentes sandboxed, premium-web-stack)
- ✅ Token budget del sistema documentado (~18K base)
- ✅ 3 workflows deprecated (phases, harvard_teacher, marketing_mcp_eval)

### Lo que falta (gaps)

## GAP 1: Dreaming Automático → Memory Curation Loop
**Prioridad:** Alta | **Complejidad:** Media

El sistema tiene dreaming manual (session_checkpoint). El próximo nivel es un loop que corra entre sesiones y cure memoria automáticamente.

### Implementación
1. Crear `workflows/dreaming.md` — workflow que:
   - Lee `memory/lessons-global.md`, `tasks/lessons.md`, `memory/developer_growth.md`
   - Detecta patrones repetidos (N≥3)
   - Propone promociones a reglas globales
   - Identifica lecciones stale (sin mención en 30+ días → candidato a poda)
   - Genera un "dream report" que el humano aprueba/rechaza
2. Integrar con Claude Code `/loop` o cron: correr dreaming cada noche o cada 5 sesiones
3. Cuando Claude Managed Agents esté disponible, conectar dreaming automático

## GAP 2: Outcomes con Grader → Quality Gate Automático
**Prioridad:** Alta | **Complejidad:** Media

El sistema tiene outcomes manual (validation.md). El próximo nivel es un grader separado que evalúe output en su propio context window.

### Implementación
1. Crear `workflows/outcomes.md` — workflow que:
   - Define rubric de éxito antes de empezar (criterios verificables)
   - Al finalizar, un subagente separado (maker/checker) evalúa contra la rubric
   - Grader usa modelo diferente o reasoning effort alto
   - Output: score + gaps + recomendaciones
2. Integrar con `/goal` primitive: el grader es el checker del goal
3. Métrica: trackear scores por tipo de tarea → detectar degradación

## GAP 3: Worktree Workflow → Aislamiento Formal
**Prioridad:** Media | **Complejidad:** Baja

`parallel_agents.md` menciona worktrees pero no hay workflow formal.

### Implementación
1. Agregar sección "Worktree Protocol" a `parallel_agents.md`:
   - `git worktree add ../feature-X feature-X` para cada agente
   - Cleanup automático post-merge
   - Conflict resolution protocol
2. Mapear a Claude Code `--worktree` flag y Codex built-in worktree

## GAP 4: Agentic Budgeting Automático → Token Awareness en el Loop
**Prioridad:** Media | **Complejidad:** Baja

El sistema tiene agentic budgeting documentado pero no hay mecanismo que lo enforce.

### Implementación
1. Agregar a `harness.md`: trackear tokens consumidos por sesión
2. En `/goal` primitive: el checker también verifica budget (si >80%, reportar)
3. En `session_checkpoint.md`: agregar campo "tokens estimados consumidos"

## GAP 5: Comprehension Debt Countermeasure → Review Protocol
**Prioridad:** Media | **Complejidad:** Baja

El sistema identifica comprehension debt como gotcha pero no tiene countermeasure.

### Implementación
1. Agregar a `validation.md`: "¿Leíste todo el código que el loop generó?" como check
2. Agregar a `harness.md`: si un loop generó >500 líneas sin intervención humana, flag como "comprehension debt risk"
3. Regla: cada 3 loops desatendidos → 1 sesión de review manual obligatoria

## GAP 6: Skill Discovery → Auto-routing por Descripción
**Prioridad:** Baja | **Complejidad:** Alta

El router index.md enruta por intención, pero las skills se activan manualmente. Addy dice: "a tight boring description beats a clever one" para auto-trigger.

### Implementación
1. Audit skill descriptions: ¿son lo suficientemente específicas para auto-trigger?
2. Agregar a `skills_routing.md`: pattern matching por descripción de skill
3. Cuando Claude Code soporte skill auto-discovery, conectar

## GAP 7: Plugin Distribution → Shareable System
**Prioridad:** Baja | **Complejidad:** Alta

El sistema es personal. Para ser "el mejor del mundo", debería ser shareable.

### Implementación
1. Empaquetar como plugin de Claude Code: `agents-system@nachopalmeri`
2. Bundle: AGENTS.md + skills core + workflows core + rules
3. Publicar en awesome-opencode o Claude plugin registry
4. Cada usuario puede customizar via AGENTS.override.md

## Timeline sugerido

| Semana | GAPs | Entregable |
|---|---|---|
| 1 | GAP 1 + GAP 2 | Dreaming + Outcomes workflows |
| 2 | GAP 3 + GAP 4 | Worktree protocol + Budget enforcement |
| 3 | GAP 5 | Comprehension debt countermeasure |
| 4 | GAP 6 + GAP 7 | Skill discovery + Plugin packaging |

## Métrica de éxito

El sistema será "el mejor" cuando:
1. Un loop puede correr desatendido overnight y el humano confía en el resultado (GAP 2)
2. El sistema mejora entre sesiones sin intervención humana (GAP 1)
3. El costo en tokens es visible y controlado (GAP 4)
4. El humano no pierde comprensión del código que existe (GAP 5)
5. Cualquier developer puede instalarlo en 5 minutos (GAP 7)
