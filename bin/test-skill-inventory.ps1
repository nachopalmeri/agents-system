#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$fixture = Join-Path ([IO.Path]::GetTempPath()) ('agents-skills-' + [guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path $fixture)
try {
    Copy-Item -LiteralPath (Join-Path $root '.agents') -Destination (Join-Path $fixture '.agents') -Recurse
    $agents = Join-Path $fixture '.agents'
    [void](New-Item -ItemType Directory -Force -Path (Join-Path $agents 'skills/old-empty-directory'))
    $expected = (Get-Content (Join-Path $root 'config/capabilities.json') -Raw | ConvertFrom-Json).skills.Count
    $output = & pwsh -NoProfile -File (Join-Path $root 'bin/test-system.ps1') -AgentsRoot $agents 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $output -notmatch "Skills activas: $expected") { throw "Incorrect active skill inventory: $output" }
    $empty = Join-Path $agents 'skills-library/broken-skill'
    [void](New-Item -ItemType Directory -Path $empty)
    [IO.File]::WriteAllText((Join-Path $empty 'SKILL.md'), '')
    & pwsh -NoProfile -File (Join-Path $root 'bin/test-system.ps1') -AgentsRoot $agents | Out-Null
    if ($LASTEXITCODE -eq 0) { throw 'Empty library SKILL.md was accepted.' }
    'SKILL_INVENTORY_TESTS_OK'
} finally {
    $resolved = [IO.Path]::GetFullPath($fixture)
    if (-not $resolved.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe fixture cleanup.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
