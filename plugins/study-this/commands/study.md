---
description: Ingest an article, video, PDF, or pasted text for active-reading study
---

You are running the `study-this` skill's ingest flow. Follow the instructions in `skills/study-this/SKILL.md` exactly.

The user invoked `/study` with this argument:

$ARGUMENTS

Behavior:

- If `$ARGUMENTS` looks like a URL, treat it as the source. Decide YouTube / PDF / general article by inspection.
- If `$ARGUMENTS` looks like an absolute or `~/`-prefixed path, treat it as a local file (use `Read`).
- If `$ARGUMENTS` is quoted text or a longer paragraph, treat it as pasted content.
- If `$ARGUMENTS` is empty, ask the user what they want to study.

After resolving the source, run the full ingest flow:

1. Two-pass generation (pure summary in Pass A, extensions in Pass B — never blended).
2. Claim extraction (3–5 declarative claims).
3. Tag + concept extraction, normalized against existing INDEX.md tags.
4. Claim-shape cross-linking against the vault (surface only strong links; never fake).
5. Mermaid concept map.
6. Persist to `<vault>/entries/`, append to `INDEX.md`, sync to the configured remote.

When done, offer to start a quiz.
