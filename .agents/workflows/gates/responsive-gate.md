---
description: Quality gate responsive para world-class-web - prueba y degradación elegante en todos los dispositivos
---

# Responsive Gate

## Viewports a probar

| Dispositivo | Resolución |
|---|---|
| Desktop XL | 1920x1080 |
| Desktop | 1440x900 |
| Laptop | 1366x768 |
| Tablet landscape | 1024x768 |
| Tablet portrait | 768x1024 |
| Mobile large | 430x932 |
| Mobile small | 375x667 |
| Foldable | 717x512 (dual screen) |

## Checklist

- [ ] Sin scroll horizontal en ningún viewport
- [ ] Texto legible sin zoom
- [ ] Touch targets >= 48x48px en mobile
- [ ] Gestures: swipe, pinch, scroll funcionan en touch
- [ ] Degradación 3D: WebGPU fallback a WebGL 2.0
- [ ] Degradación animaciones: `prefers-reduced-motion` respetado
- [ ] Canvas se redimensiona correctamente (ResizeObserver)
- [ ] Responsive images con `<picture>` o `srcset`
- [ ] Menú mobile funcional (hamburguesa o equivalente)
- [ ] Formularios usables en mobile (no zoom automatico en inputs)

## Hard stop

Si hay scroll horizontal, texto ilegible, o CTA no accesible en mobile, no deployar.
