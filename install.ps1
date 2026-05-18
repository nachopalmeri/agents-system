#!/usr/bin/env pwsh
param(
    [string]$RepoUrl = "https://github.com/nachopalmeri/agents-system.git",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

# Detectar repo existente en ubicaciones conocidas
$candidates = @(
    (Join-Path $env:USERPROFILE "agents-system"),
    (Join-Path $env:USERPROFILE "CascadeProjects\agents-system")
)
$installDir = $null
foreach ($c in $candidates) {
    if (Test-Path "$c\.git") { $installDir = $c; break }
}
if (-not $installDir) { $installDir = $candidates[0] }  # default a ~/agents-system

$agentsDir = Join-Path $env:USERPROFILE ".agents"
$binDir = Join-Path $env:USERPROFILE "bin"
$opencodeDir = Join-Path $env:USERPROFILE ".config\opencode"

Write-Host "=== Agents System Installer ===" -ForegroundColor Cyan
Write-Host "Installing from: $RepoUrl" -ForegroundColor Gray
Write-Host ""

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$useSymlinks = [bool]$isAdmin
if (-not $useSymlinks) {
    Write-Warning "Not running as Administrator. Will copy files instead of creating symlinks."
}

if (Test-Path $installDir) {
    Write-Host "Directory exists. Updating..." -ForegroundColor Yellow
    git -C $installDir pull origin $Branch
} else {
    Write-Host "Cloning repository to $installDir..." -ForegroundColor Green
    git clone --branch $Branch $RepoUrl $installDir
}

function Backup-DirectoryIfNeeded {
    param(
        [string]$Path,
        [string]$BackupPrefix,
        [switch]$OnlyIfContainsNuevoProyecto
    )

    if (-not (Test-Path $Path)) {
        return
    }

    $item = Get-Item $Path
    if ($item.Target) {
        return
    }

    if ($OnlyIfContainsNuevoProyecto -and -not (Test-Path (Join-Path $Path "nuevo-proyecto.ps1"))) {
        return
    }

    $backupName = "$BackupPrefix-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    $backupPath = Join-Path $env:USERPROFILE $backupName
    Write-Host "Backing up existing $Path to $backupPath..." -ForegroundColor Yellow
    Rename-Item $Path $backupPath
}

Backup-DirectoryIfNeeded -Path $agentsDir -BackupPrefix ".agents"
Backup-DirectoryIfNeeded -Path $binDir -BackupPrefix "bin" -OnlyIfContainsNuevoProyecto

if ($useSymlinks) {
    Write-Host "Creating symbolic links..." -ForegroundColor Green

    if (Test-Path $agentsDir) { Remove-Item $agentsDir -Force }
    New-Item -ItemType SymbolicLink -Path $agentsDir -Target (Join-Path $installDir ".agents") | Out-Null
    Write-Host "  [OK] ~/.agents -> agents-system/.agents" -ForegroundColor Gray

    if (Test-Path $binDir) { Remove-Item $binDir -Force }
    New-Item -ItemType SymbolicLink -Path $binDir -Target (Join-Path $installDir "bin") | Out-Null
    Write-Host "  [OK] ~/bin -> agents-system/bin" -ForegroundColor Gray
} else {
    Write-Host "Copying files (no admin rights)..." -ForegroundColor Yellow

    if (Test-Path $agentsDir) { Remove-Item $agentsDir -Recurse -Force }
    Copy-Item (Join-Path $installDir ".agents") $agentsDir -Recurse -Force
    Write-Host "  [OK] Copied .agents" -ForegroundColor Gray

    if (Test-Path $binDir) { Remove-Item $binDir -Recurse -Force }
    Copy-Item (Join-Path $installDir "bin") $binDir -Recurse -Force
    Write-Host "  [OK] Copied bin" -ForegroundColor Gray
}

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binDir*") {
    Write-Host "Adding ~/bin to PATH..." -ForegroundColor Green
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$binDir", "User")
    Write-Host "  [OK] Added to user PATH (restart terminal to use)" -ForegroundColor Gray
} else {
    Write-Host "  [OK] ~/bin already in PATH" -ForegroundColor Gray
}

$opencodeSource = Join-Path $installDir "config\opencode"
if (Test-Path $opencodeSource) {
    if (-not (Test-Path $opencodeDir)) {
        New-Item -ItemType Directory -Path $opencodeDir -Force | Out-Null
    }
    Copy-Item (Join-Path $opencodeSource "*") $opencodeDir -Recurse -Force
    Write-Host "  [OK] Copied OpenCode config" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Verification ===" -ForegroundColor Cyan

$checks = @(
    [pscustomobject]@{ Name = "~/.agents"; Path = $agentsDir },
    [pscustomobject]@{ Name = "~/bin/nuevo-proyecto.ps1"; Path = (Join-Path $binDir "nuevo-proyecto.ps1") },
    [pscustomobject]@{ Name = "~/bin/nuevo-proyecto.sh"; Path = (Join-Path $binDir "nuevo-proyecto.sh") }
)

$allOk = $true
foreach ($check in $checks) {
    if (Test-Path $check.Path) {
        Write-Host "  [OK] $($check.Name)" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $($check.Name) -> $($check.Path)" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""
if ($allOk) {
    Write-Host "=== Installation Complete ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Test it:"
    Write-Host "  nuevo-proyecto test-install astro" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Then:"
    Write-Host "  cd ~/test-install" -ForegroundColor Gray
    Write-Host "  opencode" -ForegroundColor Gray
    Write-Host ""

    if (-not $useSymlinks) {
        Write-Host "NOTE: You used copy mode. To use symlinks (better for updates), run:" -ForegroundColor Yellow
        Write-Host "  1. Open PowerShell as Administrator" -ForegroundColor Gray
        Write-Host "  2. Run this script again" -ForegroundColor Gray
    }
} else {
    Write-Host "=== Installation Incomplete ===" -ForegroundColor Red
    Write-Host "Some files are missing. Check errors above."
    exit 1
}

Write-Host ""
Write-Host "=== Configurando punteros multi-IDE ===" -ForegroundColor Cyan
$setupScript = Join-Path $installDir "bin\setup-ide-pointers.ps1"
if (Test-Path $setupScript) {
    if ($useSymlinks) {
        & $setupScript -AgentsRoot $agentsDir
    } else {
        & $setupScript -AgentsRoot $agentsDir -ForceCopy
    }
} else {
    Write-Warning "setup-ide-pointers.ps1 no encontrado, skip multi-IDE setup"
}

Write-Host ""
Write-Host "Repository location: $installDir" -ForegroundColor Gray
Write-Host "To update later: $installDir\bin\update-system.ps1" -ForegroundColor Gray
