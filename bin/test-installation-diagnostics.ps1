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

    # A tiny independent checkout keeps installed-resource and Git state tests off the live home/repo.
    $checkout = Join-Path $fixture 'checkout'
    $installed = Join-Path $fixture 'installed home'
    function Write-FixtureFile([string] $Base, [string] $Relative, [string] $Content) {
        $path = Join-Path $Base $Relative
        [void](New-Item -ItemType Directory -Force -Path (Split-Path $path -Parent))
        [IO.File]::WriteAllText($path, $Content)
    }
    Write-FixtureFile $checkout 'bin/doctor.ps1' (Get-Content (Join-Path $root 'bin/doctor.ps1') -Raw)
    $scopedManifest = @{
        canonicalPath = '.agents/AGENTS.md'
        excludedRuntimePaths = @('.agents/archive','node_modules')
        preserveIfExists = @('.agents/memory')
        adapters = @(
            @{ client='codex'; repoPath='AGENTS.md'; globalSourcePath='.agents/AGENTS.md'; globalTarget='.codex/AGENTS.md' },
            @{ client='claude'; repoPath='CLAUDE.md'; globalTarget='.claude/CLAUDE.md' }
        )
        installTargets = @(
            @{ client='cli'; sourcePath='.agents'; targetPath='.agents'; kind='directory' },
            @{ client='cli'; sourcePath='bin/agents.ps1'; targetPath='bin/agents.ps1'; kind='file' },
            @{ client='cli'; sourcePath='bin/agents.cmd'; targetPath='bin/agents.cmd'; kind='file' },
            @{ client='codex'; sourcePath='prompts'; targetPath='.codex/prompts'; kind='directory' },
            @{ client='delegation'; sourcePath='config/model-routing.json'; targetPath='config/model-routing.json'; kind='file' }
        )
    }
    Write-FixtureFile $checkout 'config/runtime-manifest.json' ($scopedManifest | ConvertTo-Json -Depth 6)
    foreach ($relative in @('.agents/AGENTS.md','.agents/skills/example/SKILL.md','CLAUDE.md','bin/agents.ps1','bin/agents.cmd','prompts/nested/review.md','config/model-routing.json')) {
        Write-FixtureFile $checkout $relative 'fixture content'
        Write-FixtureFile $installed $relative 'fixture content'
    }
    Write-FixtureFile $installed '.codex/AGENTS.md' 'fixture content'
    Write-FixtureFile $installed '.codex/prompts/nested/review.md' 'fixture content'
    Write-FixtureFile $installed '.agents/local-runtime.json' (@{repoPath=$checkout} | ConvertTo-Json)
    Write-FixtureFile $checkout '.agents/archive/old.md' 'excluded from installation'
    Write-FixtureFile $checkout '.agents/skills/example/node_modules/vendor.js' 'excluded at any depth'
    Write-FixtureFile $checkout '.agents/memory/default.md' 'default memory'
    Write-FixtureFile $installed '.agents/memory/user.md' 'preserved local memory'
    & git -C $checkout init --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Cannot initialize isolated diagnostic checkout.' }
    $effectiveHooks = Join-Path $checkout 'custom hooks'
    & git -C $checkout config core.hooksPath $effectiveHooks
    if ($LASTEXITCODE -ne 0) { throw 'Cannot configure isolated hooks path.' }
    foreach ($hook in @('pre-commit','pre-push')) { Write-FixtureFile $effectiveHooks $hook "#!/bin/sh`nexit 0`n" }

    function Assert-ScopedDoctor([string[]] $Arguments, [int] $Code, [string] $Expected, [string] $Absent) {
        $output = & pwsh -NoProfile -File (Join-Path $checkout 'bin/doctor.ps1') -HomePath $installed @Arguments 2>&1 | Out-String
        if ($LASTEXITCODE -ne $Code -or $output -notmatch $Expected -or ($Absent -and $output -match $Absent)) {
            throw "Unexpected scoped diagnostic (expected exit $Code, $Expected): $output"
        }
    }
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 0 '\[supported\] codex' '\[not-installed\].*claude'
    # Directory existence alone must not hide missing nested managed files.
    Remove-Item -LiteralPath (Join-Path $installed '.codex/prompts/nested/review.md')
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 1 '\[not-installed\] codex resource.*review.md' '\[not-installed\].*claude'
    Assert-ScopedDoctor @('-Client','cli','-GlobalCommands') 0 '\[supported\] cli resource' 'codex resource'
    Write-FixtureFile $installed '.codex/prompts/nested/review.md' 'fixture content'
    Remove-Item -LiteralPath (Join-Path $installed '.agents/skills/example/SKILL.md')
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 1 '\[not-installed\] cli resource.*SKILL.md' ''
    Write-FixtureFile $installed '.agents/skills/example/SKILL.md' 'fixture content'
    Remove-Item -LiteralPath (Join-Path $installed 'config/model-routing.json')
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 1 '\[not-installed\] delegation resource.*model-routing.json' ''
    Write-FixtureFile $installed 'config/model-routing.json' 'fixture content'
    # An explicitly requested missing adapter is an incomplete install; unrelated adapters are out of scope.
    Remove-Item -LiteralPath (Join-Path $installed '.codex/AGENTS.md')
    Assert-ScopedDoctor @('-Client','codex') 1 '\[not-installed\] codex' ''
    Write-FixtureFile $installed '.codex/AGENTS.md' 'fixture content'
    # A decoy in .git/hooks must not satisfy a missing effective hook.
    Write-FixtureFile $checkout '.git/hooks/pre-push' "#!/bin/sh`nexit 0`n"
    Remove-Item -LiteralPath (Join-Path $effectiveHooks 'pre-push')
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 1 '\[not-installed\] git hook pre-push' ''
    Write-FixtureFile $effectiveHooks 'pre-push' "#!/bin/sh`nexit 0`n"
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 0 '\[present\] git hook pre-push.*execution.*not verified' ''
    Assert-ScopedDoctor @('-Client','codex','-GlobalCommands') 0 'client-loaded.*not verified' ''
    'INSTALLATION_DIAGNOSTICS_TESTS_OK'
} finally {
    $resolved = [IO.Path]::GetFullPath($fixture)
    if (-not $resolved.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe fixture cleanup.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
# Expected negative subprocess checks must not leak a failure to CI's shared shell.
exit 0
