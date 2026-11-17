---
name: runbook-to-script
description: Convert a written operational runbook (markdown, wiki page or list of shell steps) into a safe, reviewable Bash or Python script with a dry run mode, read only checks first, explicit confirmation before changes, and logging. Use when the user asks to automate, script or codify a runbook or a repeated manual procedure.
---

# Runbook to script

Turn a manual runbook into a script that a tired engineer can trust at 3 a.m. Safety beats cleverness.

## Steps

1. **Read the whole runbook first** and classify every step:
   * **Read only:** inspects state (status, logs, df, curl a health endpoint).
   * **Changes state:** restarts, deletes, edits config, scales, fails over.
   * **Judgement:** a human decision ("if the graph looks wrong, escalate"). These are not automated; the script stops and prints the question.
2. **Show the classification to the user** as a short table before writing code, and list any step that is ambiguous or unsafe to automate. Wait for confirmation when a state changing step is unclear.
3. **Choose the language:** Bash for a short sequence of commands, Python when there is parsing, branching, retries or structured output. Follow the user's preference if given.
4. **Write the script** with the structure below.
5. **Explain how to test it:** dry run first, then on a non production host.

## Required structure

* A header comment: purpose, source runbook, usage, exit codes.
* `--dry-run` (default **on** for any script that changes state) that prints every command instead of running it. Changes need an explicit `--execute`.
* Preconditions checked up front: required tools present, running user, target host or service exists.
* Read only diagnostics first, printed clearly.
* Every state changing step:
  * printed before it runs, with what it changes and how to undo it,
  * guarded by a confirmation prompt unless `--yes` is given,
  * followed by a check that it worked.
* Stops on the first unexpected failure (`set -euo pipefail` in Bash, explicit checks in Python). Never continues blindly.
* Timestamped log of every action to stdout or a log file.
* Idempotent where possible: running it twice must not make things worse.
* Bash must pass `shellcheck`; quote every variable.

## Rules

* Never hard code secrets, hostnames or credentials; take them from arguments or environment variables.
* Never add a destructive step that the runbook did not contain.
* Keep judgement steps human: print the question and the data needed to answer it, then exit with a distinct code.
* After the script, list what was **not** automated and why.
