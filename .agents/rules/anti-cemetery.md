---
description: Regla para evitar acumulacion de workflows, agentes, docs y automatizaciones que ya no aportan valor operativo.
---

# Anti-Cemetery / Anti-Sludge

El sistema debe mantenerse chico, usable y verificable. Cada workflow, skill, agente o documento tiene que justificar su existencia por uso real, reduccion de riesgo o mejora clara de velocidad/calidad.

## Siempre

- Preferir el menor workflow suficiente.
- Podar instrucciones duplicadas cuando una regla, skill o herramienta ya cubre el caso.
- Archivar o eliminar piezas sin uso claro despues de una revision de evidencia.
- Mantener nombres, activadores y salidas concretas.
- Convertir errores repetidos en reglas, checks o simplificaciones concretas.

## Nunca

- Agregar capas de proceso para parecer mas sofisticado.
- Mantener agentes o workflows que nadie puede invocar con claridad.
- Duplicar instrucciones entre `AGENTS.md`, workflows y skills sin una razon concreta.
- Crear automatizaciones que no tengan criterio de salida verificable.

## Criterio De Poda

Una pieza es candidata a poda si cumple una o mas:

- No tiene trigger natural.
- No produce un output distinguible.
- Repite otro workflow o skill.
- Aumenta tokens sin mejorar decision, ejecucion o validacion.
- No se puede testear ni auditar.

