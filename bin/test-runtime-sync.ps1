#!/usr/bin/env pwsh
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$syncScript = Join-Path $PSScriptRoot "sync-runtime.ps1"
$doctorScript = Join-Path $PSScriptRoot "doctor.ps1"
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) "agents-runtime-sync-$([guid]::NewGuid().ToString('N'))"
$script:passed = 0

function Assert-True {
    param([bool] $Condition, [string] $Message)
    if (-not $Condition) { throw "ASSERT FAILED: $Message" }
    $script:passed++
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Invoke-PowerShellScript {
    param([string] $Path, [string[]] $Arguments = @(), [hashtable] $Environment = @{})
    $previous = @{}
    foreach ($name in $Environment.Keys) {
        $previous[$name] = [Environment]::GetEnvironmentVariable($name, "Process")
        [Environment]::SetEnvironmentVariable($name, [string]$Environment[$name], "Process")
    }
    try {
        $previousPreference = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        $output = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Path @Arguments 2>&1 | Out-String
        $ErrorActionPreference = $previousPreference
        return [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = $output }
    } finally {
        $ErrorActionPreference = "Stop"
        foreach ($name in $Environment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $previous[$name], "Process")
        }
    }
}

function Invoke-Sync {
    param([string] $HomePath, [string[]] $Arguments = @(), [hashtable] $Environment = @{})
    return Invoke-PowerShellScript -Path $syncScript -Arguments (@("-HomePath", $HomePath) + $Arguments) -Environment $Environment
}

function New-TestHome([string] $Name) {
    $path = Join-Path $testRoot $Name
    [void](New-Item -ItemType Directory -Path $path -Force)
    return $path
}

function Get-ManifestPath([string] $Output) {
    $match = [regex]::Match($Output, '(?m)^Backup manifest:\s*(.+)\s*$')
    if (-not $match.Success) { throw "Backup manifest missing from output:`n$Output" }
    return $match.Groups[1].Value.Trim()
}

function Copy-SyncFixtureRepo([string] $Name) {
    $fixtureRoot = Join-Path $testRoot $Name
    foreach ($directory in @("bin", "config", "config\templates", "config\opencode", ".agents", ".agents\workflows")) {
        [void](New-Item -ItemType Directory -Path (Join-Path $fixtureRoot $directory) -Force)
    }
    Copy-Item $syncScript (Join-Path $fixtureRoot "bin\sync-runtime.ps1")
    Copy-Item (Join-Path $repoRoot "config\runtime-manifest.json") (Join-Path $fixtureRoot "config\runtime-manifest.json")
    Copy-Item (Join-Path $repoRoot "config\templates\root-AGENTS.md.tmpl") (Join-Path $fixtureRoot "config\templates\root-AGENTS.md.tmpl")
    Copy-Item (Join-Path $repoRoot "config\opencode\opencode.jsonc") (Join-Path $fixtureRoot "config\opencode\opencode.jsonc")
    Copy-Item (Join-Path $repoRoot "config\opencode\AGENTS.md") (Join-Path $fixtureRoot "config\opencode\AGENTS.md")
    Copy-Item (Join-Path $repoRoot ".agents\AGENTS.md") (Join-Path $fixtureRoot ".agents\AGENTS.md")
    Copy-Item (Join-Path $repoRoot ".agents\workflows\index.md") (Join-Path $fixtureRoot ".agents\workflows\index.md")
    foreach ($adapter in @("AGENTS.md", "CLAUDE.md", "GEMINI.md")) {
        Copy-Item (Join-Path $repoRoot $adapter) (Join-Path $fixtureRoot $adapter)
    }
    return $fixtureRoot
}

if (-not (Test-Path $syncScript -PathType Leaf)) {
    throw "Required implementation missing: $syncScript"
}

