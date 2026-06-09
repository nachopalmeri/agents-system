# Research Notes — Junio 2026

Hallazgos de investigación web integrados al agents-system. Este archivo es referencia, no se carga en cada sesión.

## Claude Code — Managed Agents (Mayo 2026)

### Dreaming
- Proceso programado que revisa sesiones pasadas, extrae patrones, cura memoria entre sesiones.
- Agentes que mejoran solos sin intervención humana.
- Puede actualizar memoria automáticamente o requerir aprobación.
- Especialmente útil para long-running work y multiagent orchestration.
- Nuestro equivalente: `session_checkpoint.md` (dreaming manual).
- Ref: https://claude.com/blog/new-in-claude-managed-agents

### Outcomes
- Rubric de éxito + grader separado que evalúa output en su propio context window.
- Hasta +10 puntos de mejora vs prompting loop estándar.
- +8.4% task success en docx, +10.1% en pptx.
- Nuestro equivalente: `validation.md` (outcomes manual sin grader).
- Próximo nivel: outcomes con grader automático.
- Ref: https://platform.claude.com/docs/en/managed-agents/define-outcomes

### Multiagent Orchestration
- Lead agent delega a especialistas con modelo/prompt/tools propios.
- Corren en paralelo, filesystem compartido.
- Eventos persistentes: cada agente recuerda qué hizo.
- Trace completo en Claude Console.
- Nuestro equivalente: `web-factory.md` (5 agentes sandboxed) + `parallel_agents.md`.

## Devin Desktop (ex-Windsurf) — Junio 2, 2026

- Windsurf renombrado a Devin Desktop (Cognition).
- Agent Client Protocol (ACP): protocolo abierto Apache 2.0.
- Codex, Claude Agent, OpenCode, etc. corren dentro de un mismo editor.
- Devin Local reemplaza a Cascade (30% más token-efficient, subagents, Rust rewrite).
- Agent Command Center es la pantalla default.
- Legacy `.windsurf/` paths siguen como fallback.
- Ref: https://devin.ai/blog/windsurf-is-now-devin-desktop

## Antigravity CLI (ex-Gemini CLI) — Junio 18, 2026

- Gemini CLI se descontinúa Junio 18, 2026.
- Reemplazo: Antigravity CLI (built in Go, más rápido).
- Sigue leyendo GEMINI.md y AGENTS.md sin cambios.
- Skills migran de `.gemini/skills/` a `.agents/skills/` (ya compatible con nuestra estructura).
- Soporta multi-agent, async background workflows.
- Ref: https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/

## Codex CLI — AGENTS.override.md

- Codex soporta AGENTS.override.md por directorio (precedencia sobre AGENTS.md).
- Discovery chain: global (~/.codex/AGENTS.md) → project root → subdirectorios → override.
- `project_doc_fallback_filenames` para nombres custom.
- `project_doc_max_bytes`: 32 KiB default.
- Ref: https://developers.openai.com/codex/guides/agents-md

## AGENTS.md Spec (ASDLC.io / Gloaguen et al. 2026)

### Toolchain First
- Si un linter/tsconfig/ESLint lo enforcea, sacarlo de AGENTS.md.
- La tool es el mecanismo de enforcement, no el agente.

### Context Map
- Directory maps no aceleran file discovery durante delivery tasks (Gloaguen et al. 2026).
- Solo útiles para onboarding, spec writing, error triage, ADR authoring.

### LLM-generated Context Files
- Reducen agent performance consistentemente.
- Amplían exploration, aumentan reasoning cost sin mejorar outcomes.
- Usar /init output como inventario, no como constitución.

### Judgment Boundaries (3-tier)
- NEVER: hard judgment limits.
- ASK: human-in-the-loop triggers.
- ALWAYS: proactive judgment.

### Personas como Registry
- Listar por nombre e invocación en AGENTS.md.
- Definiciones completas en skill/workflow files, no inline.
- Loading todas las definiciones en cada sesión es wasteful.

## Claude Design Skills (freshtechbro/claudedesignskills)

- 22 plugins individuales, 5 bundles.
- Core 3D & Animation: threejs-webgl, gsap-scrolltrigger, react-three-fiber, motion-framer, babylonjs-engine
- Extended 3D & Scroll: aframe-webxr, lightweight-3d-effects, playcanvas, pixijs-2d, locomotive-scroll, barba-js
- Animation & Components: react-spring-physics, animated-component-libraries, scroll-reveal-libraries, animejs, lottie-animations
- 3D Authoring & Motion: blender-web-pipeline, spline-interactive, rive-interactive, substance-3d-texturing
- Meta-Skills: web3d-integration-patterns, modern-web-design
- Instalación: `/plugin install [nombre]` en Claude Code.
- Ref: https://github.com/freshtechbro/claudedesignskills

