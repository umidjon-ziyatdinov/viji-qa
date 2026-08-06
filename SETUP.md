# One-time setup (each team member, about 1 minute)

After you clone the skill (see README), it needs two values that are deliberately NOT in this
public repo: a test token and the findings-sheet webhook. Your team lead will send you these
two lines.

## Set them once
Paste the block your team lead gives you into your terminal (it looks like this, with the
real values filled in):

```bash
mkdir -p ~/.config/viji-qa
cat > ~/.config/viji-qa/secrets.sh <<'EOF'
export VIJI_AGENT_TOKEN="the-token-your-lead-sends"
export VIJI_SHEET_WEBHOOK="https://script.google.com/macros/s/XXXX/exec"
EOF
```

That's it. The plugin reads this file automatically on every run. You never edit anything
in the plugin itself, and updates (`/plugin update viji-qa`) never touch your secrets.

## Then use it
In Claude Code:
```
/viji-qa                                  # 3 varied scenarios
/viji-qa book a padel court and pay by card    # test a specific request
```

## Notes
- The token only reaches reserved test numbers; it can never message a real customer or read
  customer data. It is revocable at any time.
- `pandoc` is required for the Word report: https://pandoc.org/installing.html
- If a run says "Not configured yet", the secrets file is missing or misnamed. Re-run the
  block above.
