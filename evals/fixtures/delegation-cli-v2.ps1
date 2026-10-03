# V2 must be rejected before model discovery or inference until scoped config is supported.
if ($args[0] -eq '--version') { 'opencode v2.0.15'; exit 0 }
throw 'V2 bridge attempted discovery or inference without verified scoped configuration.'
