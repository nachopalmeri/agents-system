#!/usr/bin/env pwsh
# Script para copiar tu sistema actual a este repo local
# Ejecutar desde: C:\Users\ignac\CascadeProjects\cv-palmeri\agents-system\

$ErrorActionPreference = "Stop"

Write-Host "=== Copiando sistema actual al repo ===" -ForegroundColor Cyan
Write-Host "Origen: $env:USERPROFILE" -ForegroundColor Gray
Write-Host "Destino: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# 1. Copiar .agents/
Write-Host "[1/3] Copiando ~/.agents ..." -ForegroundColor Yellow
if (Test-Path "$env:USERPROFILE\.agents") {
    if (Test-Path ".\.agents") {
        Write-Host "  Eliminando .agents existente..." -ForegroundColor Gray
        Remove-Item ".\.agents" -Recurse -Force
    }
    Copy-Item "$env:USERPROFILE\.agents" . -Recurse -Force
    Write-Host "  ✓ .agents copiado" -ForegroundColor Green
} else {
    Write-Warning "No se encontró ~/.agents"
}

# 2. Copiar bin/
Write-Host "[2/3] Copiando ~/bin ..." -ForegroundColor Yellow
$binFiles = @("nuevo-proyecto.ps1", "nuevo-proyecto.sh")
$copied = 0

foreach ($file in $binFiles) {
    $source = "$env:USERPROFILE\bin\$file"
    if (Test-Path $source) {
        Copy-Item $source ".\bin\$file" -Force
        Write-Host "  ✓ $file copiado" -ForegroundColor Green
        $copied++
    } else {
        Write-Host "  ✗ $file no encontrado" -ForegroundColor Red
    }
}

if ($copied -eq 0) {
    Write-Warning "No se encontraron scripts en ~/bin"
}

# 3. Copiar config/opencode/
Write-Host "[3/3] Copiando config/opencode ..." -ForegroundColor Yellow
$opencodeDir = "$env:USERPROFILE\.config\opencode"
if (Test-Path $opencodeDir) {
    if (-not (Test-Path ".\config\opencode")) {
        New-Item -ItemType Directory -Path ".\config\opencode" -Force | Out-Null
    }
    
    $files = @("AGENTS.md", "opencode.jsonc")
    foreach ($file in $files) {
        $source = "$opencodeDir\$file"
        if (Test-Path $source) {
            Copy-Item $source ".\config\opencode\$file" -Force
            Write-Host "  ✓ $file copiado" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $file no encontrado" -ForegroundColor Red
        }
    }
} else {
    Write-Warning "No se encontró ~/.config/opencode/"
}

# 4. Crear .gitignore si no existe
if (-not (Test-Path ".\.gitignore")) {
    Write-Host "[Extra] Creando .gitignore ..." -ForegroundColor Yellow
    @"
# Windows
Thumbs.db
desktop.ini

# macOS
.DS_Store

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Temporal
*.tmp
*.temp
*~

# Never commit these
.env
.env.local
.env.*
*.key
*.pem
secrets/
"@ | Set-Content ".\.gitignore" -Encoding UTF8
    Write-Host "  ✓ .gitignore creado" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Resumen ===" -ForegroundColor Cyan
Write-Host "Ahora ejecuta:" -ForegroundColor White
Write-Host "  git init" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor Yellow
Write-Host "  git commit -m 'feat: sistema inicial de agentes'" -ForegroundColor Yellow
Write-Host "  gh repo create agents-system --public --source=. --push" -ForegroundColor Yellow
Write-Host ""
Write-Host "O manualmente:" -ForegroundColor Gray
Write-Host "  1. Crear repo en https://github.com/new" -ForegroundColor Gray
Write-Host "  2. git remote add origin https://github.com/TU-USUARIO/agents-system.git" -ForegroundColor Gray
Write-Host "  3. git push -u origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "Luego actualiza TU-USUARIO en:" -ForegroundColor Yellow
Write-Host "  - install.ps1 (línea con github.com/TU-USUARIO)" -ForegroundColor Gray
Write-Host "  - install.sh (línea con github.com/TU-USUARIO)" -ForegroundColor Gray
Write-Host "  - README.md (todas las URLs)" -ForegroundColor Gray
