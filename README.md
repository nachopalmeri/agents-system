# Agents System — Dotfiles de Nacho Palmeri

Sistema global de agentes, workflows, skills y scaffolding para desarrollo con IA multi-herramienta.

## Qué contiene

- `.agents/` — Reglas globales, workflows, skills, agentes personalizados
- `bin/` — Scripts `nuevo-proyecto.ps1` y `nuevo-proyecto.sh`
- `config/opencode/` — Configuración de OpenCode (`AGENTS.md`, `opencode.jsonc`)
- `config/windsurf/` — Estructura local de Windsurf (planes, etc)
- `docs/` — Guías de instalación privada, laptop bootstrap y ecosistema OpenCode

## Principios operativos

- La interfaz es chat; los workflows son motor interno.
- El agente debe elegir el menor workflow suficiente y explicar la eleccion cuando haya ambiguedad real.
- Validar significa aportar evidencia observable o declarar la limitacion.
- Cuando el routing o el output fallan, usar `.agents/workflows/feedback_loop.md` para convertir el error en una regla, checklist, test o poda concreta.

## Requisitos previos

- Git instalado
- PowerShell (Windows) o Bash (Linux/Mac)
- GitHub CLI (`gh`) para instalar desde repo privado
- Opcional: OpenCode, Zed, Obsidian

## Instalación y actualización

Una sola vía: `bin/sync-runtime.ps1`, que **copia** (no crea symlinks) reglas, skills y adapters a cada herramienta, con backup y `-Restore`. Guía completa, qué recibe cada cliente y flujo de trabajo: `docs/global-setup-2026.md`.

```powershell
gh repo clone nachopalmeri/agents-system $env:USERPROFILE\agents-system   # primera vez
cd $env:USERPROFILE\agents-system; git pull
pwsh .\bin\sync-runtime.ps1 -WhatIf    # qué va a escribir y qué conserva
pwsh .\bin\sync-runtime.ps1            # instala lo nuevo; no toca nada distinto
pwsh .\bin\sync-runtime.ps1 -Force     # además reemplaza (con backup) lo que el repo gestiona
pwsh .\bin\sync-runtime.ps1 -Check     # avisa si alguna copia quedó distinta del repo
```

- Merge: sólo se escriben skills/archivos que existen en el repo. Lo tuyo que no está en el repo se conserva y se lista como `[keep]`. `~/.agents/memory`, `~/.agents/tasks` y `~/.agents/projects-index.md` nunca se pisan.
- Si `~/.agents` es un symlink/junction de una instalación vieja, el sync se detiene y te dice cómo borrar sólo el link.
- `nuevo-proyecto` no se agrega al PATH: correlo como `pwsh ~\agents-system\bin\nuevo-proyecto.ps1 <nombre> <tipo>`.
- `install.sh` (Linux/Mac) todavía usa symlinks: preferí `pwsh bin/sync-runtime.ps1 -HomePath ~`.

## Test de integridad

```powershell
.\bin\test-system.ps1
```

Valida: archivos requeridos, referencias internas no rotas, frontmatter de reglas/agentes, workflows con contenido, ratio skills llenas/vacías, prompts portables existentes.

## Registry de agentes

`agents.registry.json` es el contrato machine-readable de los 5 roles. No reemplaza los prompts en `.agents/agents/` (fuente única que `bin/render-agents.ps1` convierte al formato de cada cliente); los hace direccionables por routers, integraciones y checks automáticos.

Cada entrada define:

- `id` y `file`: identidad estable y archivo fuente.
- `division`: área funcional para routing.
- `whenToUse`: disparadores naturales para elegir el agente.
- `inputs` y `outputs`: contrato esperado de trabajo.
- `riskLevel` y `requiresApproval`: guardrails para ejecución y futuras integraciones workspace-native.
- `tools` y `memoryTags`: permisos y contexto que el agente puede necesitar.

Validar el registry:

```powershell
.\bin\validate-agents.ps1
```

