---
description: Quality gate de accesibilidad para world-class-web, siguiendo WCAG 2.2 AA
---

# Accessibility Gate

## Checklist obligatorio

- [ ] WCAG 2.2 AA verificado
- [ ] Navegación por teclado completa (Tab, Enter, Escape, flechas)
- [ ] Focus visible en todos los elementos interactivos
- [ ] Skip to content link presente
- [ ] Contraste de color >= 4.5:1 (texto normal), >= 3:1 (texto grande)
- [ ] Contraste suficiente en overlays sobre canvas 3D
- [ ] Alt text descriptivo en canvas (fallback narrativo)
- [ ] `prefers-reduced-motion` detectado y respetado
- [ ] Versión estática disponible sin animaciones ni 3D
- [ ] Screen reader: anuncios de cambios de escena con `aria-live`
- [ ] Landmarks semánticos: `<nav>`, `<main>`, `<footer>`
- [ ] Heading hierarchy (h1 → h2 → h3) sin saltos
- [ ] Formularios con `<label>` asociado
- [ ] Mensajes de error claros y anunciados
- [ ] Zoom al 200% sin pérdida de contenido

## Tools

- axe DevTools para auditoría automatizada
- Lighthouse Accessibility section
- WAVE para validación visual
- NVDA o VoiceOver para screen reader

## Hard stop

Si no pasa WCAG 2.2 AA, no deployar.
