---
name: css-animations
description: Genera animaciones CSS 2D para sitios web — keyframes, parallax, hover effects, fade-on-scroll, texto animado
allowed-tools: Read Write Grep
---

# CSS 2D Animations

## Cuándo usar

- El usuario pide animaciones CSS para un sitio web.
- Se necesita agregar movimiento a una landing o portfolio.
- Se quiere ofrecer "animaciones web" como servicio a clientes.
- El usuario dice "animaciones", "keyframes", "parallax", "hover effects", "fade on scroll".

## 6 Recetas

### 1. Keyframes flotantes / rebote

```css
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); }
  75% { transform: translateY(-5px); }
}

.float { animation: float 3s ease-in-out infinite; }
.bounce { animation: bounce 2s ease-in-out infinite; }
```

Ajustar: duración (2-6s), distancia (5-20px), easing (ease-in-out, cubic-bezier).

### 2. Fade-on-scroll

```css
.fade-up {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.fade-up.visible {
  opacity: 1;
  transform: translateY(0);
}
```

JS mínimo con IntersectionObserver:

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
}, { threshold: 0.1 });
document.querySelectorAll('.fade-up').forEach(el => observer.observe(el));
```

### 3. Parallax para fondos

```css
.parallax-bg {
  background-attachment: fixed;
  background-position: center;
  background-size: cover;
  min-height: 50vh;
}
```

Alternativa JS (más control):

```js
window.addEventListener('scroll', () => {
  const el = document.querySelector('.parallax-bg');
  const scroll = window.scrollY;
  el.style.transform = `translateY(${scroll * 0.5}px)`;
});
```

⚠️ Precaución: parallax pesado afecta CLS y performance. Ver `performance_audit.md` sección Core Web Vitals.

### 4. Hover effects (glow, scale, rotate)

```css
.btn-glow:hover {
  box-shadow: 0 0 20px rgba(99, 102, 241, 0.6);
  transition: box-shadow 0.3s ease;
}

.btn-scale:hover {
  transform: scale(1.05);
  transition: transform 0.2s ease;
}

.btn-rotate:hover {
  transform: rotate(2deg);
  transition: transform 0.3s ease;
}
```

Combinar: `transform: scale(1.05) rotate(1deg)`.

### 5. Texto palabra por palabra

```css
.word { display: inline-block; opacity: 0; transform: translateY(20px); animation: wordIn 0.4s forwards; }
@keyframes wordIn { to { opacity: 1; transform: translateY(0); } }
```

JS para splitear:

```js
document.querySelectorAll('.animate-text').forEach(el => {
  const words = el.textContent.split(' ');
  el.innerHTML = words.map((w, i) =>
    `<span class="word" style="animation-delay: ${i * 0.08}s">${w}</span>`
  ).join(' ');
});
```

### 6. Ajuste de timing

Reglas generales:
- **Micro-interacciones** (hover, focus): 150-300ms.
- **Transiciones de entrada** (fade, slide): 400-600ms.
- **Animaciones decorativas** (float, pulse): 2-6s.
- **Easing**: `ease-out` para entradas, `ease-in-out` para loops, `cubic-bezier(0.34, 1.56, 0.64, 1)` para overshoot.

## Output

```text
Animación:
Tipo:
CSS:
JS (si aplica):
Integración:
Timing:
Precauciones:
```

## Reglas

- No exagerar animaciones: máximo 2-3 tipos por página.
- Respetar `prefers-reduced-motion`: wrappear keyframes en `@media (prefers-reduced-motion: no-preference)`.
- Verificar CLS después de agregar animaciones (conectar con `performance_audit.md`).
- CSS primero, JS solo cuando CSS no alcanza.

## Conexiones

- `agente-design` para diseño visual y coherencia estética.
- `performance_audit.md` para verificar que animaciones no rompan Core Web Vitals.
- `marketing.md` para ofrecer animaciones web como servicio a clientes.
