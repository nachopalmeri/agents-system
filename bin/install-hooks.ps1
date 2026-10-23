#!/usr/bin/env pwsh
param([switch]$Uninstall, [switch]$Check)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
# A custom hooksPath may be shared by other repositories or hook managers.
$customHooks = & git -C $repoRoot config --get core.hooksPath 2>$null
if ($LASTEXITCODE -eq 0 -and $customHooks) { throw 'Custom core.hooksPath detected; integrate checks with your existing hook manager explicitly.' }
$hooksDir = (& git -C $repoRoot rev-parse --git-path hooks 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($hooksDir)) { throw "Unable to resolve Git hooks directory at $repoRoot" }
$hooksDir = $hooksDir.Trim()
if (-not [IO.Path]::IsPathRooted($hooksDir)) { $hooksDir = Join-Path $repoRoot $hooksDir }
$marker = '# agents-system-managed-hook-v1'
$preCommit = @'
#!/bin/sh
# agents-system-managed-hook-v1
repo_root=$(git rev-parse --show-toplevel) || exit 1
if command -v pwsh >/dev/null 2>&1; then
  exec pwsh -NoProfile -File "$repo_root/bin/check-secrets.ps1"
else
  printf '%s\n' 'PowerShell 7 (pwsh) is required for agents-system validation.' >&2
  exit 1
fi
'@
$prePush = @'
#!/bin/sh
# agents-system-managed-hook-v1
repo_root=$(git rev-parse --show-toplevel) || exit 1
if ! command -v pwsh >/dev/null 2>&1; then
  printf '%s\n' 'PowerShell 7 (pwsh) is required for agents-system validation.' >&2
  exit 1
fi
pwsh -NoProfile -File "$repo_root/bin/validate-agents.ps1" || exit $?
pwsh -NoProfile -File "$repo_root/bin/check-secrets.ps1" || exit $?
'@

$expected = @{ 'pre-commit'=$preCommit.Replace("`r`n", "`n") + "`n"; 'pre-push'=$prePush.Replace("`r`n", "`n") + "`n" }
# Preflight every target before changing any; never overwrite another hook manager.
foreach ($hook in @('pre-commit','pre-push')) {
    $path = Join-Path $hooksDir $hook
    if (Test-Path -LiteralPath $path) {
        $item = Get-Item -LiteralPath $path -Force
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -or $item.PSIsContainer) { throw "Refusing non-regular hook: $hook" }
        $content = [IO.File]::ReadAllText($path).Replace("`r`n", "`n")
        if (($content -split "`n") -notcontains $marker) { throw "Unmanaged $hook preserved. Integrate the validation commands manually." }
        if ($Check -and $content -cne $expected[$hook]) { throw "Managed $hook is outdated; rerun bin/install-hooks.ps1." }
    } elseif ($Check) { throw "Missing $hook; run bin/install-hooks.ps1." }
}
if ($Check) { Write-Output 'HOOKS_OK'; exit 0 }
if ($Uninstall) {
    foreach ($hook in @('pre-commit','pre-push')) {
        $path = Join-Path $hooksDir $hook
        if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
    }
    Write-Host 'Managed hooks removed.'
    exit 0
}
if (-not (Test-Path -LiteralPath $hooksDir)) { [void](New-Item -ItemType Directory -Path $hooksDir) }
foreach ($hook in @('pre-commit','pre-push')) {
    $path = Join-Path $hooksDir $hook
    [IO.File]::WriteAllText($path, $expected[$hook], [Text.UTF8Encoding]::new($false))
    if (-not $IsWindows) { [IO.File]::SetUnixFileMode($path, [IO.UnixFileMode]493) }
}
Write-Host "Hooks installed." -ForegroundColor Green
