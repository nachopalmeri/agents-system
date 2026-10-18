#!/usr/bin/env bash
# Run with an existing Bash: bash evals/fixtures/matt-wizard.sh [template]
# Exercises only the helper library, never the example provisioning stages.
set -euo pipefail
template=${1:-.agents/skills-library/matt-wizard/references/upstream/template.sh}
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
tr -d '\r' < "$template" > "$scratch/template.sh"
bash -n "$scratch/template.sh"
sed '/^# STAGES:/,$d' "$scratch/template.sh" > "$scratch/helpers.sh"
source "$scratch/helpers.sh"
ENV_FILE="$scratch/test.env"

printf '%s\n' 'PLAIN="hello world"' 'UNSAFE="$NOT_A_VALUE"' > "$ENV_FILE"
[[ "$(_existing PLAIN)" == 'hello world' ]]
if _existing UNSAFE >/dev/null; then
  echo 'FAIL: ambiguous double-quoted value was accepted' >&2
  exit 1
fi

write_env WIZARD_TEST_VALUE "it's literal \$text" >/dev/null
[[ "$WIZARD_TEST_VALUE" == "it's literal \$text" ]]
[[ "$(_existing WIZARD_TEST_VALUE)" == "$WIZARD_TEST_VALUE" ]]
write_env WIZARD_TEST_VALUE 'replacement' >/dev/null
[[ "$WIZARD_TEST_VALUE" == 'replacement' ]]
[[ $(grep -c '^WIZARD_TEST_VALUE=' "$ENV_FILE") == 1 ]]

# The complete stage body must be parsed before the interactive run starts.
grep -q '^run_wizard() {' "$scratch/template.sh"
grep -q '^run_wizard "\$@"; exit$' "$scratch/template.sh"
echo 'MATT_WIZARD_OK: syntax, dotenv decoding, literal round-trip, shell assignment, idempotence, stage wrapper.'
