# Script simple para copiar sistema actual al repo
$ErrorActionPreference = "Stop"

Write-Host "=== Copiando sistema actual al repo ===" -ForegroundColor Cyan

# 1. Copiar .agents/
Write-Host "[1/3] Copiando .agents ..." -ForegroundColor Yellow
if (Test-Path "$env:USERPROFILE\.agents") {
    if (Test-Path ".\.agents") { Remove-Item ".\.agents" -Recurse -Force }
    Copy-Item "$env:USERPROFILE\.agents" . -Recurse -Force
    Write-Host "  OK .agents copiado" -ForegroundColor Green
} else {
    Write-Host "  ERROR: No se encontro .agents" -ForegroundColor Red
}

# 2. Copiar bin/
Write-Host "[2/3] Copiando bin ..." -ForegroundColor Yellow
$files = @("nuevo-proyecto.ps1", "nuevo-proyecto.sh")
foreach ($f in $files) {
    $src = "$env:USERPROFILE\bin\$f"
    if (Test-Path $src) {
        Copy-Item $src ".\bin\$f" -Force
        Write-Host "  OK $f copiado" -ForegroundColor Green
    } else {
        Write-Host "  SKIP $f no encontrado" -ForegroundColor Gray
    }
}

# 3. Copiar config/opencode/
Write-Host "[3/3] Copiando config/opencode ..." -ForegroundColor Yellow
$srcDir = "$env:USERPROFILE\.config\opencode"
if (Test-Path $srcDir) {
    New-Item -ItemType Directory -Path ".\config\opencode" -Force -ErrorAction SilentlyContinue | Out-Null
    Copy-Item "$srcDir\*" ".\config\opencode\" -Recurse -Force
    Write-Host "  OK config/opencode copiado" -ForegroundColor Green
} else {
    Write-Host "  SKIP config/opencode no encontrado" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Listo para commitear ===" -ForegroundColor Green
Write-Host "Ejecuta: git init; git add .; git commit -m 'feat: sistema inicial'" -ForegroundColor Yellow
