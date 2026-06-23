---
description: Aprendizaje de errores en tiempo real para routing, output, scope y calidad
---

# Workflow: Feedback Loop

## Principio

Cuando el usuario corrige al agente o el agente detecta que fallo, el error se clasifica, se registra y se convierte en una regla aplicable. No es catarsis ni postmortem largo: es aprendizaje operativo con evidencia.

## Taxonomia de errores

| Tipo | Definicion | Ejemplo |
|---|---|---|
| ROUTING | El agente eligio el workflow, skill o nivel de proceso equivocado | Uso multiagent review para un fix chico |
| OUTPUT | Eligio bien el workflow pero el resultado fue incorrecto, incompleto o no resolvio el pedido | Planifico bien pero omitio tests |
| SCOPE | Toco archivos, servicios, configuracion o decisiones fuera del alcance | Edito AGENTS.md cuando solo debia actualizar docs |
| QUALITY | El output era funcional pero inaceptable en calidad, claridad, formato o estandar profesional | Entrego una spec vaga que parece completa |

## Triggers

- El usuario dice que el workflow elegido no era el adecuado.
- El usuario corrige una respuesta, implementacion, scope o formato.
- El agente detecta que actuo sin evidencia suficiente.
- Aparece el mismo error dos veces en una sesion.
- Una validacion falla por una regla vaga o ausente.

## Flujo inmediato

1. **Parar y clasificar**
   - Elegir un tipo: ROUTING, OUTPUT, SCOPE o QUALITY.
   - Si hay dos tipos, elegir el primario y mencionar el secundario.

2. **Encontrar causa raiz**
   - No registrar sintomas.
   - Preguntar: que regla, criterio, dato o hard stop falto para evitarlo.

3. **Registrar en `.agents/tasks/lessons.md` del proyecto si existe**
   - Si no existe y el proyecto es mediano/grande, proponer crearlo.
   - Si no existe y el trabajo es chico, reportar la leccion en el cierre sin crear archivo.

4. **Aplicar en la sesion actual**
   - Si el error fue grave o se repite en la misma sesion, aplicar la regla inmediatamente al resto del trabajo.
   - Si implica cambiar `.agents/AGENTS.md`, workflows globales o memoria global, pedir confirmacion explicita antes de editar.

5. **Preguntar al cierre**
   - "Este error te paso antes en otro proyecto? Si si, es candidato a leccion global; decime y lo promovemos."

## Formato para `.agents/tasks/lessons.md`

```markdown
## YYYY-MM-DD - [ROUTING|OUTPUT|SCOPE|QUALITY] Titulo corto

- Que paso: una linea factual.
- Causa raiz: por que paso, no solo el sintoma.
- Regla derivada: Siempre/Nunca ...
- Evidencia: archivo, comando, conversacion o comportamiento observado.
- Aplicacion inmediata: que cambia desde ahora en esta sesion.
- Candidato global: si/no/desconocido.
```

## Regla derivada

La regla debe empezar con `Siempre` o `Nunca` y ser accionable.

Mal:

```text
Hacer mejores respuestas.
```

Bien:

```text
Siempre explicar el routing en una linea cuando el pedido pueda caer en dos workflows.
```

## Hard stops

- No promover una leccion global por un solo incidente.
- No modificar `AGENTS.md`, workflows globales ni `.agents/memory/developer_growth.md` sin confirmacion explicita.
- No usar feedback loop para justificar al agente; usarlo para corregir comportamiento.
- No guardar ruido: si no hay evidencia, registrar como supuesto o pedir ejemplo.

## Salida esperada

```text
Feedback aplicado:
- Tipo:
- Que paso:
- Causa raiz:
- Regla derivada:
- Aplicacion inmediata:
- Registro:
- Candidato global:
```

