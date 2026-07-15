# Lecciones de Sesión

Estados permitidos: `candidate`, `active`, `promoted`, `rejected`. Una corrección nueva nace como `candidate`; requiere evidencia/fixture para pasar a `active` y confirmación humana para `promoted`.

## 2026-06-23 20:30 - [ROUTING] Paths relativos en workflows rompen el loop de aprendizaje

- Estado: active
- Evidencia: incidente reproducido y paths corregidos

- Tipo: ROUTING
- Señal: validación de la Fase A — la simulación reveló que start.md busca `tasks/` en CWD, no en `.agents/tasks/`
- Contexto: auditoría del sistema de aprendizaje durante sesión de reparación del agents-system
- Corrección/error: todos los workflows referenciaban `tasks/lessons.md` como path relativo. start.md nunca encontraba las lecciones porque el CWD es `C:\Users\ignac` y el archivo está en `.agents/tasks/`
- Causa raíz: al diseñar los workflows, se asumió que `tasks/` resolvería desde la raíz del sistema, pero no se explicitó el path base. Los flujos de archivo necesitan paths absolutos o relativos a `.agents/`
- Lección: Siempre usar `.agents/tasks/` como prefijo explícito en todos los workflows del sistema de agentes. No confiar en CWD para resolver paths internos.
- Aplicación inmediata: ya aplicado — todos los workflows del sistema cambiaron de `tasks/` a `.agents/tasks/`
- Candidato global: si (puede repetirse en cualquier proyecto que use workflows)

## 2026-06-23 20:45 - [OUTPUT] La validación del loop requiere simulación concreta, no teoría

- Estado: candidate
- Evidencia: una aparición; falta fixture durable

- Tipo: OUTPUT
- Señal: el diseño inicial de las 3 fases no identificó los paths rotos hasta que se simuló paso a paso
- Contexto: diseño de la validación del sistema de aprendizaje
- Corrección/error: se escribió un plan detallado pero no se detectó que `tasks/` era ambiguo hasta la simulación concreta
- Causa raíz: el análisis teórico pierde detalles de implementación que solo aparecen al ejecutar
- Lección: Siempre simular end-to-end con operaciones reales (lectura/escritura) antes de declarar un flujo validado. No alcanza con revisar el diseño.
- Aplicación inmediata: esta simulación se ejecutó y detectó el problema antes del push
- Candidato global: no (primera aparición)

## 2026-06-23 21:00 - [SCOPE] No modificar paths en archivos ajenos al sistema (per-project)

- Estado: candidate
- Evidencia: una aparición durante refactor de paths

- Tipo: SCOPE
- Señal: durante la reparación de paths, agent_coordination.md y client_workflow.md referencian `tasks/` correctamente como archivos per-project
- Contexto: reparación masiva de paths en 20+ archivos
- Corrección/error: hubo que separar manualmente qué archivos debían cambiarse y cuáles no
- Causa raíz: no hay distinción explícita en el sistema entre "system paths" y "project paths"
- Lección: Siempre verificar si el path refiere a un archivo del sistema (`.agents/`) o del proyecto (`tasks/`). No aplicar replaceAll sin revisar cada contexto.
- Aplicación inmediata: en esta sesión se dejaron sin tocar agent_coordination.md, client_workflow.md, task_ledger.md y work_policy.md
- Candidato global: si (fricción que reaparecerá en cada refactor del sistema)
