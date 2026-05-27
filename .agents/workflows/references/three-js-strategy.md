---
description: Estrategia técnica de Three.js para world-class-web - decisiones de arquitectura 3D
---

# Three.js Strategy Reference

## Stack 3D (2026)

| Componente | Elección | Por qué |
|---|---|---|
| Renderer | WebGPURenderer (default en r182+) | Rendimiento superior, compute shaders |
| Fallback | WebGLRenderer (WebGL 2.0) | Dispositivos sin WebGPU |
| Loader | GLTFLoader + DRACOLoader | Estándar, compresión Draco |
| Textures | KTX2Loader + Basis Universal | Compresión GPU-native |
| Physics | Rapier (Rust → WASM) | Performance, determinista |
| Post-processing | THREE.EffectComposer (r182 API) | Nativo, sin dependencias extra |

## OffscreenCanvas + Web Worker

**Requisito obligatorio** para render 3D en world-class-web:

- Render loop en Worker dedicado
- TransferControlToOffscreen para pintar en canvas del DOM
- Mensajes postMessage para input/scroll/data
- Pool de Workers para multi-escena si aplica

Beneficios:
- Render 3D no bloquea main thread (TBT baja)
- UI 3D sin jank en scroll
- Compatible con `performance.now()` worker-local

## Asset Pipeline

```
Blender → .glb (Draco compressed) → .ktx2 textures → Runtime
```

- Polígonos: < 50K por objeto, < 200K por escena
- Texturas: 1024x1024 max, KTX2 con Basis Universal
- Animaciones: GLTF animations exportadas desde Blender
- LOD: para objetos distantes (si aplica)

## Cámara

- PerspectiveCamera como default
- Camera path con scroll (GSAP ScrollTrigger + curve)
- LookAt narrativo:​​ la cámara enfoca puntos de interés al scrollear

## Regla

Si una escena 3D baja el Lighthouse Performance < 90, simplificarla o reemplazarla por CSS 3D transforms.
