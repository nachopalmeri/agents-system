---
description: Reglas de prompting basadas en la guía oficial de Anthropic para Claude
---

# Reglas de Prompting

## Principio
Buen prompting es hacer explícito lo que muchas veces asumimos que el modelo ya entiende.

## 8 Reglas

### 1. Objetivo claro
- No es lo mismo "haceme un dashboard" que "dashboard con métricas principales, filtros por fecha, gráficos y estados de carga".
- Cuanto más claro el objetivo, menos espacio para que el modelo suponga cosas.
- Si el pedido es vago, el agente debe pedir aclaración antes de implementar.

### 2. Contexto explícito
- No alcanza con decir qué hacer. Hay que contar para qué se va a usar o por qué una regla importa.
- No es lo mismo "escribí un email de seguimiento" que "escribí un email de seguimiento para alguien que pidió una demo y no respondió. Tiene que sonar amable, breve y dejar claro el próximo paso sin presionar".
- Ese contexto cambia mucho la respuesta.

### 3. Ejemplos relevantes
- Los ejemplos son la forma más efectiva de guiar tono, formato y estructura.
- Si se quiere respuestas consistentes, mostrar cómo se ve una buena respuesta.
- Usar ejemplos relevantes, variados y parecidos al caso real.
- En el sistema: los templates de `obsidian_sync.md` y los modos de `activate-global.md` son ejemplos.

### 4. Effort según la tarea
- No todas las tareas necesitan el mismo nivel de razonamiento.
- Para coding y tareas agentic: empezar con `xhigh`.
- Para otros casos complejos: usar al menos `high`.
- Para tareas simples (cambio chico, copy puntual): `medium` es suficiente.

### 5. Validar el resultado
- Para tareas importantes, no quedarse solo con la primera respuesta.
- Pedirle que revise el output contra criterios concretos antes de terminar.
- Ejemplo: "antes de finalizar, verificá que la solución cumple estos requisitos y no rompe los tests existentes".
- Conectar con `validation.md` como cierre central.

### 6. Ser explícito con las tools
- Si el modelo tiene tools, decir cuándo usarlas y cuándo no.
- Si se quiere que modifique código: pedirle que haga el cambio.
- Si solo se quiere recomendaciones: aclarar que no toque archivos.
- En el sistema: `mcp_catalog.md` define niveles de permisos por tool.

### 7. Scope acotado = mejor calidad
- No intentar resolver todo en un único prompt. Empezar por un área.
- Cuando el scope es más acotado, el agente encuentra mejores soluciones y profundiza más.
- Si el contexto se carga demasiado, splitear en sesiones nuevas con resumen de handoff.
- Más contexto cargado = peores resultados. Cambiar de sesión no es pérdida, es optimización.
- Ejemplo: auditar cache primero, después indexes, después payloads. No todo junto.

### 8. Write loops, not prompts
- El trabajo del developer pasa de "escribir prompts" a "escribir loops que promptean al AI".
- "I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops." — Boris Cherny, head of Claude Code at Anthropic.
- En el sistema: el Ralph Loop (`parallel_agents.md`) es la implementación de este principio.
- No sobre-abstractizar: loops son el nivel correcto. Más capas (ultrathoughts, aura, soul) = más fricción, menos control.

## Aplicación en el sistema

- El agente aplica estas reglas internamente al enrutar y ejecutar tareas.
- Si el usuario da un pedido vago, el agente pide aclaración (regla 1).
- Si falta contexto, el agente pregunta brevemente (regla 2).
- Los templates y ejemplos en workflows sirven como few-shot (regla 3).
- El effort se ajusta según tamaño/riesgo de la tarea (regla 4).
- `validation.md` es el mecanismo de auto-validación (regla 5).
- Los niveles de MCP y las reglas de permisos son la explicitación de tools (regla 6).
- Tareas complejas se dividen en áreas, una por sesión. Handoff con `session_checkpoint.md` (regla 7).
- El trabajo es escribir loops, no prompts. Ralph Loop es la implementación concreta (regla 8).
