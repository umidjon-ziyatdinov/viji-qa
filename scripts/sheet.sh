#!/bin/bash
# sheet.sh history              -> print the shared sheet as JSON:
#                                  {"findings":[...], "testlog":[...], "next_case_no":N}
#                                  findings -> dedup bugs; testlog -> cases already run + next case #.
# sheet.sh append <file.json>   -> append NEW findings.  File: {"rows":[ {finding}, ... ]}
# sheet.sh logcases <file.json> -> append RUN cases to the Test log. File: {"cases":[ {case}, ... ]}
# All use the shared Apps Script Web App URL (VIJI_SHEET_WEBHOOK). No per-user Google login.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DIR}/config.sh"

if [ "${VIJI_SHEET_WEBHOOK}" = "PASTE_YOUR_APPS_SCRIPT_EXEC_URL_HERE" ] || [ -z "${VIJI_SHEET_WEBHOOK}" ]; then
  echo '{"error":"VIJI_SHEET_WEBHOOK is not set. See setup/WEBHOOK-SETUP.md and paste the /exec URL into your local secrets file."}'
  exit 0
fi

cmd="${1:?usage: sheet.sh history | append <file.json> | logcases <file.json>}"
case "$cmd" in
  history)
    curl -sL "$VIJI_SHEET_WEBHOOK" ;;
  append|logcases)
    file="${2:?usage: sheet.sh $cmd <file.json>}"
    curl -sL -X POST "$VIJI_SHEET_WEBHOOK" -H "Content-Type: application/json" --data-binary @"$file" ;;
  *)
    echo "unknown command: $cmd" >&2; exit 1 ;;
esac
echo
