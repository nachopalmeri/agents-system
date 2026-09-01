---
description: Nota de archivo sobre la auditoria de julio 2026 (docs/audit/00-10, orchestrator/, schemas/, evals/, examples/, agents.registry.json). No ejecutiva, no borra nada.
---

# Nota de archivo — auditoria de julio 2026

captured_at: 2026-09-01
decision: PRESERVE_AS_HISTORICAL_REFERENCE
consumers: ninguno conocido en el runtime vivo (`C:\Users\ignac\.agents\`)
restore: el contenido sigue en el repo tal cual; no se movio ni se borro nada

## Que es esto

En julio de 2026 se corrio una auditoria completa (`00-audit-plan.md` a `10-safe-pruning-gates.md`) sobre este mismo sistema, con la misma pregunta que motivo la pasada de 2026-09-01: si el sistema esta sobre-diseñado y conviene simplificarlo. Definio un framework propio de 10 compuertas (G0-G10), estados de migracion por capacidad, fixtures adversariales de no-perdida, y una politica de archivado. Tambien crecio infraestructura no ejecutada: `orchestrator/router.ps1`, `schemas/*.schema.json`, `evals/runtime-cases.json`, `examples/tasks/*.json`, `agents.registry.json`.

## Por que queda archivado y no se adopta

La conclusion textual de `09-final-conservative-target.md` es que **ningun agente pasa sus propios gates** (G6 - A/B real, G10 - aceptacion humana) porque la evidencia que el framework exige nunca se genero. El resultado neto de esa pasada fue documentacion (mas de 3000 lineas repartidas en 11 archivos) sin ninguna poda ejecutada.

Esto es exactamente lo que `rules/anti-cemetery.md` prohibe explicitamente: *"Nunca: agregar capas de proceso para parecer mas sofisticado."* Construir un aparato de gobernanza de 10 compuertas para decidir si podar 19 prompts personales es proceso desproporcionado al problema, incluso si cada gate individual es razonable en un contexto de equipo/producto real.

La pasada de 2026-09-01 aplico en cambio poda directa con evidencia minima (leer el archivo, confirmar que el cambio no rompe nada con `check-agents-system.ps1`, commitear) sobre `C:\Users\ignac\.agents\` — sin este framework.

## Que hacer si esto se retoma

- No reactivar el framework de gates completo por defecto; es sobre-ingenieria para el tamaño de este sistema.
- Si en el futuro hace falta A/B real (por ejemplo antes de retirar un agente de alto riesgo como `agente-release-manager` u `agente-obsidian-brain`), rescatar puntualmente las fixtures de `09-final-conservative-target.md` (seccion "Pruebas adversariales de no perdida") en vez de todo el aparato.
- `config/capabilities.json` de esta auditoria (schemaVersion 2, con `status`/`migrationTarget`) quedo desactualizado respecto al set actual de skills (no lista ~40 skills agregadas despues de julio). No usarlo como fuente de verdad sin regenerarlo.
