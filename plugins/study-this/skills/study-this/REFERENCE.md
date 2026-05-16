# study-this — Reference

Detailed material for SKILL.md: question typology, visual-type rules, runtime vocabulary, file formats, and edge-case heuristics.

## Question typology

Eight question types. In `mixed` quiz mode, draw from **≥3 distinct types**. Every question must be grounded in a specific claim from the entry — generic prompts like *"what are the implications?"* or *"how could this apply to other industries?"* are forbidden because they produce hollow synthesis.

| Type | Form | Example |
|---|---|---|
| **Assumption-surfacing** | "The piece treats X as given — what if it isn't?" | *"The article treats positional encoding as a workaround for losing sequence info. But the workaround works *too* well. What does that hint at about whether 'sequence' was the core problem to begin with?"* |
| **Counterfactual** | "If X were not true, what part of the argument survives?" | *"If transformers didn't parallelize, what part of the result survives — and what collapses?"* |
| **Constraint-mapping** | "Apply this to a domain with constraint Y. Does it hold?" | *"Logistics has hard physical constraints the paper doesn't address. Does the central claim survive them, or does it depend on the constraints being absent?"* |
| **Domain-transposition** | "Where else does this pattern show up?" — must cite a *specific* domain, never *"various industries"*. | *"The same iterative-refinement bet shows up in diffusion models. Same mechanism, or surface similarity?"* |
| **Contradiction-finding** | "Does claim X conflict with claim Y in the same piece?" | *"Page 3 says A is the bet; page 5 says A is the cost. How do those reconcile?"* |
| **Mechanism-probing** | "You explained the *what*. What's the *why* underneath?" | *"You said attention enables parallelism. Why is parallelism even possible here — what made the previous architecture sequential in the first place?"* |
| **Scale-shifting** | "What changes at 10× / 0.1× scale?" | *"At 1M tokens this argument is one thing; at 100 tokens — does it still hold?"* |
| **Stakeholder-flipping** | "Who benefits if this is true? Who is sidelined?" | *"Who in the ML ecosystem benefits from this framing? Whose research program just got harder to justify?"* |

