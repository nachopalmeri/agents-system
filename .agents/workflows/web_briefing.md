---
description: Briefing obligatorio antes de crear una web, landing, presentación web, pitch o demo visual
---

# Workflow: Web Briefing

## Regla principal
Antes de crear una web desde cero o rediseñar una experiencia completa, preguntar qué busca el usuario si el objetivo no está explícito.

No empezar por código. Empezar por intención.
Si el usuario ya dio objetivo, audiencia, tono y contenido suficiente, no hacer preguntas innecesarias.

## Preguntas mínimas

1. **Objetivo**
   - ¿Qué querés lograr con esta web?
   - Opciones típicas: vender, explicar, impresionar, enseñar, presentar un TP, conseguir clientes, portfolio, validar idea.

2. **Audiencia**
   - ¿Quién la va a ver?
   - Profesor, cliente, recruiter, usuario final, inversor, comunidad, Google.

3. **Tono**
   - ¿Qué sensación tiene que dar?
   - Premium, divertido, académico, startup, técnico, minimalista, cálido, artesanal.

4. **Contenido base**
   - ¿De dónde sale la info?
   - Obsidian, README, texto pegado, PDF, repo, imágenes, web existente.

5. **Stack y formato**
   - HTML/CSS/JS para simple y rápido
   - Astro para landing estática/SEO
   - Next/React/Vite para app o demo interactiva

6. **Nivel de animación**
   - Sin animaciones
   - Microinteracciones
   - Scroll storytelling
   - GSAP
   - Three.js / 3D

7. **Entrega**
   - ¿Necesitás deploy, zip, GitHub, Vercel, presentación offline o solo código?

## Si el usuario dice “lo que vos digas”
Elegir por defecto:

- **Web simple/landing:** Astro o HTML/CSS/JS
- **Presentación facultad:** HTML/CSS/JS con scroll storytelling suave
- **Pitch startup/SaaS:** Next/React si hay interacción; Astro si es mostly static
- **Experiencia wow:** GSAP primero; Three.js solo si aporta al concepto
- **Componentes animados React (beUI):** beUI skill + Next.js + Tailwind 4 + Motion

## Routing de skills/agentes

- Para presentación premium: leer `web-presentation-premium`
- Para contenido desde Obsidian: activar `agente-obsidian-brain`
- Para narrativa: `agente-docs`
- Para UI/animación: `agente-design`
- Para implementación: `agente-principal`
- Para SEO: `agente-seo`
- Para validación: `agente-tests`

## Output esperado del briefing
Antes de implementar, responder con:

```text
Objetivo:
Audiencia:
Tono:
Stack elegido:
Nivel de animación:
Contenido fuente:
Estructura propuesta:
Qué NO voy a tocar:
Validación:
```

## Regla final
La web tiene que responder a una intención clara. Si no se sabe qué busca el usuario, preguntar antes de diseñar o codear.
Para cierre y QA web, usar `workflows/validation.md`.
