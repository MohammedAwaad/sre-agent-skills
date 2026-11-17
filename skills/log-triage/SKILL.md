---
name: log-triage
description: Triage application or system logs during an incident. Finds when errors started, groups repeated messages into patterns, ranks them by volume and timing, and proposes the most likely lead with the evidence and the next command to run. Use when the user shares logs or a log file and asks what is wrong, what changed, or where to look.
---

# Log triage

Help an engineer find the signal in a pile of logs, fast. The goal is a ranked list of leads backed by evidence, not a confident diagnosis.

## Steps

1. **Establish the window.** Ask, or infer from the logs, when the problem started. Note the time zone of the log timestamps.
2. **Get the shape before the detail.** If the logs are files on disk and you can run commands, start with counts, not reading:

   ```bash
   # Error-ish lines per minute (adjust the timestamp cut to the format)
   grep -iE 'error|fatal|exception|panic|timeout|refused' app.log | cut -c1-16 | sort | uniq -c

   # Most frequent messages with numbers, IDs and hex normalised away
   grep -iE 'error|exception' app.log \
     | sed -E 's/[0-9a-f]{8,}/<id>/g; s/[0-9]+/<n>/g' \
     | sort | uniq -c | sort -rn | head -20
   ```

   For journald: `journalctl -u <unit> --since "<start>" -p warning --no-pager`.
3. **Group into patterns.** Normalise variable parts (IDs, numbers, IPs, timestamps) so identical messages collapse. For each pattern: count, first seen, last seen, example line.
4. **Find what is new.** Compare the error window with a normal period before it. A pattern that existed before at the same rate is probably noise; a pattern that started at the incident start is a lead.
5. **Follow the first error, not the loudest one.** Cascading failures produce many errors downstream; the earliest new pattern is usually closer to the cause.
6. **Check for change markers** near the start: deploys, restarts, config reloads, certificate or DNS changes, failovers, cron jobs.

## Output format

```markdown
**Window:** <start> to <end> (<tz>)

**Leads, most likely first**
1. <pattern>: first seen <time>, <count> times. Evidence: <why it is a lead>. Next: `<command to confirm>`
2. ...

**Noise (present before the incident too)**
* <pattern>, <count>

**Change markers found**
* <time> <event>

**What I could not tell from these logs**
* ...
```

## Rules

* Say "likely" and "consistent with", not "the cause is", unless the logs prove it.
* Quote real lines as evidence; never paraphrase an error message.
* If the logs contain secrets or personal data, do not repeat them in the answer; mask them.
* If the logs are too large to read whole, sample with commands and say what you sampled.
