#!/usr/bin/env pwsh
[CmdletBinding()] param([Parameter(Mandatory=$true)][string]$ResultPath)
$ErrorActionPreference='Stop'; $raw=Get-Content -LiteralPath $ResultPath -Raw -Encoding UTF8 | ConvertFrom-Json
$s=([string]$raw.status).ToLowerInvariant(); $status='BLOCKED'; $retryable=$false
switch -Regex ($s) { '^success$|^completed$' {$status='SUCCESS'} '^refusal$|^provider_refusal$|^safety' {$status='PROVIDER_REFUSAL'} '^rate[_ -]?limit' {$status='RATE_LIMITED';$retryable=$true} '^needs[_ -]?user$' {$status='NEEDS_USER'} '^retry$|^timeout$|^unavailable$' {$status='BLOCKED';$retryable=$true} }
$msg=if($raw.message){[string]$raw.message}else{if($raw.errorCode){[string]$raw.errorCode}else{$status}}
if($msg.Length -gt 240){$msg=$msg.Substring(0,240)}
[ordered]@{status=$status;provider=if($raw.provider){[string]$raw.provider}else{'unknown'};code=if($raw.errorCode){[string]$raw.errorCode}else{$status.ToLowerInvariant()};message=$msg;retryable=$retryable;retryAfterSeconds=if($raw.retryAfterSeconds){[int]$raw.retryAfterSeconds}else{0}} | ConvertTo-Json -Depth 8
