# update-system.ps1
# Pipeline de actualizacion: git pull -> resync ~/.agents -> setup-ide-pointers -> doctor
# Resuelve la falla critica de drift cuando se usan copias en vez de symlinks.

[CmdletBinding()]
param(
    [string]$RepoPath,
    [switch]$SkipPull,
    [switch]$DryRun,
    [switch]$VerboseOutput
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "  [ERROR] $msg" -ForegroundColor Red }

# Detectar el repo automaticamente si no se paso
if (-not $RepoPath) {
    $candidates = @(
        "$env:USERPROFILE\agents-system",
        "$env:USERPROFILE\CascadeProjects\agents-system"
    )
    foreach ($c in $candidates) {
        if (Test-Path "$c\.git") {
            $RepoPath = $c
            break
        }
    }
}

if (-not $RepoPath -or -not (Test-Path "$RepoPath\.git")) {
    Write-Err "No se encontro el repo agents-system. Especificar con -RepoPath."
    exit 1
}

$agentsTarget = "$env:USERPROFILE\.agents"
$agentsSource = "$RepoPath\.agents"

Write-Step "Update System"
Write-Host "  Repo:   $RepoPath" -ForegroundColor Gray
Write-Host "  Target: $agentsTarget" -ForegroundColor Gray
Write-Host ""

# Detectar si symlinks estan disponibles
function Test-SymlinkSupport {
    $testPath = "$env:TEMP\symlink-test-$(Get-Random)"
    try {
        New-Item -ItemType SymbolicLink -Path $testPath -Target $env:USERPROFILE -ErrorAction Stop | Out-Null
        Remove-Item $testPath -Force
        return $true
    } catch {
        return $false
    }
}

$canSymlink = Test-SymlinkSupport
if ($canSymlink) {
    Write-OK "Symlinks disponibles (Developer Mode o admin)"
} else {
    Write-Warn "Symlinks NO disponibles. Usando copias (drift posible). Activar Developer Mode para mejor experiencia."
}

# 1. Git pull
if (-not $SkipPull) {
    Write-Step "Step 1: git pull"
    if ($DryRun) {
        Write-Host "  [DRY] git -C $RepoPath pull origin main"
    } else {
        Push-Location $RepoPath
        try {
            $prevPref = $ErrorActionPreference
            $ErrorActionPreference = "Continue"
            $pullOutput = & git pull origin main 2>&1 | Out-String
            $ErrorActionPreference = $prevPref
            if ($LASTEXITCODE -ne 0) {
                Write-Err "git pull fallo:"
                Write-Host $pullOutput
                exit 1
            }
            Write-OK "Pull completo"
            if ($VerboseOutput) { Write-Host $pullOutput -ForegroundColor Gray }
        } finally {
            Pop-Location
        }
    }
} else {
    Write-Warn "Skip pull (flag -SkipPull)"
}

# 2. Sync ~/.agents
Write-Step "Step 2: Sync ~/.agents"

if ($DryRun) {
    Write-Host "  [DRY] Sync $agentsSource -> $agentsTarget"
} else {
    # Si target existe y es symlink correcto, no tocar
    if (Test-Path $agentsTarget) {
        $item = Get-Item $agentsTarget -Force
        if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $agentsSource) {
            Write-OK "~/.agents ya es symlink correcto. No se toca."
        } else {
            # Es copia o symlink mal apuntado: borrar y rehacer
            try {
                Remove-Item $agentsTarget -Recurse -Force -ErrorAction Stop
            } catch {
                # Algunos items tienen .git con permisos especiales
                Write-Warn "Borrado parcial fallo, usando robocopy..."
                Remove-Item $agentsTarget -Recurse -Force -ErrorAction SilentlyContinue
            }

            if ($canSymlink) {
                New-Item -ItemType SymbolicLink -Path $agentsTarget -Target $agentsSource | Out-Null
                Write-OK "~/.agents -> symlink"
            } else {
                New-Item -ItemType Directory -Path $agentsTarget -Force | Out-Null
                Copy-Item "$agentsSource\*" $agentsTarget -Recurse -Force
                Write-OK "~/.agents -> copia actualizada"
            }
        }
    } else {
        if ($canSymlink) {
            New-Item -ItemType SymbolicLink -Path $agentsTarget -Target $agentsSource | Out-Null
            Write-OK "~/.agents -> symlink (nuevo)"
        } else {
            New-Item -ItemType Directory -Path $agentsTarget -Force | Out-Null
            Copy-Item "$agentsSource\*" $agentsTarget -Recurse -Force
            Write-OK "~/.agents -> copia (nuevo)"
        }
    }
}

# 3. Re-correr setup-ide-pointers
Write-Step "Step 3: setup-ide-pointers"
$setupScript = "$RepoPath\bin\setup-ide-pointers.ps1"
if (Test-Path $setupScript) {
    if ($DryRun) {
        Write-Host "  [DRY] $setupScript"
    } else {
        if ($canSymlink) {
            & $setupScript -AgentsRoot $agentsTarget
        } else {
            & $setupScript -AgentsRoot $agentsTarget -ForceCopy
        }
    }
} else {
    Write-Warn "setup-ide-pointers.ps1 no encontrado en $setupScript"
}

# 4. Doctor
Write-Step "Step 4: doctor (validacion)"
$doctorScript = "$RepoPath\bin\doctor.ps1"
if (Test-Path $doctorScript) {
    if ($DryRun) {
        Write-Host "  [DRY] $doctorScript"
    } else {
        & $doctorScript
    }
} else {
    Write-Warn "doctor.ps1 no encontrado"
}

Write-Host ""
Write-Step "Update completo"
if (-not $canSymlink) {
    Write-Host ""
    Write-Host "TIP: Activa Developer Mode en Windows para usar symlinks reales:" -ForegroundColor Yellow
    Write-Host "  Settings -> Privacy and security -> For developers -> Developer Mode: ON" -ForegroundColor Gray
    Write-Host "Despues corre este script de nuevo y va a migrar automaticamente a symlinks." -ForegroundColor Gray
}
