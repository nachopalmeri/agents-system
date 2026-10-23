#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$fixture = Join-Path ([IO.Path]::GetTempPath()) ('agents-hooks-' + [guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path (Join-Path $fixture 'bin') -Force)
function Invoke-Installer([string[]] $Options) {
    $output = & pwsh -NoProfile -File (Join-Path $fixture 'bin/install-hooks.ps1') @Options 2>&1 | Out-String
    return @{ Code=$LASTEXITCODE; Output=$output }
}
try {
    Copy-Item -LiteralPath (Join-Path $root 'bin/install-hooks.ps1') -Destination (Join-Path $fixture 'bin/install-hooks.ps1')
    & git -C $fixture init -q
    if ($LASTEXITCODE -ne 0) { throw 'Fixture init failed.' }
    $hooks = Join-Path $fixture '.git/hooks'
    $preCommit = Join-Path $hooks 'pre-commit'
    $prePush = Join-Path $hooks 'pre-push'
    $check = Invoke-Installer @('-Check')
    if ($check.Code -eq 0) { throw 'Missing hooks must fail the installation check.' }
    [IO.File]::WriteAllText($prePush, "#!/bin/sh`n# unrelated user hook`nexit 0`n")
    $before = [IO.File]::ReadAllText($prePush)
    $install = Invoke-Installer @()
    if ($install.Code -eq 0 -or [IO.File]::ReadAllText($prePush) -cne $before -or (Test-Path $preCommit)) {
        throw 'Installation must refuse unmanaged hooks without partial writes.'
    }
    $uninstall = Invoke-Installer @('-Uninstall')
    if ($uninstall.Code -eq 0 -or -not (Test-Path $prePush)) { throw 'Uninstall must preserve unmanaged hooks.' }
    # This is a disposable fixture file whose exact content was just checked.
    Remove-Item -LiteralPath $prePush
    $install = Invoke-Installer @()
    if ($install.Code -ne 0) { throw "Install failed: $($install.Output)" }
    $check = Invoke-Installer @('-Check')
    if ($check.Code -ne 0 -or $check.Output -notmatch 'HOOKS_OK') { throw 'Managed installation check failed.' }
    $managedPush = [IO.File]::ReadAllText($prePush)
    [IO.File]::WriteAllText($prePush, $managedPush + "# obsolete managed revision`n")
    $stale = Invoke-Installer @('-Check')
    if ($stale.Code -eq 0) { throw 'Outdated managed hook must fail the installation check.' }
    $repair = Invoke-Installer @()
    if ($repair.Code -ne 0 -or [IO.File]::ReadAllText($prePush) -cne $managedPush) { throw 'Managed hook update failed.' }
    # Execute the actual shell hook, with local validators that fail predictably.
    [IO.File]::WriteAllText((Join-Path $fixture 'bin/check-secrets.ps1'), "exit 0`n")
    [IO.File]::WriteAllText((Join-Path $fixture 'bin/validate-agents.ps1'), "exit 7`n")
    $gitCommand = Get-Command git -ErrorAction Stop
    $shell = if ($IsWindows) { Join-Path (Split-Path (Split-Path $gitCommand.Source)) 'bin/sh.exe' } else { '/bin/sh' }
    if (-not (Test-Path -LiteralPath $shell)) { throw 'Git shell unavailable; cannot verify the actual hook.' }
    Push-Location $fixture
    try {
        & $shell $prePush *> $null
        if ($LASTEXITCODE -ne 7) { throw 'Pre-push must propagate a failing validator.' }
        [IO.File]::WriteAllText((Join-Path $fixture 'bin/validate-agents.ps1'), "exit 0`n")
        & $shell $prePush *> $null
        if ($LASTEXITCODE -ne 0) { throw 'Pre-push must allow passing checks.' }
        [IO.File]::WriteAllText((Join-Path $fixture 'bin/check-secrets.ps1'), "exit 9`n")
        & $shell $preCommit *> $null
        if ($LASTEXITCODE -ne 9) { throw 'Pre-commit must propagate a failing secret scan.' }
        & $shell $prePush *> $null
        if ($LASTEXITCODE -ne 9) { throw 'Pre-push must propagate a failing secret scan.' }
    } finally { Pop-Location }
    # A shared/custom hook directory must not be overwritten implicitly.
    $custom = Join-Path $fixture 'custom-hooks'
    & git -C $fixture config core.hooksPath $custom
    $customInstall = Invoke-Installer @()
    if ($customInstall.Code -eq 0 -or (Test-Path $custom)) { throw 'Custom hooksPath must remain untouched.' }
    'GIT_HOOK_TESTS_OK'
} finally {
    $resolved = [IO.Path]::GetFullPath($fixture)
    if (-not $resolved.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase) -or (Split-Path $resolved -Leaf) -notlike 'agents-hooks-*') { throw 'Unsafe fixture cleanup.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
