---
description: Routine mensual read-only/draft para mantener limpio el vault y la memoria global
---

# Workflow: Vault Review

## Principio

El vault debe mejorar decisiones futuras. Si solo acumula notas sin accion, se vuelve cementerio.

## Frecuencia

Mensual o cuando el usuario pida "revisemos el vault".

## Modo

Read-only + draft. Nunca borrar, mover o archivar sin confirmacion explicita.

## Pasos

1. Revisar notas sin tags y proponer tags.
2. Revisar notas sin proxima accion y proponer archivar, conectar o mantener.
3. Revisar `.agents/memory/lessons-global.md`:
   - Mantener lecciones activas con evidencia reciente.
   - Proponer poda de reglas obsoletas.
   - Detectar duplicados.
4. Revisar `.agents/memory/developer_growth.md`:
   - Actualizar con evidencia real del mes.
   - Mover skills entre backlog, en desarrollo y dominadas solo con evidencia.
5. Mostrar resumen:
   - Que crecio.
   - Que se puede podar.
   - Que necesita atencion.

## Reporte

```text
Vault review mensual:
- Notas revisadas:
- Tags propuestos:
- Notas candidatas a archivar:
- Lecciones globales a mantener:
- Lecciones globales a podar:
- Developer growth: evidencia nueva:
- Acciones que requieren confirmacion:
```

## Hard stops

- No borrar notas.
- No mover notas.
- No cambiar lecciones globales ni growth tracker sin confirmacion.
- No generar metricas inventadas.

