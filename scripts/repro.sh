#!/usr/bin/env bash
set -euo pipefail

for p in \
  "**/l10n/gen/**" \
  "test/**" \
  "**/test/**" \
  "{**/l10n/gen/**,**/test/**}" \
  "{**/l10n/gen/**,test/**}"

do
  echo "PATTERN=$p"
  dcm check-unused-l10n . --class-pattern '^AppLocalizations$' --exclude="$p" --reporter=json --no-fatal-unused --no-congratulate \
    | jq '{summary,paths:[.unusedL10nResults[].path]}'
  echo
 done
