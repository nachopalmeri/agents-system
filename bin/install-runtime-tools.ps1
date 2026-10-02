#!/usr/bin/env pwsh
[CmdletBinding()]
param([switch] $Apply, [string[]] $Only)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$catalog = Get-Content (Join-Path $root 'config/runtime-tools.json') -Raw | ConvertFrom-Json
$Only = @($Only | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
foreach ($name in $Only) { if ($catalog.tools.name -notcontains $name) { throw "Unknown tool: $name" } }
$selected = @($catalog.tools | Where-Object { $Only.Count -eq 0 -or $Only -contains $_.name })
foreach ($tool in $selected) {
    $command = Get-Command $tool.command -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $Apply) { [pscustomobject]@{tool=$tool.name; command=$tool.command; targetVersion=$tool.version; found=[bool]$command; path=$command.Source}; continue }
    if ($tool.manager -eq 'winget') {
        if (-not $IsWindows) { throw 'Winget tools require Windows; install the equivalent platform package explicitly.' }
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'Windows Package Manager is required.' }
        & winget install --id $tool.package --exact --version $tool.version --scope user --silent --accept-source-agreements --accept-package-agreements --disable-interactivity
        # Winget reports an already-installed package with a nonzero no-update status.
        if ($LASTEXITCODE -notin @(0,-1978335189)) { throw "Winget installation failed for $($tool.name): $LASTEXITCODE" }
    } else {
        & npm install --global "$($tool.package)@$($tool.version)" --ignore-scripts --no-audit --no-fund
        if ($LASTEXITCODE -ne 0) { throw "npm installation failed for $($tool.name)" }
        # Only these pinned, reviewed packages need hooks to place native Windows binaries.
        if ($tool.package -in @('pnpm','opencode-ai')) {
            & npm rebuild --global $tool.package --foreground-scripts
            if ($LASTEXITCODE -ne 0) { throw "Native CLI setup failed for $($tool.name)" }
        }
    }
}
if ($Apply) { 'Selected CLIs installed. Verify in a fresh shell. Native addon rebuilds and daemon startup are not automatic.' }
