# Evidencia de delegación — 30/09/2026

Entorno: Windows, PowerShell 7, OpenCode 1.18.33. Modelo: `opencode/muse-spark-1.3-contributor-free`.

| Prueba real | Resultado | Evidencia |
|---|---|---|
| Investigación del repo | SUCCESS | Tres inconsistencias de README corroboradas contra el árbol local; cero archivos modificados; costo reportado 0 |
| Coordinador y dos workers | SUCCESS | `workerCalls: 2`; resultados 42 y 81 agregados por OpenCode; costo reportado 0 |
| Escritura de archivo declarado | SUCCESS | `actualChangedFiles: [fixture.txt]`; contenido `DELEGATED_EDIT_OK` verificado fuera del worker; costo reportado 0 |

No se midió un ahorro comparativo de tokens. Se registraron tokens y costo del proveedor; preparación y revisión en el primary siguen consumiendo tokens del harness principal. Los workers reciben contexto independiente.

Checks locales: routing 44/44 puntos ponderados; graph con 19 agentes y 115 skills alcanzables; adapters con hash canónico; contratos, policy, provider states, loops, eventos y hooks; integración sync/restore 50 assertions; release check y diff sin errores críticos. El scanner informa ejemplos históricos para revisión, no credenciales nuevas.

Correcciones necesarias para la ejecución real:

- Se restauraron tablas de routing que habían desaparecido del JSON.
- El graph acepta el formato generado agents/skills y declara la migración next → next-best-practices.
- El shell se mantiene en aprobación requerida; OpenCode rechaza automáticamente comandos no aprobados en el modo no interactivo. Su deshabilitación total causaba rechazo 403 del free tier.
- El resultado se toma del último evento de texto, separando progreso de respuesta final.
- Write/Edit usan permisos exactos calculados también respecto de la raíz del worktree.

La instalación local del bridge y la política tiene un backup previo en `.agents-system-sync/backups/`. La rama de implementación se mantiene separada de main.

## Follow-up — 04/10/2026

The global entrypoint points to this checkout through `~/.agents/local-runtime.json`. A live two-worker request completed both tasks, but the coordinator emitted `state: "done"` and a scalar `uncertainty`. The bridge accepted only `SUCCESS`/`BLOCKED` and array-valued fields, so it silently kept its initial `BLOCKED` receipt. The provider and worker calls had succeeded.

The bridge now normalizes `done`/`completed` to `SUCCESS`, `failed` to `BLOCKED`, singleton result fields to arrays, and worker-reported paths only when each resolves to an exact file declared by the parent. Invalid final output now includes a reason and `fallbackExecutor: primary`; it also records any authorized file changed before the worker stopped, so the primary can inspect it.

Verification:

- `bin/test-delegation.ps1` — pass, including the original schema mismatch, absolute in-scope file paths, and unstructured output after a partial edit.
- `bin/test-delegation-v2.ps1` — pass; V2 stays fail-closed pending a verified scoped adapter.
- `bin/test-global-entrypoint.ps1` — pass.
- `bin/test-system.ps1` — zero errors, one pre-existing warning (`matt-skills.md` frontmatter description).
- Live call through `~/.agents/bin/invoke-delegation.ps1`: Muse Spark free model, two worker calls, both findings returned, cost reported `$0`.
- Live exact-file edit: the worker changed only the declared file, then stopped with progress text instead of a structured final report. The bridge correctly returned `BLOCKED`, listed `sample.txt`, and handed it back to the primary for verification. It did not misreport this as a complete task.

This fixes the multi-agent false-blocking issue and makes incomplete worker output actionable. Exact-file edit success still depends on the worker returning a verifiable completion report; otherwise parent review remains required by design.
