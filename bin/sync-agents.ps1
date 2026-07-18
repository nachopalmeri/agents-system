#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [string] $HomePath = $env:USERPROFILE,
    [switch] $WhatIf,
    [switch] $Force
)

$ErrorActionPreference = "Stop"
$syncScript = Join-Path $PSScriptRoot "sync-runtime.ps1"
$parameters = @{ HomePath = $HomePath }
if ($WhatIf) { $parameters.WhatIf = $true }
if ($Force) { $parameters.Force = $true }
Write-Host "sync-agents delegates to managed runtime sync."
& $syncScript @parameters
exit $LASTEXITCODE
