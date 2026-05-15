# study-this

A Claude Code plugin that turns passive reading into a Socratic tutorial.

Paste an article, video, PDF, or local file. The plugin builds a sourced summary, draws a concept map, surfaces topically-related entries from your private learning vault, and runs an adversarial Q&A that pushes you past recall into synthesis — assumption-surfacing, counterfactuals, domain-transposition, contradiction-finding.

Every claim the agent makes is labelled `[TEXT]` (from the article) or `[ME]` (its own extension), so you always know which voice you're wrestling with. You can call `cite?` on any claim to make the agent produce a passage or downgrade.

## Install

```
/plugin install fredmarquez/study-this
```

## Quick start

```
/study https://example.com/some-article
/study /path/to/paper.pdf
/study https://youtube.com/watch?v=...
/study "paste any text directly in quotes"
```

After the ingest produces the entry, the plugin offers to run a quiz. You can also start one later:

```
/quiz                    # most recent entry
/quiz attention-paper    # by slug
/quiz "transformers"     # by topic match
```

## First run

On first invocation the plugin asks you three things:

1. **Where should your learning vault live?** (default: `~/learning-vault/`) — a folder of markdown files, one per entry.
2. **Where should the remote mirror live?**
   - **Notion** — paste a parent page URL; the plugin creates a "Learning Vault" database with all the right properties.
   - **GitHub** — paste a private repo URL; the plugin commits one entry at a time. Mermaid renders natively on github.com.
   - **Local-only** — no remote; point Obsidian, Logseq, VS Code, or Cursor at the vault folder.
3. **Install yt-dlp?** Needed for YouTube transcripts. One-time `brew install yt-dlp`.

Your config is stored at `<vault>/config.json` and is fully local — nothing in this repo touches it.

## What you get per entry

```
2026-05-15-attention-is-all-you-need-a7f.md
├── frontmatter: title, source, date, tags, concepts, claims
├── ## What the article claims        ← Pass A: pure summary, no extensions
├── ## My extensions (agent)          ← Pass B: analogies, follow-up reading, framings
├── ## Concept map                    ← Mermaid mindmap of the claim structure
├── ## Related past entries           ← surfaced by claim-shape match, not tag overlap
└── ## Quiz transcript                ← dated sub-section per quiz session
```

## Runtime vocabulary

During a quiz, you have a handful of single-word controls:

| Phrase | Effect |
|---|---|
| `cite?` | After an agent claim — agent must produce a passage or downgrade to `[ME]`. |
| `move on` / `park it` | Drop the current Socratic line, advance to the next question. |
| `text-only` | Suppress all `[ME]` extensions for the rest of the session. |
| `extend` | Re-enable extensions. |

## Why this exists

Most "summarize this article" tools optimize for *speed*. This one optimizes for *friction* — the kind that makes ideas stick. The default agent behavior (volunteer analogies, blur source and synthesis) is the opposite of what a good professor does. The honest-professor protocol baked into this plugin is the smallest set of barriers that meaningfully cut that drift.

## License

MIT.
