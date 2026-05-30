---
description: Workflow interno para estrategia de contenido X/Twitter, LinkedIn, Substack, personal branding y growth social. Usar cuando el pedido involucre crear, mejorar o planificar contenido para redes.
---

# Workflow: X Content System

## Principio
El usuario habla normal. Si el pedido es de contenido social o personal branding, el agente enruta internamente y no pide nombres de workflows.

## Cuándo usar
- Crear o mejorar tweets, hilos, quote tweets, replies o carousels.
- Auditar cuenta, bio, pinned tweet o posicionamiento.
- Definir calendario de contenido o estrategia de crecimiento en redes.
- Adaptar contenido de una plataforma a otra (X → LinkedIn → Substack).
- Estrategia de networking social (replies inteligentes, quote tweets, authority building).
- Detectar hooks virales o ángulos diferenciadores en ideas del usuario.

## Cuándo NO usar
- Bug técnico o fix de código → usar debugging + validation.
- SEO técnico/on-page → usar agente-seo.
- Paid media o ads → usar marketing.md + evaluación MCP.
- Crisis de reputación → workflow específico de crisis.

## Sistema de decisión: ¿dónde va esta idea?

Antes de generar contenido, el agente aplica este árbol de decisión:

```
¿Se puede decir en un hook + 3 puntos + pregunta final?
  ├─ SÍ → X (longpost o tweet corto)
  └─ NO → ¿Necesita contexto, narrativa, o conectar 2+ disciplinas?
        ├─ SÍ → Substack (ensayo)
        └─ NO → ¿Es una opinión sobre algo de otro?
              ├─ SÍ → Quote tweet con aporte propio
              └─ NO → Descartar. No todo lo que el usuario piensa es contenido.
```

**Regla de ecosistema:**
- X = trailer. Substack = película. Nunca el mismo contenido exacto en ambas.
- Si va a Substack, siempre extraer un núcleo para X (hook + stake + 3 puntos + reply hook + link).
- LinkedIn = derivado del mejor post de Substack de la semana, recortado y con CTA profesional.

## Inputs mínimos
El agente extrae del pedido en lenguaje natural:
1. Tema, idea o borrador del usuario.
2. Objetivo de negocio (awareness, authority, networking, oportunidades).
3. Aplicar el árbol de decisión para definir plataforma (X, Substack, LinkedIn, multi).

## Fases

### FASE 0 — Diagnóstico Algorítmico (Phoenix)
Antes de generar o mejorar contenido, evaluar según el algoritmo de X:

**Pre-condiciones de la cuenta:**
- ¿Cuenta pública? (sin embedding multimodal no hay retrieval OON)
- ¿Embedding limpio? (sin racha reciente de not_interested/block/mute/report)
- ¿Sin publicación previa en últimas 4-6h? (AuthorDiversityScorer castiga segundo post)

**Anatomía del post (4 líneas críticas):**
1. **Línea 1 = hook fuerte.** ¿Para el scroll en 280 chars? Si no, reescribir. Aquí se decide `not_dwelled`.
2. **Línea 2 = stake/claim concreto.** ¿Dato, contradicción o promesa que retiene?
3. **Cuerpo = sustancia.** ¿Cifras, ejemplos, puntos concretos? Maximiza `dwell_score` + `cont_dwell_time`.
4. **Final = reply hook.** ¿Pregunta, opinión polarizante con tacto, o cebo de experiencia? Activa `reply_score`.

**Formato:**
- ¿Texto largo y denso O corto + vídeo ≥10s con audio? Ambos maximizan dwell time.
- ¿Sin emojis spam, sin walls de hashtags? Minimiza `slop_score`.
- ¿Es un hilo de más de 7 tweets? Si sí, convertir a longpost o recortar (`DedupConversationFilter` penaliza).

