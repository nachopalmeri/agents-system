#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
# Match GitHub's -Command shared-shell invocation: expected negative child checks must not leak exit 1.
$commands = @('test-installation-diagnostics.ps1','test-skill-inventory.ps1','test-vault-resolution.ps1') |
    ForEach-Object { "& '" + (Join-Path $PSScriptRoot $_).Replace("'", "''") + "'" }
$ciCommand = '$global:LASTEXITCODE = 1; ' + ($commands -join '; ') + '; if (Test-Path variable:\LASTEXITCODE) { exit $LASTEXITCODE }'
$output = & pwsh -NoProfile -Command $ciCommand 2>&1 | Out-String
if ($LASTEXITCODE -ne 0) { throw "Successful diagnostics leaked a failure exit code in CI's shared shell: $output" }
foreach ($marker in @('INSTALLATION_DIAGNOSTICS_TESTS_OK','SKILL_INVENTORY_TESTS_OK','VAULT_RESOLUTION_TESTS_OK')) {
    if ($output -notmatch $marker) { throw "Missing test completion: $marker" }
}
'CI_EXIT_CONTRACT_OK'
exit 0
