#!/usr/bin/env bash
# Viji QA skill — one-command installer.
#
#   curl -fsSL https://raw.githubusercontent.com/umidjon-ziyatdinov/viji-qa/main/install.sh \
#     | VIJI_AGENT_TOKEN="the-token" VIJI_SHEET_WEBHOOK="the-webhook-url" bash
#
# Run WITHOUT the two env vars to install the skill only; it then writes a blank secrets
# file for you to fill in. This script contains NO secrets.
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/viji-qa"
REPO="https://github.com/umidjon-ziyatdinov/viji-qa.git"
SECRETS="$HOME/.config/viji-qa/secrets.sh"

say() { printf '  %s\n' "$1"; }
echo "Installing the Viji QA skill…"

# 1. Prerequisite: git
if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required but not installed."
  echo "  macOS:   xcode-select --install"
  echo "  Windows: install Git for Windows (https://git-scm.com/download/win)"
  echo "  Linux:   sudo apt install git   (or your package manager)"
  exit 1
fi

# 2. Install or update the skill
if [ -d "$SKILL_DIR/.git" ]; then
  say "Updating existing install…"
  git -C "$SKILL_DIR" pull --quiet --ff-only || git -C "$SKILL_DIR" pull --quiet
else
  mkdir -p "$(dirname "$SKILL_DIR")"
  git clone --quiet "$REPO" "$SKILL_DIR"
fi
say "Skill installed at $SKILL_DIR"

# 3. Secrets (from env vars if provided; never stored in the repo)
mkdir -p "$(dirname "$SECRETS")"
if [ -n "${VIJI_AGENT_TOKEN:-}" ] && [ -n "${VIJI_SHEET_WEBHOOK:-}" ]; then
  cat > "$SECRETS" <<EOF
export VIJI_AGENT_TOKEN="${VIJI_AGENT_TOKEN}"
export VIJI_SHEET_WEBHOOK="${VIJI_SHEET_WEBHOOK}"
EOF
  chmod 600 "$SECRETS"
  say "Secrets written to $SECRETS"
elif [ -f "$SECRETS" ] && grep -q 'VIJI_AGENT_TOKEN="..*"' "$SECRETS"; then
  say "Secrets already present at $SECRETS (left unchanged)"
else
  cat > "$SECRETS" <<'EOF'
export VIJI_AGENT_TOKEN=""
export VIJI_SHEET_WEBHOOK=""
EOF
  chmod 600 "$SECRETS"
  say "No token/webhook provided — edit $SECRETS and paste the two values your team lead sent."
fi

# 4. pandoc (for the Word report; optional)
if command -v pandoc >/dev/null 2>&1; then
  say "pandoc: found"
else
  say "pandoc: NOT found (needed only for the Word report). Install: https://pandoc.org/installing.html"
fi

echo ""
echo "Done. Now FULLY QUIT and REOPEN Claude Code, then run:"
echo "    /viji-qa book a padel court and pay by card"
