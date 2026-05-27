---
description: Quality gate de performance para world-class-web, basado en referencias reales de producción (PorscheLab 100/100)
---

# Performance Gate

## Budgets obligatorios

| Métrica | Objetivo | 
|---|---|
| Lighthouse Performance | >= 90 |
| Lighthouse Accessibility | >= 90 |
| Lighthouse Best Practices | >= 90 |
| LCP | < 2.5s |
| TBT | < 200ms |
| CLS | < 0.1 |
| SI | < 3.0s |
| FPS (desktop) | 60fps estable |
| FPS (mobile baseline) | 30fps estable |

## Bundle budgets

| Recurso | Budget |
|---|---|
| JS total (gzipped) | < 500KB |
| CSS total (gzipped) | < 200KB |
| Assets críticos | < 300KB |
| Textures total (comprimido) | < 2MB KTX2/Basis |
| Heap memory (3D scenes) | < 200MB |
| Network requests (critical) | < 15 |

## Tools

- Lighthouse CI
- Chrome DevTools Performance tab
- Web Vitals extension
- Bundle analyzer (vite-bundle-visualizer)
- Safari Web Inspector
- Firefox Profiler

## Referencia

PorscheLab: 100/100 Lighthouse con 3D fotorealista en producción vía @property + perspective + transform. Imágenes lazy cargadas vía IntersectionObserver.

## Hard stop

Si Lighthouse Performance < 90, no deployar.
