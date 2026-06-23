---
name: beui
description: beUI motion components para React — Tailwind 4, React 19, Motion, vía shadcn registry. Incluye Tilt Card, Morphing Modal, Command Palette, Dynamic Island, Bouncy Accordion y +20 componentes copiables.
allowed-tools: Read Write Grep Bash
---

# beUI — Motion Components

## Cuándo usar

- Se necesita una web con UI animada y componentes listos para copiar-pegar.
- El stack es Next.js + Tailwind 4 + React 19 + Motion.
- Se busca una estética premium sin escribir animaciones desde cero.
- El usuario menciona "beUI", "motion components", "componentes animados React" o quiere algo "como beui.dev".

## Stack requerido

| Tech | Versión | Uso |
|---|---|---|
| Next.js | 15+ (App Router) | Framework base |
| Tailwind CSS | v4 | Estilos utility-first |
| React | 19 | UI |
| Motion | latest (ex-Framer Motion) | Animaciones base |
| shadcn/ui | latest | Integración via registry |

## Instalación

```bash
# Inicializar shadcn si no está
npx shadcn@latest init

# Instalar componentes beUI vía shadcn registry
bunx --bun shadcn add @beui/tilt-card
bunx --bun shadcn add @beui/morphing-modal
bunx --bun shadcn add @beui/command-palette
bunx --bun shadcn add @beui/dynamic-island
bunx --bun shadcn add @beui/bouncy-accordion
bunx --bun shadcn add @beui/drawer
bunx --bun shadcn add @beui/checkbox
bunx --bun shadcn add @beui/radio-group
bunx --bun shadcn add @beui/animated-toast-stack
bunx --bun shadcn add @beui/action-swap
bunx --bun shadcn add @beui/expandable-tabs
bunx --bun shadcn add @beui/file-upload
bunx --bun shadcn add @beui/prediction-market
bunx --bun shadcn add @beui/not-found
bunx --bun shadcn add @beui/expandable-action-bar
bunx --bun shadcn add @beui/overflow-actions
bunx --bun shadcn add @beui/swipeable-list
bunx --bun shadcn add @beui/otp-input
```

## Componentes

| Componente | Tipo | Cuándo usarlo |
|---|---|---|
| Tilt Card | Motion | Cards con efecto 3D hover |
| Button | Motion | Botones con spring feedback + estados (idle/loading/success/error) |
| Marquee | Motion | Texto/cards en scroll horizontal infinito |
| Tabs | Motion | Pill, segment o underline tabs con layoutId |
| Switch | Motion | Toggle switch animado |
| Checkbox | Motion | Checkbox con draw-on checkmark + indeterminate |
| Radio Group | Motion | Radio buttons con layoutId indicator |
| Bottom Sheet | Motion | Panel desde abajo con drag-to-dismiss |
| Dock | Motion | macOS-style dock con active pill |
| Tooltip | Motion | Tooltip animado |
| Morphing Modal | Motion | Modal que morphs height entre vistas |
| Text Animation | Motion | Texto con stagger, blur, fade |
| Number Animation | Motion | Contadores animados |
| Animated Badge | Motion | Badge con entrada/salida |
| Action Swap | Motion | CTA que swap texto/icono con blur |
| Animated Toast Stack | Motion | Toasts apilados con swipe dismiss |
| Theme Toggle | Motion | Dark/light toggle animado |
| Bouncy Accordion | Motion | Accordion con spring layout + icon rows |
| Drawer | Motion | Side panel con spring + backdrop blur |

## Blocks (páginas/composiciones)

| Block | Cuándo usarlo |
|---|---|
| Multi-chain Swap | Interfaz de swap crypto/DeFi |
| Dynamic Island | iOS-style island pill que morphs entre live activities |
| Command Palette | Cmd+K palette con fuzzy filter + glass surface |
| Expandable Action Bar | Iconos que se expanden a labeled controls |
| Overflow Actions | Pill rail que springs open para extra controles |
| Expandable Tabs | Icon tab bar + panel morphing |
| Swipeable List | Lista con swipe actions |
| File Upload | Drag-and-drop upload queue con progress rows |
| Prediction Market | Trade ticket con buy/sell, amount entry, chips |
| OTP Input | Input de código OTP |
| 404 / Not Found | 5 estilos de 404 animados |

## Reglas de uso

- Todos los componentes son copy-paste via shadcn registry. No requieren build step adicional.
- Usar `bunx --bun shadcn add @beui/[componente]` para instalar.
- Los componentes usan `motion` (ex-Framer Motion, v12+) para animaciones. No instalar framer-motion aparte.
- Los componentes beUI son complementarios a shadcn/ui base. Conviene tener ambos.
- Si el proyecto usa Astro + React islands, beUI funciona con `astro add react`.
- Si el proyecto usa solo Tailwind sin React, no usar beUI. Usar `css-animations` skill.
- beUI es MIT. Se puede modificar, copiar, redistribuir.

## Conexiones

- `premium-web-stack` skill — stack completo donde beUI es capa de componentes.
- `web-factory.md` — orquestación de agentes web. beUI se usa en `agente-web-layout`.
- `frontend-design` skill — diseño base. beUI acelera la implementación.
- `css-animations` skill — para animaciones 2D fuera de React.
- `web-presentation-premium` skill — si la web es presentación/pitch.

## Anti-patterns

- ❌ No instalar beUI si el proyecto no usa React. Son componentes React.
- ❌ No usar beUI si el stack es Astro sin islands de React. Usar CSS animations.
- ❌ No mezclar beUI con animaciones inline de Tailwind. beUI usa Motion para animaciones.
- ❌ No sobreelegir componentes. Preferir 2-3 componentes beUI bien usados vs 10 sin coherencia visual.
