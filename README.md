# Agents System — Dotfiles de Nacho Palmeri

Sistema global de agentes, workflows, skills y scaffolding para desarrollo con IA multi-herramienta.

## Qué contiene

- `.agents/` — Reglas globales, workflows, skills, agentes personalizados
- `bin/` — Scripts `nuevo-proyecto.ps1` y `nuevo-proyecto.sh`
- `config/opencode/` — Configuración de OpenCode (`AGENTS.md`, `opencode.jsonc`)
- `config/windsurf/` — Estructura local de Windsurf (planes, etc)
- `docs/` — Guías de instalación privada, laptop bootstrap y ecosistema OpenCode

## Requisitos previos

- Git instalado
- PowerShell (Windows) o Bash (Linux/Mac)
- GitHub CLI (`gh`) para instalar desde repo privado
- Opcional: OpenCode, Zed, Obsidian

## Instalación rápida (PC nueva)

### Repo privado (recomendado)

```powershell
winget install --id GitHub.cli
gh auth login
gh repo clone nachopalmeri/agents-system $env:USERPROFILE\agents-system
& "$env:USERPROFILE\agents-system\install-private.ps1"
```

Ver guía completa en `docs/private-repo-install.md` y `docs/bootstrap-laptop.md`.

### Repo público (si algún día se publica)

```powershell
iwr https://raw.githubusercontent.com/nachopalmeri/agents-system/main/install.ps1 | iex
```

O manualmente:

```powershell
git clone https://github.com/nachopalmeri/agents-system.git $env:USERPROFILE\agents-system-temp
# Luego seguir instrucciones de install.ps1
```

### Linux/Mac

```bash
curl -fsSL https://raw.githubusercontent.com/nachopalmeri/agents-system/main/install.sh | bash
```

## Instalación manual

1. Clonar este repo en tu PC
2. Crear symlinks o copiar archivos a ubicaciones estándar
3. Verificar que todo funcione

### Windows (manual)

```powershell
# 1. Clonar
git clone https://github.com/nachopalmeri/agents-system.git C:\Users\%USERNAME%\agents-system

# 2. Crear symlinks (como Admin)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.agents" -Target "$env:USERPROFILE\agents-system\.agents"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\bin" -Target "$env:USERPROFILE\agents-system\bin"

# 3. Copiar config de OpenCode
Copy-Item "$env:USERPROFILE\agents-system\config\opencode\*" "$env:USERPROFILE\.config\opencode\" -Recurse -Force

# 4. Agregar ~/bin al PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\bin", "User")
```

### Linux/Mac (manual)

```bash
# 1. Clonar
git clone https://github.com/nachopalmeri/agents-system.git ~/agents-system

# 2. Crear symlinks
ln -sf ~/agents-system/.agents ~/.agents
ln -sf ~/agents-system/bin ~/bin

# 3. Copiar config de OpenCode
mkdir -p ~/.config/opencode
cp -r ~/agents-system/config/opencode/* ~/.config/opencode/

# 4. Agregar ~/bin al PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

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
nuevo-proyecto test-install astro
```

Tiene que crear:
- `~/test-install/AGENTS.md`
- `~/test-install/tasks/todo.md`
- Worktrees de agentes

## Estructura del sistema

```text
.agents/
├── AGENTS.md                 # Reglas globales de orquestación
├── agents/                   # Agentes personalizados
│   ├── agente-principal.md
│   ├── agente-design.md
│   ├── agente-seo.md
│   ├── agente-tests.md
│   ├── agente-docs.md
│   ├── agente-obsidian-brain.md
│   ├── agente-ai-architect.md
│   ├── agente-marketing-strategist.md
│   ├── agente-growth-seo-geo.md
│   ├── agente-product-founder.md
│   ├── kickoff-architect.md
│   └── workflow-pruner.md
├── workflows/                # Workflows reutilizables
│   ├── start.md
│   ├── phases.md
│   ├── skills_routing.md
│   ├── task_ledger.md
│   ├── multiagent_review_loop.md
│   ├── ai_production.md
│   ├── web_briefing.md
│   ├── marketing.md
│   ├── marketing_mcp_eval.md
│   ├── venture_loop.md
│   ├── product_foundry.md
│   ├── seo_geo_growth.md
│   ├── mcp_catalog.md
│   ├── mcp_security.md
│   ├── mcp_adoption.md
│   ├── opencode_ecosystem.md
│   ├── parallel_agents.md
│   ├── hooks.md
│   └── ...
├── skills/                   # Skills del sistema
│   ├── astro/
│   ├── next/
│   ├── python/
│   ├── html-vanilla/
│   ├── obsidian-vault/
│   ├── product-foundry/
│   ├── seo-geo-growth/
│   ├── ai-production-architecture/
│   ├── web-presentation-premium/
│   └── ...
└── rules/                    # Reglas de código, testing, git
    ├── code-style.md
    ├── testing.md
    └── git.md

bin/
├── nuevo-proyecto.ps1        # Scaffolding Windows
├── nuevo-proyecto.sh         # Scaffolding Linux/Mac
├── doctor.ps1                # Diagnóstico de instalación
├── check-secrets.ps1         # Scanner simple de secretos
└── install-hooks.ps1         # Hooks locales opcionales

config/opencode/
├── AGENTS.md                 # Resumen global para OpenCode
└── opencode.jsonc            # Config con instructions

docs/
├── world-class-workflow.md    # Workflow maestro chat-first
├── architecture.md            # Capas Input → Model → Memory → Tools → Output
└── how-to-use-the-agent-system.md
```

## Uso diario

### Workflow maestro

Ver `docs/world-class-workflow.md`.

El flujo base es:

```text
start.md
→ index.md
→ phases.md si no trivial
→ modo simple / plan / /loop / Routine / multiagent review / Venture Loop
→ agente o skill especializado
→ tools seguras
→ validation.md
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

El agente `agente-product-founder` aplica el framework:

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

No se usa para fixes chicos. Si la crítica no puede cambiar la solución, usar flujo simple o `phases.md`.

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

El agente `agente-growth-seo-geo` aplica el loop:

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

Como es un repo Git, simplemente:

```bash
git pull origin main
```

Los symlinks apuntan automáticamente al contenido actualizado.

En Windows:

```powershell
.\update.ps1
.\bin\doctor.ps1
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
