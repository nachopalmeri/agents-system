# Cómo usar el sistema de agentes

Este sistema está diseñado para que el usuario hable normal y los workflows funcionen como motor interno.

## Regla principal

```text
No memorices workflows.
Decí qué querés lograr.
El agente enruta internamente al menor workflow suficiente.
```

## Camino 1 — Crear un proyecto nuevo

Usar cuando querés arrancar una app, landing, SaaS, proyecto AI, proyecto SEO o experimento de producto desde cero.

### Comando

```powershell
nuevo-proyecto mi-app next
```

Stacks disponibles:

```text
html-css-js
astro
next
python
ai-prod
spec-kit
saas-mvp
local-business
seo-growth
product-foundry
```

### Ejemplos

```powershell
nuevo-proyecto mi-saas saas-mvp
nuevo-proyecto dulces-creaciones local-business
nuevo-proyecto seo-site seo-growth
nuevo-proyecto ideas-ai product-foundry
nuevo-proyecto jobbot-ai ai-prod
```

### Después

```powershell
cd ~/mi-app
opencode
```

### Qué hace el agente

1. Ejecuta `start.md`.
2. Lee `AGENTS.md`.
3. Lee `tasks/todo.md` si existe.
4. Lee `tasks/lessons.md` si existe.
5. Revisa Git si está disponible.
6. Espera tu instrucción.
7. Enruta con `workflows/index.md`.

### Cuándo usar cada preset

| Preset | Usar cuando |
|---|---|
| `saas-mvp` | Querés validar un SaaS chico con landing, MVP y métricas |
| `local-business` | Querés trabajar oferta/web/SEO para un negocio local |
| `seo-growth` | Querés un proyecto centrado en adquisición orgánica |
| `product-foundry` | Querés pensar ideas, rankearlas y definir MVPs |
| `ai-prod` | Querés AI/RAG production-ready |
| `spec-kit` | Querés specs, plan y tasks para algo grande |

## Camino 2 — Trabajar en un repo existente

Usar cuando ya existe código.

### Comando

```powershell
cd C:\Users\ignac\CascadeProjects\jobbot
opencode
```

### Qué decir

```text
"Revisá el proyecto y decime estado actual"
"Implementá esta feature"
"Arreglá este bug hasta que pasen los tests"
"Leé el contexto del vault si existe"
```

### Qué hace el agente

1. Busca `AGENTS.md` local.
2. Si no existe, continúa con reglas globales.
3. Revisa `tasks/`.
4. Revisa Git.
5. Usa el stack detectado o la skill correspondiente.
6. Si la tarea es larga, puede usar `/loop`.
7. Si toca muchos archivos, puede dividir con `parallel_agents.md`.
8. Valida con `validation.md`.

### Ejemplos de routing

| Pedido | Ruta interna |
|---|---|
| “arreglá este bug” | debugging + validation |
| “agregá esta feature grande” | phases + spec-kit si aplica |
| “hacé la UI más premium” | web_briefing + web-presentation-premium |
| “esto es AI/RAG serio” | ai_production + agente-ai-architect |
| “subilo a GitHub” | agente-release-manager + agente-security-auditor |

## Camino 3 — Vault Obsidian / estudiar

Usar cuando trabajás con notas, clases, MOCs, flashcards o proyectos documentados en el vault.

### Comando

```powershell
cd "C:\Users\ignac\OneDrive\Desktop\Q1\Q1-2026-UADE"
opencode
```

### Qué decir

```text
"Nueva clase de Redes de Datos, tema TCP/IP"
"Creá flashcards de esta nota"
"Actualizá el MOC de la materia"
"Leé el proyecto JobBot documentado en mi vault"
```

### Qué hace el agente

Usa:

- `agente-obsidian-brain`
- skill `obsidian-vault`

Puede combinarse con:

- `python` si hay código.
- `product-foundry` si el proyecto es una idea.
- `seo-geo-growth` si hay adquisición orgánica.
- `docs` si hay que ordenar documentación.

