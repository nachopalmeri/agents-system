---
description: Actualizacion del tracker de crecimiento profesional con evidencia concreta
---

# Workflow: Growth Update

## Principio

El growth tracker no es un diario ni autoestima asistida. Solo registra evidencia concreta de evolucion profesional.

## Triggers

- Cierre de proyecto.
- El agente detecta que Nacho resolvio algo que antes lo trababa.
- El usuario pide "actualiza mi growth tracker" o equivalente.
- Una retro de Obsidian deja evidencia de skill, decision o patron superado.

## Proceso

1. Revisar retro, session checkpoint o `.agents/tasks/lessons.md`.
2. Identificar evidencia concreta:
   - Skill tecnica aplicada.
   - Error que dejo de repetirse.
   - Decision que tomo mejor que antes.
   - Proyecto completado con aprendizaje verificable.
3. Proponer una actualizacion especifica a `.agents/memory/developer_growth.md`.
4. Esperar confirmacion o ajuste del usuario.
5. Aplicar el cambio confirmado.
6. Sincronizar copia en Obsidian si el vault esta disponible.
7. Commit y push si hubo cambios del sistema.

## Regla de evidencia

Nunca:

```text
Mejore en Python.
```

Siempre:

```text
En JobBot implemente el scheduler con threading porque python-telegram-bot 20+ no soportaba asyncio en Python 3.14; lo resolvi despues de 2 intentos fallidos y deje la decision documentada.
```

## Formato de propuesta

```text
Growth update propuesto:
- Seccion:
- Entrada:
- Evidencia:
- Proyecto:
- Fecha:
- Confirmas aplicar? (si/no/ajustar)
```

## Hard stops

- No actualizar `developer_growth.md` sin confirmacion explicita.
- No inventar metricas.
- No mover skills a "dominadas" sin evidencia de uso autonomo.
- No registrar aprendizajes que no puedan trazarse a proyecto, error, decision o investigacion.

