#!/usr/bin/env pwsh
# Lista skills fuera de ~/.agents/skills que cada cliente precarga (su metadata
# entra en cada sesion). No borra nada: reporta para decidir que mover a
# ~/.agents/skills-library o eliminar.
[CmdletBinding()]
param([string] $HomePath = $(if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }))

$ErrorActionPreference = "Stop"
$dirs = [ordered]@{
    "agents (codex, gemini, opencode)" = ".agents/skills"
    "claude"                           = ".claude/skills"
    "antigravity"                      = ".gemini/antigravity/skills"
    "gemini cli"                       = ".gemini/skills"
    "opencode"                         = ".config/opencode/skills"
    "codex"                            = ".codex/skills"
    "hermes"                           = ".hermes/skills"
}
$core = @{}
$coreDir = Join-Path $HomePath ".agents/skills"
if (Test-Path $coreDir) { Get-ChildItem $coreDir -Directory | ForEach-Object { $core[$_.Name] = $true } }

foreach ($label in $dirs.Keys) {
    $path = Join-Path $HomePath $dirs[$label]
    if (-not (Test-Path $path)) { continue }
    $skills = @(Get-ChildItem $path -Directory | Where-Object { $_.Name -ne ".system" -and (Test-Path (Join-Path $_.FullName "SKILL.md")) })
    $bytes = 0
    $extra = @()
    foreach ($skill in $skills) {
        $text = Get-Content (Join-Path $skill.FullName "SKILL.md") -Raw -Encoding UTF8
        if ($text -match '(?s)^---\r?\n(.*?)\r?\n---') { $bytes += $Matches[1].Length }
        if (-not $core.ContainsKey($skill.Name)) { $extra += $skill.Name }
    }
    Write-Host ("{0,-34} {1,4} skills  ~{2,5} tokens/sesion  {3}" -f $label, $skills.Count, [math]::Round($bytes / 4), $dirs[$label])
    if ($dirs[$label] -ne ".agents/skills" -and $extra.Count -gt 0) {
        Write-Host ("    fuera del nucleo: " + ($extra -join ", ")) -ForegroundColor Yellow
    }
}
