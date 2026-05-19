---
description: Guia de uso de la memoria global del sistema de agentes
---

# Memoria Global del Sistema

## Que es

Memoria durable para patrones que deben afectar como trabaja el agente en cualquier proyecto de Nacho Palmeri.

## Que no es

- No es diario.
- No es inbox.
- No es backlog infinito.
- No es lugar para guardar preferencias aisladas.
- No reemplaza `tasks/lessons.md` de cada proyecto.

## Local vs global

| Archivo | Scope | Cuando se usa |
|---|---|---|
| `tasks/lessons.md` | Proyecto actual | Error, decision o aprendizaje local |
| `.agents/memory/lessons-global.md` | Sistema completo | Lecciones repetidas en 2+ proyectos o confirmadas como durables |
| `.agents/memory/developer_growth.md` | Crecimiento profesional | Evidencia concreta de evolucion tecnica y criterio |

## Criterio de promocion

Una leccion local pasa a global solo si:

- Aparecio en 2+ proyectos distintos, o
- El usuario confirma explicitamente que debe ser regla durable.

Siempre requiere:

- Tipo: ROUTING, OUTPUT, SCOPE o QUALITY.
- Evidencia concreta.
- Regla derivada con "Siempre" o "Nunca".
- Revision de contradicciones con `AGENTS.md` y workflows.

## Revision mensual

Usar `workflows/vault_review.md` para:

- Podar lecciones obsoletas.
- Fusionar duplicados.
- Mantener evidencia.
- Actualizar `developer_growth.md` con hechos reales del mes.

## Como afecta proyectos nuevos

Al iniciar o revisar un proyecto, el agente puede consultar `lessons-global.md` para ajustar routing, scope, calidad y validacion. Si una leccion global contradice un workflow, debe proponer correccion con confirmacion humana.

