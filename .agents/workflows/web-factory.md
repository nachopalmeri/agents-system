---
description: Orquestación tipo Lovable para crear webs premium, 3D, disruptivas con agentes sandboxed en paralelo
---

# Web Factory

## Principio

Las webs premium no se hacen con un solo agente. Se hacen con especialistas sandboxed que trabajan en paralelo, cada uno enfocado en su dominio, integrados al final. Inspirado en Lovable (Agent→Visual→Plan), Bolt.new (auto-routing + sandbox) y v0 (Generative UI con shadcn/ui).

## Cuándo usar

- El usuario quiere una web premium, 3D, disruptiva, que venda sola.
- Una landing con animaciones, CTA fuerte, y diseño que no se vea genérico.
- Un sitio que se vea como $10K de diseño custom.
- El usuario dice "web premium", "landing que venda", "3D website", "web como Lovable/v0".

## Cuándo NO usar

- Web simple sin 3D ni animaciones → `web-presentation-premium` skill.
- Proyecto 3D ambicioso con pipeline completo → `world-class-web.md`.
- Solo animaciones CSS → `css-animations` skill.

## 3 Fases (tipo Lovable)

### Fase 1: Plan Mode (estrategia antes de ejecutar)

Como Lovable Plan Mode: discutir estrategia antes de gastar tokens en código.

1. **Brief rápido** (usar `web_briefing.md`):
   - Objetivo: vender, mostrar, explicar, marcar presencia.
   - Audiencia y tono.
   - CTA principal (registro, compra, demo, WhatsApp, waitlist).
   - Stack: Next.js + shadcn/ui + GSAP + R3F (default) o Astro + Tailwind (más liviano).
   - Deadline y restricciones.

2. **Concepto visual**:
   - Scroll story: entrada → desarrollo → clímax → CTA.
   - Paleta, tipografía, tono visual.
   - Mapa de scroll: qué pasa en cada scroll position.
   - Decisiones 3D: sí/no, qué tipo (fondo, objeto, full scene), Spline vs procedural.

3. **Plan de ejecución**:
   - Qué agentes se activan.
   - Qué hace cada uno (scope sandboxed).
   - Orden de integración.
   - Budget de performance (Lighthouse ≥ 90, LCP < 2.5s).

**Output:**
```text
Nombre:
Objetivo:
CTA:
Stack:
3D:
Animaciones:
Agentes activos:
Plan de integración:
Budget performance:
```

### Fase 2: Agent Mode (build en paralelo, sandboxed)

Como Lovable Agent Mode: cada agente trabaja autónomo en su dominio.

#### 5 Agentes sandboxed

| Agente | Scope | Produce | No toca |
|---|---|---|---|
| `agente-web-layout` | Estructura, responsive, shadcn/ui, Tailwind | Layout completo con secciones, componentes, responsive | 3D, animaciones complejas, copy final |
| `agente-web-3d` | Three.js/R3F scenes, Spline imports, WebGPU, assets | Componentes 3D listos para integrar | Layout, copy, animaciones 2D |
| `agente-web-motion` | GSAP ScrollTrigger, micro-interacciones, page transitions, Locomotive Scroll | Animaciones y transiciones | Layout structure, 3D scenes, copy |
| `agente-web-copy` | Copy persuasivo, CTAs, headlines, storytelling | Textos, headlines, CTAs, meta tags | Layout, código, 3D |
| `agente-web-qa` | Lighthouse, performance budgets, accesibilidad, anti-slop | Reporte de calidad + fixes | Creación de features nuevas |

#### Reglas de sandbox

- Cada agente trabaja en archivos propios (o secciones marcadas con comentarios `<!-- AGENT: nombre -->`).
- Un agente NO modifica el output de otro sin coordinación.
- Los agentes se comunican vía contrato (ver `agent_coordination.md`):
  - **Produce**: qué genera.
  - **Consume**: qué necesita de otros.
  - **Interfaz**: formato de input/output.
- Si hay conflicto, el agente principal decide.

#### Contratos entre agentes

