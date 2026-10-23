[CmdletBinding()]
param([Parameter(ValueFromRemainingArguments=$true)] [string[]] $CliArguments)
$ErrorActionPreference='Stop'
$runtimeHome=if($env:USERPROFILE){$env:USERPROFILE}else{[Environment]::GetFolderPath('UserProfile')}
$toolRoot=Join-Path $runtimeHome '.agents-tools/opencode-v1'
$cli=Join-Path $toolRoot 'opencode.ps1'
$verifyExisting=$false
if (-not (Test-Path -LiteralPath $cli -PathType Leaf)) {
 $existing=Get-Command opencode.ps1,opencode -ErrorAction SilentlyContinue | Where-Object { $_.CommandType -in @('Application','ExternalScript') -and $_.Source -ne $PSCommandPath } | Select-Object -First 1
 if (-not $existing) { throw 'Worker CLI missing. Install opencode-ai@1.18.34 only with explicit authorization, or provide an existing verified V1 CLI.' }
 $cli=$existing.Source
 $verifyExisting=$true
}
# V1 must never open the V2 session database or inherit its global integrations.
$saved=@{}
foreach ($key in @('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','XDG_STATE_HOME')) {
 $saved[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
 [Environment]::SetEnvironmentVariable($key,(Join-Path $toolRoot "runtime/$key"),'Process')
}
try {
 if($verifyExisting){
  $existingVersion=[string](@(& $cli --version 2>$null) -join ' ')
  if($LASTEXITCODE -ne 0 -or $existingVersion.Trim() -ne '1.18.34'){throw 'Existing OpenCode CLI is not the verified V1 version 1.18.34; no installation or paid fallback was attempted.'}
 }
 & $cli @CliArguments
 $workerExitCode=$LASTEXITCODE
} finally {
 foreach($key in $saved.Keys){
  if ($null -eq $saved[$key]) { Remove-Item -LiteralPath "Env:$key" -ErrorAction SilentlyContinue }
  else { [Environment]::SetEnvironmentVariable($key,$saved[$key],'Process') }
 }
}
exit $workerExitCode
