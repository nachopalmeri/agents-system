---
description: Guardrail para decisiones de alto costo de reversion antes de ejecutarlas
---

# Workflow: Irreversible Decision

## Principio

Algunas decisiones no son bugs baratos. Si se toman mal, cuestan semanas. Antes de ejecutar una decision de alto costo de reversion, el agente debe frenar, chequear alternativas y dejar registro.

## Que cuenta como decision de alto costo de reversion

- Arquitectura de base de datos u ORM.
- Stack tecnologico principal del proyecto.
- Modelo de pricing o monetizacion.
- Dominio o nombre de producto/empresa.
- Integracion con servicio externo que requiere migracion costosa.
- Estructura de datos que va a produccion.

## Flujo

1. Pausar antes de ejecutar.
2. Mostrar:

```text
Esto es una decision de alto costo de reversion.
Antes de continuar:
```

3. Forzar checklist minima:
   - [ ] Evaluamos al menos 2 alternativas.
   - [ ] El costo de equivocarse es aceptable dado el contexto actual.
   - [ ] No falta informacion critica que deberiamos tener.
   - [ ] Esta decision no bloquea algo importante hacia adelante sin plan.
4. Registrar en `tasks/decisions.md` del proyecto.
5. Registrar en el vault via `obsidian_sync.md` como decision tecnica si aplica.
6. Solo entonces ejecutar.

## Formato para `tasks/decisions.md`

```markdown
| Fecha | Decision | Alternativas evaluadas | Por que esta | Costo si me equivoque |
|---|---|---|---|---|
```

## Hard stops

- No ejecutar la decision si no se evaluaron al menos 2 alternativas, salvo confirmacion explicita del usuario.
- No tratar "me parece mejor" como justificacion suficiente.
- No saltear el registro en proyectos donde exista `tasks/decisions.md`.
