---
description: Validacion central para cerrar trabajo, dejar handoff, revisar deuda y capturar aprendizaje
---

# Workflow: Validation

## Regla principal

Nunca declarar victoria sin evidencia. Validar no es "me parece correcto"; es contrastar el resultado contra tests, diff, build, logs, captura, fuente externa o una limitacion explicitamente informada.

## Orden de cierre

1. Checklist tecnico: scope, tests, secrets y riesgos.
2. Actualizar `.agents/tasks/handoff.md` si existe.
3. Revisar `.agents/tasks/tech-debt.md` si hay deuda nueva.
4. Registrar errores de la sesion en `tasks/lessons.md` con tipo (ROUTING/OUTPUT/SCOPE/QUALITY).
5. Si una leccion aparece en 2+ proyectos, preguntar al usuario si promover a `memory/lessons-global.md`.
6. Commit y push si hubo cambios del sistema o del proyecto.
7. Reporte final: que se cerro, que se aprendio.

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

### 2.5. Playwright E2E (si aplica)

Si el proyecto tiene flujos de usuario criticos (login, signup, checkout, CRUD principal):

- Definir tests E2E con `@playwright/test` para los flujos clave.
- Ejemplo: un usuario puede hacer login, crear un proyecto, actualizar su perfil.
- Los tests se definen una vez y se reutilizan en cada cambio.
- Workflow: agente hace cambio → ejecuta Playwright → Playwright corre cada flujo en navegador real → si algo falla, se sabe exactamente donde se rompio.
- Si hay MCP de Playwright disponible, el agente puede ejecutar el navegador directamente desde terminal sin intervención manual.
- Playwright valida acciones reales de principio a fin, no solo partes aisladas.
- No crear tests E2E para cambios que no afectan flujos de usuario.

### 3. Seguridad y secretos

- Revisar riesgos de credenciales, datos personales, pagos, ads, DMs o produccion.
- Correr secret scan si el repo lo tiene.
- No cerrar como listo si queda una exposicion sensible sin aclarar.

### 4. Riesgos pendientes

- Separar lo validado de lo no validado.
- Si hay deuda, bloqueo o decision fragil, dejarla en `.agents/tasks/tech-debt.md`, `.agents/tasks/decisions.md` o `.agents/tasks/handoff.md` segun corresponda.

## Niveles de evidencia

| Cambio | Evidencia minima |
|---|---|
| Docs/prompts/workflows | Diff revisado + referencias internas + check del sistema |
| Codigo | Tests relevantes o reproduccion manual + build/lint si aplica |
| UI | Revision visual/responsive + consola sin errores si aplica |
| UI con flujos criticos | Playwright E2E de flujos clave + revision visual + consola sin errores |
| AI/RAG | Dataset/evals o limitacion explicita; no declarar production-ready sin evidencia |
| Decision estrategica | Supuestos, trade-offs, criterio de decision y siguiente paso falsable |
| Cliente | Entrega versionada + feedback registrado + scope claro |

## Handoff minimo

Si existe `.agents/tasks/handoff.md`, debe quedar actualizado con:

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

## Auto-validación del output

Para tareas importantes, no quedarse solo con la primera respuesta. Antes de declarar listo:

1. Revisar el output contra los criterios del pedido original.
2. Verificar que no se rompieron tests existentes.
3. Si el pedido tenía requisitos explícitos, chequear cada uno.
4. Si algo no se pudo validar, declararlo explícitamente en lugar de asumir que está bien.

Esta regla viene de la guía oficial de Anthropic: pedirle al modelo que valide su propio resultado contra criterios concretos antes de terminar.

## Comprehension Debt Check

Si el trabajo fue generado por un loop desatendido o con mínima intervención humana:

1. **¿Leíste todo el código que el loop generó?** Si no → no declarar listo. Leer primero.
2. **¿Entendés cada cambio en el diff?** Si hay cambios que no entendés → investigar antes de cerrar.
3. **¿Podés explicar la solución a otro engineer?** Si no → comprehension debt acumulado.

### Regla: 3 loops desatendidos → 1 sesión de review manual

Después de 3 loops que generaron código sin intervención humana, la próxima sesión debe ser exclusivamente de review:
- Leer todo el código generado.
- Verificar que los tests realmente testean lo que dicen.
- Confirmar que no hay "green by deletion" (tests eliminados para pasar).
- Entender la arquitectura resultante.

Esta sesión de review no es opcional. Es la countermeasure contra comprehension debt.
