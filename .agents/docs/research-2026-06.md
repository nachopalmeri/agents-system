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
