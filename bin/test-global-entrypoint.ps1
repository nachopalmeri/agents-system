#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$entry = Join-Path $root 'bin/agents.ps1'
if (-not (Test-Path $entry)) { throw 'Global agents entrypoint is missing.' }
if (-not (Test-Path (Join-Path $root 'bin/agents.cmd'))) { throw 'Windows command shim is missing.' }
$manifest = Get-Content (Join-Path $root 'config/runtime-manifest.json') -Raw | ConvertFrom-Json
foreach ($target in @('bin/agents.ps1','bin/agents.cmd')) {
    if ($manifest.installTargets.targetPath -notcontains $target) { throw "Global target missing: $target" }
}
if ($manifest.preserveIfExists -notcontains '.agents/local-runtime.json') { throw 'Local runtime pointer is not preserved.' }
if (-not (Test-Path (Join-Path $root 'bin/setup-global-runtime.ps1'))) { throw 'Global registration missing.' }
$tools = Get-Content (Join-Path $root 'config/runtime-tools.json') -Raw | ConvertFrom-Json
foreach ($name in @('powershell','ripgrep','uv','pnpm','sandcastle','evalite')) {
    if ($tools.tools.name -notcontains $name) { throw "Tool missing: $name" }
}
$fixture = Join-Path ([IO.Path]::GetTempPath()) ('agents-entry-' + [guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path $fixture)
try {
    $help = & pwsh -NoProfile -File $entry help -HomePath $fixture 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $help -notmatch 'agents doctor') { throw 'Help requires an installed checkout.' }
    $unconfigured = & pwsh -NoProfile -File $entry catalog -HomePath $fixture 2>&1 | Out-String
    if ($LASTEXITCODE -eq 0 -or $unconfigured -notmatch 'setup-global-runtime') { throw 'Missing pointer should be actionable.' }
    $catalog = & pwsh -NoProfile -File $entry catalog retro -RepoPath $root -HomePath $fixture 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $catalog -notmatch 'matt-retro') { throw 'Catalog lookup failed.' }
    $route = & pwsh -NoProfile -File $entry route (Join-Path $root 'examples/tasks/docs-update.json') -RepoPath $root -HomePath $fixture 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $route -notmatch '"primary"') { throw "Repo-dependent route failed: $route" }
    $agentsDir = Join-Path $fixture '.agents'
    [void](New-Item -ItemType Directory -Path $agentsDir)
    [IO.File]::WriteAllText((Join-Path $agentsDir 'local-runtime.json'), (@{repoPath=$root} | ConvertTo-Json))
    $registered = & pwsh -NoProfile -File $entry catalog matt-pr -HomePath $fixture 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $registered -notmatch 'matt-pr') { throw 'Registered checkout lookup failed.' }
    $install = Get-Content (Join-Path $root 'bin/install-runtime-tools.ps1') -Raw
    if ($install -notmatch '\[switch\]\s*\$Apply' -or $install -notmatch 'ignore-scripts') { throw 'Tool installation is not opt-in and bounded.' }
    'GLOBAL_ENTRYPOINT_TESTS_OK'
} finally {
    $resolved = [IO.Path]::GetFullPath($fixture)
    if (-not $resolved.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe test fixture cleanup.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