**Adversarial follow-up is mandatory at least once per question** (unless the user's answer is exceptional):

- *"That's the surface answer — what's the second-order effect?"*
- *"That's the obvious framing. Who would disagree, and on what grounds?"*
- *"You're describing the mechanism. What's the *bet* the mechanism encodes?"*
- *"That's true *given* the constraints. Which constraint, if loosened, kills the argument?"*

When the user types `move on` or `park it`, drop the line immediately. Don't argue with the escape.

## Content shape → diagram type

| Content shape | Diagram type | Mermaid keyword |
|---|---|---|
| "How X works" / process | flowchart | `flowchart TD` |
| "X vs. Y" / comparison | quadrant or table | `quadrantChart` |
| "Components of X" / structure | concept map / mind map | `mindmap` |
| "Sequence of events" / history | timeline | `timeline` |
| "States and transitions" | state diagram | `stateDiagram-v2` |
| "Tradeoffs" / 2×2 | quadrant | `quadrantChart` |
| "Cross-link between entries" | flowchart with two clusters | `flowchart LR` with `subgraph` |

**Mermaid validation rule:** before writing the diagram, mentally trace the syntax — node IDs unique, edges valid, no unmatched braces. If the diagram fails to render (looks like a code block to the user), regenerate **once** with simpler structure. Don't loop.

## Runtime vocabulary

The user can type these mid-session. The agent must recognize them as control phrases, not normal input.

| Phrase | When | Effect |
|---|---|---|
| `cite?` | After any agent claim during quiz | Agent produces a passage / quote from the article, or downgrades the claim to `[ME]`. |
| `move on` | Any time during quiz | Drop the current Socratic line, advance to the next question. |
| `park it` | Synonym for `move on`. | — |
| `text-only` | Any time | Agent suppresses all `[ME]` extensions for the rest of the session. |
| `extend` | After `text-only` | Re-enables extensions. |
| `draw me <X>` | Any time | Generate a Mermaid diagram of `<X>`. |
| `show me <X>` | Synonym for `draw me`. | — |
| `visualize <X>` | Synonym for `draw me`. | — |

## Source-attribution rules

Every claim the agent makes during the Socratic phase is prefixed:

- **`[TEXT]`** — directly supported by the article. Must be able to point to a passage on demand if challenged with `cite?`.
- **`[ME]`** — agent's own synthesis, extension, analogy, or framing not present in the article.

If a user asks something the article doesn't address, the agent **must** open the response with:

> *"The article doesn't address this directly — [ME] extension below."*

Never silently extrapolate.

When challenged with `cite?` after a `[TEXT]` claim, the agent must:

1. Produce a short quote or passage anchor from the article, **OR**
2. Downgrade the claim to `[ME]` (acknowledge: *"You're right — that was my framing, not the article's."*)

There is no third option.

## INDEX.md line format

One block per entry. Empty line between blocks. Order: newest first.

```
- [2026-05-15 Attention Is All You Need](entries/2026-05-15-attention-is-all-you-need-a7f.md)
  tags: ml, transformers, architecture
  concepts: self-attention, positional-encoding, multi-head
  claims:
    - Parallelism comes from removing recurrence, not from adding attention
    - Positional encoding is the price of order-agnostic attention
    - Self-attention's O(n²) cost is the bet, not a bug
```

When INDEX.md exceeds ~200 lines, move oldest blocks to `ARCHIVE.md`. Archive is still searchable on explicit ask but isn't loaded by default during cross-linking.

## Entry schema

```markdown
---
title: Attention Is All You Need
source_url: https://arxiv.org/abs/1706.03762
source_type: pdf | article | youtube | pasted | file
date: 2026-05-15
slug: attention-is-all-you-need
tags: [ml, transformers, architecture]
concepts: [self-attention, positional-encoding, multi-head]
claims:
  - Parallelism comes from removing recurrence, not from adding attention
  - Positional encoding is the price of order-agnostic attention
  - Self-attention's O(n²) cost is the bet, not a bug
quiz_mode: mixed
pending_sync: false
---

## What the article claims
(Pass A — direct claims from the text. 5–10 bullets. No analogies, no extensions.)

## My extensions (agent — not in the article)
(Pass B — analogies, follow-up reading, cross-domain framings.)

## Concept map
```mermaid
mindmap
  ...
```

## Related past entries
- [Entry X](path) — one-line on how it links

## Quiz transcript
### 2026-05-15 — mixed mode
(Q&A from the first quiz session)
```

## Paywall / login heuristics

When `WebFetch` returns content, trigger the fallback flow (run `scripts/fetch-article.sh`; if still bad, ask user to paste) if **any** of these conditions hold:

- Content length under ~500 characters
- Presence of phrases (case-insensitive): `paid subscribers`, `subscribe to continue`, `sign in to read`, `log in to continue`, `become a member`, `unlock this article`, `for subscribers only`, `cloudflare`, `checking your browser`, `please enable javascript`
- Title looks like a login/paywall page (`sign in`, `log in`, `subscribe`)
- Body is mostly HTML noise (more `<script>` tags than paragraphs)

When fallback is needed, tell the user *why* — *"The fetched content looks like a paywall — let me try the readability fallback / can you paste the article text?"*

## Tag normalization

Before proposing tags for a new entry, read the existing tag set from `INDEX.md`. Then:

1. **Prefer an existing tag** over creating a new variant. If the entry is about machine learning and `ml` exists, use `ml` (don't create `machine-learning` or `ai`).
2. **Snake-case, lowercase, ASCII**. `cognitive-science`, not `Cognitive Science` or `cognitive_science`.
3. **Prefer broader tags + narrow concepts**. Tags are coarse (`ml`, `economics`); concepts are specific (`self-attention`, `principal-agent-problem`).
4. **3–5 tags max, 3–8 concepts max**. If you want more, you're probably mixing the two.

## Retry on `pending_sync`

At the start of every ingest, scan `<vault>/entries/` for any entry with `pending_sync: true` in frontmatter. Try the remote sync for each before processing the new piece. Clear the flag on success. Leave it on failure (don't loop).
