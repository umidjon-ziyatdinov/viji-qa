#!/bin/bash
# sheet.sh history            -> print existing findings from the shared sheet (JSON)
# sheet.sh append <file.json> -> append findings (a JSON file with {"rows":[...]}) to the sheet
# Both use the shared Apps Script Web App URL (VIJI_SHEET_WEBHOOK). No per-user Google login.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DIR}/config.sh"

if [ "${VIJI_SHEET_WEBHOOK}" = "PASTE_YOUR_APPS_SCRIPT_EXEC_URL_HERE" ] || [ -z "${VIJI_SHEET_WEBHOOK}" ]; then
  echo '{"error":"VIJI_SHEET_WEBHOOK is not set. See setup/WEBHOOK-SETUP.md and paste the /exec URL into scripts/config.sh."}'
  exit 0
fi

cmd="${1:?usage: sheet.sh history | append <file.json>}"
case "$cmd" in
  history)
    # doGet returns {"findings":[{title, area, severity, conversation, status}, ...]}
    curl -sL "$VIJI_SHEET_WEBHOOK" ;;
  append)
    file="${2:?usage: sheet.sh append <file.json>}"
    curl -sL -X POST "$VIJI_SHEET_WEBHOOK" -H "Content-Type: application/json" --data-binary @"$file" ;;
  *)
    echo "unknown command: $cmd" >&2; exit 1 ;;
esac
echo
