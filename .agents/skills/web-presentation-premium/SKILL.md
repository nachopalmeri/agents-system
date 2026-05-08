---
name: web-presentation-premium
description: Crear webs/presentaciones premium para facultad, pitches, demos y proyectos usando storytelling visual, animaciones, GSAP, Three.js o frontend moderno. Usar cuando el usuario pida una presentación web, landing interactiva, pitch deck web, demo visual, sitio con animaciones, Three.js, GSAP o una web digna de frontend senior.
---

# Web Presentation Premium

## Objetivo
Transformar una presentación normal, entrega de facultad, pitch o demo en una experiencia web memorable con narrativa, diseño, animación y claridad.

## Antes de crear cualquier web
Siempre preguntar qué busca el usuario si no está claro:

1. ¿Cuál es el objetivo? (vender, explicar, impresionar, enseñar, presentar TP, portfolio)
2. ¿Quién es la audiencia? (profesor, cliente, recruiter, usuario final, inversor)
3. ¿Qué tono quiere? (premium, divertido, académico, startup, técnico, minimalista)
4. ¿Qué stack prefiere? (HTML/CSS/JS, Astro, Next, React/Vite)
5. ¿Qué nivel de animación? (simple, scroll storytelling, GSAP, Three.js)
6. ¿Qué contenido base existe? (Obsidian, README, PDF, texto, repo, imágenes)
7. ¿Qué deadline y formato final necesita? (deploy, zip, GitHub, Vercel)

Si el usuario dice “lo que vos digas”, elegir la opción más simple que logre impacto.

## Cuándo usar HTML/CSS/JS
Usar para:
- Presentaciones rápidas
- Entregas de facultad
- Demos offline
- Sitios de una sola página
- Cuando no hace falta routing ni estado complejo

Estructura:

```text
presentation/
├── index.html
├── styles.css
├── app.js
├── assets/
└── README.md
```

## Cuándo usar Astro
Usar para:
- Landings estáticas premium
- SEO importante
- Contenido principalmente estático
- Sitios rápidos y deployables

## Cuándo usar Next/React/Vite
Usar para:
- Interacciones complejas
- Componentes reutilizables
- Demos con estado
- Dashboards o prototipos SaaS

## Cuándo usar GSAP
Usar cuando:
- La narrativa depende del scroll
- Hay reveals, parallax, timeline o secuencias
- Se busca efecto “wow” controlado

No usar GSAP para microinteracciones simples que CSS puede resolver.

## Cuándo usar Three.js
Usar cuando:
- El concepto se beneficia de 3D o espacialidad
- Hay una metáfora visual fuerte
- La presentación necesita impacto visual alto

No usar Three.js solo por moda. Si no agrega claridad, evitarlo.

## Estructura narrativa recomendada

1. **Hook** — una frase/visual que captura atención
2. **Problema** — qué duele o qué se intenta resolver
3. **Insight** — el ángulo inteligente
4. **Solución** — qué se construyó o propone
5. **Demo/Proceso** — cómo funciona
6. **Impacto** — resultados, métricas o aprendizaje
7. **Cierre** — conclusión clara + next step

## Checklist de calidad
- [ ] Se entiende en 10 segundos
- [ ] Tiene un hook visual o textual fuerte
- [ ] No depende de animaciones para comunicar lo esencial
- [ ] Responsive mobile/desktop
- [ ] Performance aceptable
- [ ] Accesible: contraste, foco, textos legibles
- [ ] No hay animaciones que mareen
- [ ] Tiene narrativa, no solo secciones lindas
- [ ] Si es facultad: responde exactamente a la consigna
- [ ] Si es pitch: deja clara la propuesta de valor

## Conexión con Obsidian
Si el contenido existe en el vault:
- Leer notas del proyecto/clase
- Extraer conceptos principales
- Convertir en guion
- Crear estructura de secciones
- Mantener links o referencias útiles

Fuentes típicas:
- `Efforts/A Q1 2026/` para clases
- `Proyects/` para proyectos
- `Atlas/Maps/` para MOCs
- `Clippings/` para referencias externas

## Agentes recomendados
- `agente-obsidian-brain` → extrae contenido y conceptos del vault
- `agente-docs` → arma guion/storytelling
- `agente-design` → visual, responsive, animación
- `agente-principal` → estructura e implementación
- `agente-tests` → validación final

## Regla final
Una web premium no es “más efectos”. Es una idea clara, una narrativa fuerte y movimiento al servicio del mensaje.
