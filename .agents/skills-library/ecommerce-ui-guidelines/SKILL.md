---
name: ecommerce-ui-guidelines
description: Usala al diseñar, prototipar o revisar UI de ecommerce, mockups o experiencias de compra (ficha de producto, carrito y checkout). Checklist destilada de Vercel Web Interface Guidelines, hallazgos públicos de Baymard y Laws of UX, más convenciones de Zentra.
---

# Guidelines de UI para ecommerce

Usá esta skill cuando diseñes, prototipes o revises pantallas de ecommerce. No reemplaza a `frontend-design` (dirección visual) ni a `/matt-prototype` (hay que invocarlo a mano). Se leen juntas.

Citas solo de fuentes públicas leídas el 2026-11-14. No inventar hallazgos de Baymard que no estén acá.

## Cómo prototipar en Zentra

1. Arrancá mobile-first a **390px**. Después cerrá desktop a **1440px**.
2. Invocá **`/matt-prototype` a mano** (tiene `disable-model-invocation: true`) y pedí **3 variantes HTML** distintas, no un solo mock.
3. Mantené consistencia con el tema actual de Tiendanube (tipografía, color, componentes y tono). No armes un look genérico de IA que rompa la tienda.
4. Mostrá el **descuento del 20% por transferencia de forma consistente** en ficha, carrito, checkout y resumen, hasta el primer pantallazo de checkout (nunca más allá en pruebas).
5. Si un dato no está confirmado (precio, stock, costo de envío, fecha, copy legal), escribí **`[a confirmar]`**. Nunca inventes cifras.
6. Revisá el prototipo contra este checklist y contra `frontend-design`.

## Vercel Web Interface Guidelines

