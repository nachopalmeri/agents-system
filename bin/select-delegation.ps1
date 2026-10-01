[CmdletBinding()]
param([Parameter(Mandatory)] [string] $RequestPath)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$request = Get-Content -LiteralPath $RequestPath -Raw | ConvertFrom-Json
$policy = Get-Content (Join-Path $root 'config/model-routing.json') -Raw | ConvertFrom-Json
if (-not $request.objective -or $request.objective.Length -gt 12000) { throw 'Provide a bounded objective (1-12000 characters).' }
if ($request.risk -notin @('low','medium','high')) { throw 'Explicit risk is required.' }
if ($request.sensitiveData -isnot [bool] -or $request.sensitiveData -ne $false) { throw 'Delegation requires explicitly non-sensitive input.' }
if ($request.operation -notin @('read','edit')) { throw 'Only scoped local read/edit delegation is supported.' }
$subtasks = @($request.subtasks | Where-Object { $_ })
if ($subtasks.Count -gt 3) { throw 'At most three workers are allowed.' }
$owned = @{}
foreach ($subtask in $subtasks) {
    if (-not $subtask.objective -or $subtask.objective.Length -gt 4000 -or $subtask.operation -notin @('read','edit')) { throw 'Invalid bounded subtask.' }
    if ($subtask.operation -eq 'edit' -and $request.operation -ne 'edit') { throw 'Read delegation cannot spawn editing workers.' }
    if ($subtask.operation -eq 'edit' -and @($subtask.allowedPaths | Where-Object { $_ }).Count -eq 0) { throw 'Editing worker requires exact paths.' }
    foreach ($path in @($subtask.allowedPaths | Where-Object { $_ })) {
        if ($request.allowedPaths -notcontains $path) { throw 'Worker scope exceeds parent scope.' }
        if ($owned.ContainsKey($path)) { throw 'Workers must own separate edit files.' }
        $owned[$path]=$true
    }
}
if ($request.operation -eq 'edit' -and @($request.allowedPaths | Where-Object { $_ }).Count -eq 0) { throw 'Edit delegation requires exact relative allowedPaths.' }
foreach ($path in @($request.allowedPaths | Where-Object { $_ })) {
    if (-not $path -or [IO.Path]::IsPathRooted($path) -or $path -match '(^|[\\/])\.\.([\\/]|$)|[*?]|(^|[\\/])(\.git|\.env[^/\\]*|secrets|production)([\\/]|$)') { throw "Invalid or sensitive edit path: $path" }
}
$tier = if ($request.risk -eq 'high') { 'frontier' } else { $policy.taskClasses.($request.taskClass) }
if (-not $tier) { $tier = 'strong' }
$delegate = $request.risk -ne 'high' -and $request.taskClass -in @('read-only-research','repo-exploration','mechanical-check','preliminary-red-team','mechanical-edit','tests-and-fixtures','documentation-edit','bounded-refactor') -and $request.trivial -ne $true
$executor = 'primary'
if ($delegate) {
    $tier = if ($request.operation -eq 'edit') { 'free-worker' } else { 'free-fast' }
    $executor = if ($request.sameHarnessAvailable -eq $true -and $request.prefer -ne 'opencode') { 'same-harness' } else { 'opencode' }
    if ($executor -eq 'same-harness') { $tier = 'cheap' }
}
[ordered]@{ delegate=$delegate; executor=$executor; tier=$tier; modelCandidates=@($policy.tiers.$tier.candidates); parentReviewRequired=$true; maxAttempts=2; maxWorkers=3; maxWallSeconds=180; finalSynthesis='primary'; reason=if($delegate){'bounded-task'}else{'primary-task'} } | ConvertTo-Json -Depth 8
