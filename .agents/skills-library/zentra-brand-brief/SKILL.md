---
name: zentra-brand-brief
description: Usala SIEMPRE antes de cualquier mockup, prototipo, rediseño o pieza de UI para Zentra (zentra.com.ar, Tiendanube). Obliga a leer la marca real, armar un brief con referencias y dirección, generar 3 variantes realmente distintas y autocriticarlas contra la lista de AI slop antes de mostrarlas.
---

# Zentra brand brief: nada de diseño sin brief

Antes de diseñar, el brief. No escribas HTML/CSS hasta completar los pasos 1 a 3 y mostrar el brief.

**Jerarquía (gana lo de arriba):** spec de `/zentra:requirements-interview` > Design System de Zentra y skills `zentra-marca` / `zentra-copywriting` (si están disponibles) > `references/brand.md` > esta skill > `frontend-design` / `impeccable`. Esta skill no reemplaza a `zentra-prototype`: le agrega el brief, las referencias y la autocrítica.

## 1. Leer la marca real (no de memoria)
- Leé `references/brand.md`. Si tiene más de 60 días, o si el pedido toca algo que no cubre, volvé a mirar el sitio:
  `curl -sL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36" https://zentra.com.ar` y la ficha afectada. Sacá variables CSS (`--button-background`, `--main-foreground`, etc.), fuentes de Google Fonts y copy real.
- Si podés, abrí la página en navegador (Playwright) a 390 y 1440 y mirá fotos, densidad y ritmo. La foto/estilo visual se verifica mirando, no leyendo HTML.
- Todo lo que no verificaste va como `[a confirmar]`. Nunca inventes precios, plazos, stock, cuotas, reseñas ni números.
- Si cambiaste algo de la marca, actualizá `references/brand.md` con URL y fecha.

## 2. Referencias concretas (2-3, obligatorio)
- Pedile a Ignacio sus referencias (capturas de Mobbin o links). Si no tiene, proponé 2-3 de ecommerce top y explicá QUÉ tomás de cada una (un patrón concreto, no "la vibra"): Apple (ficha y configurador), Herman Miller / Uplift Desk (configurador de escritorio/silla, specs), Allbirds (claridad de ficha, materiales), Aesop (tono, fotografía, ritmo editorial).
- Son referencias, no plantillas: no copies layout ni assets.

## 3. Brief (mostralo antes de diseñar, máx. 15 líneas)
- Objetivo y métrica (ej. % que reserva visita al showroom desde mobile).
- Usuario y momento (desde dónde llega, qué duda tiene).
- Restricciones: theme Tiendanube actual, marca de `references/brand.md`, performance (LCP ya es alto: nada de imágenes pesadas ni JS innecesario).
- Para cada una de las 3 variantes: **dirección** (1 línea), **hipótesis** que prueba y **una idea audaz** (algo que una tienda genérica no haría y que sale del producto: ej. mostrar la altura del escritorio con la persona real, el showroom de Palermo como protagonista, comparador Lite vs PRO tangible).
- Las 3 tienen que diferir en estructura o enfoque, no solo en colores.

- **Etapa 4 del onboarding:** las direcciones las pone Ignacio (regla de `zentra-prototype`). Pedíselas; vos solo completás hipótesis y chequeás que sean distintas de verdad.

## 4. Construir
- **En el repo de Zentra (WSL):** usá `zentra-prototype` (manda sobre `matt-prototype`), con la spec si existe (`docs/specs/*.md`).
- **Fuera del repo** (mockup suelto, portfolio): `/matt-prototype` (invocación manual).
- Cargá `frontend-design`, `ecommerce-ui-guidelines` e `impeccable` (modo Persuade para home/landing, Operate para checkout/agenda).
- Copy en español rioplatense con voseo, corto, concreto, como el sitio actual. Placeholders honestos: `[a confirmar]`.

## 5. Autocrítica antes de mostrar (obligatoria)
Para cada variante:
1. Screenshots a 390 px y 1440 px (Playwright). Miralos vos antes que Ignacio.
2. Pasala contra `ecommerce-ui-guidelines` y la lista de slop de abajo. Si podés, corré `impeccable detect <archivo o URL>` (launcher en `~/.agents/skills/impeccable/scripts/impeccable`, `.cmd` en Windows) o `/impeccable critique`.
3. Corregí lo que falle y recién ahí mostrá: screenshots + dirección + hipótesis + lo que corregiste + lo que queda `[a confirmar]`.

## Lista de AI slop prohibida (salvo que el brief lo pida explícitamente)
- Gradientes violeta/índigo o azul-violeta de relleno. **Ojo:** el violeta del logo (#6158FF / `--accent-color` #5F57F9) es de la marca: se usa como acento puntual, nunca como gradiente ni fondo de hero.
- Hero genérico: H1 centrado + subtítulo + 2 botones sobre fondo liso o gradiente.
- Íconos emoji, íconos en cuadradito redondeado arriba de cada título.
- Glassmorphism, glow, sombras de colores y blur por todos lados.
- Inter/Roboto por defecto: Zentra usa Plus Jakarta Sans + Urbanist.
- Grilla de 3 cards de features iguales; cards dentro de cards.
- Copy genérico: "Elevá tu experiencia", "Descubrí", "Transformá tu forma de trabajar", "solución integral", lorem ipsum, mayúsculas de hype.
- Testimonios, ratings, logos de prensa o stats inventados ("+10.000 clientes felices"). Solo datos reales del sitio con fuente.
- Badges "NUEVO"/"BETA" decorativos, flechas → en todos los botones, animaciones bounce/elastic, todo centrado.
- Texto gris sobre fondo de color, contraste bajo, tap targets < 44 px.

## Reglas
- Nunca entregues una sola variante.
- No toques la tienda real ni el theme desde esta skill: esto es prototipo. Implementar va por el flujo de Leo.
- Después de elegir variante: `web-quality-audit` / `core-web-vitals` / `accessibility` a demanda, y `/smoke` + `/perf-check`.
