#!/usr/bin/env pwsh
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$hook = Join-Path $PSScriptRoot '../.agents/hooks/log-usage.ps1'
$sandbox = Join-Path ([IO.Path]::GetTempPath()) ('usage-hook-test-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($sandbox)
$script:passed = 0

function Assert-True($Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

function Invoke-Hook([string]$InputJson, [string]$TestHome) {
    $start = [Diagnostics.ProcessStartInfo]::new()
    $start.FileName = (Get-Process -Id $PID).Path
    $start.UseShellExecute = $false
    $start.RedirectStandardInput = $true
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.Environment['USERPROFILE'] = $TestHome
    $start.Environment['HOME'] = $TestHome
    $start.Environment['USAGE_TEST_HOME'] = $TestHome
    $start.Environment['USAGE_TEST_HOOK'] = $hook
    # Refuse to execute the real hook unless home isolation succeeded.
    $bootstrap = 'if ($HOME -ne $env:USAGE_TEST_HOME) { exit 91 }; & $env:USAGE_TEST_HOOK'
    foreach ($argument in @('-NoLogo', '-NoProfile', '-NonInteractive', '-EncodedCommand',
        [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($bootstrap)))) {
        $start.ArgumentList.Add($argument)
    }
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $start
    try {
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        $process.StandardInput.Write($InputJson)
        $process.StandardInput.Close()
        if (-not $process.WaitForExit(10000)) {
            $process.Kill($true)
            throw 'Hook exceeded the test timeout.'
        }
        Assert-True ($process.ExitCode -eq 0) 'Hook failed or temporary home isolation failed.'
        Assert-True ($stdout.GetAwaiter().GetResult().Length -eq 0) 'Hook emitted stdout.'
        Assert-True ($stderr.GetAwaiter().GetResult().Length -eq 0) 'Hook emitted stderr.'
    } finally { $process.Dispose() }
}

function Test-Case([string]$Name, [scriptblock]$Body) {
    $caseHome = Join-Path $sandbox ([guid]::NewGuid().ToString('N'))
    [void][IO.Directory]::CreateDirectory($caseHome)
    & $Body $caseHome (Join-Path $caseHome '.agents/tasks/usage-log.md')
    $script:passed++
    Write-Host "PASS $Name"
}

Test-Case 'Skill logs metadata only and preserves the four-column schema' {
    param($caseHome, $log)
    Invoke-Hook (@{ tool_name = 'Skill'; tool_input = @{
        skill = 'test-driven-development'; args = "SYNTHETIC_PRIVATE_ARGS | injected`nforged-row"
        description = 'SYNTHETIC_PRIVATE_DESCRIPTION'
    }} | ConvertTo-Json -Depth 5 -Compress) $caseHome
    $content = [IO.File]::ReadAllText($log)
    $today = Get-Date -Format 'yyyy-MM-dd'
    $rows = @($content -split '\r?\n' | Where-Object { $_ -match '^\d{4}-\d{2}-\d{2} \|' })
    Assert-True ($rows.Count -eq 1) 'Expected exactly one usage row.'
    Assert-True ($rows[0] -ceq "$today | skill | test-driven-development | ") 'Privacy/schema failure: expected an empty detail column.'
    Assert-True (-not $content.Contains('SYNTHETIC_PRIVATE')) 'Raw private fields reached the log.'
}

Test-Case 'Agent omits descriptions and ignores supplied dates' {
    param($caseHome, $log)
    Invoke-Hook (@{ tool_name = 'Agent'; date = "fake`nrow"; tool_input = @{
        subagent_type = 'reviewer'; description = "SYNTHETIC_PRIVATE_DESCRIPTION | forged`nrow"
        args = 'SYNTHETIC_PRIVATE_ARGS'
    }} | ConvertTo-Json -Depth 5 -Compress) $caseHome
    $content = [IO.File]::ReadAllText($log)
    $today = Get-Date -Format 'yyyy-MM-dd'
    Assert-True ($content.Contains("$today | agent | reviewer | ")) 'Expected agent metadata.'
    Assert-True (-not ($content -match 'SYNTHETIC_PRIVATE|fake|forged')) 'Unexpected raw metadata.'
}

Test-Case 'Missing agent type preserves general-purpose fallback' {
    param($caseHome, $log)
    Invoke-Hook '{"tool_name":"Agent","tool_input":{}}' $caseHome
    Assert-True ([IO.File]::ReadAllText($log).Contains(' | agent | general-purpose | ')) 'Agent fallback changed.'
}

Test-Case 'Namespaced and maximum-length names remain usable' {
    param($caseHome, $log)
    foreach ($name in @('plugin-name:skill_name.v2', ('a' * 128))) {
        Invoke-Hook (@{ tool_name = 'Skill'; tool_input = @{ skill = $name }} | ConvertTo-Json -Compress) $caseHome
    }
    $content = [IO.File]::ReadAllText($log)
    $rows = @($content -split '\r?\n' | Where-Object { $_ -match '^\d{4}-\d{2}-\d{2} \|' })
    Assert-True ($rows.Count -eq 2) 'Valid names were dropped.'
    Assert-True (@($content -split '\r?\n' | Where-Object { $_ -match '^## ' }).Count -eq 1) 'Duplicate daily headings.'
}

$invalidNames = @("reviewer | secret", "reviewer`nforged", "reviewer`rforged", "reviewer`n",
    "reviewer`tsecret", "reviewer$([char]0)secret", 'user@example.com', '../reviewer',
    'a..b', 'a::b', 'reviewer secret', ('a' * 129), @('reviewer'), @{ name = 'reviewer' }, 123, $true)
foreach ($tool in @('Agent', 'Skill')) {
    foreach ($name in $invalidNames) {
        Test-Case "$tool rejects unsafe or non-string component (case $script:passed)" {
            param($caseHome, $log)
            $inputFields = if ($tool -eq 'Agent') { @{ subagent_type = $name } } else { @{ skill = $name } }
            Invoke-Hook (@{ tool_name = $tool; tool_input = $inputFields } | ConvertTo-Json -Depth 5 -Compress) $caseHome
            Assert-True (-not (Test-Path -LiteralPath $log)) 'Invalid component was persisted.'
        }
    }
}

foreach ($json in @('', 'not-json', '{', 'null', '[]', '42',
    '{"tool_name":"Skill","tool_input":{}}', '{"tool_name":"Skill","tool_input":{"skill":""}}',
    '{"tool_name":"Skill","tool_input":{"skill":"   "}}',
    '{"tool_name":"Skill","tool_input":"reviewer"}',
    '[{"tool_name":"Skill","tool_input":{"skill":"reviewer"}}]',
    '{"tool_name":["Skill"],"tool_input":{"skill":"reviewer"}}')) {
    Test-Case "Malformed or missing metadata is silent (case $script:passed)" {
        param($caseHome, $log)
        Invoke-Hook $json $caseHome
        Assert-True (-not (Test-Path -LiteralPath $log)) 'Malformed event was logged.'
    }
}

foreach ($tool in @('Read', 'Bash', 'Task', 'OtherSkill', 'skill')) {
    Test-Case "Unrelated tool $tool creates no log" {
        param($caseHome, $log)
        Invoke-Hook (@{ tool_name = $tool; tool_input = @{ skill = 'reviewer'; subagent_type = 'reviewer' }} |
            ConvertTo-Json -Compress) $caseHome
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $caseHome '.agents'))) 'Unrelated tool touched logging directories.'
    }
}

