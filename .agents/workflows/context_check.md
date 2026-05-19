---
description: Deteccion temprana de degradacion de contexto y compresion de checkpoint
---

# Workflow: Context Check

## Principio

No esperar a que la sesion se corrompa. Si el agente muestra senales de perdida de contexto, se pausa, se comprime el estado y se sigue solo con confirmacion del usuario.

## Senales de degradacion

- Repite informacion o sugerencias que ya dio en la misma sesion.
- Contradice una decision previa de la misma sesion.
- Pierde el objetivo original y empieza a resolver otra cosa.
- Las respuestas se vuelven genericas en vez de especificas al proyecto.

## Trigger

Cuando aparecen 2 o mas senales en la misma sesion.

## Flujo

1. Pausar la ejecucion.
2. Generar checkpoint comprimido:
   - Objetivo original de la sesion.
   - Decisiones tomadas hasta ahora.
   - Estado actual.
   - Proximo paso.
3. Mostrar al usuario:

```text
Detecto posible degradacion de contexto.
Checkpoint generado.
Continuo con este resumen como base? (si/no/ajustar)
```

4. Esperar confirmacion.
5. Continuar con el checkpoint como contexto activo.

## Formato del checkpoint

```text
Objetivo original:
Decisiones tomadas:
Estado actual:
Proximo paso:
```

## Integraciones

- Si la sesion es larga, combinar con `session_checkpoint.md`.
- Si la degradacion nace de errores repetidos, combinar con `feedback_loop.md`.
- Si el trabajo queda pausado, actualizar `tasks/handoff.md` si existe.

## Hard stops

- No seguir ejecutando si el checkpoint contradice decisiones previas sin aclararlo.
- No usar este workflow para resumir por reflejo; solo ante senales reales.
- No reemplazar `session_checkpoint.md`; este workflow es preventivo.
