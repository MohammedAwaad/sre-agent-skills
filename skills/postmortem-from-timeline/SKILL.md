---
name: postmortem-from-timeline
description: Turn raw incident material (chat export, timeline notes, alert history, ticket comments) into a blameless postmortem draft with impact, timeline, contributing factors and owned action items. Use when the user asks to write, draft or structure a postmortem, incident review, RCA or incident report.
---

# Postmortem from timeline

Produce a blameless postmortem **draft** from whatever incident material the user provides. The draft is for humans to review; never present guesses as facts.

## Inputs

Ask for anything missing that you cannot infer, in one short message:

* The raw material: chat log, timeline notes, alert history, tickets.
* Severity and the service or product affected, if not obvious.
* The time zone used in the material (convert everything to UTC).

## Steps

1. **Build the timeline first.** Extract every timestamped event. Normalise to UTC, sort, and keep only events that matter: first impact, detection, declaration, key findings, decisions, mitigation, resolution. Quote the source wording for decisions.
2. **Compute the key durations** from the timeline: time to detect (impact start to alert), time to mitigate, total duration. Show the arithmetic.
3. **Describe impact** in user terms: who, how long, how much. If numbers are not in the material, write `TODO: confirm` instead of estimating.
4. **Contributing factors, not a single root cause.** List the technical cause and the conditions that allowed it or made it worse (missing check, timing, alert gap, unclear ownership). Use "the system allowed", never "X forgot" or "X failed to".
5. **Detection:** how it was found, how it could have been found sooner.
6. **What went well, what went poorly, where we got lucky.** At least one item each when the material supports it.
7. **Action items.** Each one: action, type (Prevent / Detect / Mitigate / Process), owner, due date. Leave owner and date as `TODO` when unknown. Every contributing factor should map to at least one action, or say why not.

## Output format

Use this structure exactly:

```markdown
# Postmortem: <title>

**Status:** Draft
**Date of incident:** YYYY-MM-DD
**Severity:** SEV<n>

## Summary
## Impact
## Timeline (UTC)
| Time | Event |
## Contributing factors
## Detection
## What went well
## What went poorly
## Where we got lucky
## Action items
| Action | Type | Owner | Due |
## Open questions
```

## Rules

* **Blameless language.** Describe actions and system conditions, not people's failings. Names appear only as roles (on call engineer, incident commander) unless the user asks otherwise.
* **No invented facts.** Anything not in the material is `TODO: confirm` and listed under Open questions.
* **Keep secrets out.** If the material contains tokens, passwords, customer personal data or internal hostnames the user may not want in a shared document, point them out and redact them in the draft.
* Keep the summary to five sentences or fewer.
