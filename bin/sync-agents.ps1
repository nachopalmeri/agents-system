#!/usr/bin/env pwsh
# sync-agents.ps1 - Sincroniza ~/.agents/ con el repo agents-system
# Usar después de actualizar el repo para que los cambios lleguen a todos los IDEs

$repoDir = "$env:USERPROFILE\CascadeProjects\cv-palmeri\agents-system"
$agentsDir = "$env:USERPROFILE\.agents"

if (-not (Test-Path $repoDir)) {
    Write-Host "ERROR: Repo no encontrado en $repoDir" -ForegroundColor Red
    exit 1
}

Write-Host "Syncing $repoDir\.agents\ -> $agentsDir\" -ForegroundColor Cyan

# Sync AGENTS.md principal
Copy-Item "$repoDir\AGENTS.md" "$agentsDir\AGENTS.md" -Force
Write-Host "  [OK] AGENTS.md" -ForegroundColor Green

# Sync rules
Get-ChildItem "$repoDir\.agents\rules" -File | ForEach-Object {
    Copy-Item $_.FullName "$agentsDir\rules\$($_.Name)" -Force
    Write-Host "  [OK] rules/$($_.Name)" -ForegroundColor Green
}

# Sync workflows
Get-ChildItem "$repoDir\.agents\workflows" -File | ForEach-Object {
    Copy-Item $_.FullName "$agentsDir\workflows\$($_.Name)" -Force
    Write-Host "  [OK] workflows/$($_.Name)" -ForegroundColor Green
}

# Sync agents
Get-ChildItem "$repoDir\.agents\agents" -File -ErrorAction SilentlyContinue | ForEach-Object {
    Copy-Item $_.FullName "$agentsDir\agents\$($_.Name)" -Force
    Write-Host "  [OK] agents/$($_.Name)" -ForegroundColor Green
}

# Sync skills
Get-ChildItem "$repoDir\.agents\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $dest = "$agentsDir\skills\$($_.Name)"
    if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
    Copy-Item $_.FullName $dest -Recurse -Force
    Write-Host "  [OK] skills/$($_.Name)" -ForegroundColor Green
}

# Re-run IDE pointers
Write-Host ""
Write-Host "Updating IDE pointers..." -ForegroundColor Cyan
& "$repoDir\bin\setup-ide-pointers.ps1" -AgentsRoot $agentsDir -ForceCopy

Write-Host ""
Write-Host "Sync complete." -ForegroundColor Green
