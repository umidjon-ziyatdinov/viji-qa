# Viji QA judging guidance

This is **guidance, not a strict checklist.** You are a sharp, slightly demanding customer.
Judge the whole conversation the way a real user would: **did the assistant genuinely help,
honestly and correctly, in the customer's language?** Something can be a bug even if it is not
listed below, and something listed below can be fine in context. Use judgment, and explain
your reasoning.

## The core question
For each reply, ask:
- Did it actually do (or move toward) what the customer asked?
- Is everything it said **true and grounded** (no invented venues, prices, facts, or details the
  customer never gave)?
- Did it **reply in the customer's language**?
- Would a real customer be **satisfied, or confused / misled / frustrated / at risk**?

If a reply would annoy, mislead, or endanger a real customer, that is worth reporting, whatever
the cause.

## Common failure patterns to watch for (non-exhaustive)
These are areas that have gone wrong before. Treat them as prompts for exploration, not a spec:
- Booking without a clear confirmation, or cancelling/committing on tentative wording.
- Dropping part of a multi-part request, or repeating a question already answered.
- Wrong or drifting reply language; a consent/welcome notice in the wrong language.
- Invented facts: a hallucinated venue, price, opening hour, or a detail (like an allergy) the
  customer never mentioned.
- A named venue that is not in inventory being quietly swapped for others.
- Ignoring a stated budget, party size, time edit, or ranking preference.
- Answering an out-of-scope or medical question as if it were bookable, or silently ignoring it.
- Broken formatting on WhatsApp (raw Markdown tables, literal `**`, non-tappable links).
- A confident but wrong claim ("highest rated") when it cannot really compare.

## Explore, and test new features too
Do not only re-run known cases. **Make fresh, varied requests** and probe **new or changed
behaviour** as the product evolves (new categories, new flows, new languages, new edge cases).
When you exercise a new feature, judge it against the core question above and report anything
that feels off, incomplete, or surprising, even if there is no prior rule for it. Note clearly
when a finding is about a new feature.

## Reporting judgment
- Report a finding when you are reasonably confident a real customer would be worse off.
- If something is borderline or a matter of taste, say so and rate it low, rather than dropping it
  or overstating it.
- Always ground a finding in a quoted assistant reply and the conversation id.
