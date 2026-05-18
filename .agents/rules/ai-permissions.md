---
description: Permisos y límites para acciones del agente sobre archivos y estado del sistema
---

# Permisos de IA

## Principio

El agente puede proponer, leer, editar y commitear dentro del scope autorizado. Pero hay marcadores de estado y acciones que **solo puede tocar un humano**.

## Lo que el agente PUEDE hacer

- Leer cualquier archivo dentro del proyecto activo.
- Buscar, indexar, analizar.
- Proponer cambios via `Plan Mode`.
- Editar archivos en su scope (según el agente activo).
- Crear notas, drafts, archivos nuevos.
- Commitear con mensaje semántico.
- Pushear si la regla `git.md` lo exige.

## Lo que el agente NO puede hacer sin confirmación humana

### Marcadores de estado "humanos"
- `processed: true` (en notas de inbox/clippings).
- `flashcards_done: true`.
- `portfolio_ready: true`.
- `reviewed_by_user: true`.
- `validated_by_human: true`.
- Cualquier flag que afirme "un humano confirmó esto".

### Acciones destructivas
- Borrar archivos.
- Mover archivos fuera de su carpeta original.
- Modificar `.obsidian/`, `.windsurf/`, `.git/`, `.github/`.
- Hacer `force push` o reescribir historial.
- Mergear ramas a main.

### Acciones externas sensibles
- Instalar plugins, MCPs o dependencias.
- Conectar a APIs con credenciales reales.
- Enviar mensajes (DMs, emails, notifications).
- Ejecutar gasto publicitario o pagos.
- Modificar producción.

## Flags obligatorios para contenido generado por IA

Si el agente genera una nota o documento completo:

```yaml
ai_generated: true
reviewed_by_user: false
generated_at: YYYY-MM-DD
generated_by: nombre-del-agente
```

El usuario actualiza `reviewed_by_user: true` cuando lo revisa manualmente.

## Separación hechos vs hipótesis

Usar `evidence_level` para distinguir:

- `real` — dato verificado.
- `target` — meta deseada.
- `mock` — placeholder para testing.
- `estimate` — estimación con margen de error.

No mezclar los cuatro en la misma tabla sin etiquetar.

## Regla final

Si hay duda sobre si una acción requiere confirmación, preguntar antes de ejecutar. Es preferible una pregunta que un cambio irreversible.