Este check falla si hay ids duplicados, archivos faltantes, frontmatter desalineado, campos requeridos incompletos, herramientas no soportadas, tags de memoria inválidos o niveles de riesgo inválidos.

## Router de tareas

`schemas/task.schema.json` define un task envelope común para pedidos que vengan de chat, CLI, GitHub, Notion o Slack. `bin/route-task.ps1` carga ese envelope, consulta `agents.registry.json` y devuelve una decisión de routing en JSON.

Ejemplo:

```powershell
.\bin\route-task.ps1 .\examples\tasks\security-review.json
```

La salida incluye `selectedAgents`, razones de routing y si hace falta aprobación humana antes de ejecutar.

## Verificación post-instalación

Ejecutar en terminal:

```powershell
.\bin\doctor.ps1
```

Para validar secretos antes de publicar:

```powershell
.\bin\check-secrets.ps1
```

Para validar el repo antes de commitear o pushear:

```powershell
.\bin\release-check.ps1
```

Para validar scaffolding:

```bash
pwsh ./bin/nuevo-proyecto.ps1 test-install astro
```

Tiene que crear:
- `~/test-install/AGENTS.md`
- `~/test-install/tasks/todo.md`
- Worktrees de agentes

## Estructura del sistema

```text
.agents/
├── AGENTS.md          # Política canónica (única fuente; se copia a cada cliente)
├── agents/            # 5 roles: explorador, planner, implementador, reviewer, verificador
├── commands/          # /planear, /revisar, /cerrar (fuente única)
├── hooks/             # guard, lint-edited, session-todo, stop-unpushed, log-usage + guard-rules.json
├── skills/            # 30 skills núcleo (metadata precargada)
├── skills-library/    # skills on-demand + INDEX.md (incluye externas instalables)
├── workflows/  rules/  memory/  tasks/  prompts/  shared/  docs/
└── archive/           # historia (agentes y skills viejos); nada lo carga

config/
├── runtime-manifest.json   # qué se instala dónde (modo merge)
├── model-tiers.json        # modelo por rol y cliente
├── claude-hooks.json       # hooks que se mergean en ~/.claude/settings.json
├── external-skills.json    # skills de terceros (se bajan de su fuente)
├── generated/              # agentes y comandos por cliente (bin/render-*.ps1)
├── global/                 # CLAUDE.md global y versión chat web
└── opencode/               # plugin de guardia + plantilla opcional opencode.jsonc

bin/
├── sync-runtime.ps1            # instalar / -Check / -Restore
├── sync-claude-settings.ps1    # hooks de Claude (merge, -Check, -Remove)
├── install-external-skills.ps1 # video, docs, arte, vercel… desde su fuente
├── render-agents.ps1  render-commands.ps1  generate-skill-index.ps1  generate-capabilities.ps1
├── check-runtime-graph.ps1  validate-agents.ps1  release-check.ps1  check-secrets.ps1
├── audit-skill-dirs.ps1  inventory-agents.ps1  doctor.ps1
└── nuevo-proyecto.ps1 / .sh    # scaffolding
```

## Uso diario

### Workflow maestro

Ver `docs/world-class-workflow.md`.

El flujo base es:

```text
start.md
→ index.md
→ lane (SIMPLE / SPECIALIZED / PARALLEL / HIGH_RISK) según AGENTS.md
→ modo simple / plan / /loop / Routine / multiagent review / Venture Loop
→ agente o skill especializado
→ tools seguras
→ validation.md
→ feedback_loop.md si hubo correccion del enfoque/routing/output
→ checkpoint/docs si aporta continuidad
```

### Crear proyecto simple

```bash
nuevo-proyecto mi-landing astro
```

### Crear proyecto AI production

```bash
nuevo-proyecto mi-ai-app ai-prod
```

### Crear proyecto Spec-Driven Development

```bash
nuevo-proyecto mi-app-compleja spec-kit
```

Crea el scaffold base más `.specify/`:

```text
.specify/
├── memory/
│   └── constitution.md
├── specs/
├── templates/
└── README.md
```

