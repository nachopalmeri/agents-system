---
description: Pipeline completo para crear websites 3D/immersive de clase mundial con Three.js, WebGPU, GSAP y scroll storytelling
---

# World-Class Web Pipeline

## Principio

No alcanza con que "se vea lindo". Una web de clase mundial es un sistema: concepto → narrativa → tecnología → performance → accesibilidad, todo alienado. Este workflow NO es para landings simples — es para proyectos ambiciosos con 3D, scroll storytelling o animaciones premium.

## Entry Point

Para proyectos de alcance contenido, usar la skill `web-presentation-premium`. Para orquestación con agentes sandboxed en paralelo (tipo Lovable), usar `web-factory.md`. Este pipeline es para cuando ninguno de los dos alcanza.

## Pipeline (10 etapas)

### 1. Briefing Estratégico

Leer `workflows/web_briefing.md`. Extraer:

- Objetivo del sitio (vender, mostrar, explicar, marcar presencia)
- Audiencia y tono
- Stack preferido o definido por el proyecto
- Palabras clave y propuesta de valor
- CTA principal
- Deadline y restricciones

**Criterio de salida:** brief aprobado antes de pasar a concepto.

### 2. Concepto y Narrativa

- Definir scroll story: entrada → desarrollo → clímax → CTA
- Elegir perfil si aplica: `profiles/luxury-3d.md`, `profiles/portfolio-3d.md`
- Definir paleta, tipografía, tono visual
- Sketch de secciones: Hero, About, Features, Gallery, CTA
- Mapa de scroll: qué pasa en cada scroll position

**Regla:** cada sección debe responder "¿por qué está acá?"

### 3. Arquitectura 3D

Leer `references/three-js-strategy.md`. Definir:

- Qué es 3D: fondo, objeto navegable, alcoves narrativos, o full scene
- Budget de polígonos por escena
- Estrategia de assets: procedural vs. Blender → Draco → KTX2
- Cámara: fija, orbit, scroll-path, look-at narrative
- Iluminación: ambiente + directional + IBL si aplica
- Post-processing: bloom, DOF, SSR solo si suma a la narrativa

**Regla:** Three.js r182+, WebGPURenderer default, OffscreenCanvas + Web Worker obligatorio para render 3D.

### 4. Scroll Storytelling

Leer `references/scroll-storytelling.md`. Implementar:

- Scroll-linked animation con GSAP ScrollTrigger
- Camera path narrativo sincronizado con scroll
- Alcoves (escenas 3D autónomas que aparecen en scroll position)
- Timing: cada beat debe tener propósito narrativo

**Regla:** no más de 3 alcoves sin probar en dispositivo real. PorscheLab: 100/100 Lighthouse con 3D fotorealista.

### 5. Performance Budget

Leer `gates/performance-budget.md`. Cumplir:

- Lighthouse >= 90 (Performance, Accessibility, Best Practices)
- LCP < 2.5s, TBT < 200ms, CLS < 0.1
- Bundle: < 500KB JS, < 200KB CSS, < 300KB assets críticos
- Texture budget: < 2MB total comprimido (KTX2/Basis)
- FPS: 60fps en desktop, 30fps móvil baseline
- Memory: < 200MB heap para escenas 3D

**Referencia:** PorscheLab demostró 100/100 Lighthouse con 3D en producción.

### 6. Implementación

- Astro + React para shell de la página
- Three.js para escenas 3D en canvas separado (Web Worker)
- GSAP para scroll + animations del DOM
- Tailwind para estilos del shell
- TypeScript everywhere

**NO usar:**
- Bibliotecas 3D pesadas (Babylon.js, PlayCanvas) salvo que el proyecto lo justifique
- Frameworks CSS que dupliquen Tailwind
- Dependencias innecesarias — cada librería debe justificar su peso

### 7. Anti-AI-Slop

Leer `gates/ai-slop-test.md`. Pasar:

- No hay animaciones que no tengan sentido
- Las transiciones son suaves y con easing natural
- La tipografía es legible en todos los tamaños
- No hay texto genérico "Lorem ipsum" — cada palabra está ahí por decisión
- El 3D no es decorativo — sirve a la narrativa
- No hay overlaps raros ni z-fighting
- El scroll no es secuestrado ni forzado
- No hay partículas que distraigan del contenido

### 8. Accesibilidad

Leer `gates/accessibility-gate.md`. Cumplir:

- WCAG 2.2 AA mínimo
- Navegación por teclado completa
- Contraste suficiente en overlays 3D
- Alt text en canvas (fallback narrativo)
- Reduced motion: detectar `prefers-reduced-motion` y ofrecer experiencia estática
- Screen reader: anunciar cambios de escena

### 9. Responsive

Leer `gates/responsive-gate.md`. Probar:

- Desktop 1920x1080, 1440x900
- Tablet 1024x768, 768x1024 landscape
- Mobile 390x844, 375x667
- Degradación elegante: si el dispositivo no soporta WebGPU, fallback a WebGL 2.0
- Touch: gestures, scroll, tap targets

### 10. Despliegue y Validación Final

- Build y deploy a Vercel o Netlify
- Correr los 4 gates antes de declarar listo
- Verificar analytics post-deploy (PostHog o similar)
- Si hay producto: conectar eventos (signup, CTA click, scroll depth)

## Quality Gates Obligatorios

Antes de declarar listo, correr:

| Gate | Archivo |
|---|---|
| Anti-AI-Slop | `gates/ai-slop-test.md` |
| Performance | `gates/performance-budget.md` |
| Accesibilidad | `gates/accessibility-gate.md` |
| Responsive | `gates/responsive-gate.md` |

## Perfiles Predefinidos

| Perfil | Cuándo usar | Archivo |
|---|---|---|
| Luxury-3D | Marcas premium, alta gama, storytelling visual | `profiles/luxury-3d.md` |
| Portfolio-3D | Showcases, agencias, portfolios interactivos | `profiles/portfolio-3d.md` |

## Paleta Mental

```
Concepto → Narrativa → 3D al servicio → Performance como feature → Accesibilidad no negociable
```

## Regla final

No usar este workflow para landings simples. Si el proyecto no necesita 3 escenas 3D o scroll storytelling complejo, usar `web-presentation-premium`. Si se quiere orquestación con agentes sandboxed en paralelo, usar `web-factory.md`.

## Plugins Claude Code (3D skills)

Para patrones avanzados de Three.js, GSAP, R3F, Spline, etc., instalar plugins de [claudedesignskills](https://github.com/freshtechbro/claudedesignskills):

- `core-3d-animation` bundle (5 skills, 9 commands, 6 agentes)
- `threejs-webgl`, `gsap-scrolltrigger`, `react-three-fiber`, `spline-interactive`
- `modern-web-design`, `web3d-integration-patterns`

Ver skill `premium-web-stack` para referencia completa de stack y plugins.
