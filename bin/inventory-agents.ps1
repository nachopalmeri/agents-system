#!/usr/bin/env pwsh
# Inventario de agentes/subagentes definidos en la PC y en el repo:
# ubicacion, nombre, modelo, herramientas y tokens aproximados (chars/4).
# Solo lectura. Uso: pwsh bin/inventory-agents.ps1 [-Csv salida.csv]
[CmdletBinding()]
param(
    [string] $HomePath = $(if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }),
    [string] $Csv
)

$ErrorActionPreference = "Stop"
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$roots = [ordered]@{
    "claude"      = Join-Path $HomePath ".claude"
    "opencode"    = Join-Path $HomePath ".config/opencode"
    "opencode-alt"= Join-Path $HomePath ".opencode"
    "codex"       = Join-Path $HomePath ".codex"
    "gemini"      = Join-Path $HomePath ".gemini"
    "hermes"      = Join-Path $HomePath ".hermes"
    "agents"      = Join-Path $HomePath ".agents"
    "repo"        = Join-Path $repoRoot ".agents"
}

function Get-Field([string] $Text, [string] $Key) {
    if ($Text -match "(?m)^\s*$Key\s*[:=]\s*(.+)$") { return $Matches[1].Trim().Trim('"', "'") }
    return ""
}

function Get-ToolsSummary([string] $Header) {
    $inline = Get-Field $Header "tools"
    if ($inline) { return $inline }
    # opencode: bloque tools:/permission: con claves anidadas
    $block = [regex]::Match($Header, '(?ms)^(tools|permission):\s*\r?\n((?:[ \t]+.+\r?\n?)+)')
    if ($block.Success) { return (($block.Groups[2].Value -split '\r?\n' | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() }) -join "; ") }
    return "(hereda todas)"
}

$rows = @()
foreach ($label in $roots.Keys) {
    $root = $roots[$label]
    if (-not (Test-Path $root)) { continue }
    $dirs = @(Get-ChildItem $root -Directory -Recurse -Depth 3 -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -in @("agent", "agents") -and $_.FullName -notmatch '[\\/](archive|node_modules|skills|skills-library)[\\/]' })
    foreach ($dir in $dirs) {
        foreach ($file in @(Get-ChildItem $dir.FullName -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @(".md", ".toml", ".yaml", ".yml", ".json") })) {
            $text = [IO.File]::ReadAllText($file.FullName)
            $header = if ($text -match '(?s)^---\s*\r?\n(.*?)\r?\n---') { $Matches[1] } else { $text.Substring(0, [Math]::Min(2000, $text.Length)) }
            $name = Get-Field $header "name"
            if (-not $name) { $name = $file.BaseName }
            $model = Get-Field $header "model"
            $rows += [pscustomobject]@{
                origen = $label
                nombre = $name
                modelo = $(if ($model) { $model } else { "(hereda)" })
                herramientas = Get-ToolsSummary $header
                tokens = [int][Math]::Round($text.Length / 4)
                ruta = $file.FullName.Replace($HomePath, "~")
            }
        }
    }
}

# Agentes declarados dentro de configs JSON/TOML (opencode "agent", codex [agents.*])
foreach ($config in @("$HomePath/.config/opencode/opencode.json", "$HomePath/.config/opencode/opencode.jsonc", "$HomePath/.codex/config.toml")) {
    if (-not (Test-Path $config)) { continue }
    $text = [IO.File]::ReadAllText($config)
    foreach ($match in [regex]::Matches($text, '(?m)^\s*\[agents?\.([A-Za-z0-9_-]+)\]|"agent"\s*:\s*\{')) {
        $rows += [pscustomobject]@{ origen = "config"; nombre = $(if ($match.Groups[1].Value) { $match.Groups[1].Value } else { "(bloque agent)" }); modelo = "ver archivo"; herramientas = "ver archivo"; tokens = 0; ruta = $config.Replace($HomePath, "~") }
    }
}

if ($rows.Count -eq 0) { Write-Host "No se encontraron agentes." ; exit 0 }
$rows | Sort-Object origen, nombre | Format-Table origen, nombre, modelo, herramientas, tokens -AutoSize -Wrap | Out-String -Width 220 | Write-Host
Write-Host ("Total: {0} definiciones, ~{1} tokens de prompt" -f $rows.Count, ($rows | Measure-Object tokens -Sum).Sum)
if ($Csv) { $rows | Export-Csv -Path $Csv -NoTypeInformation -Encoding UTF8; Write-Host "CSV: $Csv" }
