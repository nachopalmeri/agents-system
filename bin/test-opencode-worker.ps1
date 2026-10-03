$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$tempRoot=[IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$testRoot=Join-Path $tempRoot ('opencode-worker-test-'+[guid]::NewGuid().ToString('N'))
$toolRoot=Join-Path $testRoot '.agents-tools/opencode-v1'
New-Item -ItemType Directory $toolRoot -Force | Out-Null
$fakeCli=Join-Path $toolRoot 'opencode.ps1'
@'
$values=@{}
foreach($name in @('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','XDG_STATE_HOME')){$values[$name]=[Environment]::GetEnvironmentVariable($name,'Process')}
$values | ConvertTo-Json -Compress
exit 7
'@ | Set-Content $fakeCli
$runner=Join-Path $testRoot 'runner.ps1'
@'
param($Wrapper)
$ErrorActionPreference='Stop'
$keys=@('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','XDG_STATE_HOME')
$before=@{}
foreach($key in $keys){$before[$key]=[Environment]::GetEnvironmentVariable($key,'Process')}
$payload=@(& $Wrapper probe) -join "`n"
$workerCode=$LASTEXITCODE
foreach($key in $keys){if([Environment]::GetEnvironmentVariable($key,'Process') -cne $before[$key]){throw "Environment leaked: $key"}}
@{exitCode=$workerCode;worker=($payload|ConvertFrom-Json);restored=$true}|ConvertTo-Json -Depth 5 -Compress
'@ | Set-Content $runner
try {
 $info=[Diagnostics.ProcessStartInfo]::new()
 $info.FileName=(Get-Command pwsh).Source
 foreach($arg in @('-NoProfile','-File',$runner,(Join-Path $root 'bin/opencode-worker.ps1'))){$info.ArgumentList.Add($arg)}
 $info.Environment['USERPROFILE']=$testRoot
 $info.Environment['XDG_CONFIG_HOME']='ambient-config-sentinel'
 foreach($key in @('XDG_DATA_HOME','XDG_CACHE_HOME','XDG_STATE_HOME')){[void]$info.Environment.Remove($key)}
 $info.UseShellExecute=$false; $info.CreateNoWindow=$true
 $info.RedirectStandardOutput=$true; $info.RedirectStandardError=$true
 $process=[Diagnostics.Process]::Start($info)
 $output=$process.StandardOutput.ReadToEndAsync(); $errors=$process.StandardError.ReadToEndAsync()
 if(-not $process.WaitForExit(15000)){$process.Kill($true);throw 'Worker test timeout'}
 if($process.ExitCode -ne 0){throw $errors.GetAwaiter().GetResult()}
 $result=$output.GetAwaiter().GetResult()|ConvertFrom-Json
 if($result.exitCode -ne 7 -or -not $result.restored){throw 'Exit/environment contract failed'}
 foreach($key in @('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','XDG_STATE_HOME')){
  if($result.worker.$key -ne (Join-Path $toolRoot "runtime/$key")){throw "Wrong isolated root: $key"}
 }
 'OPENCODE_WORKER_TESTS_OK'
} finally {
 $resolved=[IO.Path]::GetFullPath($testRoot)
 if(-not $resolved.StartsWith($tempRoot.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)){throw 'Unsafe fixture cleanup'}
 Remove-Item -LiteralPath $resolved -Recurse -Force
}
