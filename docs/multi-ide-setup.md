# Multi-IDE Setup

Cómo conectar el sistema de agentes (`~/.agents/`) a cada IDE/herramienta sin duplicar contenido.

## Principio

`~/.agents/AGENTS.md` es la **única fuente de verdad**. Cada IDE tiene un puntero (symlink o copia liviana) que apunta a ese archivo. Si actualizás el repo, todos los IDEs ven el cambio automáticamente.

## Setup automático

```powershell
# Windows
.\bin\setup-ide-pointers.ps1

# Si falla por permisos de symlink:
.\bin\setup-ide-pointers.ps1 -ForceCopy

# Solo simular sin tocar archivos:
.\bin\setup-ide-pointers.ps1 -DryRun
```

```bash
# Linux/Mac (manual por ahora, pendiente setup-ide-pointers.sh)
ln -sf ~/.agents/AGENTS.md ~/.cursorrules
ln -sf ~/.agents/AGENTS.md ~/CLAUDE.md
ln -sf ~/.agents/AGENTS.md ~/GEMINI.md
```

## Setup manual por IDE

| IDE | Path destino | Cómo carga el contexto |
|---|---|---|
| **Windsurf / Cascade** | `~\.windsurf\global-rules.md` | Cascade carga global rules automáticamente |
| **OpenCode** | `~\.config\opencode\AGENTS.md` | OpenCode lee `AGENTS.md` por convención |
| **Cursor** | `~\.cursorrules` (global) o `.cursorrules` (por proyecto) | Carga automática |
| **Claude Code** | `~\CLAUDE.md` (home) o `CLAUDE.md` (por repo) | Convención del CLI |
| **Gemini CLI** | `~\GEMINI.md` o `GEMINI.md` por repo | Convención del CLI |
| **Zed** | `%APPDATA%\Zed\AGENTS.md` | Asistente lee AGENTS.md si existe |
| **VS Code + Copilot** | `.github/copilot-instructions.md` por repo | Copilot Chat lo carga automáticamente |
| **ChatGPT (web)** | Custom Instructions del proyecto | Pegar contenido manualmente |

## Por qué symlinks (vs copias)

- **Symlink:** un cambio en `~/.agents/AGENTS.md` se refleja en todos los IDEs sin re-sync.
- **Copia:** funciona sin permisos especiales, pero hay que re-correr el script cuando cambia la fuente.

En Windows, los symlinks requieren:
- Ejecutar PowerShell como admin, **o**
- Activar Developer Mode (Settings → Privacy & Security → For developers).

Si ninguno está disponible, el script cae automáticamente a copias.

## Por proyecto vs global

**Por proyecto (recomendado para repos importantes):**
```bash
# En cada repo crítico:
cp ~/.agents/AGENTS.md AGENTS.md
cp ~/.agents/AGENTS.md CLAUDE.md
mkdir -p .github && cp ~/.agents/AGENTS.md .github/copilot-instructions.md
```

**Global (suficiente para la mayoría):**
- `~/.agents/AGENTS.md` con punteros desde home
- IDEs que cargan global rules ven el contexto en cualquier proyecto

## Validación

Después del setup:

```powershell
.\bin\doctor.ps1
```

Y abrí un IDE para confirmar que el contexto se cargó.

## Mantenimiento

- Actualizá `~/.agents/AGENTS.md` o cualquier regla en `~/.agents/rules/`.
- `git add -A && git commit -m "feat: ..." && git push origin main` (regla obligatoria).
- Si usaste copias en vez de symlinks, re-correr `setup-ide-pointers.ps1` después de cada cambio.
