---
description: Validacion central para cerrar trabajo, dejar handoff, revisar deuda y capturar aprendizaje
---

# Workflow: Validation

## Regla principal

Nunca declarar victoria sin evidencia. Validar no es "me parece correcto"; es contrastar el resultado contra tests, diff, build, logs, captura, fuente externa o una limitacion explicitamente informada.

## Orden de cierre

1. Checklist tecnico: scope, tests, secrets y riesgos.
2. Actualizar `tasks/handoff.md` con el estado real si existe.
3. Revisar `tasks/tech-debt.md`: si se agrego deuda intencional, registrarla.
4. Ejecutar `feedback_loop.md` para errores de la sesion.
5. Ejecutar `promote_lesson.md` para candidatos globales.
6. Ejecutar `obsidian_sync.md` para retro, decision o nota relevante.
7. Ejecutar `growth_update.md` si hay evidencia real de crecimiento.
8. Commit y push si hubo cambios del sistema o del proyecto.
9. Reporte final: que se cerro, que se aprendio, que crecio.

## Checklist tecnico

### 1. Scope

- Revisar archivos tocados.
- Confirmar que no se modifico nada fuera del alcance.
- Ejecutar `git diff --stat` si hay repo Git.
- Si habia cambios preexistentes no relacionados, mencionarlos sin revertirlos.

### 2. Tests y build

- Correr tests si existen.
- Correr lint/build si existen y el cambio puede afectarlos.
- Si no hay tests, dejar validacion alternativa explicita.

### 3. Seguridad y secretos

- Revisar riesgos de credenciales, datos personales, pagos, ads, DMs o produccion.
- Correr secret scan si el repo lo tiene.
- No cerrar como listo si queda una exposicion sensible sin aclarar.

### 4. Riesgos pendientes

- Separar lo validado de lo no validado.
- Si hay deuda, bloqueo o decision fragil, dejarla en `tasks/tech-debt.md`, `tasks/decisions.md` o `tasks/handoff.md` segun corresponda.

## Niveles de evidencia

| Cambio | Evidencia minima |
|---|---|
| Docs/prompts/workflows | Diff revisado + referencias internas + check del sistema |
| Codigo | Tests relevantes o reproduccion manual + build/lint si aplica |
| UI | Revision visual/responsive + consola sin errores si aplica |
| AI/RAG | Dataset/evals o limitacion explicita; no declarar production-ready sin evidencia |
| Decision estrategica | Supuestos, trade-offs, criterio de decision y siguiente paso falsable |
| Cliente | Entrega versionada + feedback registrado + scope claro |

## Handoff minimo

Si existe `tasks/handoff.md`, debe quedar actualizado con:

- Estado actual.
- Ultima sesion.
- Decisiones pendientes.
- Proximo paso concreto.
- Que no tocar.
- Contexto que no esta en el codigo.

## Reporte final minimo

```text
Validacion:
- Que se verifico:
- Comandos ejecutados:
- Handoff actualizado:
- Deuda registrada:
- Lecciones de la sesion:
- Nota de vault:
- Growth update:
- Resultado:
- Riesgos pendientes:
```

## Regla final

Si no se pudo validar, decirlo claramente y no presentar el trabajo como completo.
