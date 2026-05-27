---
description: Referencia de scroll storytelling para world-class-web - técnicas narrativas con scroll
---

# Scroll Storytelling Reference

## Principio

El scroll no es solo navegación. Es un control narrativo. Cada pixel de scroll debe tener intención.

## Técnicas

### 1. Scroll-Linked Animation

- GSAP ScrollTrigger
- Elementos entran, se transforman, cambian de color con el scroll
- Timing: progresión lineal o easing según narrativa

### 2. Camera Path Narrative

- Cámara 3D sigue una curva en el espacio al scrollear
- Cada sección = un punto de interés en el path
- Transición suave entre puntos usando `update()` en scroll

### 3. Alcoves (Escenas 3D Autónomas)

- Pequeñas escenas 3D que aparecen en scroll position específica
- No más de 3 sin probar en dispositivo real
- Cada alcove tiene propósito: mostrar producto, explicar concepto, generar emoción

### 4. Parallax Layers

- Fondo, medio, primer plano se mueven a distinta velocidad
- Profundidad sin 3D pesado

## Timing

| Elemento | Duración | Easing |
|---|---|---|
| Hero reveal | 1.5s | `power3.out` |
| Section transition | 0.8s | `power2.inOut` |
| Alcove entry | 2s | `power4.out` |
| Text reveal | 0.6s | `power1.out` |

## Mobile

- ScrollTrigger normalizer para iOS
- Touch events no deben tener delay
- En mobile: reducir o reemplazar alcoves por imágenes estáticas si performance baja

## Referencias

- PorscheLab: scroll 3D + performance 100/100
- Apple iPhone pages: scroll-linked + alcoves
- Cartier Immersive Garden: alcoves narrativos + sonido

## Regla

El scroll storytelling siempre debe funcionar sin 3D. Si el 3D no carga, la historia se cuenta igual.
