#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$workflowPath = Join-Path $root '.agents/workflows/ticket_sessions.md'
if (-not (Test-Path $workflowPath)) { throw 'Ticket/session workflow is missing.' }
$workflow = Get-Content $workflowPath -Raw
foreach ($required in @('small tasks','unresolved decisions','vertical slices','explicit dependencies','explicit authorization','No new chats','No external publication','starting commit','acceptance criteria','file ownership','three workers','depth one','primary','No measured token savings')) {
    if ($workflow -notmatch [regex]::Escape($required)) { throw "Missing workflow contract: $required" }
}
foreach ($name in @('matt-grill-me','matt-to-spec','matt-to-tickets','matt-handoff','matt-implement-spec')) {
    if ($workflow -notmatch [regex]::Escape($name)) { throw "Missing phase routing: $name" }
    $skill = Get-Content (Join-Path $root ".agents/skills-library/$name/SKILL.md") -Raw
    $metadata = Get-Content (Join-Path $root ".agents/skills-library/$name/agents/openai.yaml") -Raw
    if ($skill -notmatch 'disable-model-invocation: true' -or $metadata -notmatch 'allow_implicit_invocation: false') { throw "Implicit preload enabled: $name" }
}
foreach ($path in @('.agents/AGENTS.md','.agents/workflows/index.md')) {
    if ((Get-Content (Join-Path $root $path) -Raw) -notmatch 'workflows/ticket_sessions\.md') { throw "Missing default route in $path" }
}
$compatibility = Get-Content (Join-Path $root '.agents/rules/matt-skills.md') -Raw
if ($compatibility -notmatch 'ticket_sessions\.md') { throw 'Matt compatibility policy does not recognize the selected phase workflow.' }
$guide = Get-Content (Join-Path $root 'docs/ticket-session-workflow.md') -Raw
foreach ($required in @('only unresolved decisions','reuse existing approved decisions','explicit authorization','Otherwise prepare a handoff','small, trivial, or tightly coupled','does not guarantee')) {
    if ($guide -notmatch [regex]::Escape($required)) { throw "Missing user guide safeguard: $required" }
}
foreach ($gate in @('Present the breakdown for approval','Obtain approval','This global preference is not that authorization')) {
    if ($workflow -notmatch [regex]::Escape($gate)) { throw "Missing approval gate: $gate" }
}
'TICKET_SESSION_CONTRACT_OK'
exit 0