## Lovable / Bolt.new / v0 — AI Web Builders

### Lovable
- 3 modos: Agent Mode (autónomo) → Visual Edits (reshape) → Plan Mode (estrategia).
- Agent Mode: piensa, planifica, explora codebase, hace cambios, auto-fixea.
- Visual Edits: click→edit sin tocar código.
- Plan Mode: 1 crédito/mensaje, discutir antes de ejecutar.
- Nuestro equivalente: `web-factory.md` (Plan→Agent→Polish).

### Bolt.new
- Auto-routing al modelo correcto por tarea (calidad vs costo).
- WebContainer: sandbox completo en browser.
- Nuestro equivalente: `model_routing.md` + agentes sandboxed.

### v0 (Vercel)
- Generative UI: describe → genera componentes React + Tailwind.
- Deep integration con shadcn/ui.
- Nuestro equivalente: `premium-web-stack` skill.

## Tito's Sales Playbook (de0aclientes.substack.com)

- 5 métodos: Google Maps cold call, visita presencial, red de redes, boca a boca con hacks, documentar en redes.
- Insight central: VENDER es la skill más importante. Offline primero, online después.
- Casos reales: Fidelando, Picsel, PymeInteligente, 1minuto.
- Integrado en: `venture_loop.md` Etapa 0, `marketing.md` outbound.

## Loop Engineering (Addy Osmani, Junio 8, 2026)

Ref: https://x.com/addyosmani/status/...

### 5 bloques + 6to (memory)

1. **Automations** — heartbeat del loop. Schedule + cadence + findings van a ti.
   - Codex: Automations tab, triage inbox.
   - Claude Code: `/loop`, cron, hooks, GitHub Actions.
2. **Worktrees** — aislamiento para paralelo sin colisiones.
   - Codex: built-in worktree support.
   - Claude Code: `--worktree` flag, `isolation: worktree` en subagents.
3. **Skills** — dejar de re-explicar el proyecto cada sesión.
   - Ambos: SKILL.md en carpeta, `$` o `/skills` para invocar.
   - Skill = authoring format, Plugin = distribución.
4. **Plugins/Connectors (MCP)** — el loop toca tus herramientas reales.
   - Ambos hablan MCP. Conector de uno funciona en el otro.
5. **Sub-agents** — maker ≠ checker. El que escribe no es el que verifica.
   - Codex: `.codex/agents/` TOML files con model/reasoning distinto.
   - Claude Code: `.claude/agents/` + agent teams.
6. **Memory** — el 6to bloque. Markdown file, Linear board, cualquier cosa que viva fuera de la conversación.
   - "The model forgets everything between runs so the memory has to be on disk and not in the context. The agent forgets, the repo doesn't."

### `/goal` primitive

- Ralph Loop cicla tareas de una lista. `/goal` cicla hasta condición verificable.
- Checker separado evalúa si se cumple — no el agente que trabajó.
- Codex y Claude Code ambos tienen `/goal`.
- Pause, resume, clear disponibles.

### Quotes clave

- "You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents." — @steipete
- "I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops." — Boris Cherny, head of Claude Code at Anthropic.
- "nobody talks about exit conditions. writing the loop is easy. defining when it's done is the whole game. i had claude code loop to a green test suite once. green because it quietly deleted the failing tests." — @gagansaluja08
- "addy lists memory as the sixth thing but it's really the first thing. every other piece only works if the loop remembers what happened last time. memory is the loop's intelligence." — @InfomlyLab

### 3 problemas que se agudizan con loops

1. **Verification is still on you.** Un loop desatendido también comete errores desatendido. El maker/checker split hace que "done" signifique algo, pero "done" es un claim, no una proof.
2. **Comprehension debt.** Cuanto más rápido el loop shippea code que no escribiste, más grande la brecha entre lo que existe y lo que entendés.
3. **Cognitive surrender.** La postura cómoda es la riesgosa. Diseñar el loop para evitar pensar vs para moverse más rápido en trabajo que entendés. Misma acción, resultado opuesto.

### Integrado en nuestro sistema

- `parallel_agents.md`: Goal Primitive, Maker/Checker Split, Agentic Budgeting, Exit Conditions Anti-Fake.
- `AGENTS.md` GOTCHAS: Comprehension debt, Cognitive surrender.
- `AGENTS.md` ALWAYS: Diseñar loops como engineer, exit conditions anti-fake.
- `harness.md`: Automation layer (heartbeat).
- `session_checkpoint.md` + `task_ledger.md`: Memory (6to bloque).
