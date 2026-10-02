$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$fixture = Join-Path ([IO.Path]::GetTempPath()) ('agents-vault-' + [guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path (Join-Path $fixture '.agents'))
$vault = Join-Path $fixture 'vault'
[void](New-Item -ItemType Directory -Path (Join-Path $vault '.obsidian'))
[void](New-Item -ItemType Directory -Path (Join-Path $vault 'Efforts'))
[IO.File]::WriteAllText((Join-Path $vault 'AGENTS.md'), '# Fixture vault')
try {
    @{ uadeVault = $vault } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $fixture '.agents/local-paths.json')
    $resolved = & (Join-Path $root 'bin/resolve-vault.ps1') -HomePath $fixture
    if ($resolved -ne $vault) { throw 'Configured vault root was not resolved.' }
    @{ uadeVault = (Join-Path $vault 'Efforts') } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $fixture '.agents/local-paths.json')
    $resolved = & (Join-Path $root 'bin/resolve-vault.ps1') -HomePath $fixture
    if ($resolved -ne $vault) { throw 'Efforts must resolve to its containing vault.' }
    @{ uadeVault = (Join-Path $fixture 'missing') } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $fixture '.agents/local-paths.json')
    $rejected = $false
    try { & (Join-Path $root 'bin/resolve-vault.ps1') -HomePath $fixture | Out-Null } catch { $rejected = $true }
    if (-not $rejected) { throw 'Missing configured vault must not silently fall back.' }
    'VAULT_RESOLUTION_TESTS_OK'
} finally {
    $resolvedFixture = [IO.Path]::GetFullPath($fixture)
    if (-not $resolvedFixture.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe fixture cleanup.' }
    Remove-Item -LiteralPath $resolvedFixture -Recurse -Force
}
