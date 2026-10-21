$ErrorActionPreference='Stop'
$testRoot=Join-Path ([IO.Path]::GetTempPath()) ('delegation-test-'+[guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path $testRoot)
$path=Join-Path $testRoot 'request.json'
try {
    $request=@{objective='Add isolated test fixtures'; risk='low'; sensitiveData=$false; operation='edit'; taskClass='tests-and-fixtures'; allowedPaths=@('tests/example.json')}
    function Route { $request | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $path; & (Join-Path $PSScriptRoot 'select-delegation.ps1') -RequestPath $path | ConvertFrom-Json }
    $route=Route; if($route.executor -ne 'opencode' -or $route.tier -ne 'free-worker'){throw 'Local edits should delegate.'}
    if ($route.maxAttempts -ne 1) { throw 'Selector ignored free-worker policy attempt budget.' }
    $request.sameHarnessAvailable=$true; if((Route).executor -ne 'same-harness'){throw 'Same-harness cheaper worker preferred.'}
    $request.risk='high'; if((Route).delegate){throw 'High risk must stay primary.'}
    $request.risk='low'; $request.trivial=$true; if((Route).delegate){throw 'Trivial task must avoid overhead.'}
    $request.trivial=$false; $request.allowedPaths=@('../escape'); $rejected=$false; try {Route|Out-Null}catch{$rejected=$true}; if(-not $rejected){throw 'Traversal accepted.'}
    $request.allowedPaths=@('.env.local'); $rejected=$false; try {Route|Out-Null}catch{$rejected=$true}; if(-not $rejected){throw 'Secret edit accepted.'}
    $request.allowedPaths=@('tests/example.json'); $request.subtasks=@(@{objective='Write fixture'; operation='edit'; allowedPaths=@('tests/example.json')},@{objective='Write competing fixture';operation='edit';allowedPaths=@('tests/example.json')})
    $rejected=$false; try {Route|Out-Null}catch{$rejected=$true}; if(-not $rejected){throw 'Overlapping worker ownership accepted.'}
    $request.subtasks=@(@{objective='Write fixture';operation='edit';allowedPaths=@('tests/example.json')})
    if(-not (Route).delegate){throw 'Bounded worker rejected.'}
    $request.Remove('subtasks'); $request.sameHarnessAvailable=$false; $request.workspace=$testRoot; $request.operation='read'; $request.Remove('allowedPaths')
    $request.objective='Return fixture success'; Route|Out-Null
    $fixture=Join-Path (Split-Path $PSScriptRoot -Parent) 'evals/fixtures/delegation-cli.ps1'
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'SUCCESS' -or $receipt.attempts.Count -ne 1){throw 'CLI event aggregation failed.'}
    $request.subtasks=@(@{objective='Read README headings';operation='read';allowedPaths=@()},@{objective='Read delegation guide headings';operation='read';allowedPaths=@()})
    $request.objective='Return fixture multi output'
    Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'SUCCESS' -or $receipt.result.state -ne 'SUCCESS' -or $receipt.result.uncertainty.Count -ne 1 -or $receipt.result.evidence.Count -ne 2){throw 'Multi-agent completion wording and scalar uncertainty should normalize to the result contract.'}
    $request.Remove('subtasks')
    $fixtureFile=Join-Path $testRoot 'fixture.txt'
    $request.operation='edit'; $request.allowedPaths=@('fixture.txt'); Set-Content -LiteralPath $fixtureFile -Value 'scope fixture'
    $request.objective="Return fixture absolute changed file $fixtureFile"
    Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'SUCCESS' -or $receipt.result.changedFiles.Count -ne 1 -or $receipt.result.changedFiles[0] -ne 'fixture.txt'){throw 'An absolute changed-file report should normalize only when it matches a parent-authorized file.'}
    Set-Content -LiteralPath $fixtureFile -Value 'scope fixture'
    $request.objective="Return fixture partial edit $fixtureFile"
    Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'BLOCKED' -or $receipt.fallbackExecutor -ne 'primary' -or $receipt.partialChanges[0] -ne 'fixture.txt'){throw 'Unstructured output after an edit must report the exact partial change and hand back to primary.'}
    $request.operation='read'; $request.Remove('allowedPaths')
    $request.objective='Return fixture refusal'; Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'PROVIDER_REFUSAL' -or $receipt.attempts.Count -ne 1 -or $receipt.fallbackExecutor -ne 'primary'){throw '403 must stop without paid fallback.'}
    $request.objective='Return fixture free-tier policy refusal'; Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -ne 'PROVIDER_REFUSAL' -or $receipt.attempts.Count -ne 1 -or $receipt.fallbackExecutor -ne 'primary'){throw '400 free-tier policy refusal must stop after one attempt and fall back to primary.'}
    $request.objective='Return fixture malformed'; Route|Out-Null
    $receipt=& (Join-Path $PSScriptRoot 'invoke-delegation.ps1') -RequestPath $path -OpenCodeCommand $fixture | ConvertFrom-Json
    if($receipt.state -eq 'SUCCESS' -or $receipt.attempts.Count -ne 1 -or $receipt.fallbackExecutor -ne 'primary' -or -not $receipt.resultValidation){throw 'Malformed outputs must explain the contract failure and hand back to primary after one lean attempt.'}
    'DELEGATION_TESTS_OK'
} finally { Remove-Item -LiteralPath $path -ErrorAction SilentlyContinue; Remove-Item -LiteralPath $testRoot -Recurse -Force }
