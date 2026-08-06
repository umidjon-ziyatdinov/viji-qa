# Viji QA skill

A Claude Code **skill** that QA-tests the Viji WhatsApp booking assistant as a real customer. It
holds real conversations with the live bot, judges the experience, skips bugs already logged, writes
a Word report, and appends new findings to the team's shared Google Sheet.

Works anywhere Claude Code runs (desktop app, CLI, IDE). No plugin marketplace, no `/plugin`.

## Install (each team member, once)
Clone this repo into your Claude Code skills folder:
```
git clone https://github.com/umidjon-ziyatdinov/viji-qa.git ~/.claude/skills/viji-qa
```
Then do the one-time secrets setup in [`SETUP.md`](SETUP.md): paste the two lines your team lead
sends (a test token and the sheet webhook) into a local file. Nothing secret lives in this repo.

Restart Claude Code so it picks up the new skill.

## Update
```
cd ~/.claude/skills/viji-qa && git pull
```

## Use
Just ask, or type `/viji-qa`, followed by what you want to test:
```
/viji-qa                                        # 3 varied scenarios
/viji-qa book a padel court and pay by card     # test a specific request
/viji-qa try the new grocery delivery flow      # probe a NEW feature
/viji-qa customer writes in Arabic then English # test a behaviour
/viji-qa 5                                       # 5 varied scenarios
```
You can also drop a `./qa-scenarios.md` file in your working folder listing your own use-cases; the
skill runs those too.

Each run:
1. Reads existing findings from the shared sheet (so it does not re-report known bugs).
2. Holds real conversations for whatever you asked, exploring edge cases, from the customer's side.
3. Judges with its own judgment (guided by `rules/viji-rules.md`, not a rigid checklist), including new features.
4. Writes `./viji-qa-findings/<date>.md` and `<date>.docx` (needs `pandoc`).
5. Appends only the NEW findings to the shared Google Sheet, which the team collaborates on.

## Collaboration
The shared Google Sheet is the single source of truth. The skill appends new findings; the team
reviews them, sets **Status / Owner / Notes**, and adds their own manually-found bugs as rows.

## Maintainer setup (once)
Create the shared sheet and deploy the Apps Script webhook: [`setup/WEBHOOK-SETUP.md`](setup/WEBHOOK-SETUP.md),
then send the team the two-line secrets block from [`SETUP.md`](SETUP.md).

## Safety
- The token authenticates only the agent-chat endpoint and only reaches reserved `+1000000` test
  numbers. It can never message a real customer or read customer data. Revocable.
- No secrets are stored in this repo. Token and webhook live only in each user's local
  `~/.config/viji-qa/secrets.sh`.
- `pandoc` is required for the Word report: https://pandoc.org/installing.html
