#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [Parameter(Position=0)] [ValidateSet('help','doctor','check','catalog','route','delegate','update','tools')] [string] $Action = 'help',
    [Parameter(Position=1)] [string] $Path,
    [string] $RepoPath,
    [string] $HomePath = $env:USERPROFILE,
    [switch] $DryRun,
    [switch] $SkipPull
)
$ErrorActionPreference = 'Stop'
if ($Action -eq 'help') {
    @'
agents doctor              Global adapter health
agents check               Managed sync drift (read only)
agents catalog [keyword]   Find an on-demand skill
agents route <task.json>   Route a task using the registered checkout
agents delegate <request.json> [-DryRun]   Bounded free-only worker bridge
agents update [-SkipPull] [-DryRun]        Update/sync the registered branch
agents tools               List selected tool installation status
Setup: pwsh bin/setup-global-runtime.ps1 [-InstallTools]
'@
    exit 0
}
if (-not $RepoPath) {
    $pointerPath = Join-Path $HomePath '.agents/local-runtime.json'
    if (-not (Test-Path -LiteralPath $pointerPath -PathType Leaf)) { throw 'Register the checkout first: pwsh bin/setup-global-runtime.ps1' }
    $RepoPath = (Get-Content -LiteralPath $pointerPath -Raw | ConvertFrom-Json).repoPath
}
if (-not $RepoPath -or -not [IO.Path]::IsPathRooted($RepoPath)) { throw 'Registered checkout must be an absolute path.' }
$repoRoot = [IO.Path]::GetFullPath($RepoPath)
if (-not (Test-Path (Join-Path $repoRoot 'config/runtime-manifest.json')) -or -not (Test-Path (Join-Path $repoRoot '.agents/AGENTS.md'))) { throw 'Registered checkout missing; rerun bin/setup-global-runtime.ps1 from the intended repository.' }
$parameters = @{}
switch ($Action) {
    'doctor' { $script = 'doctor.ps1'; $parameters.HomePath = $HomePath; $parameters.GlobalCommands = $true }
    'check' { $script = 'sync-runtime.ps1'; $parameters.HomePath = $HomePath; $parameters.Check = $true }
    'catalog' {
        $index = Join-Path $HomePath '.agents/skills-library/INDEX.md'
        if (-not (Test-Path -LiteralPath $index)) { $index = Join-Path $repoRoot '.agents/skills-library/INDEX.md' }
        if ($Path) { Select-String -LiteralPath $index -SimpleMatch $Path | ForEach-Object Line } else { Get-Content -LiteralPath $index }
        exit 0
    }
    'route' { $script = 'route-task.ps1'; if (-not $Path) { throw 'Provide a task JSON path.' }; $parameters.TaskPath = (Resolve-Path -LiteralPath $Path).Path }
    'delegate' { $script = 'invoke-delegation.ps1'; if (-not $Path) { throw 'Provide a request JSON path.' }; $parameters.RequestPath = (Resolve-Path -LiteralPath $Path).Path; $parameters.DryRun = $DryRun }
    'update' { $script = 'update-system.ps1'; $parameters.HomePath = $HomePath; $parameters.RepoPath = $repoRoot; $parameters.SkipPull = $SkipPull; $parameters.DryRun = $DryRun }
    'tools' { $script = 'install-runtime-tools.ps1' }
}
& (Join-Path $repoRoot "bin/$script") @parameters
exit $LASTEXITCODE
