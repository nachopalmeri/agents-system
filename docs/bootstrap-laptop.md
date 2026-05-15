# Bootstrap en laptop nueva

Guía rápida para instalar el sistema de agentes desde un repo privado.

## 1. Requisitos

- Git instalado.
- PowerShell en Windows.
- GitHub CLI (`gh`) instalado y autenticado.
- Opcional: OpenCode, Ollama, Zed, VS Code, Obsidian.

## 2. Instalar GitHub CLI

```powershell
winget install --id GitHub.cli
```

Luego autenticarse:

```powershell
gh auth login
gh auth status
```

## 3. Clonar e instalar

```powershell
gh repo clone nachopalmeri/agents-system $env:USERPROFILE\agents-system
& "$env:USERPROFILE\agents-system\install-private.ps1"
```

Si el repo tiene otro nombre, ajustar `nachopalmeri/agents-system`.

## 4. Verificar

```powershell
& "$env:USERPROFILE\agents-system\bin\doctor.ps1"
```

Verificar que existan:

- `$env:USERPROFILE\.agents`
- `$env:USERPROFILE\bin\nuevo-proyecto.ps1`
- `$env:USERPROFILE\.config\opencode\opencode.jsonc`

## 5. Actualizar después

```powershell
Set-Location $env:USERPROFILE\agents-system
git pull origin main
.\update.ps1
.\bin\doctor.ps1
```

## 6. Seguridad

No copies `.env`, tokens ni credenciales al repo. Las API keys deben vivir como variables de entorno o en el gestor seguro de la herramienta correspondiente.