## Camino 4 — Negocio local / indie product

Usar cuando hay una idea, negocio local, proyecto sin código o producto que todavía no está validado.

### Comando

Podés trabajar desde el vault o desde un repo nuevo:

```powershell
nuevo-proyecto dulces-creaciones local-business
```

o:

```powershell
nuevo-proyecto mi-saas saas-mvp
```

### Qué decir

```text
"Tengo una pastelería de barrio, quiero mejores clientes"
"No sé qué producto crear con AI"
"Evaluá esta idea y definí MVP patineta"
"Armá el loop completo idea a landing a distribución"
"Quiero aparecer en Google y ChatGPT para esta categoría"
```

### Qué hace el agente

Ruta típica:

```text
agente-product-founder
→ venture_loop.md
→ web_briefing.md
→ agente-growth-seo-geo
→ validation.md
```

Si hay marketing:

```text
marketing.md + agente-marketing-strategist
```

Reglas:

- No ejecutar gasto publicitario automáticamente.
- No responder DMs sin confirmación.
- MCPs con credenciales requieren confirmación explícita.
- SEO programático debe evitar páginas thin o doorway pages.

## Loop completo de trabajo

```text
start.md
→ index.md
→ phases.md si no trivial
→ agente/skill especializado
→ tools
→ validation.md
→ reporte final
```

## Cuándo se usa `/loop`

Usar cuando querés que el agente siga trabajando hasta cumplir un criterio verificable.

Ejemplos:

```text
"seguí hasta que pasen todos los tests"
"iterá hasta que el build quede verde"
"arreglá lint hasta que no queden errores"
"completá este checklist y validalo"
"iterá esta landing hasta que cumpla el brief"
```

El loop termina cuando:

- El objetivo se cumple.
- Hay un bloqueo real.
- Aparece un riesgo que requiere confirmación.

Todo `/loop` debe tener objetivo, criterio de salida, límite y validación.

## Cuándo se usa Routine

Usar para tareas recurrentes o automatizables.

Ejemplos:

```text
"dejá armado un health check semanal"
"creá una rutina mensual de reporte SEO"
"armá una routine para revisar métricas"
```

Las routines deben ser:

- Seguras.
- Idempotentes.
- Con límites claros.
- Draft/read-only si involucran credenciales, DMs, ads, pagos o datos personales.

Nunca deben publicar, gastar, responder DMs, tocar producción ni usar datos personales sin confirmación explícita.

## Growth moderno con SEO + analytics

Para proyectos de adquisición orgánica, el sistema aplica:

```text
qué busca la gente
→ qué página visita
→ qué hace dentro del producto
→ qué se mejora
→ qué se poda o escala
```

Principios:

- Programmatic SEO sí, pero de calidad.
- Cada página debe tener valor único, buen front, intención clara y medición.
- Páginas sin interés se reforman, fusionan, noindexan o borran.
- Backlinks importan: proyectos propios, partnerships, directorios relevantes, PR real y assets linkables.
- No monetizar antes de tiempo si reduce aprendizaje o confianza.
- DataForSEO, PostHog, Mixpanel o base de eventos pueden ayudar, pero MCPs con credenciales empiezan read-only/draft y requieren confirmación.

## Validación antes de cerrar

Siempre usar `validation.md` antes de declarar listo.

Checklist mínimo:

```text
Scope revisado:
Archivos tocados:
Tests/build:
Config/JSON:
Secret scan si aplica:
Riesgos:
Resultado:
```

## Qué pedirle al agente

Buenas formas:

```text
"quiero lograr X, decidí el workflow vos"
"hacelo de la forma más simple segura"
"si es largo, usá loop"
"si falta contexto, preguntame solo lo necesario"
"validá antes de decir listo"
```

No hace falta decir:

```text
"usá product_foundry.md"
"activá seo_geo_growth.md"
"leé phases.md"
```

Eso lo decide internamente el sistema.

## Regla final

La interfaz es conversación. La arquitectura interna decide agentes, workflows, skills, tools y validación.
