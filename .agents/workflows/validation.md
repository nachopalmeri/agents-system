---
description: Validacion central para cerrar trabajo, dejar handoff, revisar deuda y capturar aprendizaje
---

# Workflow: Validation

## Regla principal

Nunca declarar victoria sin evidencia. Validar no es "me parece correcto"; es contrastar el resultado contra tests, diff, build, logs, captura, fuente externa o una limitacion explicitamente informada.

Un test rojo demuestra el problema o comportamiento faltante; no demuestra que el trabajo terminó. Cerrar requiere cumplir los criterios de aceptación, revisar el diff y observar los checks relevantes en verde. No cambiar el esperado ni eliminar tests sólo para lograr verde; un cambio de contrato aprobado debe explicar también sus cambios de tests. Informar qué quedó sin verificar.

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

- Elegir tests por el comportamiento y los límites afectados, usando el framework existente: unitarios para lógica, integración para contratos reales y E2E para recorridos críticos que cambian. No exigir los tres niveles en cada tarea ni instalar un framework como paso implícito.
- Reutilizar los tests existentes y agregar cobertura cuando el comportamiento o una regresión lo justifique; no crear tests que sólo repiten el texto o la implementación.
- Correr lint/build si existen y el cambio puede afectarlos.
- Si no hay tests, dejar validacion alternativa explicita.

### 2.5. E2E de recorridos afectados (si aplica)

Si el cambio afecta un flujo de usuario crítico (login, signup, checkout, CRUD principal) o se pide validar una entrega completa:

- Reutilizar el runner y los recorridos existentes; Playwright es una opción cuando ya está disponible o su instalación está autorizada.
- Verificar el recorrido completo afectado, incluido el resultado visible y su persistencia cuando corresponda, no sólo que un botón reciba un clic.
- Usar las herramientas de navegador permitidas por el entorno. Si no se puede ejecutar, registrar el bloqueo y la evidencia alternativa sin afirmar que E2E pasó.

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
| UI con flujos criticos afectados | E2E del recorrido afectado + revision visual + consola sin errores; declarar cualquier ejecución pendiente |
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
