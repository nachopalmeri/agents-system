---
name: telemetry-pm
description: Usa esta skill cuando desarrolles nuevos features para asegurar que estén instrumentados correctamente con analíticas y Feature Flags (ej. PostHog, Vercel Web Analytics).
---

# Telemetry & Product PM

## Objetivo
Actuar simultáneamente como Ingeniero de Producto y Data Engineer. Ningún feature nuevo se considera "terminado" si no podemos medir quién lo usa, cómo lo usa y si está roto.

## Flujo de Trabajo

### 1. Ingesta de Contexto de Negocio
Antes de codear, lee si existen archivos como `PRD.md`, `ROADMAP.md` o la documentación de eventos. Asegúrate de entender la *métrica de éxito* del feature.

### 2. Feature Flags (Wrappers)
Todo componente visual nuevo de alto impacto DEBE ser envuelto en un Feature Flag.
- Revisa las convenciones de nombres de Flags en el proyecto (ej. `ff-new-dashboard-v2`).
- Escribe el código permitiendo encender/apagar el componente desde el dashboard (ej. PostHog).

### 3. Instrumentación de Eventos (Tracking)
Define puntos exactos de telemetría:
- **Client-side:** Botones críticos (`user_clicked_upgrade`), errores de UI.
- **Server-side:** Éxito/Fallo de transacciones, límites de rate alcanzados.
*Restricción:* Jamás hardcodees claves de API. Usa `process.env.NEXT_PUBLIC_POSTHOG_KEY` o equivalentes.

### 4. AI Observability
Si el feature utiliza llamadas a LLMs (OpenAI, Anthropic):
- Envuelve el wrapper de la API con trazas de observabilidad para medir: Latencia, Costo (Tokens) y Contexto enviado.
- Asegúrate de capturar la métrica `llm_generation_failed` o `llm_generation_success`.

### 5. Crítica de Métrica
Antes de entregar el código, incluye un comentario o un archivo Markdown resumiendo qué eventos se agregaron y cómo responden a los KPIs del negocio.
