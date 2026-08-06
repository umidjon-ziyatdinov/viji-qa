# Viji QA plugin

An autonomous QA agent for the Viji WhatsApp booking assistant, packaged as a Claude Code
plugin. It simulates real customer conversations against the live assistant, judges the
replies against the product's expected behaviour, skips anything already logged, and reports
a Word document plus rows in the team's shared Google Sheet.

Runs in **Claude Code** (desktop app, CLI, or IDE extension). It does not run in the regular
Claude web chat.

## Install (each team member, once)
This repo is public, so there is no GitHub account or collaborator invite needed. In Claude Code:
```
/plugin marketplace add umidjon-ziyatdinov/viji-qa-plugin
/plugin install viji-qa@viji-qa
```
Then do the **one-time setup** in [`SETUP.md`](SETUP.md): paste the two lines your team lead sends
(a test token and the sheet webhook) into a local file. Nothing secret lives in this repo.

## Update (each team member)
```
/plugin update viji-qa
```
Or enable auto-update: run `/plugin`, open **Marketplaces**, select this one, toggle
auto-update on. Then updates arrive automatically when the maintainer pushes.

## Use
Make requests however you like:
```
/viji-qa                                  # 3 varied scenarios, agent's choice
/viji-qa 5                                # 5 varied scenarios
/viji-qa book a padel court and pay by card    # test a specific request as a customer
/viji-qa try the new grocery delivery flow     # probe a NEW feature
/viji-qa stress-test Arabic voice-note phrasing
```
You can also drop a `./qa-scenarios.md` file in your working folder listing your own use-cases,
and the agent will run those too.

Each run:
1. Reads the existing findings from the shared sheet (so it does not re-report known bugs).
2. Holds real conversations for whatever you asked (yours, or auto), exploring freely.
3. Judges the conversation with its own judgment (guided by `plugin/rules/viji-rules.md`, not a
   rigid checklist), and validates new features too.
4. Writes `./viji-qa-findings/<date>.md` and `<date>.docx` (needs `pandoc`).
5. Appends only the NEW findings to the shared Google Sheet, which the team collaborates on.

## Collaboration
The shared Google Sheet is the single source of truth. The agent appends new findings; the
team reviews them, sets **Status / Owner / Notes**, and adds their own manually-found bugs as
rows. Everyone's runs feed the same sheet.

## Add your own test cases and tune behaviour
- Add use cases: create `./qa-scenarios.md` in your working folder and describe scenarios; the
  agent will run them alongside the ones it generates.
- Tune what counts as a bug: the judging reference is `plugin/rules/viji-rules.md`. To change it
  for everyone, edit that file and push (it updates with the plugin). To change it just for
  yourself, keep a `./qa-rules.md` in your working folder and mention it when you run.

## Setup (maintainer, once)
1. Create the shared sheet and deploy the Apps Script: [`setup/WEBHOOK-SETUP.md`](setup/WEBHOOK-SETUP.md).
2. Send the team the two-line secrets block (token + `/exec` webhook) from [`SETUP.md`](SETUP.md).
   These are NOT committed to this public repo.

## Safety
- The test token authenticates only the agent-chat endpoint and only reaches reserved
  `+1000000` test numbers. It can never message a real customer or read customer data. Revocable.
- No secrets are stored in this repository. The token and webhook live only in each user's local
  `~/.config/viji-qa/secrets.sh`.
- `pandoc` is required for the Word report: https://pandoc.org/installing.html
