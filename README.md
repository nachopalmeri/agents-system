# Agents System — Dotfiles de Nacho Palmeri

Sistema global de agentes, workflows, skills y scaffolding para desarrollo con IA multi-herramienta.

## Qué contiene

- `.agents/` — Reglas globales, workflows, skills, agentes personalizados
- `bin/` — Scripts `nuevo-proyecto.ps1` y `nuevo-proyecto.sh`
- `config/opencode/` — Configuración de OpenCode (`AGENTS.md`, `opencode.jsonc`)
- `config/windsurf/` — Estructura local de Windsurf (planes, etc)

## Requisitos previos

- Git instalado
- PowerShell (Windows) o Bash (Linux/Mac)
- Opcional: OpenCode, Zed, Obsidian

## Instalación rápida (PC nueva)

### Windows (PowerShell como Admin)

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
│   ├── kickoff-architect.md
│   └── workflow-pruner.md
├── workflows/                # Workflows reutilizables
│   ├── start.md
│   ├── phases.md
│   ├── skills_routing.md
│   ├── ai_production.md
│   ├── web_briefing.md
│   └── ...
├── skills/                   # Skills del sistema
│   ├── astro/
│   ├── next/
│   ├── python/
│   ├── html-vanilla/
│   ├── obsidian-vault/
│   ├── ai-production-architecture/
│   ├── web-presentation-premium/
│   └── ...
└── rules/                    # Reglas de código, testing, git
    ├── code-style.md
    ├── testing.md
    └── git.md

bin/
├── nuevo-proyecto.ps1        # Scaffolding Windows
└── nuevo-proyecto.sh         # Scaffolding Linux/Mac

config/opencode/
├── AGENTS.md                 # Resumen global para OpenCode
└── opencode.jsonc            # Config con instructions
```

## Uso diario

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

### Crear proyecto web premium (con briefing)

```bash
nuevo-proyecto mi-pitch next
# La IA preguntará: ¿qué buscás? objetivo, audiencia, tono...
```

## Actualizar el sistema

Como es un repo Git, simplemente:

```bash
cd ~/agents-system
git pull origin main
```

Los symlinks apuntan automáticamente al contenido actualizado.

## Contribuciones

Este es tu sistema personal. Modificá reglas, agregá skills, experimentá. Cuando encuentres algo que funcione bien, commitealo y pushealo.

## Notas

- El vault de Obsidian (`Q1-2026-UADE`) se sincroniza vía OneDrive, no está en este repo
- Las API keys y `.env` nunca deben commitearse (están en `.gitignore` global)
- Cada proyecto creado con `nuevo-proyecto` hereda las reglas pero tiene su propio `AGENTS.md` local

## Contacto

Nacho Palmeri — Pisculichi Labs
