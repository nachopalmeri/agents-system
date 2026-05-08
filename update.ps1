#!/usr/bin/env pwsh
# Script para actualizar el sistema después de hacer git pull
# Ejecutar desde: ~/agents-system/

$ErrorActionPreference = "Stop"

Write-Host "=== Actualizando sistema local ===" -ForegroundColor Cyan
Write-Host ""

# Detectar si se usan symlinks o copias
$agentsDir = "$env:USERPROFILE\.agents"
$binDir = "$env:USERPROFILE\bin"

$usingSymlinks = $false
if (Test-Path $agentsDir) {
    $item = Get-Item $agentsDir -ErrorAction SilentlyContinue
    if ($item.Target) {
        $usingSymlinks = $true
    }
}

if ($usingSymlinks) {
    Write-Host "Modo: Symlinks (los cambios ya están activos)" -ForegroundColor Green
    Write-Host "  Los symlinks apuntan a esta carpeta, así que git pull = actualización inmediata" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Verificación:" -ForegroundColor Yellow
    
    # Verificar que todo esté bien
    $checks = @(
        @{ Name = "~/.agents"; Path = $agentsDir },
        @{ Name = "~/bin"; Path = $binDir }
    )
    
    foreach ($check in $checks) {
        $target = (Get-Item $check.Path -ErrorAction SilentlyContinue).Target
        if ($target -and $target -like "*agents-system*") {
            Write-Host "  ✓ $($check.Name) -> $target" -ForegroundColor Green
        } else {
            Write-Warning "  ✗ $($check.Name) symlink roto o apuntando a otro lado"
        }
    }
} else {
    Write-Host "Modo: Copias (necesita sincronización manual)" -ForegroundColor Yellow
    Write-Host "  Copiando archivos actualizados..." -ForegroundColor Gray
    
    # Copiar de vuelta a ubicaciones estándar
    if (Test-Path ".\.agents") {
        if (Test-Path $agentsDir) { Remove-Item $agentsDir -Recurse -Force }
        Copy-Item ".\.agents" $agentsDir -Recurse -Force
        Write-Host "  ✓ ~/.agents actualizado" -ForegroundColor Green
    }
    
    if (Test-Path ".\bin") {
        if (Test-Path $binDir) { Remove-Item $binDir -Recurse -Force }
        Copy-Item ".\bin" $binDir -Recurse -Force
        Write-Host "  ✓ ~/bin actualizado" -ForegroundColor Green
    }
    
    if (Test-Path ".\config\opencode") {
        $opencodeDir = "$env:USERPROFILE\.config\opencode"
        if (-not (Test-Path $opencodeDir)) { New-Item -ItemType Directory -Path $opencodeDir -Force | Out-Null }
        Copy-Item ".\config\opencode\*" $opencodeDir -Recurse -Force
        Write-Host "  ✓ ~/.config/opencode actualizado" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Actualización completa ===" -ForegroundColor Green
Write-Host "Reiniciá tu terminal/IDE para asegurar cambios cargados."
