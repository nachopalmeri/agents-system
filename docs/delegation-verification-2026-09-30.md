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