Usarlo para features/proyectos medianos o grandes. No usarlo para fixes chicos.

### Crear proyecto SaaS MVP / negocio local / SEO growth

```bash
nuevo-proyecto mi-saas saas-mvp
nuevo-proyecto dulces-creaciones local-business
nuevo-proyecto seo-site seo-growth
nuevo-proyecto ideas-ai product-foundry
```

Estos presets crean carpetas para `product/`, `growth/`, `landing/`, `metrics/`, `docs/` y `tasks/`.

### Crear proyecto web premium (con briefing)

```bash
nuevo-proyecto mi-pitch next
# La IA preguntará: ¿qué buscás? objetivo, audiencia, tono...
```

### Marketing AI opcional

El sistema puede enrutar pedidos de marketing internamente sin que recuerdes workflows:

- Ideas de producto, MVPs, indie hacking y validación
- Estrategia de lanzamiento, posicionamiento, GTM
- Research de audiencia, competencia, Category Entry Points
- SEO/GEO/AEO growth: keywords, landings, backlinks, local SEO, AI search
- SEO técnico/on-page: auditoría, metadata, sitemap, schema, canonicals
- Evaluación de MCPs para ads, Meta, Instagram, scrapers

**Reglas de seguridad:**
- Nunca ejecuta gasto publicitario automáticamente.
- Los DMs y social selling empiezan en modo draft/handoff humano.
- Todo MCP de marketing se evalúa con `marketing_mcp_eval.md` antes de instalar.

Ejemplos de prompts naturales:
```text
"armame una estrategia de lanzamiento para JobBot"
"no sé qué producto crear, ayudame a encontrar ideas"
"quiero lanzar 12 productos chicos con AI"
"evaluá esta idea con MVP patineta y kill/scale criteria"
"auditá el SEO y decime quick wins"
"armame una estrategia SEO para mi SaaS en Argentina"
"tengo una pastelería de barrio, quiero mejores clientes por Google"
"qué keywords buscarías en Ahrefs y qué landings crearías?"
"quiero aparecer en ChatGPT cuando preguntan por mi categoría"
"quiero investigar anuncios de competidores"
"evaluá si conviene conectar Meta Ads MCP"
```

### Product Foundry

La skill `product-founder` (con `product-foundry`) aplica el framework:

```text
flujos de dinero → fricción real → MVP patineta → lanzamiento rápido → validación → kill/keep/scale
```

Sirve para:

- Pensar ideas de producto.
- Armar una cartera de 15-20 apuestas pequeñas.
- Definir MVPs de 1-2 semanas.
- Actualizar productos existentes con AI.
- Simplificar productos grandes para nichos.
- Detectar procesos que la gente ya resuelve mal con Sheets, WhatsApp, email o copy-paste.
- Conectar ideas prometedoras con SEO/GEO/AEO si hay demanda buscable.

Reglas:

- No enamorarse de una idea sin señales.
- No construir el auto completo: empezar por la patineta.
- Evidencia fuerte: pago, preorden, uso repetido, usuario pidiendo más.
- Evidencia débil: likes, elogios y tráfico sin conversión.

### Venture Loop

El workflow `venture_loop.md` conecta:

```text
idea → MVP patineta → landing/oferta → distribución → medición → kill/keep/scale
```

Integra:

- `product_foundry.md`
- `web_briefing.md`
- `seo_geo_growth.md`
- `marketing.md`
- `validation.md`

### Multiagent Review Loop

El workflow `multiagent_review_loop.md` se usa para decisiones de alto impacto:

```text
crear → criticar → red team → segunda crítica → plan de mejora → roadmap → reevaluación
```

No se usa para fixes chicos. Si la crítica no puede cambiar la solución, usar el flujo simple (lane SIMPLE).

### Task Ledger / Kanban

El workflow `task_ledger.md` aplica el patrón:

```text
pedido en lenguaje natural
→ coordinador interpreta intención
→ task trazable si corresponde
→ agente correcto
→ progreso visible
→ evidencia
→ recibo final
```

