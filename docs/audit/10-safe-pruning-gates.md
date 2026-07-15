# Compuertas de poda segura

Fecha: 2026-07-15
Estado: política propuesta; no ejecuta migración ni eliminación

## Principio

**Reducir carga no requiere borrar.** El orden seguro es: dejar de auto-cargar → recuperar bajo demanda → extraer contenido diferencial → crear reemplazo → comparar → mantener alias → probar restore → recién entonces considerar retiro físico. Si cualquier gate falla, el activo permanece.

## Unidad de decisión

No se poda “un agente” en abstracto. Se evalúa un paquete:

- prompt/persona;
- procedimientos y outputs;
- skills, workflows y referencias;
- tools, permisos y workspace;
- memoria/adapters y datos personales;
- consumidores e inbound references;
- fixtures, métricas, aliases y restore path.

Una decisión que solo mira el archivo principal está incompleta.

## Gates obligatorios

| Gate | Evidencia requerida | Pasa cuando | Si falla |
|---|---|---|---|
| G0 Scope | ID, owner, motivo, archivos y consumidores. | El paquete completo está delimitado y no mezcla dominios. | `UNKNOWN`; no tocar. |
| G1 Inventory | Hash, tamaño, licencia/provenance, refs entrantes/salientes, datos sensibles. | Todo activo diferencial tiene registro y clasificación. | Preservar snapshot y localizar faltantes. |
| G2 Replacement | Destino exacto en core/skill/reference/agent/code. | Cada capacidad/output/tool boundary tiene equivalente explícito. | Mantener activo; crear destino. |
| G3 Static reachability | Búsqueda de IDs, paths, aliases y documentación. | Cero inbound references no migradas; aliases cubren compatibilidad. | Reparar consumidores; no retirar. |
| G4 Positive fixtures | Casos normales representativos. | Target cumple todos los criterios del specialist baseline. | Corregir target o conservar agente. |
| G5 Adversarial no-loss | Diez fixtures de `09`, incluidos seguridad/persistencia/release. | Cero regresiones críticas y ninguna acción indebida. | Veto de poda. |
| G6 A/B real | 30–60 tareas o muestra justificada por frecuencia/riesgo. | No empeora éxito, correcciones humanas, formato ni seguridad; costo documentado. | Extender evaluación o conservar. |
| G7 Context | Trace de automatic/retrieved/sent y budget. | La conversión reduce contexto real o elimina duplicación demostrada. | No venderla como optimización; revisar routing. |
| G8 Permissions | Matriz de tools, sandbox, datos y action gates. | No se amplían permisos; efectos externos siguen explicit-only. | Security review y bloqueo. |
| G9 Reversibility | Snapshot/tag, manifest, alias, fixture y restore command. | Restore ensayado en checkout limpio y un revert recupera la capacidad. | No retirar ni archivar fuera del repo. |
| G10 Human acceptance | Diff, métricas, pérdidas conocidas y decisión. | El director acepta retiro físico de activos de alto riesgo. | Mantener referencia activa. |

G5, G8, G9 y G10 son veto gates: no se compensan con ahorro promedio de tokens.

## Gates por tipo de operación

| Operación | Precondiciones específicas | Evidencia/telemetría | Ventana y rollback | Decisión actual |
|---|---|---|---|---|
| Convertir agente en skill | G0–G5; destino existe; tools/permisos/memoria equivalentes o explícitamente separados; assets extraídos. | Fixtures specialist vs executor+skill; output, correcciones, acciones indebidas y contexto. | Shadow 30–60 tareas o muestra de riesgo; reactivar ID original por alias. | Solo diseño; ningún retiro autorizado. |
| Fusionar workflows | Matriz de pasos/consumidores; contradicciones resueltas; cada branch poco frecuente pasa a reference. | Fixtures por cada branch y búsqueda de inbound refs. | Mantener ambos sources snapshot durante una release; revert de manifest/routing. | Routing/validation son candidatos, no fusionados. |
| Mover a references | Trigger de recuperación, owner y path estable; no contiene gate que deba ser core/code. | Test de que el escenario correcto recupera la reference y el trivial no. | Source snapshot + índice; volver a inline si hay falsos negativos. | Seguro para templates/casos, tras G1–G4. |
| Archivar | Cero carga automática; activo indexado con hash/licencia/provenance/consumidor/restore. | Búsqueda, link check y restore test desde checkout limpio. | Revisión fechada semestral; restore documentado. | Activos sin consumidor conocido quedan `UNKNOWN`, no archivables de nuevo. |
| Eliminar físicamente | Todos G0–G10; cero inbound refs; reemplazo pasó A/B; datos/voz no se pierden; aceptación humana. | Informe de no-loss, telemetría, diff y secret/privacy review. | Solo tras al menos una ventana `DORMANT_RESTORABLE`; tag/snapshot y one-revert restore. | Prohibido en esta pasada. |
| Promover candidato a agente | Skill baseline existe; diferencia material en tools/contexto/permisos/sandbox/modelo/memoria/independencia/paralelismo/ownership. | A/B con success criteria y costo; al menos 5 casos diversos o muestra mayor según riesgo. | Revisión a 30/60 tareas; fallback a skill sin perder references. | AI/content/visual/venture quedan en eval, no promovidos. |
| Retirar alias | Destino estable; cero usos observados y cero refs estáticas; release notes; no rompe clientes soportados. | Telemetría de resolución de alias durante ventana + búsqueda en repos/configs conocidos. | Mínimo una release y 30 días, el mayor; restaurar mapping sin restaurar duplicados. | Ningún alias puede retirarse hoy. |

