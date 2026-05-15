#!/usr/bin/env pwsh
param(
    [string]$Repo = "nachopalmeri/agents-system",
    [string]$InstallDir = "$env:USERPROFILE\agents-system"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) is required for private repo install. Install it and run: gh auth login"
}

if (-not (Test-Path $InstallDir)) {
    gh repo clone $Repo $InstallDir
}

$installScript = Join-Path $InstallDir "install.ps1"
if (-not (Test-Path $installScript)) {
    throw "install.ps1 not found at $installScript"
}

& $installScript

$doctor = Join-Path $InstallDir "bin\doctor.ps1"
if (Test-Path $doctor) {
    & $doctor
}
