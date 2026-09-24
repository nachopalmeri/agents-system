#!/usr/bin/env pwsh
# Regenera .agents/skills-library/INDEX.md: una linea por skill (nombre + primera
# frase de la descripcion, <=110 chars). Correr despues de mover skills entre
# skills/ y skills-library/. check-runtime-graph.ps1 valida que este al dia.
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = "Stop"
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$libraryRoot = Join-Path $repoRoot ".agents/skills-library"
$indexPath = Join-Path $libraryRoot "INDEX.md"

function Get-ShortDescription([string] $SkillFile) {
    $text = [IO.File]::ReadAllText($SkillFile)
    if ($text -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---') { return "" }
    $frontmatter = $Matches[1]
    if ($frontmatter -notmatch '(?ms)^description:\s*(.*?)(?=\r?\n[a-zA-Z_-]+:|\z)') { return "" }
    $description = (($Matches[1] -split '\s+') -join ' ').Trim().Trim('"', "'", '>', '|', '-', ' ')
    $description = ($description -split '(?<=[.;])\s')[0]
    if ($description.Length -gt 110) {
        $cut = $description.Substring(0, 107)
        $description = $cut.Substring(0, $cut.LastIndexOf(' ')) + "…"
    }
    return $description
}

$lines = @(
    "# Skills library (on-demand)",
    "",
    "No se cargan solas. Si la tarea encaja con una fila, leé ``~/.agents/skills-library/<skill>/SKILL.md`` completo y seguilo. No leas otras.",
    ""
)
foreach ($dir in @(Get-ChildItem $libraryRoot -Directory | Sort-Object { $_.Name } -Culture "en-US")) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skillFile)) { continue }
    $lines += "- ``$($dir.Name)`` — $(Get-ShortDescription $skillFile)"
}
$content = ($lines -join "`n") + "`n"

if ($Check) {
    $current = if (Test-Path $indexPath) { [IO.File]::ReadAllText($indexPath).Replace("`r`n", "`n") } else { "" }
    if ($current -ne $content) { Write-Host "[FAIL] skills-library/INDEX.md desactualizado; correr bin/generate-skill-index.ps1" -ForegroundColor Red; exit 1 }
    Write-Host "[OK] skills-library/INDEX.md al dia" -ForegroundColor Green
    exit 0
}
[IO.File]::WriteAllText($indexPath, $content, (New-Object Text.UTF8Encoding($false)))
Write-Host "Escrito $indexPath ($($lines.Count - 4) skills)" -ForegroundColor Green