**Checklist algorítmico (5 preguntas):**
1. ¿Es original (no reply/retweet)? Solo originales pasan Banger Screen.
2. ¿El hook está en las primeras 280 chars?
3. ¿Maximiza dwell time? (¿me quedaría leyendo esto 8+ segundos?)
4. ¿Es un hilo de más de 7 tweets?
5. ¿Hay riesgo de slop_score alto? (genérico, template, AI-sounding)

**Señales a activar (estimación):**
| Señal | Cómo activarla |
|---|---|
| `dwell_score` | Texto que hace pausar y re-leer |
| `reply_score` | Pregunta final o opinión que invite a responder |
| `profile_click_score` | Vulnerabilidad + proof of work + link |
| `follow_author_score` | Narrativa consistente, contenido original de calidad |
| `share_score` | Utilidad práctica, recursos, tools |
| `slop_score` | BAJO: voz personal, detalles específicos, estructura única |

---

### FASE 1 — Detectar (Las 3 preguntas)
Antes de escribir una palabra, responder:

1. **¿Este post hace pausar al lector 8+ segundos?**
   > Test: leer en voz alta. Si termina en <8 segundos, es demasiado ligero.
   
2. **¿Las primeras 280 caracteres son imposibles de scrollear?**
   > Test: tapar el resto del post. Si no genera curiosidad propia, no la genera en nadie.
   
3. **¿Termina con algo que el lector quiera responder?**
   > Test: si cerrás la app después de publicar, ¿querés volver a abrirla a ver replies?

| Elemento | Qué buscar | Por qué importa |
|---|---|---|
| Hook | Primera frase que para el scroll | 80% del engagement depende del hook |
| Insight | Idea útil o contra-intuitiva | Aporta valor real, no humo |
| Valor | El lector se lleva algo concreto | Genera guardados, shares, follows |
| Emoción | Curiosidad, sorpresa, identificación | Drivea likes y replies |
| Voz | ¿Parece humano? ¿Es auténtico? | Evita AI slop y corporate speak |

### FASE 2 — Mejorar (Ciclo de generación)
**No generar ideas nuevas. Documentar lo que el usuario ya hace y piensa.**

**Paso 1: Documentar**
Cada vez que el usuario:
- Resuelve un bug → ¿qué era y cómo lo resolvió?
- Termina de leer algo → ¿qué le hizo replantear?
- Toma una decisión técnica → ¿por qué A y no B?
- Falla en algo → ¿qué falló y qué aprendió?

**Paso 2: Extraer núcleo para X**
Del documento, extraer:
- Momento de tensión (¿qué estaba en juego?)
- Contradicción (¿qué creía antes y dejó de ser cierto?)
- Aprendizaje concreto (¿qué sabe ahora que no sabía?)
- Pregunta para el lector (¿qué experiencia similar tuvieron?)

**Paso 3: Expandir para Substack**
Del mismo documento, desarrollar:
- Contexto: ¿por qué importa esto ahora?
- Narrativa: cómo llegó a ese aprendizaje.
- Conexiones: ¿qué tiene que ver con otras disciplinas?
- Implicancias: ¿qué cambia si acepta esto?
- Recursos: ¿qué leer/ver para profundizar?

**Mejorar formato:**
- **Claridad:** una idea por tweet. Sin relleno.
- **Retención:** estructura que invite a leer hasta el final.
- **Ritmo:** frases cortas, saltos de línea estratégicos, pausas.
- **CTA:** pregunta al final o invitación a interactuar.

### FASE 2b — Tácticas de Lanzamiento (Algoritmo Phoenix)
Antes de publicar, aplicar tácticas que maximicen las primeras 30 minutos:

1. **Notificar red personal en primeros 10 min**
   - Compartir el post con 2-3 personas que sabés que les interesa.
   - No "mirá lo que publiqué". Decir "esto te puede interesar porque [razón específica para ellos]".
   - Sin engagement rápido, Grok ni evalúa el post.

2. **Primer comentario propio**
   - Responder al propio post con un comentario que agregue valor (dato extra, recurso, opinión).
   - Genera actividad visible desde el minuto 0.

