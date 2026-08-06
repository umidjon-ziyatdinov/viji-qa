#!/bin/bash
# Public-safe configuration. NO secrets live in this repository.
#
# The token and the sheet webhook are provided by each user ONCE via a local
# secrets file that is never committed (see SETUP.md). This file only holds
# non-secret defaults and loads the local secrets if present.

# Load local secrets (default location; override with VIJI_QA_SECRETS).
_viji_secrets="${VIJI_QA_SECRETS:-$HOME/.config/viji-qa/secrets.sh}"
[ -f "$_viji_secrets" ] && source "$_viji_secrets"

# --- Non-secret defaults (safe to be public) ---
# The live assistant's agent-chat endpoint. It hashes each session to a reserved
# whatsapp:+1000000... TEST number, so it can NEVER message a real customer, and it
# does nothing without a valid token (which is NOT in this repo).
export VIJI_ENDPOINT="${VIJI_ENDPOINT:-https://admin.askviji.ai/admin/agent-chat}"
# Human link to the shared findings sheet (access is controlled by Google sharing).
export VIJI_SHEET_URL="${VIJI_SHEET_URL:-https://docs.google.com/spreadsheets/d/1zrfGxOyQTTv4fDcx2nWwS4_5J9_ubMSLqAKs0WVBRvE/edit}"

# --- Secrets (MUST come from the local secrets file; never committed) ---
export VIJI_AGENT_TOKEN="${VIJI_AGENT_TOKEN:-}"
export VIJI_SHEET_WEBHOOK="${VIJI_SHEET_WEBHOOK:-}"

if [ -z "${VIJI_AGENT_TOKEN}" ]; then
  echo "[viji-qa] Not configured yet. Do the one-time setup in the plugin's SETUP.md." >&2
fi
