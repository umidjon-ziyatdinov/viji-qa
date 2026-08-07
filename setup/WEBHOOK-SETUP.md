# Webhook setup (one time, ~5 minutes)

This connects the plugin to your shared findings sheet. Do it once. Every team member's
runs then feed the same sheet, with no personal Google login.

## 1. Create the shared sheet
Create a Google Sheet named **Viji QA Findings** (or reuse an existing one). This is the
single source of truth the team collaborates on. Do NOT use the client's curated bug
tracker for this; keep the agent's output separate.

The script creates two tabs automatically on first use: **Findings** (bugs only, which the
team triages) and **Test log** (one row per case run, so planning avoids repeats and everyone
sees collective coverage). You do not need to create the tabs by hand.

## 2. Add the bound Apps Script
1. In that sheet, open **Extensions > Apps Script**. (Opening it from the sheet is what makes
   the script *bound* to it. A standalone script will not work.)
2. Delete any default code, then paste the entire contents of **`apps-script.gs`** (in this
   folder).
3. Save (the disk icon).

## 3. Deploy as a Web App
1. Click **Deploy > New deployment**.
2. Gear icon > **Web app**.
3. Set:
   - **Execute as:** Me
   - **Who has access:** Anyone
4. **Deploy**, authorise when prompted, and **copy the Web app URL** (it ends in `/exec`).

## 4. Send the webhook to the team (do NOT commit it)
This repo is public, so the webhook and token are NOT stored in it. Send each team member the
two-line secrets block from `SETUP.md`, with the real values filled in:
```
export VIJI_AGENT_TOKEN="the-test-token"
export VIJI_SHEET_WEBHOOK="https://script.google.com/macros/s/XXXX/exec"   # the /exec URL from step 3
```
They paste it once into `~/.config/viji-qa/secrets.sh` (see `SETUP.md`). Send it privately
(WhatsApp/email/1Password), never in a public channel or a commit.

## 5. Share the sheet with the team
Share the Google Sheet with each team member (Editor) so they can triage, set Status/Owner,
add Notes, and log their own findings alongside the agent's.

## 6. Verify
From this folder:
```
bash scripts/sheet.sh history
```
You should get `{"findings":[],"testlog":[],"next_case_no":1}` (empty at first). If you see a "not configured" message,
re-check step 4. If you get a Google login page, re-check "Who has access: Anyone" in step 3.

## Notes
- If you ever change the Apps Script code, redeploy with **Deploy > Manage deployments >
  (edit) > Version: New version** to keep the same `/exec` URL.
- The webhook URL is a shared write endpoint. Keep this repository private.
