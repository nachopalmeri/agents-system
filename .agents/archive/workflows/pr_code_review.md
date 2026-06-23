---
description: Code review escalable para PRs, con subagentes solo cuando el tamaño o el riesgo lo justifican
---

# Code Review Escalable

No toda PR necesita orquestación compleja.
El criterio es usar la menor cantidad de review process que mantenga buena calidad.

---

## Nivel 1 — Review Directo

Usar cuando:

- la PR es chica
- toca un área conocida
- el riesgo es bajo

Flujo:

`leer diff -> buscar regresiones -> verificar cobertura -> emitir review`

## Nivel 2 — Review con Checklist

Usar cuando:

- la PR es mediana
- mezcla backend/frontend o varios módulos
- hay riesgo funcional moderado

Checklist:

- bugs lógicos
- edge cases
- consistencia con patrones existentes
- tests faltantes
- impacto en performance si aplica

## Nivel 3 — Review Paralelo con Subagentes

Usar solo cuando:

- la PR es grande
- hay varios dominios distintos
- el diff no entra cómodo en una sola revisión

En ese caso, dividir el review por foco:

### Subagente 1 — Bugs y edge cases
- Buscar fallos lógicos, ramas no cubiertas y regresiones.

### Subagente 2 — Diseño y mantenibilidad
- Revisar nombres, abstracciones, acoplamiento y claridad.

### Subagente 3 — Performance o riesgos operativos
- Revisar consultas, loops, llamadas costosas, memoria o impacto runtime.

El agente principal sintetiza y prioriza.

---

## Formato de Salida Recomendado

```markdown
## Findings

### P0
- ...

### P1
- ...

### P2
- ...

## Veredicto
[approve / request changes / discuss]
```

---

## Cuándo NO usar Subagentes

- Documentación pura
- Config menor
- Hotfix chico
- PRs que el agente principal puede revisar rápido sin perder foco

## Regla Final

Si coordinar el review cuesta más que revisar, no uses subagentes.