Test-Case 'Existing synthetic log is appended without migration' {
    param($caseHome, $log)
    [void][IO.Directory]::CreateDirectory((Split-Path $log))
    $prefix = "# Synthetic legacy log`n2000-01-01 | skill | old-skill | SYNTHETIC_OLD_DETAIL`n"
    [IO.File]::WriteAllText($log, $prefix, [Text.UTF8Encoding]::new($false))
    $before = [IO.File]::ReadAllBytes($log)
    Invoke-Hook '{"tool_name":"Skill","tool_input":{"skill":"astro"}}' $caseHome
    $after = [IO.File]::ReadAllBytes($log)
    Assert-True ($after.Length -gt $before.Length) 'Expected append.'
    for ($i = 0; $i -lt $before.Length; $i++) {
        Assert-True ($after[$i] -eq $before[$i]) 'Existing synthetic log bytes changed.'
    }
}

foreach ($blockedTarget in @('parent', 'log')) {
    Test-Case "Filesystem failure at $blockedTarget is silent and nonblocking" {
        param($caseHome, $log)
        if ($blockedTarget -eq 'parent') {
            [IO.File]::WriteAllText((Join-Path $caseHome '.agents'), 'synthetic blocker')
        } else {
            [void][IO.Directory]::CreateDirectory($log)
        }
        Invoke-Hook '{"tool_name":"Skill","tool_input":{"skill":"astro"}}' $caseHome
    }
}

# Retain only synthetic fixtures in the OS temp directory; never inspect a real home log.
Write-Host "USAGE_LOG_TESTS_OK ($script:passed tests)"
