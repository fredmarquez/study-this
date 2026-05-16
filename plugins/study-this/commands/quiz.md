---
description: Run a Socratic quiz on a vault entry (most recent by default)
---

You are running the `study-this` skill's quiz flow. Follow the instructions in `skills/study-this/SKILL.md` (section "Quiz flow") exactly.

The user invoked `/quiz` with this argument:

$ARGUMENTS

Behavior:

- If `$ARGUMENTS` is empty, pick the most recent entry from the vault (most recent `entries/` filename by date).
- If `$ARGUMENTS` matches a slug exactly, use that entry.
- Otherwise treat `$ARGUMENTS` as a topic and search `INDEX.md` for the best match by tag / concept / claim overlap.

Then:

1. Ask the user for a quiz mode: `quick-recall` / `deep-synthesis` / `mixed` (default `mixed`).
2. Generate a question pool drawing from the typology in `REFERENCE.md`. Each question must cite a specific claim from the entry. Generic prompts are forbidden.
3. Run the Socratic loop one question at a time. Adversarial pushback at least once per question. Honor `move on`, `park it`, `text-only`, `extend`, `cite?` runtime toggles.
4. Every claim you make is prefixed `[TEXT]` or `[ME]`.
5. If related past entries were surfaced during ingest, at least one quiz question must link the current entry to one of them.
6. Append the exchange to the entry's `## Quiz transcript` as a dated sub-section. Re-sync to remote.
