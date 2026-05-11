# Script para copiar tu sistema actual a este repo local
$ErrorActionPreference = "Stop"

Write-Host "=== Copiando sistema actual al repo ===" -ForegroundColor Cyan
Write-Host "Origen: $env:USERPROFILE" -ForegroundColor Gray
Write-Host "Destino: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

Write-Host "[1/3] Copiando .agents ..." -ForegroundColor Yellow
if (Test-Path "$env:USERPROFILE\.agents") {
    if (Test-Path ".\.agents") {
        Remove-Item ".\.agents" -Recurse -Force
    }
    Copy-Item "$env:USERPROFILE\.agents" . -Recurse -Force
    Write-Host "  OK .agents copiado" -ForegroundColor Green
} else {
    Write-Host "  ERROR: No se encontro .agents" -ForegroundColor Red
}

Write-Host "[2/3] Copiando bin ..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path ".\bin" -Force | Out-Null
foreach ($file in @("nuevo-proyecto.ps1", "nuevo-proyecto.sh", "check-agents-system.ps1")) {
    $source = "$env:USERPROFILE\bin\$file"
    if (Test-Path $source) {
        Copy-Item $source ".\bin\$file" -Force
        Write-Host "  OK $file copiado" -ForegroundColor Green
    } else {
        Write-Host "  SKIP $file no encontrado" -ForegroundColor Gray
    }
}

Write-Host "[3/3] Copiando config/opencode ..." -ForegroundColor Yellow
$opencodeDir = "$env:USERPROFILE\.config\opencode"
if (Test-Path $opencodeDir) {
    New-Item -ItemType Directory -Path ".\config\opencode" -Force | Out-Null
    Copy-Item "$opencodeDir\*" ".\config\opencode\" -Recurse -Force
    Write-Host "  OK config/opencode copiado" -ForegroundColor Green
} else {
    Write-Host "  SKIP config/opencode no encontrado" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Listo ===" -ForegroundColor Green
Write-Host "Siguiente: git status; git add .; git commit -m 'chore: sync agents system'" -ForegroundColor Yellow
