---
name: next
description: Skill para proyectos Next.js — estructura, reglas y comandos
---

# Skill: Next.js

## Activar cuando
El proyecto tiene next.config.js o next.config.ts.

## Estructura (App Router — Next 13+)
app/             → rutas y layouts
app/api/         → API routes
components/      → componentes reutilizables
lib/             → lógica de negocio
public/          → assets estáticos
next.config.js   → config (archivo sagrado)

## Reglas Específicas
- Componentes server por defecto
- "use client" solo si necesitás hooks o eventos del browser
- Variables de entorno: NEXT_PUBLIC_ para cliente, el resto solo servidor
- No modificar next.config.js sin confirmar

## Comandos
npm run dev      → desarrollo
npm run build    → producción
npm run start    → servidor producción
npm run lint     → linting

## Errores Comunes a Evitar
- No usar useState/useEffect en server components
- No exponer variables de servidor al cliente (sin NEXT_PUBLIC_)
- No olvidar "use client" en componentes con interactividad
