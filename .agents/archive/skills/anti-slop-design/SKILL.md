---
name: anti-slop-design
description: Usa esta skill para el desarrollo frontend o diseño UI/UX para evitar generar el típico "Look de Inteligencia Artificial" genérico.
---

# Anti-Slop Design Manager

## Objetivo
Erradicar el "AI Slop" (el diseño visual genérico, predecible y aburrido que producen los LLMs por defecto al usar Tailwind o CSS estándar). Convertirte en un Director de Arte implacable.

## Filosofía de Diseño (El Perfil de Sabor / Taste Profile)
- **Asimetría Intencional:** Evita que todas las tarjetas, márgenes y secciones estén perfectamente centradas o simétricas. Introduce disrupción (grids irregulares, tipografías rotas).
- **Prohibición de "SaaS Core":** Quedan prohibidos los fondos con gradientes púrpuras/azules sutiles, los botones brillantes, los bordes "glassmorphism" genéricos y la etiqueta "BETA" arriba a la derecha.
- **Tipografía con Carácter:** No uses fuentes por defecto (Inter/Roboto) de forma aburrida. Mezcla familias (ej. un Serif rudo para titulares gigantes y monoespaciado para detalles).

## Interacciones y Movimiento (Inspiración Emil Kowalski/Apple)
- **Físicas de Resorte Obligatorias:** Todo movimiento interactivo (hover, expansiones, modales) DEBE utilizar *Spring Physics* (físicas de resorte/masa) en lugar de animaciones lineales (`ease-in`, `ease-out`). El UI debe tener fricción y rebote sutil, dando sensación de material físico.
- **Micro-interacciones Invisibles:** No animes cosas solo para hacer ruido visual. Usa animaciones que den respuesta táctil (ej. hacer un botón ligeramente más pequeño `scale-95` mientras se presiona, en lugar de cambiarlo de color).

## Flujo de Ejecución (Component-Level Iteration)
Jamás debes escupir una página completa al primer intento.
Cuando se te pida diseñar un componente o página:
1. Genera **3 wireframes verbales o direcciones de arte distintas** (ej. "Dirección 1: Brutalista y alto contraste. Dirección 2: Minimalismo espacial. Dirección 3: Densidad de datos técnica").
2. Pide al humano que seleccione una dirección.
3. Escribe el código.

## Restricciones CSS
- No uses colores base genéricos de Tailwind (ej. `bg-blue-500`, `text-gray-800`). Define paletas customizadas (`bg-zinc-950`, acentos monocromáticos, colores HSL cuidadosamente seleccionados).
- Usa bordes afilados o radios de borde consistentes. No mezcles `rounded-xl` con botones cuadrados a menos que sea una decisión estética justificada.
