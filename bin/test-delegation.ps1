$ErrorActionPreference='Stop'
$dir=Join-Path ([IO.Path]::GetTempPath()) ('delegation-test-'+[guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path $dir)
$path=Join-Path $dir 'request.json'
try {
    $request=@{objective='Add isolated test fixtures'; risk='low'; sensitiveData=$false; operation='edit'; taskClass='tests-and-fixtures'; allowedPaths=@('tests/example.json')}
    function Route { $request | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $path; & (Join-Path $PSScriptRoot 'select-delegation.ps1') -RequestPath $path | ConvertFrom-Json }
    $route=Route; if($route.executor -ne 'opencode' -or $route.tier -ne 'free-worker'){throw 'Local edits should delegate.'}
    $request.sameHarnessAvailable=$true; if((Route).executor -ne 'same-harness'){throw 'Same-harness cheaper worker preferred.'}
    $request.risk='high'; if((Route).delegate){throw 'High risk must stay primary.'}
    $request.risk='low'; $request.trivial=$true; if((Route).delegate){throw 'Trivial task must avoid overhead.'}
    $request.trivial=$false; $request.allowedPaths=@('../escape'); $rejected=$false; try {Route|Out-Null}catch{$rejected=$true}; if(-not $rejected){throw 'Traversal accepted.'}
    $request.allowedPaths=@('.env.local'); $rejected=$false; try {Route|Out-Null}catch{$rejected=$true}; if(-not $rejected){throw 'Secret edit accepted.'}
    $request.allowedPaths=@('tests/example.json'); $request.subtasks=@(@{objective='Write fixture'; operation='edit'; allowedPaths=@('tests/example.json')},@{objective='Write competing fixture';operation='edit';allowedPaths=@('tests/example.json')})
    $rejected=$false; try {Route|Out-Null}catch{$rejected=$true}; if(-not $rejected){throw 'Overlapping worker ownership accepted.'}
    $request.subtasks=@(@{objective='Write fixture';operation='edit';allowedPaths=@('tests/example.json')})
    if(-not (Route).delegate){throw 'Bounded worker rejected.'}
    $request.Remove('subtasks'); $request.sameHarnessAvailable=$false; $request.workspace=$dir; $request.operation='read'; $request.Remove('allowedPaths')
    $request.objective='Return fixture success'; Route|Out-Null
    $fixture=Join-Path (Split-Path $PSScriptRoot -Parent) 'evals/fixtures/delegation-cli.ps1'
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'SUCCESS' -or $receipt.attempts.Count -ne 1){throw 'CLI event aggregation failed.'}
    $request.objective='Return fixture refusal'; Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'PROVIDER_REFUSAL' -or $receipt.attempts.Count -ne 1 -or $receipt.fallbackExecutor -ne 'primary'){throw '403 must stop without paid fallback.'}
    $request.objective='Return fixture malformed'; Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -eq 'SUCCESS' -or $receipt.attempts.Count -ne 2){throw 'Malformed outputs must exhaust bounded attempts.'}
    'DELEGATION_TESTS_OK'
} finally { Remove-Item -LiteralPath $path -ErrorAction SilentlyContinue; Remove-Item -LiteralPath $dir }