3. **Timing óptimo según audiencia**
   - LATAM tech: 6:00-10:00 PM (ARG) — after work, peak engagement.
   - US tech: 9:00-12:00 AM ET — mañana laboral, alta atención.
   - Substack: evitar viernes (pierde en finde) y lunes (competencia inbox).
   - Evitar postear si publicaste algo propio en últimas 4-6h (AuthorDiversityScorer).

4. **Frecuencia de publicación**
   - X: Máximo 2-3 posts originales por día. Espaciar 4-6h. Post 4 seguido = score en el suelo.
   - Substack: 1 post por semana óptimo. Máximo 2. Si no tenés algo que te gustaría releer en 6 meses, no lo publiques.
   - LinkedIn: 1 post por semana, derivado del mejor Substack.

5. **Autoevaluación de dwell time**
   - Antes de publicar: "¿Me quedaría leyendo esto 8+ segundos?"
   - Dwell time pesa 5x más que likes. Un post de 1 segundo = muerto algorítmicamente.

### FASE 3 — Adaptar
| Plataforma | Reglas específicas |
|---|---|
| X/Twitter | 280 chars, hooks agresivos, hilos con numeración, hashtags mínimos |
| LinkedIn | Posts más largos, tono profesional pero humano, storytelling personal, 3-5 hashtags |
| Substack/threads | Contenido profundo, estructura con subtítulos, citas, links internos |
| Quote tweets | Aportar valor propio sobre el tweet original, nunca solo decir "de acuerdo" |
| Replies | Ser el comentario más útil de la sección, aportar dato, experiencia o pregunta inteligente |

### FASE 4 — Variantes
Generar al menos 2 variantes por pieza:
1. Versión más directa/agresiva (mayor engagement potencial, mayor riesgo).
2. Versión más segura/educativa (mayor retención, menor polarización).

### FASE 4b — Checklist de Pre-publicación
Antes de declarar una pieza lista, responder sí/no:
1. ¿Este contenido tiene al menos 1 detalle personal o específico del usuario?
2. ¿Aporta valor real (no es solo opinión sin sustancia)?
3. ¿Suena como lo escribiría el usuario, o como un template de IA?
4. ¿Tiene un hook que haría que el lector pare de scrollear?
5. ¿El CTA (si hay) invita a interactuar, no solo a leer?

Si la respuesta a 3 o más es "no": reescribir la piecha antes de entregarla.

### FASE 4c — Adaptación LinkedIn
Para cada pieza X, generar versión LinkedIn con:
- Intro personal/storytelling de 1-2 líneas.
- Body del tweet X, expandido a 2-3 párrafos con más contexto.
- CTA profesional (pregunta abierta o invitación a conectar).
- 3-5 hashtags relevantes.

Ejemplo:
- X: "Universidad te enseña teoría. X te enseña a pensar en público."
- LinkedIn: "Cuando empecé la Lic. en Gestión de TI en UADE, pensé que la universidad me iba a enseñar todo lo que necesitaba. Dos años después, descubrí que lo que realmente me formó fueron los proyectos que construí por fuera... [seguir]"

### FASE 5 — Validación y Cierre
1. Aplicar checklist de pre-publicación (FASE 4b).
2. Generar versión LinkedIn (FASE 4c).
3. Usar `workflows/validation.md` como cierre central.
4. Si la sesión genera más de 5 piezas de contenido o dura más de 30 minutos, crear checkpoint con `workflows/session_checkpoint.md` antes de cerrar.
5. Después de publicar, registrar en `x-content-feedback.md`: tema, métricas, aprendizaje.

Reportar:
- Qué funciona en el contenido.
- Qué no funciona y por qué.
- Cómo mejorarlo.
- Versión optimizada (X + LinkedIn).
- Variantes.
- Por qué tendría rendimiento.
- Métricas a trackear post-publicación.

## Regla final
No usar este workflow para todo. Elegir el enfoque más simple que mantenga claridad y voz auténtica. Nunca generar contenido motivacional vacío ni growth hacks baratos.
