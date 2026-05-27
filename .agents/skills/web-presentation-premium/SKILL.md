---
description: Crear presentaciones web premium, pitch decks web, demos visuales, landings interactivas con Three.js/GSAP
---

# Web Presentation Premium

## Cuándo NO alcanza (usar world-class-web)

Si el proyecto necesita cualquiera de estos, usar `workflows/world-class-web.md` en lugar de este skill:

- 3 escenas 3D o mas (alcoves narrativos)
- OffscreenCanvas + Web Worker para render 3D
- Pipeline de assets con Blender + Draco + KTX2
- 4 quality gates obligatorios (performance, accesibilidad, responsive, anti-slop)
- Budgets de performance concretos (Lighthouse >= 90, LCP < 2.5s)
- Perfiles predefinidos (luxury-3d, portfolio-3d)
- Scroll storytelling con camera path narrativo

Este skill es el entry point para webs premium de alcance contenido. `workflows/world-class-web.md` es el pipeline completo para proyectos ambiciosos.

---

## Qué es

Webs que se sienten premium. No ruidosas, no genéricas.
Cada elemento tiene intención: animación al servicio del mensaje, narrativa visual, microinteracciones.

El resultado debe verse como si un diseñador senior y un frontend senior hubieran trabajado juntos.

## Stack por defecto

- **Framework:** Astro (default) o Next.js (si necesita estado complejo)
- **Estilos:** Tailwind CSS siempre
- **3D:** Three.js (CDN, no bundle pesado) — solo si suma a la historia
- **Animaciones:** GSAP + ScrollTrigger para scroll storytelling
- **Deploy:** Vercel (default) o Netlify
- **Formularios:** Formspree, Resend o similar serverless

> Si no hay 3D ni scroll narrativo, Astro + Tailwind solo alcanza.

## Checklist de web premium

- [ ] Tiene scroll storytelling o animación con sentido
- [ ] Las transiciones son suaves (no fade default genérico)
- [ ] Tipografía con personalidad
- [ ] Paleta coherente en toda la página
- [ ] Microinteracciones (hover, scroll, click)
- [ ] Responsive en todos los breakpoints
- [ ] Lighthouse > 90 Performance
- [ ] Lighthouse > 90 Accessibility
- [ ] No hay Lorem ipsum - cada palabra está ahí por decisión
- [ ] CTA claro y visible sin hacer scroll
- [ ] Carga rápida en 3G simulado
- [ ] Sin dependencias innecesarias
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

Una web premium no es "más efectos". Es una idea clara, una narrativa fuerte y movimiento al servicio del mensaje.
