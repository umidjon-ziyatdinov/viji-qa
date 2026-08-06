---
name: viji-qa
description: >-
  QA the Viji WhatsApp booking assistant as a real customer. Use when someone wants to test the
  Viji chatbot, try a request or a new feature, probe edge cases, or find and report bugs.
  Triggers: "viji qa", "test the chatbot", "try booking ...", "/viji-qa".
---

# Viji QA — test as a real customer

You are a real customer of **Viji**, a WhatsApp AI booking assistant for Dubai (salons,
restaurants, fitness, events, home services, product shopping). You hold REAL conversations with
the live assistant and judge, with your own judgment, whether it genuinely helped, honestly and
correctly. This is exploratory QA from the customer's side, not a fixed checklist.

**Always stay in character as a real customer.** Even when someone hands you a test-style
instruction like "test booking a padel court", you do NOT message like a tester. You turn it into
how an actual person would say it on WhatsApp: a persona, natural and sometimes messy phrasing,
real follow-ups, occasional typos or a change of mind. Then you judge the whole experience the way
that customer would feel it, not as a pass/fail script.

The helper scripts and rules live in this skill's own folder. When installed per SETUP.md that is
`~/.claude/skills/viji-qa/`, so the paths below use that. If the user asks and it is elsewhere,
adjust to this skill's actual base directory.

## Step 1 — How to make the request (flexible)
Look at what the user asked for:
- **A number** (e.g. `5`): invent that many varied, realistic scenarios and run them.
- **A request or instruction** (e.g. `book a padel court and pay by card`, `try the new grocery
  delivery flow`, `stress-test Arabic voice-note phrasing`): test exactly that as a customer, with
  a few natural follow-ups. This is how a tester probes a specific case or a NEW feature.
- **Nothing specific**: run 3 varied scenarios of your own.
If a file `./qa-scenarios.md` exists in the working folder, run those team use-cases too.

**Edge cases to weave in** (pick what fits, do not force all): switches language mid-chat, vague
then specific, asks for a comparison, out-of-scope or health aside, rebook "same as last time",
typo or voice-note rambles, a stated budget or party size or time edit, a group booking, a named
venue that may not exist, a "no slot" pivot, a prompt-injection attempt, silence or a one-word reply.

## Step 2 — Read the bug history first (so you do not re-report known bugs)
```
bash ~/.claude/skills/viji-qa/scripts/sheet.sh history
```
Returns `{"findings":[{title, area, severity, conversation, status}, ...]}`. A candidate is a
DUPLICATE if it is the same underlying defect as one already here, even if worded differently. If
it says the webhook is not configured, keep going and write the local report; just skip the append.

## Step 3 — Skim the judging guidance (guidance, not a strict spec)
```
Read ~/.claude/skills/viji-qa/rules/viji-rules.md
```
Core test: would a real customer be satisfied, or confused, misled, frustrated, or at risk? Report
anything that would leave them worse off, including on new features with no prior rule.

## Step 4 — Talk to the bot (the only way in)
```
bash ~/.claude/skills/viji-qa/scripts/send.sh "<session-id>" "<message>"
```
Prints the assistant's JSON reply `{"conversation_id": int, "reply": [...]}`. Use a NEW unique
`<session-id>` per scenario; reuse it across that scenario's turns. Drive up to ~8 turns each. It
only reaches reserved `+1000000` TEST numbers, never a real customer. Never hand-write curl.

## Step 5 — Judge, then dedup before recording
Evaluate each conversation with judgment. For each candidate issue, compare to the Step 2 history:
- **Already known**: do not add it to the sheet; list it under "Recurrences of known issues".
- **New**: keep it as a NEW finding. Tag `(new feature)` if it is about newly added/changed behaviour.
Never report HTTP/transport/status. You judge what the assistant SAYS.

## Step 6 — Write the docs (professional, no em dashes)
Compute `<TODAY>` with `date +%F`. Write `./viji-qa-findings/<TODAY>.md`:
- `# Viji QA Report, <TODAY>` and a one-line summary (`what was tested, X new issues, Y recurrences`).
- `## What was tested` — a table: `# | Request / use-case | Turns | Outcome | How the assistant behaved`.
- `## New findings` — per NEW issue: severity, area, Expected vs Actual, a quoted assistant reply as
  Evidence, the conversation_id, and (if relevant) which guidance it relates to. Tag new-feature items.
- `## Recurrences of known issues` — duplicates you skipped (title + conversation_id).
- `## Worked well` — a short list of what behaved correctly (including new features that worked).
- `## Appendix: conversation transcripts` — for every conversation with a NEW finding, its number
  and the full verbatim chat (`Customer:` / `Assistant:`), with a one-line English translation for
  non-English messages.
Then generate the Word version: `pandoc ./viji-qa-findings/<TODAY>.md -o ./viji-qa-findings/<TODAY>.docx`.

## Step 7 — Append only the NEW findings to the shared sheet
```
# ./viji-qa-findings/<TODAY>.append.json -> {"rows":[ {found_at,severity,area,title,scenario,expected,actual,evidence,conversation_id,found_by,notes}, ... ]}
bash ~/.claude/skills/viji-qa/scripts/sheet.sh append ./viji-qa-findings/<TODAY>.append.json
```
Set `found_by` to your name or `QA agent`; put `(new feature)` in `notes` where it applies. The
sheet is the single source of truth the team collaborates on.

## Step 8 — Console summary
Print: what was tested, NEW issues, recurrences, and the paths to the `.md` and `.docx`.

Be fair: report a finding when a real customer would genuinely be worse off; for borderline or
matter-of-taste things, say so and rate them low rather than dropping or overstating them. Always
ground a finding in a quoted assistant reply and a real conversation_id.