```
agente-web-layout:
  Produce: layout.html / Layout.tsx con secciones vacías marcadas
  Consume: lista de secciones del Plan
  Interfaz: componentes React con props para 3D/motion/copy

agente-web-3d:
  Produce: Scene3D.tsx, modelos, shaders
  Consume: dimensiones del layout, scroll positions
  Interfaz: componente React con ref para GSAP

agente-web-motion:
  Produce: animations.ts, scroll-config.ts
  Consume: estructura del layout, refs de componentes 3D
  Interfaz: GSAP timeline + ScrollTrigger config

agente-web-copy:
  Produce: copy.json / Copy.tsx
  Consume: lista de secciones, CTA, audiencia
  Interfaz: objeto con headlines, body, CTAs por sección

agente-web-qa:
  Produce: qa-report.md + fixes
  Consume: build final integrado
  Interfaz: checklist + scores + archivos a corregir
```

#### Orden de ejecución

1. **Paralelo**: `agente-web-layout` + `agente-web-copy` + `agente-web-3d` (no dependen entre sí).
2. **Secuencial después**: `agente-web-motion` (necesita refs del layout y 3D).
3. **Al final**: `agente-web-qa` (necesita build integrado).

### Fase 3: Polish Mode (integración + visual review + deploy)

Como Lovable Visual Edits: ajustar lo visual sin rehacer todo.

1. **Integración**: ensamblar output de todos los agentes.
2. **Visual review**: verificar coherencia visual, narrativa, CTA visibility.
3. **Performance check**: Lighthouse, Core Web Vitals, bundle size.
4. **Anti-slop pass**:
   - No hay Lorem ipsum.
   - No hay fade genérico.
   - No hay gradientes sin propósito.
   - No hay animaciones que mareen.
   - Tipografía con personalidad.
   - CTA claro sin hacer scroll.
5. **Deploy**: Vercel (default) o Netlify.
6. **Handoff**: si es para cliente, usar `client_workflow.md`.

## Stack premium (ver skill `premium-web-stack`)

- **Framework:** Next.js 15 (App Router) o Astro (si no necesita estado)
- **Estilos:** Tailwind CSS v4
- **Componentes:** shadcn/ui (base) + beUI (motion components vía shadcn registry) + Radix UI (primitives)
- **3D:** React Three Fiber + Three.js r182+ + Drei
- **3D Authoring:** Spline (importar .splinecode) o Blender → Draco → KTX2
- **Animaciones scroll:** GSAP + ScrollTrigger
- **Micro-interacciones:** Motion (ex-Framer Motion)
- **Smooth scroll:** Locomotive Scroll o Lenis
- **Page transitions:** Barba.js o View Transitions API
- **Iconos:** Lucide React
- **Fonts:** Google Fonts (variable) o Fontshare
- **Deploy:** Vercel

## Plugins opcionales (claudedesignskills)

Referencia: [freshtechbro/claudedesignskills](https://github.com/freshtechbro/claudedesignskills)

Instalar según necesidad:
- `threejs-webgl` — patrones Three.js avanzados
- `gsap-scrolltrigger` — scroll storytelling
- `react-three-fiber` — R3F patterns
- `spline-interactive` — importar escenas Spline
- `modern-web-design` — principios de diseño moderno
- `web3d-integration-patterns` — integración 3D completa

Instalación: `/plugin install [nombre]` en Claude Code.

## "Landing que vende" — CTA-focused

Toda web premium debe tener un CTA claro. Reglas:

1. **CTA visible sin scroll** (above the fold).
2. **Un solo CTA principal** por página. Los demás son secundarios.
3. **Copy del CTA = acción concreta**, no "Click here" sino "Empezar gratis", "Agendar demo", "Ver precios".
4. **CTA repetido** al final de cada sección larga.
5. **Proof cerca del CTA**: testimonios, logos, métricas, caso de éxito.
6. **Urgencia si aplica**: countdown, oferta limitada, "últimas plazas".
7. **Friction mínima**: el CTA lleva directo a la acción, no a una página intermedia.

## Conexiones

- `world-class-web.md` para proyectos 3D ambiciosos (pipeline 10 etapas).
- `web-presentation-premium` skill para webs premium de alcance contenido.
- `css-animations` skill para animaciones 2D.
- `web_briefing.md` para el brief inicial.
- `agent_coordination.md` para contratos entre agentes.
- `parallel_agents.md` para orquestación técnica.
- `client_workflow.md` si es trabajo para cliente.
- `premium-web-stack` skill para referencia de stack.
- `performance_audit.md` para el QA pass.

## Regla final

Una web premium no es "más efectos". Es una idea clara, una narrativa fuerte, movimiento al servicio del mensaje, y un CTA que convierte. Los agentes sandboxed aseguran que cada capa se haga bien, sin que un agente rompa lo que hizo otro.
