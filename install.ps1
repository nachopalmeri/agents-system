#!/usr/bin/env pwsh
# Install script for agents-system on Windows
# Run: iwr https://raw.githubusercontent.com/nachopalmeri/agents-system/main/install.ps1 | iex

param(
    [string]$RepoUrl = "https://github.com/nachopalmeri/agents-system.git",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$installDir = "$env:USERPROFILE\agents-system"

Write-Host "=== Agents System Installer ===" -ForegroundColor Cyan
Write-Host "Installing from: $RepoUrl" -ForegroundColor Gray
Write-Host ""

# Check if running as Admin for symlink creation
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warning "Not running as Administrator. Will copy files instead of creating symlinks."
    $useSymlinks = $false
} else {
    $useSymlinks = $true
}

# 1. Clone or update repo
if (Test-Path $installDir) {
    Write-Host "Directory exists. Updating..." -ForegroundColor Yellow
    Push-Location $installDir
    git pull origin $Branch
    Pop-Location
} else {
    Write-Host "Cloning repository to $installDir..." -ForegroundColor Green
    git clone --branch $Branch $RepoUrl $installDir
}

# 2. Backup existing .agents if exists (not symlink)
$agentsDir = "$env:USERPROFILE\.agents"
$binDir = "$env:USERPROFILE\bin"

if ((Test-Path $agentsDir) -and -not (Get-Item $agentsDir).Target) {
    $backupName = ".agents-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "Backing up existing .agents to $backupName..." -ForegroundColor Yellow
    Rename-Item $agentsDir "$env:USERPROFILE\$backupName"
}

if ((Test-Path $binDir) -and -not (Get-Item $binDir).Target -and (Test-Path "$binDir\nuevo-proyecto.ps1")) {
    $backupName = "bin-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "Backing up existing bin to $backupName..." -ForegroundColor Yellow
    Rename-Item $binDir "$env:USERPROFILE\$backupName"
}

# 3. Create symlinks or copy files
if ($useSymlinks) {
    Write-Host "Creating symbolic links..." -ForegroundColor Green
    
    if (Test-Path $agentsDir) { Remove-Item $agentsDir -Force }
    New-Item -ItemType SymbolicLink -Path $agentsDir -Target "$installDir\.agents" | Out-Null
    Write-Host "  ✓ ~/.agents -> agents-system/.agents" -ForegroundColor Gray
    
    if (Test-Path $binDir) { Remove-Item $binDir -Force }
    New-Item -ItemType SymbolicLink -Path $binDir -Target "$installDir\bin" | Out-Null
    Write-Host "  ✓ ~/bin -> agents-system/bin" -ForegroundColor Gray
} else {
    Write-Host "Copying files (no admin rights)..." -ForegroundColor Yellow
    
    if (Test-Path $agentsDir) { Remove-Item $agentsDir -Recurse -Force }
    Copy-Item "$installDir\.agents" $agentsDir -Recurse -Force
    Write-Host "  ✓ Copied .agents" -ForegroundColor Gray
    
    if (Test-Path $binDir) { Remove-Item $binDir -Recurse -Force }
    Copy-Item "$installDir\bin" $binDir -Recurse -Force
    Write-Host "  ✓ Copied bin" -ForegroundColor Gray
}

# 4. Ensure ~/bin is in PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binDir*") {
    Write-Host "Adding ~/bin to PATH..." -ForegroundColor Green
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$binDir", "User")
    Write-Host "  ✓ Added to user PATH (restart terminal to use)" -ForegroundColor Gray
} else {
    Write-Host "  ✓ ~/bin already in PATH" -ForegroundColor Gray
}

# 5. Copy OpenCode config
$opencodeDir = "$env:USERPROFILE\.config\opencode"
$opencodeSource = "$installDir\config\opencode"
if (Test-Path $opencodeSource) {
    if (-not (Test-Path $opencodeDir)) {
        New-Item -ItemType Directory -Path $opencodeDir -Force | Out-Null
    }
    Copy-Item "$opencodeSource\*" $opencodeDir -Recurse -Force
    Write-Host "  ✓ Copied OpenCode config" -ForegroundColor Gray
}

# 6. Verify installation
Write-Host ""
Write-Host "=== Verification ===" -ForegroundColor Cyan

$checks = @(
    @{ Name = "~/.agents"; Path = $agentsDir },
    @{ Name = "~/bin/nuevo-proyecto.ps1"; Path = "$binDir\nuevo-proyecto.ps1" },
    @{ Name = "~/bin/nuevo-proyecto.sh"; Path = "$binDir\nuevo-proyecto.sh" }
)

$allOk = $true
foreach ($check in $checks) {
    if (Test-Path $check.Path) {
        Write-Host "  ✓ $($check.Name)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($check.Name) MISSING" -ForegroundColor Red
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
}

Write-Host ""
Write-Host "Repository location: $installDir" -ForegroundColor Gray
Write-Host "To update later: cd $installDir; git pull" -ForegroundColor Gray
