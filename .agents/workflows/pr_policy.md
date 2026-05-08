---
description: Política de commits y pull requests optimizada para cambios revisables y bajo desperdicio de tokens
---

# Política de PRs

La meta no es abrir PRs rápido por deporte.
La meta es mantener cambios pequeños, claros y fáciles de revisar.

---

## 1. Cuándo Abrir una PR

- Abrir PR cuando el cambio ya tenga una forma coherente y revisable.
- No esperar al proyecto completo si el objetivo ya puede discutirse.
- No abrir una PR demasiado temprano si todavía no explica nada.

## 2. Tamaño Ideal

- Una PR = un objetivo coherente.
- Evitar mezclar feature, refactor y fixes no relacionados.
- Si el diff se vuelve difícil de revisar, dividir.

Guía práctica:

- Hasta ~200 líneas netas: normalmente bien.
- Entre ~200 y ~600: revisar si conviene separar.
- Más de ~600: dividir salvo que exista una muy buena razón.

## 3. Commits

- Hacer commits chicos cuando agregan trazabilidad real.
- No commitear cada microcambio irrelevante.
- Un commit debe contar una idea entendible.

Formato sugerido:

`tipo(scope): descripción corta`

Ejemplos:

- `feat(auth): add password reset flow`
- `fix(api): handle empty payload`
- `refactor(ui): extract table actions`

## 4. Push

- Hacer push al cerrar una unidad lógica verificable.
- Si todavía estás explorando o rompiendo cosas, no hace falta empujar ruido.
- Preferir menos pushes, pero más claros.

## 5. Antes de Pedir Review

- Correr la verificación más cercana al área tocada.
- Limpiar debug prints, código muerto y cambios incidentales.
- Asegurarse de que el diff cuente una historia legible.

## 6. Descripción de PR

La PR debe responder en pocas líneas:

- qué cambia
- por qué cambia
- cómo se verificó
- qué riesgos o límites quedan

## 7. Checklist Antes de Merge

```
[ ] El diff tiene un objetivo claro
[ ] La verificación relevante pasó
[ ] No quedaron cambios incidentales innecesarios
[ ] El título y la descripción explican el por qué
[ ] El reviewer puede entender la PR sin contexto oculto
```

## 8. Regla de Oro

Si explicar la PR cuesta demasiado, probablemente la PR es demasiado grande o mezcla demasiadas cosas.
