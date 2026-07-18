# Plan de migración incremental

## Estrategia

No hacer una reescritura total. Primero restaurar coherencia; después introducir una fuente editable por concern —`AGENTS.md` para policy y manifest para metadata— y migrar componentes por grupos. Cada etapa debe poder revertirse con un commit y mantener al menos un entry point funcional.

## Qué eliminar primero

1. Referencias activas a `phases.md`, `context_check.md` y archive.
2. `opencode.json` inválido o reemplazarlo por config mínima válida.
3. Gitlink `obsidian-skills` sin `.gitmodules`, si no se recupera owner/URL.
4. `bin/check-agents-system.ps1` como supuesto gate; conservarlo temporalmente como diagnóstico deprecated si alguien lo usa.
5. Claims temporales no demostrados: Dynamic Workflows mágico, skills Antigravity, AGENTS compartido por ACP, conteos “60K+”.

Esto reduce fallos presentes sin decidir todavía la forma final de todos los agentes.

## Qué no tocar al principio

- `ai-permissions.md` y sus límites humanos.
- `chat-first.md` y mínimo proceso suficiente.
- Los tres reviewers/investigadores útiles: security, code review, research.
- Skills de dominio con trigger claro: debugging, frontend, product, SEO growth, AI architecture, academic submodes.
- Secret scan y convenciones no-force-push/no-merge.
- Historial del archive hasta registrar provenance/licencias/reemplazos.

## Fase 0 — Congelar baseline

**Objetivo:** que cada mejora compare contra una fotografía reproducible.

Acciones:

1. Etiquetar el commit auditado o registrar SHA en un issue/PR.
2. Capturar outputs de `validate-agents`, `test-system`, `release-check`, `doctor`, tres routes y `opencode debug config`.
3. Persistir los 24 IDs normativos como `observed-v1`: 14 escenarios positivos y 10 negativos, con input/comando/stdout/resultado actual aunque sea incorrecto.
4. Registrar los 667 paths y el gitlink.

Validación:

- Baseline puede regenerarse en Windows.
- Los 17 `.ps1` pasan parser y los 19 `.sh` pasan `bash -n`; el gate funcional Unix queda para Fase 6 en un runner Linux real.
- Ningún archivo productivo cambia salvo fixtures/docs aprobados.

Rollback: tag anotado `agents-system-baseline-<fecha>-<sha7>` + manifest de hashes. Borrar solo artefactos de baseline no cambia runtime; un restore test en clone temporal debe reproducir hashes y comandos registrados.

## Fase 1 — Reparar roturas sin rediseñar

**Objetivo:** ningún entry point activo referencia componentes archivados/ausentes y OpenCode abre.

Acciones:

1. Elegir temporalmente `AGENTS.md` raíz como canónico y reemplazar `.agents/AGENTS.md` por adapter generado o pointer documentado.
2. Quitar rutas inexistentes/archivadas de root, `.agents/SKILL.md`, OpenCode, docs operativas y agentes activos.
3. Cambiar fallback de `index.md` de archive a flujo simple + limitación explícita.
4. Corregir `opencode.json` con schema actual.
5. Corregir Claude a `@AGENTS.md` y `ln -s`.
6. Marcar Cursor legacy y adapters no verificados.
7. Corregir ya la autonomía mínima: fallback/trivial local no requiere aprobación; conservar `ask` para dependencias, destructivo, producción y external writes.

Validación:

- `rg`/grafo: cero referencias activas a `.agents/archive` o basenames no activos.
- `opencode debug config`: exit 0.
- Codex/Claude/OpenCode smoke manual en repo limpio.
- `git diff --name-only` limitado al scope de entry points/docs/config.
- Typo local pasa sin doble turno; los cuatro casos sensibles anteriores siguen pidiendo confirmación.

Rollback: revert único de Fase 1; baseline permanece.

Riesgo: usuarios que dependían del fallback archive. Mitigación: tabla de reemplazos en release notes y activación explícita de un componente archivado solo mediante instalación manual.

## Fase 2 — Manifest y validador semántico

**Objetivo:** una fuente de verdad machine-readable aplicada, no decorativa.

Acciones:

1. Definir `system.manifest.json` y schema versionado.
2. Importar los 19 agentes/52 skills/13 workflows con `status`, `path`, `kind`, `mode`, `triggers`, `negativeTriggers`, `tools`, `outputs`, `actionRisk`, `owner` y `version`.
3. Aplicar JSON Schema real a manifest, registry y tasks.
4. Implementar grafo de referencias activas.
5. Validar tools↔outputs, path↔frontmatter, reachability y archive inbound refs.
6. Reemplazar listas duplicadas de `release-check`/CI por el nuevo gate.

