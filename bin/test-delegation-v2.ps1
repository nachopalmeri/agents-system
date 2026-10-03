$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$fixture=Join-Path $root 'evals/fixtures/delegation-cli-v2.ps1'
$workspace=Join-Path ([IO.Path]::GetTempPath()) ('bridge-v2-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $workspace | Out-Null
$requestPath=Join-Path $workspace 'request.json'
@{objective='Verify V2 fails closed';taskClass='mechanical-check';risk='low';sensitiveData=$false;operation='read';workspace=$workspace;allowedPaths=@();prefer='opencode';trivial=$false}|ConvertTo-Json|Set-Content $requestPath
try {
 $receipt=& (Join-Path $root 'bin/invoke-delegation.ps1') -RequestPath $requestPath -OpenCodeCommand $fixture|ConvertFrom-Json
 if($receipt.state -ne 'UNSUPPORTED_CONFIGURATION' -or $receipt.executor -ne 'primary'){throw 'V2 must fail closed until its effective configuration is verified'}
 'V2_FAIL_CLOSED_TESTS_OK'
} finally {
 Remove-Item -LiteralPath $requestPath
 Remove-Item -LiteralPath $workspace
}
