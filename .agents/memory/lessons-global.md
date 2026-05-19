# Lecciones Globales del Sistema

## Como usar este archivo

- Solo entran lecciones que aparecieron en 2+ proyectos distintos o fueron confirmadas explicitamente por Nacho como regla durable.
- Cada leccion necesita evidencia: proyecto, que paso y causa raiz.
- Revision mensual: podar, fusionar o archivar lecciones que ya no aplican.
- Si una leccion debe cambiar `AGENTS.md` o un workflow, usar `promote_lesson.md` y pedir confirmacion explicita.

## ROUTING errors

### 2026-05-19 - No usar multiagent review para fixes chicos
Proyectos: JobBot, Pisculichi Labs
Que paso: el agente activo un flujo pesado para una mejora menor de output/CSS.
Causa raiz: el pedido tenia palabras como "mejorar" o "criticar" y eso disparo un workflow sobredimensionado.
Regla: Nunca usar multiagent review si el costo de equivocarse es bajo y no hay decision arquitectonica real. Para mejoras de output o calidad, usar flujo simple con iteracion y validacion.
Evidencia: patron reportado por Nacho al endurecer el sistema de agentes.
Estado: activa
Revision: 2026-06

## OUTPUT errors

### 2026-05-19 - Validar con evidencia, no con confianza del agente
Proyectos: agents-system, Pisculichi Labs
Que paso: reglas como "validar" quedaban vagas y permitian cierres decorativos.
Causa raiz: faltaba exigir comando, diff, test, fuente, captura o limitacion explicita.
Regla: Siempre reportar que se verifico, con que evidencia y que riesgo queda pendiente antes de declarar listo.
Evidencia: `validation.md` fue endurecido para definir niveles de evidencia.
Estado: activa
Revision: 2026-06

## SCOPE errors

### 2026-05-19 - No modificar reglas globales sin confirmacion humana
Proyectos: agents-system, Pisculichi Labs
Que paso: una leccion local podia convertirse en cambio global demasiado rapido.
Causa raiz: faltaba separar registro local, promocion global y edicion de workflows.
Regla: Nunca modificar `AGENTS.md`, workflows globales o `developer_growth.md` sin confirmacion explicita cuando el cambio nace de feedback, promocion o crecimiento profesional.
Evidencia: `promote_lesson.md` y `growth_update.md` separan propuesta, confirmacion y aplicacion.
Estado: activa
Revision: 2026-06

## QUALITY errors

### 2026-05-19 - TDAH-friendly no significa incompleto
Proyectos: agents-system, Pisculichi Labs
Que paso: la regla de respuestas cortas podia producir specs o decisiones tecnicas que parecian completas pero no incluian criterios, riesgos o evidencia.
Causa raiz: la restriccion de brevedad estaba globalizada sin distinguir complejidad.
Regla: Siempre mantener secciones cortas, pero incluir criterios, riesgos y evidencia cuando el tema sea tecnico, estrategico o dificil de revertir.
Evidencia: `chat-first.md` y `activation-cheatsheet.md` fueron ajustados.
Estado: activa
Revision: 2026-06

## Patrones positivos

### 2026-05-19 - Chat-first con routing explicable
Proyectos: agents-system
Que funciono: mantener la interfaz en lenguaje natural reduce friccion, pero explicar el routing en una linea cuando hay ambiguedad evita falsa confianza.
Regla: Siempre ocultar rituales al usuario, pero hacer visible la decision de routing cuando cambie el resultado.
Evidencia: `index.md` define contrato de routing y fallback cuando falta contexto.
Estado: activa
Revision: 2026-06

