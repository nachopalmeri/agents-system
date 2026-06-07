# setup-ide-pointers.ps1
# Crea punteros (symlinks o copias) desde cada IDE a ~/.agents/AGENTS.md
# Paths verificados contra docs oficiales de cada IDE (2026-06).

[CmdletBinding()]
param(
    [string]$AgentsRoot = "$env:USERPROFILE\.agents",
    [switch]$DryRun,
    [switch]$ForceCopy
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host "-> $msg" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-Skip($msg) { Write-Host "  [SKIP] $msg" -ForegroundColor DarkGray }

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
        Write-Warn "Source no existe: $Source"
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
            Move-Item $Target $backup -ErrorAction SilentlyContinue
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
        Copy-Item $Source $Target -Force
        Write-OK "$Description (copy fallback)"
    }
}

Write-Step "Setup IDE pointers - fuente: $AgentsRoot"

if (-not (Test-Path "$AgentsRoot\AGENTS.md")) {
    Write-Host "ERROR: No existe $AgentsRoot\AGENTS.md" -ForegroundColor Red
    exit 1
}

$source = "$AgentsRoot\AGENTS.md"

# 1. Devin Desktop (ex-Windsurf) - Agent Client Protocol (ACP)
# https://devin.ai/blog/windsurf-is-now-devin-desktop
# Devin Desktop soporta ACP: Codex, Claude Agent, OpenCode, etc. corren dentro.
# Legacy .windsurf/ paths pueden seguir funcionando como fallback.
Write-Step "Devin Desktop (ex-Windsurf)"
New-Pointer -Source $source -Target "$env:USERPROFILE\.windsurf\global-rules.md" -Description "Devin Desktop global rules (legacy .windsurf)"

# 2. OpenCode - convencion AGENTS.md
Write-Step "OpenCode"
$openCodeDir = "$env:USERPROFILE\.config\opencode"
if (Test-Path $openCodeDir) {
    New-Pointer -Source $source -Target "$openCodeDir\AGENTS.md" -Description "OpenCode AGENTS"
    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $openCodeConfigSource = Join-Path $repoRoot "config\opencode\opencode.jsonc"
    if (Test-Path $openCodeConfigSource) {
        Copy-Item $openCodeConfigSource "$openCodeDir\opencode.jsonc" -Force
        Write-OK "OpenCode config (copy)"
    }
} else {
    Write-Skip "OpenCode no instalado"
}

# 3. Claude Code - ~/.claude/CLAUDE.md (memoria global)
# https://code.claude.com/docs/en/claude-directory
Write-Step "Claude Code"
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
}
New-Pointer -Source $source -Target "$claudeDir\CLAUDE.md" -Description "Claude Code global memory"

# 4. Antigravity CLI (ex-Gemini CLI) - ~/.gemini/GEMINI.md (global context)
# https://antigravity.google/docs/gcli-migration
# Gemini CLI se descontinua Junio 18, 2026. Antigravity CLI sigue leyendo GEMINI.md y AGENTS.md.
# Skills se mueven de .gemini/skills/ a .agents/skills/ (ya compatible con nuestra estructura).
Write-Step "Antigravity CLI (ex-Gemini CLI)"
$geminiDir = "$env:USERPROFILE\.gemini"
if (Test-Path $geminiDir) {
    New-Pointer -Source $source -Target "$geminiDir\GEMINI.md" -Description "Antigravity CLI global context"
} else {
    Write-Skip "Antigravity CLI no instalado (no existe ~/.gemini/)"
}

# 5. Cursor - .cursorrules legacy en home (best-effort, Cursor prefiere UI Settings)
# https://docs.cursor.com/context/rules
Write-Step "Cursor (legacy .cursorrules)"
Write-Warn "Cursor user-level rules viven en Settings UI. Este archivo es fallback legacy."
New-Pointer -Source $source -Target "$env:USERPROFILE\.cursorrules" -Description "Cursor legacy rules (home)"

# 6. Codex CLI - ~/.codex/AGENTS.md (global) + AGENTS.override.md por directorio
# https://developers.openai.com/codex/guides/agents-md
# Codex soporta AGENTS.override.md por directorio (precedencia sobre AGENTS.md).
# Discovery chain: global → project root → subdirectorios → override.
Write-Step "Codex CLI"
$codexDir = "$env:USERPROFILE\.codex"
if (-not (Test-Path $codexDir)) {
    New-Item -ItemType Directory -Path $codexDir -Force | Out-Null
}
New-Pointer -Source $source -Target "$codexDir\AGENTS.md" -Description "Codex CLI global instructions"
New-Pointer -Source $source -Target "$env:USERPROFILE\AGENTS.md" -Description "Codex CLI / AGENTS home convention"

Write-Host ""
Write-Step "IDEs que requieren config manual:"
Write-Host "  Cursor User Rules:" -ForegroundColor Yellow
Write-Host "    1. Cursor -> Settings -> Cursor Settings -> Rules -> User Rules" -ForegroundColor Gray
Write-Host "    2. Pegar contenido de: $source" -ForegroundColor Gray
Write-Host ""
Write-Host "  ChatGPT (web):" -ForegroundColor Yellow
Write-Host "    1. Custom Instructions del proyecto/cuenta" -ForegroundColor Gray
Write-Host "    2. Pegar contenido de: $source" -ForegroundColor Gray
Write-Host ""
Write-Host "  VS Code Copilot (per-repo):" -ForegroundColor Yellow
Write-Host "    En cada repo: cp `"$source`" .github/copilot-instructions.md" -ForegroundColor Gray
Write-Host ""
Write-Host "  Zed:" -ForegroundColor Yellow
Write-Host "    Zed no carga AGENTS.md global. Usar configuracion del Assistant en settings.json." -ForegroundColor Gray
Write-Host ""
Write-Host "  AGENTS.override.md (Codex CLI):" -ForegroundColor Yellow
Write-Host "    Crear AGENTS.override.md en subdirectorios para reglas especificas por equipo/servicio." -ForegroundColor Gray
Write-Host "    Codex prioriza override sobre AGENTS.md en el mismo directorio." -ForegroundColor Gray
Write-Host ""
Write-Host "  Devin Desktop (ACP):" -ForegroundColor Yellow
Write-Host "    Devin Desktop soporta Codex, Claude Agent, OpenCode, etc. via Agent Client Protocol." -ForegroundColor Gray
Write-Host "    AGENTS.md funciona como contexto compartido entre todos los agentes ACP." -ForegroundColor Gray
Write-Host ""

Write-Step "Setup completo"
Write-Host "Verificar con: bin\doctor.ps1" -ForegroundColor Cyan
