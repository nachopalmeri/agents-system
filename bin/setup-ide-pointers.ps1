# setup-ide-pointers.ps1
# Crea punteros (symlinks o copias) desde cada IDE a ~/.agents/AGENTS.md
# para que cualquier herramienta (Windsurf, Zed, VS Code, Cursor, OpenCode, Claude Code, Gemini)
# use la misma fuente de verdad sin duplicar contenido.

[CmdletBinding()]
param(
    [string]$AgentsRoot = "$env:USERPROFILE\.agents",
    [switch]$DryRun,
    [switch]$ForceCopy  # Si symlink falla (sin admin), usar copia
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) {
    Write-Host "-> $msg" -ForegroundColor Cyan
}

function Write-OK($msg) {
    Write-Host "  [OK] $msg" -ForegroundColor Green
}

function Write-Warn($msg) {
    Write-Host "  [WARN] $msg" -ForegroundColor Yellow
}

function New-Pointer {
    param(
        [string]$Source,
        [string]$Target,
        [string]$Description
    )
    if ($DryRun) {
        Write-Host "  [DRY] $Description : $Target -> $Source"
        return
    }
    if (-not (Test-Path $Source)) {
        Write-Warn "Source no existe: $Source - skipping $Description"
        return
    }
    $parent = Split-Path $Target -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Remove-Item $Target -Force
        } else {
            $backup = "$Target.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Move-Item $Target $backup
            Write-Warn "Backup existente: $backup"
        }
    }
    try {
        if (-not $ForceCopy) {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -ErrorAction Stop | Out-Null
            Write-OK "$Description (symlink)"
        } else {
            Copy-Item $Source $Target -Force
            Write-OK "$Description (copy)"
        }
    } catch {
        Write-Warn "Symlink fallo (necesita admin o Developer Mode), usando copia: $Description"
        Copy-Item $Source $Target -Force
        Write-OK "$Description (copy fallback)"
    }
}

Write-Step "Setup IDE pointers - fuente: $AgentsRoot"

if (-not (Test-Path "$AgentsRoot\AGENTS.md")) {
    Write-Host "ERROR: No existe $AgentsRoot\AGENTS.md" -ForegroundColor Red
    Write-Host "Asegurate de tener el repo agents-system instalado en ~/.agents primero." -ForegroundColor Red
    exit 1
}

$source = "$AgentsRoot\AGENTS.md"

# 1. Windsurf / Cascade - global rules
Write-Step "Windsurf / Cascade"
New-Pointer -Source $source -Target "$env:USERPROFILE\.windsurf\global-rules.md" -Description "Windsurf global rules"

# 2. OpenCode (si existe la config)
Write-Step "OpenCode"
$openCodeDir = "$env:USERPROFILE\.config\opencode"
if (Test-Path $openCodeDir) {
    New-Pointer -Source $source -Target "$openCodeDir\AGENTS.md" -Description "OpenCode AGENTS"
} else {
    Write-Warn "OpenCode no instalado - skip"
}

# 3. Cursor (rules globales en home)
Write-Step "Cursor (global rules en home)"
New-Pointer -Source $source -Target "$env:USERPROFILE\.cursorrules" -Description "Cursor global rules"

# 4. Claude Code (en home)
Write-Step "Claude Code (en home)"
New-Pointer -Source $source -Target "$env:USERPROFILE\CLAUDE.md" -Description "Claude Code home"

# 5. Gemini CLI (en home)
Write-Step "Gemini CLI (en home)"
New-Pointer -Source $source -Target "$env:USERPROFILE\GEMINI.md" -Description "Gemini CLI home"

# 6. Zed (config global)
Write-Step "Zed (config global)"
$zedDir = "$env:USERPROFILE\AppData\Roaming\Zed"
if (Test-Path $zedDir) {
    New-Pointer -Source $source -Target "$zedDir\AGENTS.md" -Description "Zed global"
} else {
    Write-Warn "Zed no instalado - skip"
}

# 7. VS Code / Copilot (instrucciones globales en home, opcional)
Write-Step "Copilot (placeholder en home)"
New-Pointer -Source $source -Target "$env:USERPROFILE\copilot-instructions.md" -Description "Copilot home reference"

Write-Host ""
Write-Host "Setup completo." -ForegroundColor Green
Write-Host ""
Write-Host "Notas:" -ForegroundColor Yellow
Write-Host "  - Para Cursor/Copilot por proyecto: copiar manualmente ~/.cursorrules a .cursorrules del repo"
Write-Host "  - Para ChatGPT web: pegar contenido de $source en Custom Instructions"
Write-Host "  - Para repos individuales con CLAUDE.md / AGENTS.md: copiar desde home cuando hagas clone"
Write-Host ""
Write-Host "Verificar con: bin\doctor.ps1" -ForegroundColor Cyan
