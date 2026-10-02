#!/usr/bin/env pwsh
[CmdletBinding(SupportsShouldProcess=$true)]
param([string] $HomePath = $env:USERPROFILE, [switch] $InstallTools)
$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$homeRoot = [IO.Path]::GetFullPath($HomePath)
if (-not (Test-Path (Join-Path $repoRoot 'config/runtime-manifest.json'))) { throw 'Run from an intact runtime checkout.' }
if ($InstallTools -and $PSCmdlet.ShouldProcess('Pinned runtime CLIs','Install user-scope tools')) {
    & (Join-Path $PSScriptRoot 'install-runtime-tools.ps1') -Apply
    if ($LASTEXITCODE -ne 0) { throw 'Tool installation failed.' }
}
if (-not $PSCmdlet.ShouldProcess($homeRoot,'Sync managed runtime, register checkout and add home/bin to user PATH')) { return }
& (Join-Path $PSScriptRoot 'sync-runtime.ps1') -HomePath $homeRoot
if ($LASTEXITCODE -ne 0) { throw 'Managed runtime sync failed.' }
$pointerPath = Join-Path $homeRoot '.agents/local-runtime.json'
foreach ($checkedPath in @($homeRoot,(Join-Path $homeRoot '.agents'),$pointerPath)) {
    if ((Test-Path -LiteralPath $checkedPath) -and ((Get-Item -LiteralPath $checkedPath -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) { throw "Registration crosses a reparse point: $checkedPath" }
}
$oldUserPath = [Environment]::GetEnvironmentVariable('Path','User')
if (Test-Path -LiteralPath $pointerPath) { Copy-Item -LiteralPath $pointerPath -Destination "$pointerPath.backup-$([guid]::NewGuid().ToString('N'))" }
$pointer = [ordered]@{schemaVersion=1; repoPath=$repoRoot; registeredAt=(Get-Date -Format o); previousUserPath=$oldUserPath}
[IO.File]::WriteAllText($pointerPath, ($pointer | ConvertTo-Json), [Text.UTF8Encoding]::new($false))
$binPath = Join-Path $homeRoot 'bin'
if ($IsWindows -and [IO.Path]::GetFullPath($env:USERPROFILE) -eq $homeRoot) {
    $pathEntries = @($oldUserPath -split ';' | Where-Object { $_ })
    if ($pathEntries.TrimEnd('\') -notcontains $binPath.TrimEnd('\')) { [Environment]::SetEnvironmentVariable('Path', (($pathEntries + $binPath) -join ';'),'User') }
}
"Global runtime registered. Open a fresh shell and run: agents doctor"
