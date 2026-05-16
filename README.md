# study-this

A Claude Code plugin that turns passive reading into a Socratic tutorial.

Paste an article, video, PDF, or local file. The plugin builds a sourced summary, draws a concept map, surfaces topically-related entries from your private learning vault, and runs an adversarial Q&A that pushes you past recall into synthesis — assumption-surfacing, counterfactuals, domain-transposition, contradiction-finding.

Every claim the agent makes is labelled `[TEXT]` (from the article) or `[ME]` (its own extension), so you always know which voice you're wrestling with. You can call `cite?` on any claim to make the agent produce a passage or downgrade.

## Install

Run these inside the **Claude Code CLI** (launch by running `claude` in a terminal — not the claude.ai web app, plugins are CLI-only):

```
/plugin marketplace add https://github.com/fredmarquez/study-this
/plugin install study-this@study-this
```

The first command adds this repo as a marketplace. The second installs the plugin from it.

To check for updates later:

```
/plugin marketplace update study-this
```

### Why the HTTPS URL?

Claude Code accepts a shorter `username/repo` shorthand (e.g. `fredmarquez/study-this`), but the shorthand defaults to **SSH cloning**, which fails on machines that have never connected to GitHub via SSH (most fresh installs). The HTTPS URL form works for everyone with no setup.

If you'd rather use SSH (one-time fix for any future GitHub cloning), run this in your regular shell first:

```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

Then the shorthand `fredmarquez/study-this` will work.

## Quick start

Once installed, every slash command is namespaced with the plugin name:

```
/study-this:study https://example.com/some-article
/study-this:study /path/to/paper.pdf
/study-this:study https://youtube.com/watch?v=...
/study-this:study "paste any text directly in quotes"
```

You can also just say what you want and let the skill pick it up:

> "study this article: …"
> "help me understand this paper"
> "summarize and quiz me on what I just pasted"

After the ingest produces the entry, the plugin offers to run a quiz. You can also start one later:

```
/study-this:quiz                    # most recent entry
/study-this:quiz attention-paper    # by slug
/study-this:quiz "transformers"     # by topic match
```

## Try it locally first (before installing)

If you want to test the plugin without going through the marketplace flow, point Claude Code at the cloned repo directly:

```bash
git clone https://github.com/fredmarquez/study-this ~/Projects/study-this
claude --plugin-dir ~/Projects/study-this/plugins/study-this
```

Slash commands work the same once you're inside the session.

## First-run setup

On the very first invocation the plugin asks you three things:

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

## Repository layout

```
study-this/                          ← repo root, marketplace
├── .claude-plugin/
│   └── marketplace.json             ← catalog: lets users /plugin marketplace add this repo
├── plugins/
│   └── study-this/                  ← the plugin itself
│       ├── .claude-plugin/
│       │   └── plugin.json          ← plugin manifest
│       ├── skills/
│       │   └── study-this/
│       │       ├── SKILL.md         ← main instructions (model-invoked)
│       │       ├── REFERENCE.md     ← question typology, schemas, heuristics
│       │       ├── EXAMPLES.md      ← one fully worked end-to-end session
│       │       └── scripts/
│       │           ├── fetch-youtube-transcript.sh
│       │           └── fetch-article.sh
│       └── commands/
│           ├── study.md             ← /study-this:study entry point
│           └── quiz.md              ← /study-this:quiz entry point
├── README.md
└── LICENSE
```

## License

MIT.