Fuente: [vercel.com/design/guidelines](https://vercel.com/design/guidelines)

### Interacción y foco
- Todo el flujo se recorre con teclado y sigue patrones WAI-ARIA.
- Cada control focusable tiene un anillo visible (`:focus-visible`, no solo `:focus`). Headers, footers, banners y overlays sticky nunca tapan el foco.
- Trampas de foco, mover y devolver el foco según WAI-ARIA.
- Si el target visual es < 24px, agrandá el hit target a ≥ 24px. En mobile, mínimo **44px**.
- Inputs en mobile a **≥ 16px** para que iOS Safari no haga zoom al enfocar. Nunca deshabilites el zoom del browser.
- No bloquees pegar en campos. No pierdas foco ni valor al hidratar.
- Botón de carga: spinner + el label original. Delay corto (~150–300 ms) y tiempo mínimo visible (~300–500 ms) para no parpadear.
- Confirmá acciones destructivas o dale Undo. Los gestos (drag, swipe, pinch) tienen alternativa con click/tap y teclado.
- Los links son links (`<a>`): Cmd/Ctrl+click y click del medio tienen que funcionar. No uses un `<button>` para navegar.
- `touch-action: manipulation` en controles para evitar zoom por doble tap.
- Autofocus solo en desktop cuando hay un input primario. En mobile, casi nunca (el teclado mueve el layout).
- Persistí estado en la URL (filtros, tabs, paginación) para que funcionen compartir, refresh y atrás/adelante.

### Accesibilidad
- Semántica nativa antes que ARIA (`button`, `a`, `label`, `table`).
- Headings jerárquicos y un “Saltar al contenido”.
- No comuniques estado solo con color; sumá texto. Los botones solo-ícono llevan `aria-label`.
- Anunciá updates asíncronos con `aria-live` educado (toasts, validación).
- Media con captions/transcripciones cuando hay habla o info visual esencial.
- Preferí contraste perceptual sólido (Vercel sugiere APCA por encima de WCAG 2). Hover/active/focus suben el contraste, no lo bajan.

### Formularios
- Todo control tiene label asociado; click en el label enfoca el control.
- Enter envía si es el único control (o el último). En textarea, Enter es salto de línea y ⌘/⌃+Enter envía.
- No dejes el submit pre-deshabilitado: dejá enviar para mostrar validación. Durante el request, deshabilitalo, mostrá spinner y usá idempotencia.
- Errores al lado del campo; al enviar, el foco va al primer error.
- `autocomplete` y `name` reales para autofill. `type` e `inputmode` correctos. Spellcheck off en email, códigos y usuario.
- No bloquees teclas aunque el campo sea numérico: dejá tipear y validá con feedback.
- Placeholders son ejemplos (terminan en ellipsis), no labels. Avisá si hay cambios sin guardar.

### Tipografía y contenido
- Títulos de página precisos al contexto. Números tabulares (`font-variant-numeric: tabular-nums`) para precios y comparaciones.
- Formateá fechas, números y moneda según locale. En un mismo contexto, la moneda va con 0 o con 2 decimales, nunca mezcles.
- Separá cifra y unidad con espacio de no separación (`10 MB`).
- Copy en voz activa, clara y específica: el botón dice lo que hace (“Guardar cambios”, no “Enviar” / “Continuar”). Errores dicen cómo salir del problema.
- Todas las pantallas tienen estado vacío, error, escaso y denso, y una salida. Nada de callejones sin salida.

### Motion y layout
- Respetá `prefers-reduced-motion`. Preferí CSS; animá `transform` y `opacity`, nunca `transition: all`.
- Motion no disparada por el usuario: poca y con un solo momento orquestado. La que responde a una acción (abrir, confirmar) sí suma.
- Animaciones interrumpibles. Autoplay solo si es mute, no esencial, y con pausa si dura > 5s.
- Alineación deliberada (grilla, baseline u óptica). Safe areas para notch. Flex/grid antes que medir en JS.
- Skeletons estables, mismas dimensiones que el contenido final. Imágenes con tamaño explícito para no mover el layout.

### Performance
- Precargá solo lo above-the-fold; el resto, lazy. Preload de fuentes críticas y subset.
- Listas largas: virtualizar o `content-visibility`. Trabajo pesado fuera del main thread.
- Video en vez de GIF animado. Probar con CPU/red limitados, iOS Low Power y Safari.

## Baymard (hallazgos públicos 2026)

Solo lo publicado en estos artículos, leídos el 2026-11-14. Baymard tiene 700+ guidelines de pago; esto no es el catálogo completo.

### Ficha de producto
Fuente: [Product Page UX 2026](https://baymard.com/research-articles/current-state-ecommerce-product-page-ux) (actualizado 18 mar 2026).

Benchmark: 52% desktop, 62% mobile y 64% apps tienen UX de ficha “mediocre o peor”. Ningún sitio llega a “perfect”.

1. **Talles con botones**, no dropdown (57% no lo hace). El dropdown esconde el stock y frustra cuando no hay talle.
2. **Fotos “in scale”** con una persona u objeto conocido (37% no). El 42% de usuarios estima el tamaño por la foto.
3. **Foto con modelo humano** cuando el producto se usa en el cuerpo (23% no), para entender calce y caída.
4. **Guardar / wishlist fácil de encontrar y usar** (89% no).
5. **Precio por unidad** si hay distintos tamaños o cantidades (81% no), para comparar el negocio real.
6. **Estimación del costo total cerca del comprar** (envío, impuestos, recargos) (67% no). Los costos escondidos abandonan más adelante.
7. **Política de devolución visible o linkeada en el contenido principal** de la ficha (44% no).
8. Si hay gifting, **mostrá la opción también en la ficha** (78% no).
9. **Respondé reseñas negativas** (89% no).
10. Se puede **navegar las fotos de reseñas en un carrusel** con flechas o gestos (63% no).

### Carrito y checkout
Fuente: [Checkout UX 2026](https://baymard.com/research-articles/current-state-of-checkout-ux) (actualizado 3 nov 2026). El artículo cubre el tema Cart & Checkout.

Benchmark: 59% de sitios desktop y mobile, y 60% de apps, tienen checkout “mediocre o peor”. En una encuesta a 1.000+ shoppers, el 17% abandonó una compra en los últimos 3 meses porque el checkout era demasiado largo o complejo. Baymard está retesteando esta investigación; esperan publicar la versión nueva en el 2º trimestre de 2027.

1. **Checkout de invitado** siempre disponible. La invitación a crear cuenta, **recién en la confirmación** (56% no). Pedirla al inicio o a mitad de camino distrae y parece pushy.
2. En checkout accordion, los pasos hechos se **colapsan en un resumen editable** (72% no), para revisar datos sin reabrir todo.
3. Mostrá **fecha (o rango) de entrega**, no “2–3 días hábiles” (48% no). La pregunta real es “¿cuándo me llega?”.
4. El cutoff de envío va como **countdown** (“pedí en los próximos 43 min para recibirlo el martes”), no como hora estática en otra zona (83% no).
5. Cantidad en el carrito: **botones +/−, o botones más un campo de texto** (95% no). Un input solo tiende a errores (queda “21” en vez de “2”), peor en mobile.
6. **Todas las formas de cumplimiento** (envío, pickup, delivery local) viven en el selector de shipping del checkout (53% no). No obligues a volver al carrito.
7. **Marcá explícitos los campos obligatorios y los opcionales** (50% no). Si solo marcás unos, o ninguno, el 32% de participantes dejó al menos un required vacío.
8. Inputs opcionales poco comunes (piso, dpto, empresa) **atrás de un link**, no en el flujo principal (33% no usa bien el tipo de interfaz). Evitá radios y dropdowns para algo totalmente opcional.
9. Si el teléfono es required, **explicá para qué** (47% no). El 68% de encuestados es reacio a darlo; sin explicación inventan el número o abandonan.
10. Si hay gifting, se puede **marcar el regalo en el carrito** y también más adelante en el checkout si se puede saltear el carrito (68% no).

## Laws of UX (esenciales para ecommerce)

Fuente: [lawsofux.com](https://lawsofux.com/) (Jon Yablonski). Aplicá la ley al problema; no la cites de adorno.

- **Jakob’s Law.** La gente espera que la tienda funcione como las que ya usa. No rediseñes el checkout por originalidad.
- **Hick’s Law / Choice Overload.** Más opciones, más tarda la decisión. Recortá variantes visibles, destacá una recomendada, partí el checkout en pasos chicos.
- **Fitts’s Law.** El tiempo al target depende de distancia y tamaño. CTA y controles de carrito grandes, con aire, cerca de donde está la atención. En mobile, ≥ 44px.
- **Doherty Threshold.** Feedback en **< 400 ms**. Si hay espera, perceived performance: skeleton, progreso, no pantalla muerta.
- **Goal-Gradient Effect.** Cuanto más cerca del final, más avanzan. Barra de progreso clara en checkout; no agregues fricción al final.
- **Miller / Chunking / Cognitive Load.** Agrupá info (precio, envío, descuentos, totales). No satures la ficha ni el form.
- **Peak-End Rule.** Se juzga el pico y el final: confirmación de compra clara, calma y útil.
- **Postel’s Law.** Sé liberal al aceptar (tarjeta con espacios, mayúsculas, whitespace) y conservador al mostrar.
- **Von Restorff.** Un solo CTA primario se diferencia del resto. No compitas “Comprar” con cinco botones iguales.
- **Aesthetic-Usability Effect.** Si se ve cuidado, se percibe más usable; el pulido no es cosmética, baja fricción percibida.
- **Serial Position.** Lo más importante (precio final, envío, CTA, políticas clave) va al inicio o al final del bloque, no perdido al medio.

## Fuentes

- Vercel Web Interface Guidelines: https://vercel.com/design/guidelines
- Baymard Product Page UX 2026: https://baymard.com/research-articles/current-state-ecommerce-product-page-ux
- Baymard Checkout UX 2026: https://baymard.com/research-articles/current-state-of-checkout-ux
- Laws of UX: https://lawsofux.com/
