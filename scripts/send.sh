#!/bin/bash
# send.sh <session> <text...>
# Send one customer message to the live Viji assistant and print its JSON reply:
#   {"conversation_id": <int>, "reply": ["...bot messages..."]}
# Builds valid JSON via python (immune to quoting) and pipes to curl (no temp file).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DIR}/config.sh"

session="${1:?usage: send.sh <session> <text...>}"; shift
text="$*"
python3 -c 'import json,sys; print(json.dumps({"session":sys.argv[1],"text":sys.argv[2]}))' "$session" "$text" \
  | curl -s -X POST "$VIJI_ENDPOINT" \
      -H "Authorization: Bearer $VIJI_AGENT_TOKEN" \
      -H "Content-Type: application/json" \
      --data-binary @-
echo
