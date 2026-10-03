[CmdletBinding()]
param([Parameter(ValueFromRemainingArguments=$true)] [string[]] $CliArguments)
$ErrorActionPreference='Stop'
$runtimeHome=if($env:USERPROFILE){$env:USERPROFILE}else{[Environment]::GetFolderPath('UserProfile')}
$toolRoot=Join-Path $runtimeHome '.agents-tools/opencode-v1'
$cli=Join-Path $toolRoot 'opencode.ps1'
if (-not (Test-Path -LiteralPath $cli -PathType Leaf)) { throw 'Pinned worker CLI missing. Install opencode-ai@1.18.34 in ~/.agents-tools/opencode-v1 with explicit authorization.' }
# V1 must never open the V2 session database or inherit its global integrations.
$saved=@{}
foreach ($key in @('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','XDG_STATE_HOME')) {
 $saved[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
 [Environment]::SetEnvironmentVariable($key,(Join-Path $toolRoot "runtime/$key"),'Process')
}
try {
 & $cli @CliArguments
 $workerExitCode=$LASTEXITCODE
} finally {
 foreach($key in $saved.Keys){
  if ($null -eq $saved[$key]) { Remove-Item -LiteralPath "Env:$key" -ErrorAction SilentlyContinue }
  else { [Environment]::SetEnvironmentVariable($key,$saved[$key],'Process') }
 }
}
exit $workerExitCode
