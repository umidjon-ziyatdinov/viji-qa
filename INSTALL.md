# Installing the Viji QA agent

The Viji QA agent is a Claude Code **skill**. Once installed, you test the Viji chatbot by typing
`/viji-qa` (or just asking, e.g. "test the Viji chatbot"). It plays a real customer, judges the
conversation, writes a Word report, and logs new bugs to the team's shared sheet.

## Before you start
- **Claude Code** installed (the desktop app is easiest): https://claude.com/claude-code
- Two secret values from your team lead: a **token** and a **sheet webhook URL**. They are not in
  this public repo; your lead sends them privately.
- `git` and `pandoc` on your machine. If either is missing, the self-install prompt below tells you
  the one command to install it.

## Option A — Self-install (easiest, no terminal knowledge needed)
1. Open Claude Code.
2. Paste the setup prompt your team lead sent you (it clones the skill and sets your two secret
   values for you). If you do not have it, ask your lead for the "Viji QA install prompt".
3. When it finishes, **fully quit and reopen Claude Code** so the skill loads.
4. Type `/viji-qa book a padel court and pay by card` to test it.

## Option B — Manual (terminal)
1. Install the skill:
   ```
   git clone https://github.com/umidjon-ziyatdinov/viji-qa.git ~/.claude/skills/viji-qa
   ```
   (If that folder already exists: `cd ~/.claude/skills/viji-qa && git pull`.)
2. Add your two secret values once (your lead sends the real values):
   ```
   mkdir -p ~/.config/viji-qa
   cat > ~/.config/viji-qa/secrets.sh <<'EOF'
   export VIJI_AGENT_TOKEN="the-token-your-lead-sends"
   export VIJI_SHEET_WEBHOOK="the-webhook-url-your-lead-sends"
   EOF
   ```
3. Install pandoc if needed (for the Word report): https://pandoc.org/installing.html
4. **Quit and reopen Claude Code.**

## Using it
Type `/viji-qa` (or ask in plain language) followed by what you want to test:
```
/viji-qa                                      # 3 varied checks
/viji-qa book a padel court and pay by card   # a specific request
/viji-qa try the new grocery delivery flow    # a new feature
/viji-qa 5                                     # five scenarios
```
Each run writes a Word report locally (`viji-qa-findings/<date>.docx`) and adds any new bugs to the
shared sheet. Bugs already logged are skipped.

## Updating later
```
cd ~/.claude/skills/viji-qa && git pull
```
Then reopen Claude Code.

## Troubleshooting
- **`/viji-qa` not recognized:** you did not restart Claude Code after installing. Fully quit and reopen.
- **"Not configured yet":** the secrets file is missing or misnamed. Redo step 2 of Option B.
- **No Word file:** install `pandoc` (the rest still works).
- **`git` not found:** on macOS run `xcode-select --install`; on Windows install Git for Windows;
  on Linux use your package manager (e.g. `sudo apt install git`).
