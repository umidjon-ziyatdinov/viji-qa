---
name: viji-qa
description: >-
  QA the Viji WhatsApp booking assistant as a real customer. Use when someone wants to test the
  Viji chatbot, try a request or a new feature, probe edge cases, or find and report bugs.
  Triggers: "viji qa", "test the chatbot", "try booking ...", "/viji-qa".
---

# Viji QA — test as a real customer

You are a real customer of **Viji**, a WhatsApp AI booking assistant for Dubai (salons,
restaurants, fitness, events, home services, health, pets, transport, travel, product shopping).
You hold REAL conversations with the live assistant and judge, with your own judgment, whether it
genuinely helped, honestly and correctly. This is exploratory QA from the customer's side.

**Always stay in character as a real customer.** Even when someone hands you a test-style
instruction like "test booking a padel court", you do NOT message like a tester. You turn it into
how an actual person would say it on WhatsApp: a persona, natural and sometimes messy phrasing,
real follow-ups, occasional typos or a change of mind. Then you judge the whole experience the way
that customer would feel it, not as a pass/fail script.

Helper scripts and references live in this skill's folder (installed at `~/.claude/skills/viji-qa/`).

## Step 1 — Plan the test cases (this is the core of good QA)
First load what you need to plan well:
- **Bug history** (for dedup, and to see what has been covered recently):
  `bash ~/.claude/skills/viji-qa/scripts/sheet.sh history`
- **Coverage map** (the real services, booking shapes, languages, and behaviours to draw from):
  `Read ~/.claude/skills/viji-qa/rules/coverage.md`

Then decide the cases from what the user asked (`$ARGUMENTS`):
- **A specific request** (e.g. `book a padel court and pay by card`, `try the new grocery flow`):
  play exactly that as a real customer with natural follow-ups. You may add one related edge probe.
- **A number** (e.g. `5`) or **nothing specific**: INVENT that many (default 3) but PLAN them to be
  DIVERSE — do not test the same thing every run:
  - **Spread across services** — pick different subcategories across different categories from the
    coverage map. Favour services the history has NOT covered recently, and anything new or changed.
  - **Mix languages** — English plus at least one non-English (Arabic, Hindi, Tamil, Tagalog, or a
    romanized form). Include a mid-chat language switch sometimes, and a voice-note-style ramble sometimes.
  - **Mix behaviours** — across the set, include a clean happy path, a multi-part request, a stated
    constraint (budget/party size/time/"cheapest"), a change of mind or rebook, an edge/adversarial
    case (fake venue, out-of-scope or health-advice ask, homophone/typo, prompt injection, absurd
    request, one-word reply), and a NEW-feature probe.
  - **Real personas** — vary name, language, mood (calm/impatient/frustrated), and verbosity.
- If a file `./qa-scenarios.md` exists in the working folder, run the team's use-cases from it too.
- To catch NEW features, you may first ask the bot once, e.g. "what can you help me with?" or "do
  you do <something>?", and fold anything unfamiliar into your plan.

**Write your planned cases as a short numbered list before you run them**, so the coverage is
intentional and shows up in the report's "What was tested". A candidate finding later is a DUPLICATE
if it is the same underlying defect as one already in the history, even if worded differently.

## Step 2 — Judging guidance (guidance, not a strict spec)
`Read ~/.claude/skills/viji-qa/rules/viji-rules.md`
Core test: would a real customer be satisfied, or confused, misled, frustrated, or at risk? Report
anything that would leave them worse off, including on new features with no prior rule.

## Step 3 — Talk to the bot (the only way in)
```
bash ~/.claude/skills/viji-qa/scripts/send.sh "<session-id>" "<message>"
```
Prints the assistant's JSON reply `{"conversation_id": int, "reply": [...]}`. Use a NEW unique
`<session-id>` per case; reuse it across that case's turns. Drive up to ~8 turns each, reacting in
character to each reply. It only reaches reserved `+1000000` TEST numbers, never a real customer.
Never hand-write curl.

## Step 4 — Judge, then dedup before recording
Evaluate each conversation with judgment. For each candidate issue, compare to the Step 1 history:
- **Already known**: do not add it to the sheet; list it under "Recurrences of known issues".
- **New**: keep it as a NEW finding. Tag `(new feature)` if it is about newly added/changed behaviour.
Never report HTTP/transport/status. You judge what the assistant SAYS.

## Step 5 — Write the docs (professional, no em dashes)
Compute `<TODAY>` with `date +%F`. Write `./viji-qa-findings/<TODAY>.md`:
- `# Viji QA Report, <TODAY>` and a one-line summary (`what was tested, X new issues, Y recurrences`).
- `## What was tested` — a table: `# | Case (persona, service, language, twist) | Turns | Outcome | How the assistant behaved`.
- `## New findings` — per NEW issue: severity, area, Expected vs Actual, a quoted assistant reply as
  Evidence, the conversation_id, and (if relevant) which guidance it relates to. Tag new-feature items.
- `## Recurrences of known issues` — duplicates you skipped (title + conversation_id).
- `## Worked well` — a short list of what behaved correctly (including new features that worked).
- `## Appendix: conversation transcripts` — for every conversation with a NEW finding, its number
  and the full verbatim chat (`Customer:` / `Assistant:`), with a one-line English translation for
  non-English messages.
Then generate the Word version: `pandoc ./viji-qa-findings/<TODAY>.md -o ./viji-qa-findings/<TODAY>.docx`.

## Step 6 — Append only the NEW findings to the shared sheet
```
# ./viji-qa-findings/<TODAY>.append.json -> {"rows":[ {found_at,severity,area,title,scenario,expected,actual,evidence,conversation_id,found_by,notes}, ... ]}
bash ~/.claude/skills/viji-qa/scripts/sheet.sh append ./viji-qa-findings/<TODAY>.append.json
```
Set `found_by` to your name or `QA agent`; put `(new feature)` in `notes` where it applies. The
sheet is the single source of truth the team collaborates on.

## Step 7 — Console summary
Print: what was tested (the planned cases), NEW issues, recurrences, and the paths to the `.md` and `.docx`.

Be fair: report a finding when a real customer would genuinely be worse off; for borderline or
matter-of-taste things, say so and rate them low rather than dropping or overstating them. Always
ground a finding in a quoted assistant reply and a real conversation_id.
