#!/usr/bin/env pwsh
# Mergea los hooks de config/claude-hooks.json en ~/.claude/settings.json sin tocar
# el resto: quita sólo las entradas gestionadas (comando con '/.agents/hooks/') y
# agrega las actuales. Backup antes de escribir. -Check: exit 1 si difieren.
# -Remove: quita los hooks gestionados.
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string] $HomePath = $(if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }),
    [switch] $Check,
    [switch] $Remove
)

$ErrorActionPreference = "Stop"
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$settingsPath = Join-Path $HomePath ".claude/settings.json"
$marker = "/.agents/hooks/"
# Ruta absoluta en vez de $HOME: el shell que usa Claude Code para hooks varía según el SO.
$homeForward = ([IO.Path]::GetFullPath($HomePath)).Replace('\', '/')
$desiredJson = (Get-Content (Join-Path $repoRoot "config/claude-hooks.json") -Raw).Replace('$HOME', $homeForward)
$desired = ($desiredJson | ConvertFrom-Json -AsHashtable).hooks

$raw = if (Test-Path $settingsPath) { [IO.File]::ReadAllText($settingsPath) } else { "{}" }
$settings = if ([string]::IsNullOrWhiteSpace($raw)) { [ordered]@{} } else { $raw | ConvertFrom-Json -AsHashtable }
if ($null -eq $settings) { $settings = [ordered]@{} }

function Test-Managed($Group) {
    foreach ($hook in @($Group.hooks)) { if ([string]$hook.command -like "*$marker*") { return $true } }
    return $false
}

$hooks = if ($settings.Contains("hooks") -and $settings.hooks) { $settings.hooks } else { [ordered]@{} }
$result = [ordered]@{}
foreach ($eventName in @($hooks.Keys)) {
    $kept = @($hooks[$eventName] | Where-Object { -not (Test-Managed $_) })
    if ($kept.Count -gt 0) { $result[$eventName] = $kept }
}
if (-not $Remove) {
    foreach ($eventName in $desired.Keys) {
        $merged = [Collections.Generic.List[object]]::new()
        if ($result.Contains($eventName)) { foreach ($group in @($result[$eventName])) { $merged.Add($group) } }
        foreach ($group in @($desired[$eventName])) { $merged.Add($group) }
        $result[$eventName] = $merged.ToArray()
    }
}

$newSettings = [ordered]@{}
foreach ($key in $settings.Keys) { if ($key -ne "hooks") { $newSettings[$key] = $settings[$key] } }
if ($result.Count -gt 0) { $newSettings["hooks"] = $result }
$newJson = $newSettings | ConvertTo-Json -Depth 20

$currentNormalized = ($settings | ConvertTo-Json -Depth 20 -Compress)
$newNormalized = ($newSettings | ConvertTo-Json -Depth 20 -Compress)
if ($Check) {
    if ($currentNormalized -ne $newNormalized) { Write-Host "[DRIFT] ~/.claude/settings.json: hooks gestionados distintos del repo" -ForegroundColor Red; exit 1 }
    Write-Host "Hooks de Claude al día." -ForegroundColor Green; exit 0
}
if ($currentNormalized -eq $newNormalized) { Write-Host "Hooks de Claude: sin cambios." -ForegroundColor Green; exit 0 }
if ($WhatIfPreference) { Write-Host "[WhatIf] actualizaría hooks en $settingsPath"; exit 0 }

if (Test-Path $settingsPath) {
    $backupDir = Join-Path $HomePath ".agents-system-sync/backups"
    [void](New-Item -ItemType Directory -Force -Path $backupDir)
    $backup = Join-Path $backupDir "claude-settings-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    Copy-Item $settingsPath $backup
    Write-Host "Backup: $backup"
}
[void](New-Item -ItemType Directory -Force -Path (Split-Path $settingsPath -Parent))
[IO.File]::WriteAllText($settingsPath, $newJson, (New-Object Text.UTF8Encoding($false)))
Write-Host "Hooks de Claude $(if ($Remove) { 'quitados de' } else { 'actualizados en' }) $settingsPath" -ForegroundColor Green
