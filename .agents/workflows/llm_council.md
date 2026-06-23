---
description: LLM Council — 5 asesores con lentes opuestas, peer review anónima y Chairman para decisiones de alto impacto
---

# LLM Council

Limitacion honesta: si corre dentro de un unico modelo/contexto, el desacuerdo es simulado. Sirve para forzar lentes y detectar puntos ciegos, no como evidencia independiente. Para decisiones de alto costo, contrastar con datos, usuarios, tests, fuentes externas o revisores humanos.

## Principio

Para decisiones complejas con múltiples ángulos, una sola perspectiva miente. El Council te da 5 lentes radicalmente distintas, una peer review anónima que detecta sesgos, y un Chairman que sintetiza todo en una recomendación accionable ≤200 palabras.

## Cuándo usar

- Decisión estratégica con incertidumbre real.
- Trade-off arquitectónico difícil de revertir.
- Evaluación de oportunidad (idea de producto, oferta laboral, pivot).
- Cuando una sola perspectiva ya te dio respuesta y querés contrastar.
- Cuando estás "enamorado" de una idea y necesitás distancia crítica.

## Cuándo NO usar

- Bug puntual.
- Cambio chico o claro.
- Pregunta con respuesta directa.
- Cuando ya sabés qué hacer y solo querés ejecutar (usar `phases.md` o flujo simple).
- Cuando no hay criterio de salida verificable.

## Relación con `multiagent_review_loop.md`

| | LLM Council | Multiagent Review Loop |
|---|---|---|
| Estructura | 3 etapas (asesores + peer review + Chairman) | 7 fases (CREAR → REEVALUAR) |
| Output | Recomendación ≤200 palabras + 1 paso para hoy | Roadmap ejecutable + tabla de críticas resueltas |
| Tiempo | Rápido (1 sesión) | Más largo (puede ser multi-sesión) |
| Cuándo | Decidir entre opciones | Mejorar/atacar una solución existente |

Pueden combinarse: usar Council para elegir dirección, luego Review Loop para diseñar la implementación.

## Estructura

### ETAPA 1 — Los 5 Asesores

Cada asesor responde la pregunta una vez, completamente en carácter. Sin tibieza, sin "por otro lado".

| Asesor | Lente |
|---|---|
| **1. Contrariano** | ¿Dónde se rompe esto? ¿Cuál es el modo de falla más probable? |
| **2. First Principles** | Sacar todas las asunciones. Reconstruir desde cero. La pregunta misma puede estar mal. |
| **3. Expansionista** | ¿Cuál es la versión más grande? ¿Qué oportunidad esconde la pregunta? |
| **4. Outsider** | Sin contexto de la industria. ¿Qué se ve raro desde afuera? ¿Qué dan por sentado los insiders? |
| **5. Ejecutor** | Solo lunes a la mañana. ¿Cuál es el primer paso concreto? ¿La versión más chica que sale esta semana? |

### ETAPA 2 — Peer Review Anónima

Reetiquetar las 5 respuestas como A, B, C, D, E con orden barajado (no decir cuál es cuál).
Como revisor neutral, responder:

1. ¿Qué respuesta es la más fuerte y por qué?
2. ¿Qué respuesta tiene el punto ciego más grande y cuál es?
3. ¿Qué se les pasó por alto a las cinco?

### ETAPA 3 — Chairman

Recomendación final ≤200 palabras:

- Recomendación en lenguaje simple.
- La razón más importante detrás.
- Un paso concreto para hoy.

## Prompt portable

El prompt completo copy-paste vive en `.agents/prompts/llm-council-portable.md` para usar en cualquier chat (ChatGPT, Claude, Gemini, Copilot, Cursor, etc.).

## Reglas

- No saltear etapas.
- No resumir en el camino.
- Cada asesor mantiene su carácter.
- El Chairman no debe pasar las 200 palabras.
- Si hay contexto del proyecto (archivos, decisiones previas), incluirlo en la pregunta.

## Output esperado

```text
ETAPA 1 — 5 RESPUESTAS DE ASESORES
[Cada uno en carácter, 100-200 palabras]

ETAPA 2 — PEER REVIEW ANÓNIMA
Respuestas A-E (orden barajado)
1. Más fuerte: ...
2. Mayor punto ciego: ...
3. Lo que todas perdieron: ...

ETAPA 3 — CHAIRMAN
Recomendación: ...
Razón: ...
Paso concreto hoy: ...
```

## Validación

Antes de actuar sobre la recomendación del Chairman:

- Verificar que el paso concreto es ejecutable hoy.
- Verificar que la recomendación responde a la pregunta original.
- Si la recomendación contradice valores/identidad/restricciones reales, descartar y reexaminar.
