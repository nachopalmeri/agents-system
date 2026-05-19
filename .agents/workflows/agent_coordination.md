---
description: Protocolo de coordinación para múltiples agentes/worktrees en paralelo en el mismo proyecto
---

# Workflow: Agent Coordination

## Cuándo usar

Cuando hay 3 o más agentes/worktrees trabajando en paralelo en el mismo proyecto con dependencias entre sus outputs. Para 2 agentes sin dependencias, alcanza con `parallel_agents.md`.

## Contrato por agente

Cada agente activo debe tener un contrato explícito registrado en `tasks/agents-active.md`:

```markdown
| Agente | Worktree | Produce | Consume | Interfaz | Bloqueo | Estado |
|---|---|---|---|---|---|---|
| agente-design | agente/design | componentes UI, design system | nada | commit `ready: design system` | — | activo |
| agente-feature | agente/feature | páginas y lógica | design system (de agente-design) | commit `ready: feature` | espera a agente-design | esperando |
| agente-tests | agente/tests | tests E2E | feature completa (de agente-feature) | commit `ready: tests` | espera a agente-feature | esperando |
```

### Campos del contrato

- **Agente:** nombre del agente.
- **Worktree:** rama donde trabaja.
- **Produce:** qué archivos, componentes o resultados entrega.
- **Consume:** qué necesita que otro agente haya terminado primero.
- **Interfaz:** cómo comunica que terminó (commit message, archivo flag, PR).
- **Bloqueo:** qué pasa si no puede continuar (a quién notificar, qué mensaje).

## Fases de coordinación

### FASE 1 — Kickoff

1. El director define los contratos de todos los agentes activos.
2. Registrar cada contrato en `tasks/agents-active.md`.
3. Cada agente lee su contrato antes de arrancar.
4. Confirmar que no hay conflictos de archivos entre worktrees.

### FASE 2 — Ejecución paralela

1. Cada agente trabaja en su worktree, sin interferir con otros.
2. **No merge sin validación del director.**
3. Si un agente termina y otro depende de él:
   - Commit con mensaje `ready: [qué produce]`.
   - El agente dependiente puede arrancar.
4. Si un agente se bloquea:
   - Commit con mensaje `blocked: [por qué] [qué necesita]`.
   - Notificar al director para resolver la dependencia.
5. Si hay conflicto de archivos inesperado: parar ambos agentes y resolver manualmente.

### FASE 3 — Integración

1. El director revisa los outputs de cada agente.
2. Merge en orden de dependencias (primero los que producen, después los que consumen).
3. Ejecutar tests de integración después de cada merge.
4. Si algo falla: activar `feedback_loop.md` antes de continuar.
5. Si todo pasa: continuar con el siguiente agente en la cadena.

### FASE 4 — Cierre

1. Ejecutar `validation.md` completo sobre el proyecto integrado.
2. Limpiar worktrees: `git worktree remove [path]`.
3. Actualizar `tasks/handoff.md` con el estado post-integración.
4. Marcar todos los agentes como `completado` en `tasks/agents-active.md`.
5. Si el proyecto lo requiere, generar ADRs para decisiones tomadas durante la coordinación.

## Archivo `tasks/agents-active.md`

Formato estándar que se crea en presets `ai-prod` y `spec-kit`:

```markdown
# Agentes Activos

| Agente | Worktree | Produce | Consume | Interfaz | Bloqueo | Estado |
|---|---|---|---|---|---|---|
```

Estados posibles: `pendiente`, `activo`, `esperando`, `bloqueado`, `completado`.

## Reglas

- Un agente no modifica el scope de otro sin coordinación explícita.
- Si un agente necesita algo que otro no terminó, espera — no improvisa.
- Los commits de señal (`ready:`, `blocked:`) son obligatorios para coordinación.
- El director es el único que mergea ramas.
- Si la coordinación se vuelve más cara que hacerlo secuencial, volver a flujo simple.