[void](New-Item -ItemType Directory -Path $testRoot -Force)
try {
    Write-Host "==> WhatIf is write-free" -ForegroundColor Cyan
    $dryHome = New-TestHome "dry-home"
    $dryRun = Invoke-Sync -HomePath $dryHome -Arguments @("-WhatIf")
    Assert-True ($dryRun.ExitCode -eq 0) "WhatIf exits successfully"
    Assert-True (@(Get-ChildItem $dryHome -Force).Count -eq 0) "WhatIf creates no files or directories"

    Write-Host "==> Sync, doctor, drift, restore" -ForegroundColor Cyan
    $syncHome = New-TestHome "happy-home"
    $sync = Invoke-Sync -HomePath $syncHome
    Assert-True ($sync.ExitCode -eq 0) "initial sync succeeds"
    $manifestPath = Get-ManifestPath $sync.Output
    Assert-True (Test-Path $manifestPath -PathType Leaf) "sync writes a backup manifest"
    Assert-True (Test-Path (Join-Path $syncHome ".agents\AGENTS.md") -PathType Leaf) "canonical runtime is installed"
    Assert-True (Test-Path (Join-Path $syncHome ".codex\AGENTS.md") -PathType Leaf) "Codex adapter is installed"
    Assert-True (Test-Path (Join-Path $syncHome ".config\opencode\opencode.jsonc") -PathType Leaf) "OpenCode preload config is installed"

    $doctor = Invoke-PowerShellScript -Path $doctorScript -Arguments @("-HomePath", $syncHome)
    Assert-True ($doctor.ExitCode -eq 0) "doctor accepts a synchronized temp home"
    Assert-True ($doctor.Output -match '\[supported\]\s+codex.*sha256=') "doctor reports Codex support with a hash"
    Assert-True ($doctor.Output -match '\[supported\]\s+opencode.*preload=ok') "doctor verifies OpenCode preload"

    $openCodeConfigTarget = Join-Path $syncHome ".config\opencode\opencode.jsonc"
    $managedOpenCodeConfig = Get-Content $openCodeConfigTarget -Raw
    [System.IO.File]::WriteAllText($openCodeConfigTarget, ($managedOpenCodeConfig + "`n "), (New-Object System.Text.UTF8Encoding($false)))
    $configDriftDoctor = Invoke-PowerShellScript -Path $doctorScript -Arguments @("-Client", "opencode", "-HomePath", $syncHome)
    Assert-True ($configDriftDoctor.ExitCode -ne 0) "doctor fails when OpenCode config hash drifts but preload stays valid"
    Assert-True ($configDriftDoctor.Output -match 'config hash mismatch') "doctor names OpenCode config hash mismatch"
    [System.IO.File]::WriteAllText($openCodeConfigTarget, $managedOpenCodeConfig, (New-Object System.Text.UTF8Encoding($false)))

    $codexTarget = Join-Path $syncHome ".codex\AGENTS.md"
    $managedCodex = Get-Content $codexTarget -Raw
    Add-Content -Path $codexTarget -Value "local drift"
    $driftDoctor = Invoke-PowerShellScript -Path $doctorScript -Arguments @("-Client", "codex", "-HomePath", $syncHome)
    Assert-True ($driftDoctor.ExitCode -ne 0) "doctor fails on managed adapter drift"
    Assert-True ($driftDoctor.Output -match '\[unsupported\]\s+codex.*hash mismatch') "doctor names the hash mismatch"
    $driftSync = Invoke-Sync -HomePath $syncHome
    Assert-True ($driftSync.ExitCode -ne 0) "sync refuses drift without Force"
    Assert-True ($driftSync.Output -match 'drift') "sync explains the drift refusal"
    [System.IO.File]::WriteAllText($codexTarget, $managedCodex, (New-Object System.Text.UTF8Encoding($false)))

    $restore = Invoke-Sync -HomePath $syncHome -Arguments @("-Restore", $manifestPath)
    Assert-True ($restore.ExitCode -eq 0) "restore succeeds for an owned, intact transaction"
    Assert-True (-not (Test-Path $codexTarget)) "restore removes a target that did not exist before sync"
    $finalDoctor = Invoke-PowerShellScript -Path $doctorScript -Arguments @("-Client", "codex", "-HomePath", $syncHome)
    Assert-True ($finalDoctor.ExitCode -eq 0) "doctor accepts a restored not-installed client"
    Assert-True ($finalDoctor.Output -match '\[not-installed\]\s+codex') "doctor reports not-installed after restore"

    Write-Host "==> Reject path escape" -ForegroundColor Cyan
    $escapeRepo = Copy-SyncFixtureRepo "escape-repo"
    $escapeManifestPath = Join-Path $escapeRepo "config\runtime-manifest.json"
    $escapeManifest = Get-Content $escapeManifestPath -Raw | ConvertFrom-Json
    $escapeManifest.adapters[0].globalTarget = "..\escaped-runtime.txt"
    [System.IO.File]::WriteAllText($escapeManifestPath, ($escapeManifest | ConvertTo-Json -Depth 20), (New-Object System.Text.UTF8Encoding($false)))
    $escapeHome = New-TestHome "escape-home"
    $escape = Invoke-PowerShellScript -Path (Join-Path $escapeRepo "bin\sync-runtime.ps1") -Arguments @("-HomePath", $escapeHome, "-WhatIf")
    Assert-True ($escape.ExitCode -ne 0) "sync rejects a manifest target outside HomePath"
    Assert-True ($escape.Output -match 'escapes declared home') "path escape error is explicit"
    Assert-True (-not (Test-Path (Join-Path $testRoot "escaped-runtime.txt"))) "path escape writes nothing"

    Write-Host "==> Legacy entrypoints delegate without writes" -ForegroundColor Cyan
    $delegateHome = New-TestHome "delegate-home"
    $delegates = @(
        [pscustomobject]@{ Name = "setup-ide-pointers"; Path = (Join-Path $repoRoot "bin\setup-ide-pointers.ps1"); Arguments = @("-HomePath", $delegateHome, "-DryRun") },
        [pscustomobject]@{ Name = "sync-agents"; Path = (Join-Path $repoRoot "bin\sync-agents.ps1"); Arguments = @("-HomePath", $delegateHome, "-WhatIf") },
        [pscustomobject]@{ Name = "update-system"; Path = (Join-Path $repoRoot "bin\update-system.ps1"); Arguments = @("-RepoPath", $repoRoot, "-HomePath", $delegateHome, "-SkipPull", "-WhatIf") },
        [pscustomobject]@{ Name = "update"; Path = (Join-Path $repoRoot "update.ps1"); Arguments = @("-HomePath", $delegateHome, "-WhatIf") },
        [pscustomobject]@{ Name = "install"; Path = (Join-Path $repoRoot "install.ps1"); Arguments = @("-RepoPath", $repoRoot, "-HomePath", $delegateHome, "-WhatIf") }
    )
    foreach ($delegate in $delegates) {
        $result = Invoke-PowerShellScript -Path $delegate.Path -Arguments $delegate.Arguments
        Assert-True ($result.ExitCode -eq 0) "$($delegate.Name) delegates successfully in dry-run mode"
    }
    Assert-True (@(Get-ChildItem $delegateHome -Force).Count -eq 0) "legacy entrypoint dry-runs create no files"

    Write-Host "==> Reject tampered backup" -ForegroundColor Cyan
    $tamperHome = New-TestHome "tamper-home"
    $firstTamperSync = Invoke-Sync -HomePath $tamperHome
    Assert-True ($firstTamperSync.ExitCode -eq 0) "tamper fixture initial sync succeeds"
    Add-Content -Path (Join-Path $tamperHome ".codex\AGENTS.md") -Value "preserve me"
    $forcedSync = Invoke-Sync -HomePath $tamperHome -Arguments @("-Force")
    Assert-True ($forcedSync.ExitCode -eq 0) "Force replaces drift and captures it in backup"
    $forcedManifestPath = Get-ManifestPath $forcedSync.Output
    $forcedManifest = Get-Content $forcedManifestPath -Raw | ConvertFrom-Json
    $codexEntry = @($forcedManifest.entries | Where-Object { $_.relativeTarget -eq ".codex/AGENTS.md" })[0]
    $codexBackup = Join-Path (Split-Path $forcedManifestPath -Parent) $codexEntry.backupRelative
    Add-Content -Path $codexBackup -Value "tampered backup"
    $tamperedRestore = Invoke-Sync -HomePath $tamperHome -Arguments @("-Restore", $forcedManifestPath)
    Assert-True ($tamperedRestore.ExitCode -ne 0) "restore rejects a tampered backup"
    Assert-True ($tamperedRestore.Output -match 'Backup hash mismatch') "backup tamper error is explicit"

    Write-Host "==> Reject ownership mismatch" -ForegroundColor Cyan
    $ownerHome = New-TestHome "owner-home"
    $ownerSync = Invoke-Sync -HomePath $ownerHome
    Assert-True ($ownerSync.ExitCode -eq 0) "ownership fixture sync succeeds"
    $ownerManifestPath = Get-ManifestPath $ownerSync.Output
    Add-Content -Path (Join-Path $ownerHome ".codex\AGENTS.md") -Value "foreign owner"
    $ownerRestore = Invoke-Sync -HomePath $ownerHome -Arguments @("-Restore", $ownerManifestPath)
    Assert-True ($ownerRestore.ExitCode -ne 0) "restore rejects a target no longer owned by the manifest"
    Assert-True ($ownerRestore.Output -match 'Ownership mismatch') "ownership mismatch error is explicit"

    Write-Host "==> Roll back an injected partial failure" -ForegroundColor Cyan
    $rollbackHome = New-TestHome "rollback-home"
    [void](New-Item -ItemType Directory -Path (Join-Path $rollbackHome ".agents") -Force)
    [System.IO.File]::WriteAllText((Join-Path $rollbackHome ".agents\original.txt"), "original runtime")
    $failedSync = Invoke-Sync -HomePath $rollbackHome -Arguments @("-Force") -Environment @{ AGENTS_SYNC_FAIL_AFTER_REPLACE = "1" }
    Assert-True ($failedSync.ExitCode -ne 0) "injected replacement failure exits non-zero"
    Assert-True ((Get-Content (Join-Path $rollbackHome ".agents\original.txt") -Raw) -eq "original runtime") "partial failure restores the first replaced target"
    Assert-True (-not (Test-Path (Join-Path $rollbackHome ".codex\AGENTS.md"))) "partial failure leaves later targets untouched"
    $rolledBackManifest = Get-ChildItem (Join-Path $rollbackHome ".agents-system-sync\backups") -Filter manifest.json -Recurse | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1
    Assert-True ($null -ne $rolledBackManifest) "partial failure leaves an auditable manifest"
    Assert-True ((Get-Content $rolledBackManifest.FullName -Raw | ConvertFrom-Json).status -eq "rolled-back") "partial failure records rolled-back status"

    Write-Host "Runtime sync integration passed: $script:passed assertions." -ForegroundColor Green
    exit 0
} finally {
    if (Test-Path $testRoot) {
        $resolvedTemp = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\') + '\'
        $resolvedTest = [System.IO.Path]::GetFullPath($testRoot)
        if ($resolvedTest.StartsWith($resolvedTemp, [System.StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item $testRoot -Recurse -Force
        }
    }
}