Validación:

- Mutación controlada: borrar un path en fixture hace fallar el gate.
- Cambiar un executor a Read-only mientras output dice “implementation” hace fallar.
- Task incompleto falla antes del router.
- CI Windows/Linux ejecuta el mismo contrato; skips son warnings explícitos, no pass.

Rollback: mantener registry viejo como export generado durante una release; revert manifest/validator si el export no coincide.

Riesgo: crear otra fuente de verdad. Mitigación: registry, catálogos y docs pasan a generados; CI falla si se editan a mano o divergen.

## Fase 3 — Router v2 en shadow mode

**Objetivo:** corregir routing sin cambiar todo de golpe.

Acciones:

1. Implementar precedencia `instrucción explícita válida → gate de riesgo no-bypass → intención → dominio → tamaño → especialista/no_agent`.
2. Usar metadata del manifest; evitar regex sin boundary y agregar español/inglés.
3. Añadir ruta `no_agent`.
4. Emitir `routeVersion`, `why`, `filesToLoad`, `actionGate`, `exitCriteria`.
5. Ejecutar v1 y v2 en paralelo sobre fixtures/uso opt-in. Durante shadow, v1 solo puede decidir operaciones locales low-risk; toda diferencia high-risk requiere revisión humana y ninguna versión puede omitir el action gate.
6. Revisar diferencias y etiquetar `v2 better|same|worse|unknown`.

Validación:

- La suite `route-v2-logical` pasa los 24 IDs normativos (14 positivos + 10 negativos) en IDs/gates sin exigir todavía paths físicos target.
- Los 10 negativos incluyen las colisiones “preparación”, “producto”, “producción”, “explicar”, “sin tests”, explicit bypass, MCP, SEO, vault y ES/EN.
- Explicit mention no salta security gate.
- Agentes activos reachables o declarados `explicitOnly`.

Criterio para salir de shadow hacia F4: cero P0/P1 conocidos en routing lógico y revisión humana de diferencias high-risk. El switch productivo ocurre recién después de F4, cuando `target-v2` valida IDs y paths físicos. Ventana máxima: 14 días o 50 decisiones reales, lo que ocurra primero; abortar ante un gate sensible omitido o contrato tools↔output imposible.

Rollback: variable/config vuelve a router v1; eliminar shadow tras una ventana corta para que no se vuelva una capa permanente.

## Fase 4 — Consolidar componentes

**Objetivo:** bajar solapamiento preservando outputs.

Lotes reversibles:

### 4A — Planning y cierre

- Brainstorming condicional.
- Merge verification en validation.
- Writing plan proporcional.
- Spec Kit solo large/high-risk.
- Kickoff agent absorbido por skill.

Pruebas: trivial no crea plan; medium crea plan breve; large crea spec; docs-only usa evidencia alternativa.

### 4B — Paralelismo

- Dispatch skill conserva contratos.
- Worktrees quedan en skill propia.
- Maker/checker queda en review.
- `parallel_agents.md` se acorta a decisión y coordinación.

Pruebas: 1 tarea no delega; 2 independientes sí; tareas sobre mismo archivo no paralelizan.

### 4C — Dominios triplicados

- Product agent/workflows → `product-foundry` skill.
- Growth agent/workflow → `seo-geo-growth` skill.
- AI agent/workflow → AI skill + security/code reviewer cuando aplica.
- Academic workflow/agent → tutor skill con submodos y vault opt-in.
- Frontend agent → frontend skill; visual reviewer solo condicional.
- SEO técnico agent → `technical-seo`; marketing agent → `marketing-strategy`.
- MCP architect → `mcp-adoption` + security reviewer; Obsidian brain → `obsidian-vault`.
- Release manager → `release`; X/content agent → `content-strategy`.

Pruebas: prompts de activación/negative triggers y reader tests por dominio.

Rollback: un commit por lote. Cada alias registra `oldId`, `replacementId` y `retireAfter`; dura una release fechada y solo redirige, sin duplicar contenido.

Aliases obligatorios: `agente-researcher→researcher`, `agente-security-auditor→security-reviewer`, `agente-code-reviewer→code-reviewer`. El resto de agentes retirados apunta a una skill o a `no_agent`; nunca a un cuarto agente.

## Fase 5 — Action gate y contratos ejecutables

**Objetivo:** autonomía local y control real de side effects.

Acciones:

1. Quitar `requiresApproval` global por agente.
2. Clasificar tools/operaciones por `read`, `local-write`, `external-write`, `destructive`, `human-claim`.
3. Añadir preview/target/blast-radius/rollback antes de `ask`.
4. Dar tools correctas a executors; convertir roles read-only en reviewers.
5. Añadir tests de bypass por explicit mention.

