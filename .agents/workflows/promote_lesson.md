---
description: Promocion de lecciones locales a memoria global con confirmacion humana
---

# Workflow: Promote Lesson

## Principio

Una leccion global solo existe si aparecio en 2+ proyectos o el usuario confirma que es una regla durable del sistema. La promocion nunca es automatica.

## Trigger

- Cierre de proyecto importante.
- El usuario pide "promove esta leccion", "esto ya me paso antes" o equivalente.
- `feedback_loop.md` marco una leccion como candidata global.

## Fuentes

- `tasks/lessons.md` del proyecto actual.
- `.agents/memory/lessons-global.md`.
- Retros del vault generadas por `obsidian_sync.md`.
- Evidencia explicita del usuario si el proyecto anterior no esta disponible.

## Proceso

1. Revisar `tasks/lessons.md` del proyecto actual.
2. Para cada leccion, buscar si aparecio en otro proyecto anterior.
3. Si aparece en 2+ proyectos, marcar como candidata.
4. Mostrar al usuario:
   - Leccion local.
   - Proyectos donde aparecio.
   - Tipo: ROUTING, OUTPUT, SCOPE o QUALITY.
   - Regla global propuesta.
   - Cambio sugerido en `AGENTS.md` o workflow si aplica.
5. Esperar confirmacion explicita del usuario.
6. Si confirma:
   - Agregar a `.agents/memory/lessons-global.md`.
   - Si tambien debe cambiar `AGENTS.md` o un workflow, mostrar diff propuesto y esperar una segunda confirmacion explicita.
7. Validar con `validation.md`.
8. Commit y push si hubo cambios del sistema.

## Formato de propuesta

```text
Candidato a leccion global:
- Tipo:
- Regla propuesta:
- Evidencia:
- Proyectos:
- Archivos afectados:
- Recomiendo modificar AGENTS/workflow: si/no
- Motivo:
Confirmas promocion? (si/no/ajustar)
```

## Formato en `lessons-global.md`

```markdown
### YYYY-MM-DD - Titulo accionable
Proyectos: Proyecto A, Proyecto B
Que paso: ...
Causa raiz: ...
Regla: Siempre/Nunca ...
Evidencia: ...
Estado: activa
Revision: YYYY-MM
```

## Hard stops

- Nunca modificar `AGENTS.md` o workflows globales automaticamente.
- Nunca promover sin evidencia de 2+ proyectos o confirmacion explicita del usuario.
- Nunca borrar lecciones globales sin confirmacion; proponer poda en `vault_review.md`.
- No duplicar reglas: si ya existe una, actualizar evidencia o estado.

## Salida esperada

```text
Promocion de lecciones:
- Revisadas:
- Candidatas:
- Promovidas:
- Requieren confirmacion:
- Cambios propuestos:
- Validacion:
```

