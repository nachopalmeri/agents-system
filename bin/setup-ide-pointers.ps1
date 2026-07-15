#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [string] $AgentsRoot,
    [string] $HomePath = $env:USERPROFILE,
    [switch] $DryRun,
    [switch] $ForceCopy,
    [switch] $Force
)

$ErrorActionPreference = "Stop"
if ($AgentsRoot -and -not $PSBoundParameters.ContainsKey("HomePath")) {
    $HomePath = Split-Path ([System.IO.Path]::GetFullPath($AgentsRoot)) -Parent
}
$syncScript = Join-Path $PSScriptRoot "sync-runtime.ps1"
$parameters = @{ HomePath = $HomePath }
if ($DryRun) { $parameters.WhatIf = $true }
if ($ForceCopy -or $Force) { $parameters.Force = $true }
Write-Host "setup-ide-pointers delegates to managed runtime sync."
& $syncScript @parameters
exit $LASTEXITCODE
