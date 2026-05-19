---
description: Radar de tecnologías de Nacho Palmeri — qué usa, qué prueba, qué explora y qué descartó
---

# Tech Radar

Cuatro anillos que categorizan tecnologías según su estado actual. El agente consulta este archivo antes de proponer tecnologías.

## Reglas de uso

- Nunca proponer algo en HOLD sin justificación explícita.
- Nunca proponer algo nuevo sin preguntar si ya está en el radar.
- Si una tecnología no aparece, preguntar en qué anillo debería estar antes de usarla.

---

## ADOPT — Uso en producción o lo haría sin dudar

| Tecnología | Por qué está acá | Última evaluación | Notas |
|---|---|---|---|
| Astro | Mejor DX para landing/SEO, islas de interactividad | 2026-05 | Default para webs estáticas y contenido |
| Next.js | Ecosistema React maduro, SSR/SSG/ISR | 2026-05 | Para apps web complejas con estado |
| Python | Versatilidad, ecosistema científico y AI | 2026-05 | Default para backend, scripts y data |
| FastAPI | Performance, tipado, OpenAPI automático | 2026-05 | Default para APIs y backends AI |
| Git | No negociable | 2026-05 | Con worktrees para paralelismo |
| Vercel | Deploy sin fricción para frontend | 2026-05 | Default para Astro/Next |
| SQLite | Cero ops, ideal para MVPs | 2026-05 | Default para MVPs y proyectos chicos |
| Tailwind CSS | Velocidad de prototipado, consistencia | 2026-05 | Default para estilos |
| TypeScript | Seguridad de tipos sin perder flexibilidad | 2026-05 | Default sobre JS para proyectos nuevos |
| OpenCode | IDE agéntico principal | 2026-05 | Con plugins y MCPs curados |
| Claude API | Mejor calidad para agentes y razonamiento | 2026-05 | Vía OpenCode o directo |

## TRIAL — Estoy probando o quiero probar pronto

| Tecnología | Por qué está acá | Última evaluación | Notas |
|---|---|---|---|
| Drizzle ORM | Tipado end-to-end, SQL-first, liviano | 2026-05 | Alternativa a Prisma para proyectos nuevos |
| Bun | Runtime rápido, compatible con Node | 2026-05 | Para scripts y tooling, no producción aún |
| Hono | Router web ultrarrápido, edge-native | 2026-05 | Alternativa a Express para APIs chicas |
| Supabase | Postgres managed + auth + storage | 2026-05 | Para proyectos que necesitan DB sin managed |
| Effect-ts | Tipos algebraicos para errores y dependencias | 2026-05 | Explorando para backends robustos |

## ASSESS — Quiero explorar, no empecé

| Tecnología | Por qué está acá | Última evaluación | Notas |
|---|---|---|---|
| Rust | Performance para CLI tools | 2026-05 | Para reemplazar scripts Python pesados |
| Deno 2 | Runtime moderno, std library | 2026-05 | Alternativa a Node/Bun a futuro |
| Cloudflare Workers | Edge computing serverless | 2026-05 | Para APIs globales de baja latencia |

## HOLD — Descartado y por qué

| Tecnología | Por qué está acá | Última evaluación | Notas |
|---|---|---|---|
| Create React App | Muerto, sin mantenimiento | 2026-05 | Usar Next.js o Astro |
| Prisma | Demasiado overhead para MVPs, migraciones pesadas | 2026-05 | Usar Drizzle para proyectos nuevos |
| Express sin tipo | Reemplazado por Hono/FastAPI | 2026-05 | Solo mantener proyectos legacy |
