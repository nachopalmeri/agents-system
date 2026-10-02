[CmdletBinding()]
param([string] $HomePath = $env:USERPROFILE)
$ErrorActionPreference = 'Stop'
$configPath = Join-Path $HomePath '.agents/local-paths.json'
$vault = if (Test-Path -LiteralPath $configPath) {
    (Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json).uadeVault
} else { 'D:\Facultad\UADE-Vault' }
if ([string]::IsNullOrWhiteSpace($vault) -or -not [IO.Path]::IsPathRooted($vault)) { throw 'Configure an absolute uadeVault in ~/.agents/local-paths.json.' }
$vault = [IO.Path]::GetFullPath($vault).TrimEnd('\','/')
if ((Split-Path $vault -Leaf) -eq 'Efforts') { $vault = Split-Path $vault -Parent }
if (-not (Test-Path -LiteralPath $vault -PathType Container) -or -not (Test-Path -LiteralPath (Join-Path $vault '.obsidian') -PathType Container) -or -not (Test-Path -LiteralPath (Join-Path $vault 'AGENTS.md') -PathType Leaf)) {
    throw "Vault unavailable or missing .obsidian/AGENTS.md: $vault. Ask for its real path; do not create or migrate it."
}
$vault
