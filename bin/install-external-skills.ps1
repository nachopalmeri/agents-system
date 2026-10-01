#!/usr/bin/env pwsh
# Instala skills de terceros declaradas en config/external-skills.json en
# ~/.agents/skills-library/<name>, bajándolas de su repo oficial (siempre la última
# versión). Las que tienen términos propios requieren -AcceptTerms <id>.
# Ejemplos:
#   pwsh bin/install-external-skills.ps1 -List
#   pwsh bin/install-external-skills.ps1                        # todas las sin términos
#   pwsh bin/install-external-skills.ps1 -AcceptTerms tesseract,anthropic-docs
#   pwsh bin/install-external-skills.ps1 -Only remotion-create -Update
[CmdletBinding()]
param(
    [string] $HomePath = $(if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }),
    [string[]] $Only,
    [string[]] $AcceptTerms = @(),
    [switch] $Update,
    [switch] $List
)

$ErrorActionPreference = "Stop"
# pwsh -File pasa "a,b" como un solo string: normalizar listas.
$Only = @($Only | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$AcceptTerms = @($AcceptTerms | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$manifest = Get-Content (Join-Path $repoRoot "config/external-skills.json") -Raw | ConvertFrom-Json
$library = Join-Path $HomePath ".agents/skills-library"
$skills = @($manifest.skills | Where-Object { $Only.Count -eq 0 -or $Only -contains $_.name })

if ($List) {
    foreach ($skill in $skills) {
        $installed = Test-Path (Join-Path $library "$($skill.name)/SKILL.md")
        Write-Host ("{0,-26} {1,-11} {2}{3}" -f $skill.name, $(if ($installed) { "instalada" } else { "-" }), $skill.license, $(if ($skill.terms) { "  [requiere -AcceptTerms $($skill.terms)]" } else { "" }))
    }
    exit 0
}

$temp = Join-Path ([IO.Path]::GetTempPath()) "agents-ext-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
$clones = @{}
try {
    foreach ($skill in $skills) {
        $destination = Join-Path $library $skill.name
        if ($skill.terms -and $AcceptTerms -notcontains $skill.terms) {
            Write-Host "[skip] $($skill.name): tiene términos propios. Leelos en $($skill.termsUrl) y corré con -AcceptTerms $($skill.terms)" -ForegroundColor Yellow
            continue
        }
        if ((Test-Path $destination) -and -not $Update) { Write-Host "[ok]   $($skill.name) ya instalada (usá -Update para actualizar)"; continue }
        if (-not $clones.ContainsKey($skill.repo)) {
            $cloneDir = Join-Path $temp ($clones.Count.ToString())
            & git clone --quiet --depth 1 $skill.repo $cloneDir 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) { Write-Host "[fail] no se pudo clonar $($skill.repo)" -ForegroundColor Red; $clones[$skill.repo] = $null; continue }
            $clones[$skill.repo] = $cloneDir
        }
        $cloneDir = $clones[$skill.repo]
        if (-not $cloneDir) { continue }
        $source = Join-Path $cloneDir $skill.path
        if (-not (Test-Path (Join-Path $source "SKILL.md"))) { Write-Host "[fail] $($skill.name): no existe $($skill.path) en $($skill.repo)" -ForegroundColor Red; continue }
        if (Test-Path $destination) { Remove-Item $destination -Recurse -Force }
        [void](New-Item -ItemType Directory -Force -Path $library)
        Copy-Item $source $destination -Recurse
        $sha = (& git -C $cloneDir rev-parse --short HEAD)
        Set-Content (Join-Path $destination ".source") "$($skill.repo)/tree/$sha/$($skill.path)`nlicencia: $($skill.license)`ninstalada: $(Get-Date -Format 'yyyy-MM-dd')" -Encoding utf8
        Write-Host "[inst] $($skill.name) <- $($skill.repo)@$sha" -ForegroundColor Green
    }
} finally {
    if (Test-Path $temp) { Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue }
}
