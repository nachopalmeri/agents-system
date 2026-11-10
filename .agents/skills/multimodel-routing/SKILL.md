---
name: multimodel-routing
description: Usala cuando haya que elegir o mezclar modelos (DeepSeek flash o v4-pro y Claude Haiku, Sonnet u Opus), orquestar el pipeline fixer-reviewer-breaker, delegar desde Claude Code a OpenCode, o decidir si vale la pena escalar de un modelo barato a uno más caro.
---

# Cascada multimodelo

Elegí el modelo más barato que resuelva bien la subtarea. No es una escalera que recorre todos los modelos: se escala solo cuando hace falta. Sin secretos en el encargo, en esta skill ni en los logs.

Esta cascada es la ruta operativa con DeepSeek API y Claude Pro (vía OpenCode y Claude Code). No pisa el ruteo de tiers free de `config/model-routing.json`: si el encargo corre con candidatos gratuitos de OpenCode, aplicá ese JSON.

## Cascada de costo

1. **DeepSeek flash** (`deepseek/deepseek-flash`) — exploración, búsqueda en el repo, fixes simples, ediciones mecánicas, tests chicos.
2. **DeepSeek v4-pro** (`deepseek/deepseek-v4-pro`) — review, breaker/red team, razonamiento, bugs difíciles, diseño de un cambio no trivial.
3. **Claude Haiku** — cuando DeepSeek no alcanza o el harness es Claude y la tarea sigue siendo acotada.
4. **Claude Sonnet** — implementación o síntesis que Haiku no cierra con calidad.
5. **Claude Opus** — orquesta y planifica. También arquitectura de alto impacto, juicio de seguridad y la decisión final del orquestador.

## Criterios para escalar

Hace falta al menos uno:

- El modelo actual se equivoca, se traba o entrega algo incompleto o inseguro.
- La tarea cruzó a review, red team, arquitectura o un cambio irreversible.
- Hay ambigüedad de spec o riesgo (credenciales, producción, pagos, publicación).

No escales por costumbre ni para “darle una pasada más” al mismo prompt. Cambiá contexto o plan antes de repetir. Si se agota el cupo o el proveedor rechaza la sesión, devolvé el motivo al orquestador; no ensanches permisos para ocultar un fallo.

## Límites por tarea

- Haiku: máximo 2 llamadas
- Sonnet: máximo 2 llamadas
- Opus: máximo 1 llamada (orquesta; no la gastes en el grind)

Flash y v4-pro van primero y no tienen ese tope, pero no entres en un loop. Workers: un intento claro por encargo; el fallo vuelve al orquestador.

## Pipeline

Para un cambio de código no trivial:

1. **fixer** (flash, o Haiku si no hay DeepSeek) implementa
2. **reviewer** (v4-pro) busca vulnerabilidades, código no mantenible y bugs claros
3. **breaker** (v4-pro, red team) intenta romper el cambio, solo en entorno de prueba
4. **fix** de lo que encontraron
5. **re-review**
6. **merge solo con OK humano**

El worker no autoaprueba su entrega. El orquestador (Opus) mantiene el plan, revisa el diff y no mergea ni pushea sin confirmación explícita.

## Delegación desde Claude Code

Para el grind en DeepSeek, Claude Code delega a OpenCode:

```bash
opencode run --agent <agente> <encargo>
```

El encargo lleva objetivo, archivos exactos y restricciones; sin secretos ni el historial completo. El primary revisa el diff. Usá un agente que esté configurado; no inventes nombres.
