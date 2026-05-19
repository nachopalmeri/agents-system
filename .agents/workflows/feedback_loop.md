---
description: Loop de feedback para corregir routing, outputs inutiles y reglas vagas sin inflar el sistema
---

# Workflow: Feedback Loop

## Principio

El sistema mejora cuando un error observable se convierte en una regla, test, checklist o poda concreta. No guardar opiniones sueltas como politica durable.

## Cuando usar

- El usuario dice que el workflow elegido no era el adecuado.
- La respuesta fue inutil, demasiado larga, demasiado corta o acciono con el nivel de rigor equivocado.
- Una regla genero friccion, contradiccion o falsa confianza.
- Un workflow promete algo que no puede validar.
- El mismo error aparece dos veces.

## Entrada minima

```text
Incidente:
Pedido original:
Workflow/skill/agente usado:
Que salio mal:
Evidencia:
Correccion esperada:
```

Si falta evidencia, pedir un ejemplo concreto o marcarlo como supuesto. No inventar lecciones.

## Proceso

1. Clasificar el error:
   - Routing incorrecto.
   - Validacion insuficiente.
   - Output poco util.
   - Regla ambigua.
   - Workflow inexistente o no cargado.
   - Sobrecarga de proceso.

2. Encontrar causa raiz:
   - Falta un criterio en `workflows/index.md`.
   - Falta un gate en `workflows/validation.md`.
   - Falta una regla en `rules/`.
   - Falta documentar una limitacion.
   - Sobra una regla o workflow duplicado.

3. Aplicar el menor cambio durable:
   - Editar una regla existente antes de crear una nueva.
   - Agregar un criterio de routing si evita repetir el error.
   - Agregar un criterio de validacion si evita falsa victoria.
   - Agregar una nota a `tasks/lessons.md` solo si existe y aporta continuidad.
   - Archivar o fusionar material si era ruido.

4. Validar:
   - Releer el pedido que fallo y simular el nuevo routing.
   - Confirmar que el cambio no contradice `rules/chat-first.md`.
   - Correr `bin/test-system.ps1` o el check equivalente del repo.

## Registro recomendado

Usar este formato en `tasks/lessons.md` si el proyecto lo tiene:

```text
YYYY-MM-DD - Siempre/Nunca [regla concreta].
Contexto: [1 linea]
Evidencia: [archivo, conversacion, test o ejemplo]
Cambio aplicado: [archivo/regla/workflow]
```

## Hard stops

- No convertir una preferencia aislada en regla global.
- No crear workflows nuevos si basta con ajustar `index.md`, `validation.md` o una regla existente.
- No usar el feedback loop para defender al sistema; usarlo para corregirlo.
- No cerrar el loop sin evidencia de que el nuevo criterio habria cambiado el resultado anterior.

## Salida esperada

```text
Feedback aplicado:
- Error: ...
- Causa raiz: ...
- Cambio durable: ...
- Validacion: ...
- Riesgo pendiente: ...
```
