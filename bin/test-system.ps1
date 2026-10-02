# test-system.ps1
# Valida integridad del sistema de agentes:
# - Referencias internas no rotas
# - Workflows con contenido valido
# - Skills no vacias (warn si hay muchas vacias)
# - Reglas referenciadas existen

[CmdletBinding()]
param(
    [string]$AgentsRoot
)

$ErrorActionPreference = "Continue"
if (-not $AgentsRoot) {
    $AgentsRoot = Join-Path ([System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))) ".agents"
}
$errors = 0
$warnings = 0

function Write-Pass($msg) { Write-Host "  [PASS] $msg" -ForegroundColor Green }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red; $script:errors++ }
function Write-Warn($msg) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow; $script:warnings++ }
function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

Write-Step "Test System: $AgentsRoot"

if (-not (Test-Path $AgentsRoot)) {
    Write-Fail "AgentsRoot no existe: $AgentsRoot"
    exit 1
}

# 1. Archivos requeridos
Write-Step "Test 1: Archivos top-level requeridos"
$required = @("AGENTS.md", "SKILL.md")
foreach ($f in $required) {
    if (Test-Path "$AgentsRoot\$f") {
        Write-Pass $f
    } else {
        Write-Fail "Falta $f"
    }
}

# 2. Carpetas requeridas
Write-Step "Test 2: Carpetas requeridas"
$dirs = @("agents", "workflows", "skills", "rules", "prompts")
foreach ($d in $dirs) {
    if (Test-Path "$AgentsRoot\$d") {
        Write-Pass $d
    } else {
        Write-Fail "Falta carpeta $d"
    }
}

# 3. Referencias rotas en AGENTS.md
Write-Step "Test 3: Referencias en AGENTS.md"
$agentsContent = Get-Content "$AgentsRoot\AGENTS.md" -Raw -ErrorAction SilentlyContinue
if ($agentsContent) {
    $refs = [regex]::Matches($agentsContent, '`(rules|workflows|agents|skills|prompts)/([^`]+)`') |
            ForEach-Object { $_.Groups[1].Value + "/" + $_.Groups[2].Value } |
            Select-Object -Unique
    foreach ($ref in $refs) {
        $path = "$AgentsRoot\$($ref -replace '/', '\')"
        if (Test-Path $path) {
            Write-Pass $ref
        } else {
            Write-Fail "Referencia rota: $ref"
        }
    }
}

# 4. Reglas tienen frontmatter description
Write-Step "Test 4: Reglas con frontmatter"
Get-ChildItem "$AgentsRoot\rules\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '(?m)^---\s*\n.*?description:.*?\n---') {
        Write-Pass $_.Name
    } else {
        Write-Warn "$($_.Name) sin frontmatter description"
    }
}

# 5. Workflows tienen contenido (no vacios)
Write-Step "Test 5: Workflows con contenido"
$emptyWorkflows = @()
Get-ChildItem "$AgentsRoot\workflows\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    $size = (Get-Item $_.FullName).Length
    if ($size -lt 100) {
        $emptyWorkflows += $_.Name
        Write-Warn "$($_.Name) muy chico ($size bytes)"
    }
}
if ($emptyWorkflows.Count -eq 0) {
    Write-Pass "Todos los workflows tienen contenido sustancial"
}

# 6. Count only discoverable SKILL.md entrypoints in both active tiers.
Write-Step "Test 6: Skills activas (nucleo + library)"
$activeSkills = @()
foreach ($tier in @("skills", "skills-library")) {
    $tierPath = Join-Path $AgentsRoot $tier
    if (-not (Test-Path $tierPath)) { Write-Fail "Falta carpeta $tier"; continue }
    foreach ($directory in @(Get-ChildItem $tierPath -Directory)) {
        $entrypoint = Join-Path $directory.FullName "SKILL.md"
        if (-not (Test-Path $entrypoint -PathType Leaf)) { continue }
        $activeSkills += $entrypoint
        $content = Get-Content -LiteralPath $entrypoint -Raw
        $body = ([string]$content -replace '(?s)^---\r?\n.*?\r?\n---', '').Trim()
        if ([string]::IsNullOrWhiteSpace($body)) { Write-Fail "Skill sin contenido: $tier/$($directory.Name)/SKILL.md" }
    }
}
Write-Pass "Skills activas: $($activeSkills.Count) (nucleo + library)"

# 7. Agentes tienen frontmatter name + description
Write-Step "Test 7: Agentes con frontmatter completo"
Get-ChildItem "$AgentsRoot\agents\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '(?ms)^---.*?name:.*?description:.*?---') {
        Write-Pass $_.Name
    } else {
        Write-Warn "$($_.Name) frontmatter incompleto"
    }
}

# 8. Prompts portables
Write-Step "Test 8: Prompts portables"
if (Test-Path "$AgentsRoot\prompts\llm-council-portable.md") {
    Write-Pass "llm-council-portable.md"
} else {
    Write-Fail "Falta llm-council-portable.md"
}

Write-Host ""
Write-Step "Resumen"
Write-Host "  Errores: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host "  Warnings: $warnings" -ForegroundColor $(if ($warnings -gt 0) { "Yellow" } else { "Green" })

if ($errors -gt 0) {
    exit 1
} else {
    exit 0
}
