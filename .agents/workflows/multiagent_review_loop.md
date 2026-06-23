---
description: Secuencia multiagente crítica para crear, atacar, mejorar, convertir en roadmap y reevaluar decisiones de alto impacto
---

# Multiagent Review Loop

## Principio

No usar multiagente para parecer sofisticado. Usarlo cuando una decisión, arquitectura, workflow o estrategia necesita distancia crítica real.

## Cuándo usar

- Mejorar el sistema de agentes, workflows, skills o arquitectura.
- Diseñar una estrategia con riesgo alto o muchas dependencias.
- Evaluar un producto, Venture Loop, SEO/GEO/AEO o GTM con incertidumbre.
- Convertir una idea fuerte en roadmap ejecutable.
- Hacer red team antes de implementar cambios caros o difíciles de revertir.

## Cuándo NO usar

- Bug puntual.
- Cambio chico y claro.
- Copy puntual.
- Ajuste visual menor.
- Cuando la crítica no puede cambiar la decisión.
- Cuando no hay criterio de salida verificable.

## Secuencia obligatoria

Cada fase debe referenciar archivos, notas, datos o supuestos concretos. Si no hay referencia, marcarlo como supuesto.

### 1. CREAR

Objetivo: proponer una solución inicial usando contexto real.

Salida:

```text
Solución inicial:
Referencias usadas:
Supuestos:
Criterio de éxito:
```

### 2. CRITICAR

Objetivo: identificar fallas, riesgos y debilidades sin defender la solución.

Buscar:

- Contradicciones.
- Falta de evidencia.
- Riesgos técnicos o estratégicos.
- Puntos poco accionables.
- Sobrecarga de proceso.

Salida:

```text
Críticas:
Severidad:
Impacto:
Cómo corregir:
```

### 3. RED TEAM

Objetivo: asumir que la solución está equivocada o incompleta.

Atacar:

- Cómo falla en uso real.
- Qué promete sin poder cumplir.
- Qué automatiza de forma peligrosa.
- Qué depende de herramientas, datos o credenciales no disponibles.
- Qué se vuelve teatro multiagente.

Salida:

```text
Escenarios de fracaso:
Riesgos no considerados:
Supuestos falsables:
Hard stops:
```

### 4. SEGUNDA CRÍTICA

Objetivo: buscar lo que la primera crítica no vio.

Atacar:

- Premisas base.
- Fuentes de verdad duplicadas.
- Costos de mantenimiento.
- Métricas engañosas.
- Problemas que parecen resueltos pero solo fueron maquillados.

Salida:

```text
Problemas nuevos:
Problemas subestimados:
Causas raíz:
Qué no conviene hacer:
```

### 5. PLAN DE MEJORA

Objetivo: convertir críticas en mejoras priorizadas.

Separar:

- Quick wins.
- Estructurales.
- Avanzadas.
- No hacer.

Salida:

```text
Problemas priorizados:
Plan por etapas:
Trade-offs:
Riesgos residuales:
```

### 6. ROADMAP EJECUTABLE

Objetivo: definir fases implementables.

Cada fase debe tener:

- Objetivo.
- Archivos/notas a tocar.
- Tareas concretas.
- Riesgos.
- Criterio de éxito.
- Validación.

Salida:

```text
Fases:
Tareas:
Criterios de éxito:
Validación:
```

### 7. REEVALUACIÓN FINAL

Objetivo: validar si el roadmap resuelve las críticas originales.

Tabla obligatoria:

| Crítica | Cambio aplicado | Estado | Evidencia |
|---|---|---|---|

Estados válidos:

- Resuelta.
- Parcial.
- No resuelta.
- Riesgo aceptado.
- Empeoró.

## Anti-teatro

Antes de ejecutar la secuencia, preguntar internamente:

- ¿La crítica puede cambiar la solución?
- ¿Hay riesgo real si nos equivocamos?
- ¿Hay suficiente contexto para no inventar?
- ¿La salida será más accionable que un plan simple?

Si la respuesta es no, usar flujo simple.

## Integración con otros workflows

- Para ideas/productos: conectar con `venture_loop.md`.
- Para SEO/GEO/AEO: conectar con `seo_geo_growth.md`.
- Para marketing/ads/DMs: conectar con `marketing.md` y mantener draft/read-only.
- Para MCPs: usar `mcp_security.md` y `mcp_adoption.md`.
- Para cierre: usar `validation.md`.
- Para sesiones largas: usar `session_checkpoint.md`.

## Regla final

Un buen red team no busca tener razón. Busca evitar que el sistema mienta, sobreconstruya o declare victoria sin evidencia.
