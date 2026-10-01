---
name: web-3d
description: "Use to build 3D on the web with three.js or React Three Fiber: hero scenes, product viewers, immersive landings, with performance budgets, mobile fallback and accessibility."
---

# Web 3D (three.js / React Three Fiber)

## ¿Hace falta 3D?

Usalo sólo si el 3D comunica algo que una imagen o un video no pueden: un producto que se rota, un espacio que se recorre o datos con profundidad. Si es decoración, preferí un video corto (`<video muted autoplay loop playsinline>`) o CSS: pesa menos y rinde igual en mobile.

## Stack

- **React/Next:** `@react-three/fiber` + `@react-three/drei`. Postprocesado con `@react-three/postprocessing`, sólo si suma.
- **Astro/vanilla:** `three` directo, o una isla React con `client:visible`.
- **Next:** montá el canvas con `dynamic(() => import(...), { ssr: false })`, dentro de `<Suspense>` con un fallback estático.
- Modelos en **glTF/GLB**. Optimizalos siempre con `npx @gltf-transform/cli optimize in.glb out.glb --compress meshopt --texture-compress ktx2` (o Draco) antes de commitear.

## Presupuesto de performance (mobile de gama media)

| Recurso | Límite orientativo |
|---|---|
| GLB total | ≤ 2–3 MB comprimido |
| Triángulos en pantalla | ≤ 300k |
| Draw calls | ≤ 100 (usá instancing y merge) |
| Texturas | KTX2, ≤ 2048², potencia de 2 |
| DPR | `dpr={[1, 2]}`; bajalo si cae el FPS (`PerformanceMonitor` de drei) |

- Usá `frameloop="demand"` si la escena no anima sola: renderiza sólo cuando cambia algo.
- Preferí iluminación horneada o un `Environment` HDR chico antes que muchas luces dinámicas. Las sombras en tiempo real sólo donde se ven.
- Cargá lazy: el canvas se monta cuando entra en viewport y el primer paint es el fallback estático.
- Liberá geometrías, materiales y texturas al desmontar (R3F lo hace solo con lo que crea; en vanilla, `dispose()`).

## Accesibilidad y SEO

- El contenido importante (títulos, texto, CTAs, precios) va en HTML fuera del canvas. El canvas es decoración y lleva `aria-hidden="true"`, o `role="img"` con `aria-label` si comunica algo.
- Respetá `prefers-reduced-motion`: sin autorotación ni parallax; dejá una pose estática.
- Fallback sin WebGL o en dispositivos débiles: imagen estática (poster) del mismo encuadre.
- Los controles de cámara no deben secuestrar el scroll de la página. En mobile, habilitá el drag sólo con un gesto explícito.

## Verificación

1. Captura en 390×844 y 1440×900. Criterios visuales: skill `frontend-design`.
2. FPS estable (≥ 50 en desktop, ≥ 30 en mobile medio) con `r3f-perf` o `stats.js`, sólo en desarrollo.
3. Lighthouse mobile: el canvas no puede empeorar el LCP (el LCP tiene que ser el fallback o el texto).
4. Probá con WebGL desactivado y con reduced-motion activo.
