---
name: astro
description: Skill para proyectos Astro — estructura, reglas, comandos y errores comunes
---

# Skill: Astro

## Activar cuando
El proyecto tiene astro.config.mjs o usa Astro como framework.

## Estructura
src/components/  → componentes reutilizables (.astro, .tsx)
src/pages/       → rutas (generadas automáticamente)
src/layouts/     → layouts compartidos
src/lib/         → lógica de negocio, helpers, utils
public/          → assets estáticos (imágenes, fuentes)
astro.config.mjs → config (archivo sagrado)

## Reglas Específicas
- Usar import.meta.env para variables de entorno
- client:load solo para componentes que necesitan JS en cliente
- No modificar astro.config.mjs sin confirmar con el director
- Islands architecture: mínimo JS en cliente

## Comandos
npm run dev      → desarrollo (puerto 4321 por defecto)
npm run build    → build de producción
npm run preview  → preview del build
npm run check    → verificar tipos TypeScript

## Errores Comunes a Evitar
- No olvidar client:load en componentes interactivos
- No mezclar lógica de servidor con lógica de cliente
- No importar CSS de node_modules directamente en .astro