Validación:

- Typo local ejecuta sin doble turno.
- Instalar dependencia, borrar, producir deploy o enviar mensaje exige confirmación.
- Security/research/code reviewer no escriben.
- Ningún flag `reviewed_by_user` puede establecerse por agente.

Rollback: `git revert <commit-fase>` restaura manifest y gates en conjunto; fixture de rollback confirma que no se habilitan external writes. No mezclar ambas políticas indefinidamente.

## Fase 6 — Adapters e instalación segura

**Objetivo:** portabilidad honesta y reproducible.

Acciones:

1. Generar adapters Claude, OpenCode, Cursor y experimentales desde manifest. Para Codex generar solo `.codex/config.toml`/metadata que referencia el `AGENTS.md` hand-authored; nunca generar ni sobrescribir ese archivo.
2. Alinear install/update PowerShell y shell.
3. Administrar solo paths listados en un install manifest.
4. Dry-run y backup por defecto antes de reemplazar copias.
5. Post-check específico por proveedor.
6. Eliminar `sync-agents.ps1`, rutas personales y copias bidireccionales.

Validación:

- Fixtures de home temporal para install/update/rollback.
- Segunda instalación no cambia nada (idempotencia).
- Archivo local no administrado sobrevive update.
- OpenCode config valida; Claude bridge contiene import nativo; Unix y Windows generan mismo conjunto lógico.

Rollback: restaurar backup timestamped cuyo SHA coincide con install manifest anterior; probar restore en home temporal antes de publicar. No borrar backup hasta post-check verde.

## Fase 7 — Observabilidad y poda basada en uso

**Objetivo:** evitar nueva inflación.

Acciones:

1. Traza mínima local opt-in.
2. Reporte mensual de componentes nunca usados/corregidos.
3. Eval A/B para instrucciones core costosas.
4. Política `active → deprecated → archived → removed`.
5. Mover archive pesado fuera del runtime después de registrar hash/licencia/upstream.

Validación:

- Log no contiene prompt, paths personales ni secretos.
- Se puede reconstruir por qué una ruta fue elegida.
- Archive tiene cero inbound refs antes de salir del repo.
- Tamaño/contexto reportado con mediciones, sin porcentajes inventados.

Rollback: desactivar telemetría; restaurar archive desde tag/release manifest.

## Dependencias entre fases

```text
F0 baseline
  ↓
F1 coherencia inmediata
  ↓
F2 manifest + validator
  ↓
F3 router v2
  ↓
F4 consolidación ─→ F5 action gate
  ↓                    ↓
F6 adapters/installer ←┘
  ↓
F7 observabilidad/archive
```

F1 puede salir rápido. No comenzar poda física (F4/F7) antes de que manifest y fixtures (F2/F3) prueben reemplazos.

## Riesgos

| Riesgo | Prob. | Impacto | Mitigación |
|---|---|---|---|
| Simplificar y perder un playbook valioso | Media | Alto | Mapear outputs/fixtures antes de merge/delete; aliases una release. |
| Manifest se vuelve otra capa manual | Alta | Alto | Generar registry/docs/adapters; prohibir edición duplicada. |
| Router v2 “mejora” fixtures pero falla casos reales | Media | Alto | Shadow corto + correcciones reales anonimizadas. |
| Adapter oficial cambia | Alta | Medio | `lastVerified`, `minVersion`, diagnóstico y owner. |
| Installer borra configuración local | Media | Crítico | Manifest de ownership, backup, dry-run, home temporal. |
| Telemetría captura datos personales | Baja | Alto | Campos allowlist; sin contenido; opt-in y test de redacción. |
| Archive externo se pierde | Baja | Medio | Tag/release + hashes/licencias + restore test. |
| Consolidar agents/skills cambia invocaciones | Alta | Medio | Alias deprecated + mensaje de reemplazo + período corto. |

## Criterio de finalización de la migración

- Un único manifest produce todos los catálogos/adapters.
- Cero refs activas a archive/ausentes.
- Los 24 fixtures normativos pasan en Windows/Linux.
- OpenCode, Codex y Claude smoke tests documentados; otros adapters declaran experimental si no se prueban.
- Acción local trivial no pide aprobación; side effect sensible sí.
- Cada agente activo tiene tools/output/exit compatibles.
- Install/update es idempotente y rollback está probado.
- Archive fuera del runtime y recuperable.
- Docs generadas no divergen.
- Telemetría o, al menos, fixtures permiten justificar cada componente restante.
