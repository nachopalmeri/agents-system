#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$fixture = Join-Path ([IO.Path]::GetTempPath()) ('agents-diagnostics-' + [guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path $fixture)
try {
    $manifest = Get-Content (Join-Path $root 'config/runtime-manifest.json') -Raw | ConvertFrom-Json
    foreach ($adapter in @($manifest.adapters | Where-Object globalTarget)) {
        $source = if ($adapter.globalSourcePath) { $adapter.globalSourcePath } else { $adapter.repoPath }
        $destination = Join-Path $fixture $adapter.globalTarget
        [void](New-Item -ItemType Directory -Force -Path (Split-Path $destination -Parent))
        Copy-Item -LiteralPath (Join-Path $root $source) -Destination $destination
    }
    $canonical = Join-Path $fixture '.agents/AGENTS.md'
    [void](New-Item -ItemType Directory -Force -Path (Split-Path $canonical -Parent))
    Copy-Item -LiteralPath (Join-Path $root '.agents/AGENTS.md') -Destination $canonical
    foreach ($client in @('codex','claude','gemini','opencode')) {
        $result = & pwsh -NoProfile -File (Join-Path $root 'bin/doctor.ps1') -HomePath $fixture -Client $client 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0 -or $result -notmatch '\[supported\]') { throw "Valid $client install rejected: $result" }
    }
    Add-Content -LiteralPath (Join-Path $fixture '.codex/AGENTS.md') -Value 'drift'
    & pwsh -NoProfile -File (Join-Path $root 'bin/doctor.ps1') -HomePath $fixture -Client codex | Out-Null
    if ($LASTEXITCODE -eq 0) { throw 'Real adapter drift was accepted.' }
    'INSTALLATION_DIAGNOSTICS_TESTS_OK'
} finally {
    $resolved = [IO.Path]::GetFullPath($fixture)
    if (-not $resolved.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe fixture cleanup.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