Puede usarse con `tasks/todo.md`, Obsidian, GitHub Projects, Kanban local, Discord/Hermes u otra herramienta. No debe crear tarjetas por cada conversación: solo cuando hay acción real, handoff, tracking o continuidad.

Para setups móviles tipo Jumperz/Juan:

```text
Telegram/chat móvil
→ Discord coordinador organizado
→ Hermes Kanban como ledger
→ agente correcto
→ progress card durante el run
→ evidencia en canal del agente
→ recibo final en results channel
→ Obsidian para decisiones/aprendizajes durables
```

Discord/Hermes/Telegram son una capa opcional de orquestación. Si fallan o no están configurados, el sistema debe seguir funcionando con chat local, `tasks/todo.md`, Obsidian y git.

### SEO/GEO/AEO Growth

La skill `seo-geo-growth` (ref. `growth-playbook.md`) aplica el loop:

```text
Ahrefs/Semrush/DataForSEO → landings/blog/tools → backlinks/citations → Search Console/GA4 → registros/leads/clientes
```

Sirve para:

- SaaS Argentina/LATAM.
- Negocios locales como pastelerías, ferreterías, clínicas o estudios.
- Webs de servicios.
- Estrategias para aparecer en ChatGPT, Perplexity, Gemini y Google AI Overviews.

Reglas:

- Mejor 5-10 páginas buenas por mes que 100 páginas thin.
- No crear doorway pages ni páginas que solo cambian una keyword.
- No instalar Ahrefs, GSC, GA4, Semrush o DataForSEO MCP sin confirmación.
- Medir conversiones y calidad del tráfico, no solo visitas.
- Programmatic SEO solo si cada página tiene valor único, front cuidado, medición y criterio de poda.
- Páginas sin interés se reforman, fusionan, noindexan o borran.
- Backlinks importan: proyectos propios, partnerships, directorios relevantes, PR real y assets linkables.
- Product analytics conecta demanda con comportamiento: búsqueda → página → evento → mejora → poda/escala.
- DataForSEO, PostHog, Mixpanel o base de eventos empiezan read-only/draft si hay credenciales o datos reales.
- No monetizar antes de tiempo si reduce aprendizaje, confianza, UX o velocidad de iteración.

### MCPs y plugins opcionales

El sistema incluye workflows para evaluar MCPs y plugins, pero no instala integraciones externas automáticamente.

- `mcp_catalog.md` clasifica MCPs por riesgo.
- `mcp_security.md` define reglas de seguridad.
- `mcp_adoption.md` guía adopciones con veredicto GO/NO-GO/PIVOT.
- `opencode_ecosystem.md` usa `awesome-opencode` como fuente de descubrimiento.

Reglas:

- Empezar read-only.
- No hardcodear API keys.
- No conectar pagos, ads, DMs, producción ni datos personales sin confirmación explícita.
- OpenCode Studio es opcional y debe usarse con backup/diff de config.

### OpenCode Studio opcional

Ver `docs/opencode-studio.md`.

Uso recomendado:

- Gestionar MCPs, skills, plugins y perfiles.
- Hacer backup/restore.
- Revisar usage.

No es dependencia obligatoria del sistema.

## Actualizar el sistema

```powershell
pwsh .\bin\update-system.ps1   # git pull + sync + check-runtime-graph + sync -Check
```

## Contribuciones

Este es tu sistema personal. Modificá reglas, agregá skills, experimentá. Cuando encuentres algo que funcione bien, commitealo y pushealo.

## Notas

- El vault de Obsidian (`Q1-2026-UADE`) se sincroniza vía OneDrive, no está en este repo
- Las API keys y `.env` nunca deben commitearse (están en `.gitignore` global)
- Cada proyecto creado con `nuevo-proyecto` hereda las reglas pero tiene su propio `AGENTS.md` local
- `awesome-opencode` y OpenCode Studio son opcionales: evaluar antes de instalar o importar

## Contacto

Nacho Palmeri — Pisculichi Labs
