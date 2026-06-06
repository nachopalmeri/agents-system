---
description: Auditoría de performance para apps, queries, APIs y frontend
---

# Workflow: Performance Audit

## Cuándo usar

- App lenta o con tiempos de respuesta altos.
- Query de base de datos lenta o N+1 detectada.
- Bundle size grande o tiempo de carga alto.
- Core Web Vitals malos (LCP, FID, CLS).
- Consumo de recursos inesperado (CPU, memoria, ancho de banda).
- El usuario pide "auditoría de performance" o "optimizar velocidad".

## Cuándo NO usar

- Bug puntual no relacionado con performance → debugging + validation.
- Cambio de feature que no afecta velocidad → flujo simple.
- SEO técnico puntual → `agente-seo`.

## Checklist de auditoría

### 1. Base de datos / Queries
- Indexes: ¿faltan índices en filtros frecuentes, joins o ORDER BY?
- Consultas lentas: revisar EXPLAIN/EXPLAIN ANALYZE.
- N+1 queries: detectar y resolver con eager loading o batch.
- Datos que se recalculan o consultan repetidamente → candidatos a cache.

### 2. Cache
- ¿Hay datos que se recalculan en cada request?
- Cache de respuesta HTTP (CDN, headers).
- Cache de aplicación (Redis, memoria, etc.).
- Cache de query (ORM, prepared statements).
- Invalidación: ¿se invalida correctamente cuando cambia la fuente?

### 3. Payloads / API
- Información que se trae de más: campos innecesarios en responses.
- Paginación: ¿se paginan resultados grandes?
- Compresión: gzip/brotli habilitado.
- Serialización: ¿hay transformaciones costosas innecesarias?

### 4. Frontend / Bundle
- Bundle size: ¿es grande? Analizar con bundle analyzer.
- Code splitting: ¿se lazy-loadean rutas/componentes pesados?
- Tree shaking: ¿se eliminan imports no usados?
- Imágenes: formato (WebP/AVIF), tamaño responsive, lazy loading.
- Fonts: preload, subset, display: swap.
- CSS: purgar no usados, critical CSS inline.

### 5. Core Web Vitals
- LCP (Largest Contentful Paint): < 2.5s.
- FID / INP (Interacción): < 100ms.
- CLS (Cumulative Layout Shift): < 0.1.
- Herramientas: PageSpeed Insights, CrUX, Lighthouse, Playwright MCP.

### 6. Infraestructura / Runtime
- Cold starts: ¿hay funciones/contenedores con arranque lento?
- Conexiones: pool de conexiones a DB bien configurado.
- Concurrencia: ¿hay cuellos de botella en endpoints críticos?
- Memoria: ¿hay leaks o consumo creciente?

## Enfoque granular (Santi @santtiagom_)

No intentar resolver toda la auditoría en un único prompt. Empezar por un área. Por ejemplo, cache.

1. Que analice el área.
2. Que proponga mejoras.
3. Que las implemente.
4. Después avanzar con la siguiente área.

Cuando el scope es más acotado, el agente encuentra mejores soluciones y profundiza más en los problemas.

### Handoff entre sesiones

Si el contexto se carga demasiado, cambiar de sesión:
1. Pedir al agente un resumen de lo implementado y lo que falta.
2. Copiar/pegar ese resumen a la nueva sesión.
3. La nueva sesión tiene constancia de lo anterior sin arrastrar contexto degradado.

Más contexto cargado = peores resultados. Splitear sesiones no es pérdida, es optimización.

## Proceso

1. Identificar síntoma: ¿dónde es lento? (frontend, API, DB, todo).
2. Medir baseline: tiempos actuales con datos reales.
3. Elegir UN área del checklist para esta sesión (no todas).
4. Ejecutar checklist del área elegida.
5. Priorizar fixes por impacto/costo.
6. Implementar fix mínimo.
7. Medir mejora vs baseline.
8. Validar con `validation.md`.
9. Si hay más áreas: generar resumen de handoff y continuar en nueva sesión.

## Output

```text
Performance audit:
- Síntoma:
- Baseline:
- Hallazgos:
- Priorización (impacto/costo):
- Fixes implementados:
- Mejora medida:
- Pendientes:
```

## Conexiones

- Core Web Vitals → conectar con `seo_geo_growth.md` (Fase 6: Technical SEO handoff).
- E2E de flujos lentos → conectar con `validation.md` (Playwright E2E).
- Queries en Supabase → usar `supabase-postgres-best-practices`.

## Regla final

No optimizar sin medir. Si no hay baseline, no hay evidencia de mejora.
No auditar todo de una. Una área por sesión = mejor calidad. Contexto degradado = cambiar de sesión con resumen.
