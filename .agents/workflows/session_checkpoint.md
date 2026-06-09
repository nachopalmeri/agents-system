---
description: Checkpoint compacto para preservar contexto en sesiones largas o cambios de fase
---

# Workflow: Session Checkpoint

## Cuándo usarlo

- Sesión larga o rambling.
- Muchas decisiones acumuladas.
- Cambio de objetivo.
- Antes/después de una fase importante.
- Cuando se acerca un límite de contexto.
- Al pausar trabajo para retomarlo después.

## Formato

```text
Estado actual:
Decisiones tomadas:
Archivos tocados:
Contexto importante:
Pendientes:
Riesgos:
Próximo paso recomendado:
Qué NO tocar:
Tokens estimados consumidos:
Budget declarado (si aplica):
```

## Reglas

- Ser breve y accionable.
- Guardar decisiones, no ruido.
- Separar hechos confirmados de supuestos.
- Si hay política reusable, proponer moverla a reglas.

## Handoff entre sesiones (Santi @santtiagom_)

Cuando el contexto se degrada (más tokens = peores resultados):

1. Pedir al agente: "generá un resumen de lo implementado y lo que falta".
2. Copiar/pegar ese resumen a la nueva sesión.
3. La nueva sesión arranca con constancia de lo anterior sin arrastrar contexto degradado.

El resumen de handoff usa el formato de checkpoint de arriba. No es pérdida de tiempo, es optimización de calidad.

## Regla final
Un checkpoint debe permitir continuar la sesión sin releer toda la conversación.
Contexto degradado = cambiar de sesión con resumen, no forzar la sesión actual.

## Dreaming (próximo nivel)

Este checkpoint es un **dreaming manual**: el humano genera el resumen y lo pasa a la próxima sesión.

Claude Managed Agents tiene **dreaming automático**: un proceso programado que revisa sesiones pasadas, extrae patrones, cura memoria entre sesiones sin intervención humana. Puede actualizar memoria automáticamente o requerir aprobación.

Cuando se use Managed Agents, dreaming automático complementa este workflow:
- Checkpoints manuales siguen siendo útiles para handoffs inmediatos.
- Dreaming automático cura memoria a largo plazo (patrones, preferencias, lecciones aprendidas).
- Ambos coexisten: manual para continuidad, automático para mejora continua.

Ver `docs/research-2026-06.md` para detalles de la API de dreaming.
