---
name: incident-status-update
description: Write a clear incident status update for stakeholders or customers from the current incident state. Produces a consistent, scannable update with impact, status, what is known, what is being done and when the next update comes. Use when the user asks for an incident update, status page message, stakeholder update or customer communication during an outage.
---

# Incident status update

Write the update someone reads in fifteen seconds and understands without any other context.

## Inputs

* Current state: what is broken, who is affected, what has been found, what is being done.
* Audience: **internal** (engineers and stakeholders) or **external** (customers, status page). Ask if unclear; the two differ a lot.
* Update number and time of the next update, if the team has a cadence.

## Format: internal

```
[SEV<n>] <short title>  |  Update #<n>  |  <HH:MM> UTC

Impact:      <who is affected and how, in plain words>
Status:      Investigating / Identified / Mitigating / Monitoring / Resolved
What we know: <one to three sentences, facts only>
What we are doing: <current action and owner>
Next update: <HH:MM> UTC, or sooner if anything changes
```

## Format: external

```
<Title in customer terms>

<Status word>: <one or two sentences on what customers experience and what we are doing>.
<If relevant: what customers can do in the meantime.>
Next update by <HH:MM> UTC.
```

## Rules

* **Facts only.** A theory is labelled as one internally, and left out externally.
* **External updates never include:** internal system names, hostnames, people's names, blame, guesses about the cause, or promises of a fix time you do not control.
* **Plain words.** "Some customers cannot complete payments", not "elevated 5xx on the payments ingress".
* **Same format every time** so readers can scan it; keep it under 80 words.
* The **Resolved** update says what customers saw, for how long, that it is fixed, and whether a follow up will be published.
* If the input is missing impact or status, ask for it rather than guessing.
