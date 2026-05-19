# study-this

Turn passive reading into a Socratic tutorial. Ships in two flavors:

- 🖥️ **Claude Code CLI plugin** — local markdown vault, slash commands (`/study-this:study`), works offline once installed. Best if you live in the terminal.
- 💬 **Claude chat skill** — same Socratic protocol, but rendered in claude.ai chat with native Mermaid, chip-style choice UI, and a Notion / Google Drive / local-folder vault. Best if you read articles and want gorgeous formatting.

Paste an article, video transcript, PDF, or local file. The skill builds a sourced summary, draws a concept map, surfaces topically-related entries from your private learning vault, and runs an adversarial Q&A that pushes you past recall into synthesis — assumption-surfacing, counterfactuals, domain-transposition, contradiction-finding.

Every claim the agent makes is labelled `[TEXT]` (from the article) or `[ME]` (its own extension), so you always know which voice you're wrestling with. You can call `cite?` on any claim to make the agent produce a passage or downgrade.

---

## Install (CLI plugin — terminal users)

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

### First-run setup (CLI)

On the very first invocation the plugin asks you three things:

1. **Where should your learning vault live?** (default: `~/learning-vault/`) — a folder of markdown files, one per entry.
2. **Where should the remote mirror live?**
   - **Notion** — paste a parent page URL; the plugin creates a "Learning Vault" database with all the right properties.
   - **GitHub** — paste a private repo URL; the plugin commits one entry at a time. Mermaid renders natively on github.com.
   - **Local-only** — no remote; point Obsidian, Logseq, VS Code, or Cursor at the vault folder.
3. **Install yt-dlp?** Needed for YouTube transcripts. One-time `brew install yt-dlp`.

Your config is stored at `<vault>/config.json` and is fully local — nothing in this repo touches it.

---

## Install (chat skill — claude.ai users)

The chat skill is everything in `anthropic-skill/`. You install it once and it's available in every Claude.ai conversation.

**Steps:**

1. **Connect Notion** (or Google Drive) in claude.ai settings → Connectors. This is where your Learning Vault will live.
2. **Upload the skill.** Two options:
   - **From this repo:** download the `anthropic-skill/` folder, zip it, upload at [claude.ai/settings/skills](https://claude.ai/settings/skills).
   - **One-liner from terminal:**
     ```bash
     curl -L https://github.com/fredmarquez/study-this/archive/refs/heads/main.zip -o /tmp/study-this.zip \
       && unzip -q /tmp/study-this.zip -d /tmp \
       && cd /tmp/study-this-main/anthropic-skill \
       && zip -r ~/Downloads/study-this-skill.zip . \
       && open https://claude.ai/settings/skills
     ```
     Then upload `~/Downloads/study-this-skill.zip` on the page that opened.
3. **Trigger it.** In any claude.ai chat, paste content and say *"study this:"* or just *"help me understand this article: <paste>"*. The skill activates and runs the first-run wizard.

### First-run setup (chat)

On first invocation the skill walks you through three AskUserQuestion prompts:

1. **Where should your Learning Vault live?**
   - **Notion** (recommended) — needs the Notion connector. Creates a "Learning Vault" database in a parent page you pick.
   - **Google Drive** — needs the Drive connector. Creates a "Learning Vault" folder with markdown files.
   - **Local folder (advanced)** — needs the filesystem MCP server at claude.ai/settings/connectors. Best for sharing one vault with the CLI plugin.
2. **Point at your store** — paste the parent page URL (Notion), confirm the folder (Drive), or give an absolute path (Local).
3. **Confirm tags + concepts** for the article you just pasted. Chip-style selection.

After setup, the skill drops straight into the ingest flow you started.

### Advanced: shared vault between CLI and chat

If you want one unified vault used by both surfaces:

- Install the CLI plugin (above) with **Local-only** storage at `~/learning-vault/`.
- Install the filesystem MCP server at claude.ai/settings/connectors with access to the same path.
- In the chat skill, pick **Local folder (advanced)** and point at `~/learning-vault/`.
- Both surfaces now read/write the same INDEX.md and entries/.

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
study-this/                          ← repo root
│
├── .claude-plugin/
│   └── marketplace.json             ← Claude Code marketplace catalog
│
├── plugins/                         ← CLI plugin distribution
│   └── study-this/
│       ├── .claude-plugin/plugin.json
│       ├── skills/study-this/
│       │   ├── SKILL.md             ← CLI instructions (slash commands, scripts)
│       │   ├── REFERENCE.md
│       │   ├── EXAMPLES.md
│       │   └── scripts/
│       │       ├── fetch-youtube-transcript.sh
│       │       └── fetch-article.sh
│       └── commands/
│           ├── study.md             ← /study-this:study
│           └── quiz.md              ← /study-this:quiz
│
├── anthropic-skill/                 ← Chat skill distribution (zip and upload)
│   ├── SKILL.md                     ← Chat instructions (AskUserQuestion, connectors)
│   ├── REFERENCE.md
│   └── EXAMPLES.md
│
├── README.md
└── LICENSE
```

The two distributions share the **same Socratic protocol**, the **same question typology**, and the **same `[TEXT]`/`[ME]` attribution rules**. They differ in plumbing:

| Aspect | CLI plugin | Chat skill |
|---|---|---|
| Storage | Local markdown + optional remote | Notion / Drive / Local (via filesystem MCP) |
| Trigger | `/study-this:study <input>` | Natural language ("study this: …") |
| Choice UI | Type words | AskUserQuestion chips |
| YouTube | `yt-dlp` script | Paste transcript manually |
| Mermaid render | Terminal-dependent | Native, in-chat |
| Persistence | Always-on (any CLI session) | Within any Claude.ai chat |

## License

MIT.
