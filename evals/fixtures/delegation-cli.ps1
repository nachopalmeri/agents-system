if ($args[0] -eq '--version') { '1.16.2'; exit 0 }
# Offline CLI transport fixture; never contacts a provider or edits a workspace.
if ($args[0] -eq 'models') {
    if ($args -notcontains '--pure') { throw 'Model discovery must not load external plugins.' }
    'opencode/muse-spark-1.3-contributor-free'; 'opencode/mimo-v2.6-flash-free'; exit 0
}
$prompt=$args[-1]
if($prompt -match 'fixture refusal'){ @{type='error';error=@{data=@{statusCode=403;message='Fixture provider refusal'}}}|ConvertTo-Json -Depth 5 -Compress; exit 1 }
if($prompt -match 'free-tier policy refusal'){ @{type='error';error=@{data=@{statusCode=400;message="Error from provider (Console): OpenCode's free tier can only be used from within OpenCode."}}}|ConvertTo-Json -Depth 5 -Compress; exit 1 }
$answer=if($prompt -match 'fixture malformed'){'not json'}else{@{state='SUCCESS';summary='Offline fixture';evidence=@();changedFiles=@();uncertainty=@()}|ConvertTo-Json -Compress}
@{type='text';part=@{text='Interim progress, not the final response.'}}|ConvertTo-Json -Depth 5 -Compress
@{type='text';part=@{text=$answer}}|ConvertTo-Json -Depth 5 -Compress
@{type='step_finish';part=@{cost=0;tokens=@{input=10;output=5}}}|ConvertTo-Json -Depth 5 -Compress
exit 0
