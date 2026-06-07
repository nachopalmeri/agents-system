---
name: premium-web-stack
description: Stack consolidado para webs premium 3D — Next.js + shadcn/ui + R3F + GSAP + Spline + Motion
allowed-tools: Read Write Grep WebSearch
---

# Premium Web Stack

## Cuándo usar

- Se va a construir una web premium, 3D, con animaciones.
- El usuario pregunta qué stack usar para una web "como Lovable/v0".
- Se necesita referencia rápida de librerías y versiones para un proyecto web premium.

## Stack completo

### Base (siempre)

| Tech | Versión | Uso |
|---|---|---|
| Next.js | 15+ (App Router) | Framework base. Solo Astro si no hay estado complejo. |
| Tailwind CSS | v4 | Estilos utility-first. Siempre. |
| shadcn/ui | latest | Componentes base. Botones, cards, dialogs, forms. |
| Radix UI | latest | Primitives accesibles debajo de shadcn. |
| TypeScript | 5.x | Tipado estricto. |
| Lucide React | latest | Iconos. |

### 3D (cuando aplica)

| Tech | Versión | Uso |
|---|---|---|
| React Three Fiber | latest | React renderer para Three.js. |
| Three.js | r182+ | Motor 3D. WebGPURenderer default. |
| Drei | latest | Helpers R3F: OrbitControls, Text3D, Environment, etc. |
| Spline | latest | Authoring 3D rápido. Importar .splinecode. |
| Blender + Draco + KTX2 | — | Pipeline de assets para modelos complejos. |

### Animaciones (cuando aplica)

| Tech | Versión | Uso |
|---|---|---|
| GSAP | 3.12+ | Scroll storytelling, timeline complejas. |
| ScrollTrigger | (incluido GSAP) | Scroll-linked animations. |
| Motion | latest (ex-Framer Motion) | Micro-interacciones, layout animations. |
| Locomotive Scroll | latest | Smooth scroll nativo. Alternativa: Lenis. |
| Barba.js | latest | Page transitions sin reload. Alternativa: View Transitions API. |

### Animaciones 2D (complemento)

| Tech | Uso |
|---|---|
| Anime.js | Animaciones CSS/JS ligeras. |
| Lottie | Animaciones vectoriales (After Effects → web). |
| AOS | Animate on scroll (simple, para landings). |
| React Spring | Animaciones physics-based en React. |

### Fonts

| Fuente | Uso |
|---|---|
| Google Fonts (variable) | Inter, Space Grotesk, Outfit, Sora, DM Sans |
| Fontshare | Alternativa gratuita con fonts premium |
| Regla | Usar variable fonts. Máximo 2 familias (display + body). |

### Deploy

| Plataforma | Uso |
|---|---|
| Vercel | Default. Edge functions, ISR, analytics. |
| Netlify | Alternativa. Forms built-in. |
| Cloudflare Pages | Si necesita edge global barato. |

## Setup rápido

```bash
# Next.js + Tailwind + shadcn/ui
npx create-next-app@latest my-premium-web --typescript --tailwind --app
cd my-premium-web
npx shadcn@latest init

# 3D
npm install three @react-three/fiber @react-three/drei

# Animaciones
npm install gsap motion lenis

# Iconos
npm install lucide-react
```

## Plugins Claude Code (claudedesignskills)

Opcionales, instalar según necesidad:

```bash
# Core 3D bundle (5 skills, 9 commands, 6 agents)
/plugin install core-3d-animation

# Individual
/plugin install threejs-webgl
/plugin install gsap-scrolltrigger
/plugin install react-three-fiber
/plugin install spline-interactive
/plugin install modern-web-design
/plugin install web3d-integration-patterns
```

Repo: [freshtechbro/claudedesignskills](https://github.com/freshtechbro/claudedesignskills)

## Anti-patterns

- ❌ No usar Create React App (deprecated). Next.js o Astro.
- ❌ No usar CSS modules si hay Tailwind. Uno solo.
- ❌ No importar Three.js completo. Usar tree-shaking: `import { Scene } from 'three'`.
- ❌ No usar Framer Motion si hay Motion (es el reemplazo).
- ❌ No mezclar GSAP y Motion para lo mismo. GSAP = scroll/timeline. Motion = micro-interacciones.
- ❌ No usar Lottie para animaciones simples que CSS resuelve.
- ❌ No cargar fonts no-variable. Siempre variable fonts.

## Conexiones

- `web-factory.md` — orquestación de agentes con este stack.
- `world-class-web.md` — pipeline 10 etapas para proyectos ambiciosos.
- `css-animations` skill — animaciones 2D puras.
- `web-presentation-premium` skill — webs premium alcance medio.