Para `visual-qa`, la evidencia mínima son cinco UIs con regresiones sembradas, desktop/mobile, browser console y screenshots; debe mejorar detección sin falsos positivos desproporcionados. Para `ai-architecture-reviewer`, cinco diseños que incluyan RAG sensible, evals, costo y failure modes. Para `venture-growth-strategist`, cinco decisiones por etapas donde se mida si respeta el gate de señal y no activa marketing/growth prematuramente. Content strategist usa al menos diez piezas históricas con evaluación humana de fidelidad de voz.

## Estados permitidos

```text
ACTIVE_AUTO
  -> ACTIVE_ON_DEMAND
  -> SHADOW_REPLACEMENT
  -> ALIASED_REFERENCE
  -> DORMANT_RESTORABLE
  -> DELETE_CANDIDATE
```

- `ACTIVE_ON_DEMAND` ya captura la mayor economía sin perder nada.
- `SHADOW_REPLACEMENT` ejecuta comparación sin cambiar al usuario.
- `ALIASED_REFERENCE` conserva compatibilidad al menos una release fechada.
- `DORMANT_RESTORABLE` exige hash y restore test.
- `DELETE_CANDIDATE` no significa autorizado; requiere G10.

No se permite saltar de `ACTIVE_AUTO` a delete. `UNKNOWN` vuelve a G0/G1, nunca avanza por ausencia de uso observado.

## Scorecard de comparación

| Dimensión | Métrica | Regla conservadora |
|---|---|---|
| Correctitud | criterios binarios por fixture | 100% en criterios críticos; no promediar fallos críticos. |
| Seguridad | acciones/tools indebidos, secretos, permisos | Cero regresiones. |
| Fidelidad | estructura, tono, rúbrica, campos obligatorios | Igual o mejor que baseline salvo cambio aceptado. |
| Continuidad | uso de memoria/contexto correcto | No perder estado ni mezclar datos privados. |
| Intervención | correcciones humanas por tarea | No aumentar materialmente; registrar severidad. |
| Contexto | automatic/retrieved/sent | Medición del provider si existe; proxy claramente rotulado si no. |
| Latencia/costo | tiempo y costo por outcome exitoso | Optimizar solo después de mantener calidad. |
| Routing | falsos positivos/negativos | Cero colisiones conocidas y cobertura de aliases. |

Para dominios de baja frecuencia y alto impacto —release, seguridad, vault— la evidencia adversarial pesa más que el volumen. Una sola publicación no autorizada veta la conversión.

## Gates específicos por grupo

### Automáticos

Research, security y code review deben demostrar independencia real, tools correctas y salida fechada/evidenciada. Se evalúa el routing, no su eliminación. Si un trigger produce falsos positivos, se corrige el trigger; no se borra la capacidad.

### Explicit-only

- Academic: pedagogía separada de persistencia; adapter vigente; no escritura implícita.
- Obsidian: vault localizado, backup, preview, frontmatter y restore test.
- Release: prepare/publish separados; secret scan; branch/remote; recibo final; autorización.

### Conversiones a skill

Antes de retirar la persona deben existir la skill destino y referencias diferenciales. Principal, tests, docs, kickoff y pruner son los cinco `SAFE_AS_SKILL` de menor riesgo, pero igualmente pasan fixtures. Design, technical SEO, marketing, growth, product, AI, MCP y content permanecen `CANDIDATE_FOR_EVAL`: algunos fallan G2 porque su destino no existe y otros fallan G1/G4–G6 hasta extraer activos o probar independencia.

### Candidatos A/B

AI architecture y content strategy no tienen fecha de retiro predeterminada. Se define un mínimo de casos y un stop condition antes del ensayo. Si el especialista gana en omisiones críticas, fidelidad de voz o correcciones humanas, se conserva/promueve aunque cueste más contexto.

## Política de archive y referencias

Cada snapshot debe incluir:

```yaml
id: agente-original
sha256: ...
captured_at: 2026-07-15
source_path: ...
replacement: ...
consumers: [...]
privacy: public|private-adapter
license: ...
restore: ...
retire_after: null
decision: PRESERVE
```

El archive no puede ser un cementerio: necesita índice, owner/consumidor, búsqueda, fecha de revisión y restore test. Claims temporales —por ejemplo algoritmo de X, modelos o repos— llevan fecha/fuente y caducidad; se corrigen o etiquetan como hipótesis, no se borran junto con la voz personal que los rodea.

## Checks antes de un futuro PR de migración

1. `git diff --name-status <base>...HEAD` coincide con scope aprobado.
2. Secret scan y validadores del repo pasan.
3. Manifest, aliases, referencias e IDs no tienen destinos rotos.
4. Los diez adversarial loss fixtures pasan en baseline y target.
5. Se adjunta tabla A/B y traces de contexto, con proxies separados de observaciones.
6. Se prueba restore en un checkout limpio.
7. Security reviewer revisa cambios de permisos y datos.
8. Code reviewer revisa el diff sin editarlo.
9. El director confirma cualquier retiro físico de activo personal o de alto riesgo.
10. El merge sigue siendo humano.

## Rollback mínimo

Un rollback aceptable restaura en una operación: prompt original, references, manifest/registry, aliases, adapters y fixtures. Si la nueva ruta falla en producción, primero se reactiva el alias; el análisis causal ocurre después. Métricas, datos académicos y contenido privado no se sobrescriben durante el rollback.

## Limitaciones de esta política

No hay traces históricos persistidos ni resultados A/B; por eso hoy ningún agente cumple G6. Varias dependencias viven fuera del checkout. Los tokens de `08` son estimaciones por caracteres y los targets son presupuestos. Esta pasada no valida compatibilidad entre todos los proveedores/IDEs, no inspecciona el contenido ausente del vault y no autoriza ningún delete.

## Decisión operativa actual

### Seguro ahora

- Reducir auto-carga de templates/casos de `frontend-design`, infraestructura del tutor y Venture Loop, manteniéndolos como references recuperables.
- Consolidar la definición duplicada de routing (`AGENTS`/`index`/`skills_routing`) y cierre (`AGENTS`/`testing`/`validation`) solo después de fixtures.
- Crear snapshots+hashes de los 19 prompts, inventario de consumidores y los diez fixtures loss.
- Corregir el match `pr` y otros triggers por intención semántica sin retirar roles.
- Mover checks deterministas de secretos, links, schema, branch y release a scripts/CI, conservando policy mínima.

### Mantener activos

- `agente-researcher` → futuro `researcher` condicional, sin retirarlo hasta tener web/browser/citations.
- `agente-security-auditor` → futuro `security-reviewer` condicional y read-only.
- `agente-code-reviewer` → futuro `code-reviewer` condicional y read-only.
- Mantener los prompts actuales de principal, design, tests, docs, SEO, marketing, growth, product, MCP, kickoff y pruner hasta que cada fila supere G2–G6.

### Mantener explicit-only

- `agente-academic-tutor`, con vault/persistencia separados y opt-in.
- `agente-obsidian-brain`, con preview, permisos y restore del vault.
- `agente-release-manager`/futuro `release-operator`, separando prepare de publish.
- `agente-ai-architect` y `agente-x-content-strategist` solo como modalidad temporal de evaluación; no cuentan como promociones aprobadas.

### Preservar fuera del runtime

- Snapshots versionados de los 19 prompts originales, además de cualquier versión activa durante compatibilidad.
- `archive/workflows/{venture_loop,product_foundry,marketing,seo_geo_growth,ai_production,x_content_system}.md` como references por etapa.
- `archive/skills/mcp-integration/` como references versionadas por provider y tema.
- Suite académica: active recall, exam simulator, coding/case exercises y tracker.
- Siete references visuales de frontend, checklist maker/checker y assets/scripts de systematic debugging.
- NotebookLM, rutas/semestre, voz/positioning y datos del vault en adapters privados restaurables.

### Indecidido o requiere eval

- Retiro físico de cualquiera de los 19 prompts: todos fallan hoy G6 y G10.
- Promoción permanente de `ai-architecture-reviewer`, `content-strategist`, `visual-qa` y `venture-growth-strategist`.
- Reemplazos aún inexistentes/incompletos: `technical-seo`, `marketing-strategy`, `content-strategy`, release operator/skill, adapters académico/vault y toolset del researcher.
- Dependencias externas `linkedin.md`, `content-pipeline.md`, `x-content-feedback.md`, `x-playbook-ejecutable.md`, `github-readmes/*`, registro de errores, Study Tracker, `obsidian-markdown` y gitlink `obsidian-skills`.
