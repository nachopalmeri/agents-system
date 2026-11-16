# Marca Zentra: datos relevados del sitio

Fuente: https://zentra.com.ar/ (home) y https://zentra.com.ar/productos/standing-desk-z90-lite/ (ficha).
Fecha: 2026-11-14, ~21:20 (hora de Buenos Aires). Método: HTML con UA de Chrome (variables CSS del theme, Google Fonts, copy). Plataforma: Tiendanube (theme base "brasilia" + Tailwind con prefijo `tw-`).

## Logo
- Wordmark "zentra" en minúscula, sans geométrica, con un isotipo "Z" estilizado a la izquierda. Color violeta #6158FF (medido en el archivo del logo). Se usa a 42 px de alto en el header, sobre fondo blanco.
- Archivo: https://acdn-us.mitiendanube.com/stores/005/728/539/themes/common/logo-177958221-1742228719-5e5aca4ae570d959f06f940f706615e21742228719-320-0.webp
- Versión en negativo o monocromo: [a confirmar].

## Colores (variables CSS del theme)
| Rol | Hex | Variable / uso |
|---|---|---|
| Violeta de marca (logo, acento) | #5F57F9 (logo #6158FF) | `--accent-color` |
| Naranja CTA / barra de anuncios | #FF5F00 | `--button-background`, `--primary-adbar-background`, foco de inputs |
| Texto de botón | #F3F3F3 | `--button-foreground` |
| Texto principal / footer | #141413 | `--main-foreground`, `--footer-background` |
| Texto header / nav | #3F3D38 | `--header-foreground` |
| Fondo | #FFFFFF | `--main-background`, header |
| Lima destacado / adbar secundaria | #C6D51E | `--header-featured-link-foreground`, `--secondary-adbar-background` |
| Crema utilidades / badges | #FAFBE9 | `--header-badge-background` |
| Bloques pastel (secciones/cards de home) | #F4E6DD durazno, #E8E4F0 lavanda, #F7E5D9, #F6F4F1 | inline en home |
| Envío (label) | #E5F6ED fondo / #03A679 texto | `--label-shipping-*` |
| Stock | #E67E22 | `--stock-color` |
| Label genérico | #2980B9 | `--label-background` (parece default del theme: [a confirmar] si es intencional) |

## Tipografía
- **Plus Jakarta Sans** (400-700): cuerpo y mayoría de UI.
- **Urbanist** (400-800): titulares (clase `zl-font-serif`, aunque es sans).
- No usar Inter/Roboto.

## Forma
- Radios chicos/medios: 8, 10, 16 px; avatares 50%. Jerarquía de color: naranja = acción, violeta = marca.

## Tono de copy (real del sitio)
- Voseo rioplatense, frases cortas, beneficio concreto y algo cálido/humano.
- Ejemplos: "Standing desk y sillas ergonómicas, para que trabajar te haga bien." · "Elegí tu próximo upgrade" · "Tu espalda, primero" · "Probalo antes de decidir" · "Tu setup, tu identidad" · "Historias reales de cambio" · Ficha Z90: "Toda la L, en una sola compra." · "Sentado o parado, a un botón de distancia." · "Los cables, resueltos desde el primer día." · "La L se entiende cuando la ves armada".
- Claim del sitio: "Por qué más de 5000 argentinos eligieron Zentra" (usar solo tal cual y con fuente; actualizarlo es [a confirmar]).
- Elementos comerciales visibles: cuotas sin interés, cálculo de envío por CP, "5% OFF en tu primera compra", Showroom en Palermo (visita presencial), quiz "En 4 preguntas te decimos cuál es el producto ideal", marca Ergohuman en catálogo, botón de arrepentimiento.

## Catálogo (home)
- Sillas: Flex, Core, Alba, Vetra, Ergos, Nova, Zenith, Axis; Ergohuman IOO, Ultra, Elite.
- Standing desks: Z10 Lite/Pro, Z20 Pro, Z90 Lite/PRO (Z90 en L). Variantes de tabla por medida/espesor, colores Blanco/Negro/Nogal, opción con luces LED.
- Ficha Z90 Lite: secciones Características, Opiniones, Showroom, Especificaciones, "Lite o PRO" (comparativa), Preguntas Frecuentes, Productos similares.

## [a confirmar]
- Estilo fotográfico (setups reales vs. estudio, luz, encuadre): verificar mirando el sitio en navegador.
- Manual de marca oficial, si existe (pedírselo a Leo).
- Uso del violeta vs. naranja en piezas nuevas: confirmar con Leo cuál es el color principal de marca.
