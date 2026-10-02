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
- Los adapters declarados por `config/runtime-manifest.json`. El archivo personal `opencode.jsonc` es opcional y no se sobrescribe.

### Vault y skills opcionales

En cada PC, configurá `~/.agents/local-paths.json` con la raíz real del vault (no sólo `Efforts`):

```json
{ "uadeVault": "C:/ruta/UADE-Vault" }
```

Validá con `~/bin/resolve-vault.ps1`. Requiere `.obsidian` y `AGENTS.md`; no crea ni migra notas. La sincronización preserva este archivo local.

Las skills de terceros se instalan por separado con `bin/install-external-skills.ps1`; consultá primero su ayuda y `-List`. Instalar instrucciones no instala automáticamente sus runtimes ni acepta términos: PDF/Office, Remotion y Tesseract pueden necesitar herramientas adicionales. No copies credenciales entre PCs ni instales dependencias sin autorización.

Para Tesseract, seguí `skills-library/tesseract-video/references/installation.md` de la instalación local y la versión fijada en `references/cli-version.txt`. Verificá `tsrct --version`; no habilites telemetría automáticamente.

OpenCode requiere dos verificaciones distintas: `opencode models --pure` para descubrimiento y una invocación acotada real para inferencia. Si la API falla, conservá el bloqueo y devolvé el trabajo al primary; no cambies a modelos pagos ni amplíes permisos.

## 5. Actualizar después

```powershell
Set-Location $env:USERPROFILE\agents-system
git pull origin main
.\update.ps1
.\bin\doctor.ps1
```

## 6. Seguridad

No copies `.env`, tokens ni credenciales al repo. Las API keys deben vivir como variables de entorno o en el gestor seguro de la herramienta correspondiente.
