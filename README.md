# Human-AI Legacy - Text Humanization Engine

[![Version](https://img.shields.io/badge/version-3.0.0-lightgrey)](CHANGELOG.md)

> **Status:** Legacy v3. Replaced by `human-ai` 4.1 in Natural-skill. Do not install both.

[skills.sh page](https://www.skills.sh/madeval/humanai)

\[ **English** | [Русский](README.ru.md) \]

> **If the reader forgets a machine was involved, you won.**

An AI skill system that rewrites machine-generated text to sound human-written - across 9 languages. Detects and removes AI fingerprints through a 5-stage pipeline.

---

## What is this?

**Human-AI Legacy** is a system prompt (skill) for any LLM - GPT, Claude, Gemini, DeepSeek, or any capable model. It transforms AI-generated text that "smells like AI" into text that reads like a competent human wrote it.

AI writes with a fingerprint: same rhythm, same structure, same burned words, same dead perfection. Human-AI Legacy strips that fingerprint - not by making text "less AI", but by making it *more human*.

---

## How it works

1. **Load `skills/human-ai-legacy/SKILL.md`** as a system prompt into any LLM.
2. **Give a task:** "Rewrite this to sound human. Language: de." / "Make this a case study. EN." / "Just clean the AI patterns."
3. **Get output** with language detected, tone set, pipeline stages applied, and changelog.

**Three modes:**

- **Full Pipeline** - 5 stages: cleanup → specificity → tone → rhythm → proofread. Every text passes through. Flexible: skip stages with declared reason.
- **Single Stage** - Run just one stage: cleanup only, specificity only, rhythm only, etc.
- **Audit Mode** - Diagnostic scan only. Don't rewrite. Flag all AI patterns found.

---

## The 5-Stage Pipeline

```
anti-ai-cleanup → specificity → tone → rhythm → proofread
```

| Stage | What it does | Skip if |
|-------|-------------|---------|
| 1. Cleanup | Remove AI patterns: openers, burned words, fake transitions, hedging, conclusions | No AI patterns found |
| 2. Specificity | Replace abstractions with concrete details, numbers, examples | All claims rung 2+ |
| 3. Tone | Set the voice (7 profiles) | Tone already correct |
| 4. Rhythm | Break metronome: vary sentence length, openers, fragments | Rhythm already varied |
| 5. Proofread | Final scan for residual AI tells | Always runs (minimal scan) |

---

## 7 Tone Profiles

| Tone | Voice | Best for |
|------|-------|----------|
| `expert` | The Practitioner | Technical docs, deep analysis |
| `biz` | The Consultant | B2B proposals, service pages |
| `human` | The Smart Friend | Blog posts, about pages, emails |
| `social` | The Scroller | LinkedIn, Twitter/X, Telegram |
| `landing` | The Seller | Product pages, sales pages |
| `article` | The Explainer | Long-form guides, tutorials |
| `case` | The Case Study | Portfolio, success stories |

Each tone has per-language markers: fragment frequencies, conjunction rules, formality levels, cultural notes.

---

## 9 Languages

| Language | AI markers | Burned words | Tone notes |
|----------|-----------|-------------|------------|
| English | ✓ | ✓ | ✓ |
| Russian / Русский | ✓ | ✓ | ✓ |
| Ukrainian / Українська | ✓ | ✓ | ✓ |
| German / Deutsch | ✓ | ✓ | ✓ |
| French / Français | ✓ | ✓ | ✓ |
| Spanish / Español | ✓ | ✓ | ✓ |
| Portuguese / Português | ✓ | ✓ | ✓ |
| Italian / Italiano | ✓ | ✓ | ✓ |
| Polish / Polski | ✓ | ✓ | ✓ |

---

## Architecture

```
HumanAI/
├── skills/human-ai-legacy/         ← runtime skill package
│   ├── SKILL.md                    ← Main orchestrator (full pipeline)
│   ├── agents/openai.yaml          ← OpenAI agent manifest
│   ├── shared/                     ← Data files for 9 languages
│   ├── scenarios/                  ← Task-specific playbooks
│   └── examples/                   ← Annotated before/after examples
├── install.py                      ← Installer for Claude, OpenCode, Cursor, .agents
├── README.md / README.ru.md        ← This documentation
├── CHANGELOG.md                    ← Version history
└── LICENSE
```

---

## Quick Start

### Full pipeline
```
Rewrite this text to sound human. Language: ru.
```

### Specific task (load scenario)
```
Rewrite this as a landing page. DE.
```

### Single stage only
```
Just clean the AI patterns from this.
Add concrete details. Don't change the tone.
Fix the rhythm - it reads like a machine.
```

### Audit only
```
Tell me what's wrong with this. Don't rewrite.
```

### Translation fix
```
This was translated from Russian to English. Make it sound native.
```

---

## Example

**Request:** "Rewrite this AI-generated blog post intro to sound human. EN."

**Input:**
> "In today's fast-paced digital landscape, businesses are increasingly leveraging cutting-edge AI solutions to optimize their workflows and streamline operations. This comprehensive guide will explore the transformative power of artificial intelligence..."

**Output:**
```
[LANG: en]
[TONE: human]
[PIPELINE: cleanup → specificity → tone → rhythm → proofread]

Most AI tools promise to save time. They don't. They just move the work around.

We tested twelve of them over three months. Four actually helped. The rest added meetings, dashboards, and a new Slack channel you didn't ask for.

Here's what the four good ones have in common. And why the other eight failed.

---
[CHANGELOG]
- Deleted "In today's fast-paced digital landscape" opener
- Burned words removed: leveraging, cutting-edge, optimize, streamline, transformative, comprehensive
- Specificity added: "twelve tools / three months / four helped"
- Tone: human - direct, opinionated, fragment opener
- Rhythm: 7w → 8w → 2w → 18w → 9w → 9w → 11w
```

*→ More examples in `examples/`*

---

## Requirements

- Any capable LLM with a system prompt / custom instructions field
- For full skill functionality: a skill system that loads files from a folder (OpenCode, Claude Code)
- For standalone: copy `skills/human-ai-legacy/SKILL.md` as a system prompt - contains the complete pipeline
- No API keys, no tools, no dependencies - pure prompt engineering

---

## Installation

The installer copies `skills/human-ai-legacy/` into the selected agent directory:

```bash
python install.py --target all
python install.py --list
python install.py --check
python install.py --target project --dry-run
```

### OpenCode
```
human-ai-legacy/ → .opencode/skills/          (project)
                    → ~/.config/opencode/skills/  (global)
```

### Claude Code
```
human-ai-legacy/ → ~/.claude/skills/
```

### Any LLM (standalone)
Copy contents of `skills/human-ai-legacy/SKILL.md` as a system prompt. Add `shared/` files for richer per-language detail.

---

## Ethics

**Always:**
- Flag invented numbers with `[VERIFY]`
- Preserve factual content - only change presentation
- Declare all changes in changelog

**Never:**
- Invent facts, statistics, testimonials, or customer names
- Silently correct factual inaccuracies (flag them in [FACTUAL NOTES])
- Rewrite legal, medical, or safety-critical text

---

## Integration

Human-AI Legacy is designed to work with two other skills - [RankWise](https://github.com/MADEVAL/RankWise) (SEO content engine) and [MindFluence](https://github.com/MADEVAL/MindFluence) (cognitive bias marketing). Together they form a complete content production pipeline.

### Joint Prompt Triggers

Human-AI Legacy recognizes these joint prompts and activates preservation rules automatically:

- "SEO-rewrite this (RankWise), then humanize it (human-ai-legacy)"
- "Humanize the RankWise output below"
- "human-ai-legacy pass on RankWise content"
- "MindFluence generated this. Now humanize it with human-ai-legacy."
- "Triple pipeline: RankWise → MindFluence → human-ai-legacy"

### With RankWise (SEO)

**The rule:** RankWise handles SEO structure → human-ai-legacy handles human voice. Do not break SEO.

**Preservation rules when processing RankWise content:**

- **Do NOT delete or alter H2/H3 headings** that contain SEO keywords. Only rewrite the sentences surrounding them.
- **Preserve keyword density of 0.8%-1.5%.** If keyword instances are removed during cleanup, add equivalent keyword-adjacent language elsewhere.
- **Maintain minimum 600 words** (unless user explicitly requests shorter).
- **Keep internal link anchors and placement** - they are deliberately positioned for SEO.
- **During Stage 1 (cleanup):** skip deletion of keywords, internal links, and schema-relevant elements.
- **Meta title/description:** already SEO-optimized. Do not humanize them.

**Conflict resolution (RankWise vs human-ai-legacy instincts):**
1. Preserve keyword placement (K2, K4, K6, K8) - highest priority
2. Preserve heading structure (C13) - second priority
3. Then apply human voice cleanup
4. Accept ≤5% density fluctuation as acceptable trade-off

**SEO-safe markers - do NOT delete during cleanup:**
- Keywords in the first 100-150 words
- Keywords in H2 headings
- Keywords in image alt texts (if present)
- Internal link anchor text variety (exact-match ≤2)
- Meta title and description

**Recommended pipeline invocation:**
```
PIPELINE: cleanup(skipped: SEO structure) → specificity → tone → rhythm → proofread
```

### With MindFluence (Cognitive Bias Marketing)

**The rule:** MindFluence engineers persuasion → human-ai-legacy humanizes the voice. Do not strip psychological structure.

**Tone mapping (MindFluence → human-ai-legacy):**

| MindFluence Tone | human-ai-legacy Tone |
|-----------------|-------------|
| `bold-sell` | `landing` |
| `expert-calm` | `expert` |
| `rebel-edgy` | `social` |
| `warm-human` | `human` |
| `luxe-minimal` | `case` |

**Preservation rules when processing MindFluence content:**

- **Do NOT strip bias markers:** social proof numbers, anchoring prices, authority signals, scarcity cues, confirmation hooks.
- **Do NOT delete power words** that overlap with burned-word lists - they serve a psychological function.
- **Do NOT break "hook" openings** - they are deliberately patterned for System 1 capture.
- **Preserve social proof specificity:** "14,327 users this week" is a bias marker, not fluff.
- **During Stage 1 (cleanup):** skip cleanup of persuasion elements. Only remove generic AI patterns (throat-clearing, hedging, fake transitions).

**Recommended pipeline invocation (preserving MindFluence tone):**
```
PIPELINE: cleanup(skipped: bias structure) → specificity → tone(skipped: MindFluence tone) → rhythm → proofread
```

### Triple Pipeline (RankWise → MindFluence → human-ai-legacy)

**Recommended order and protocol:**

1. **RankWise Brief** → SEO structure, keyword placement, heading hierarchy, link plan
2. **MindFluence** → Cognitive bias copy within the SEO skeleton, section-by-section bias annotations
3. **human-ai-legacy** → Humanize the voice while preserving BOTH SEO signals AND bias structure
4. **RankWise Audit** → Final 49-factor verification

**Triple-pipeline preservation checklist for human-ai-legacy:**

| Preserve | From | Why |
|---------|------|-----|
| Keyword-containing H2/H3 headings | RankWise | SEO hierarchy breaks if altered |
| Internal link anchors | RankWise | Deliberate link-juice structure |
| Keyword density 0.8%-1.5% | RankWise | Under/over triggers ranking penalties |
| Social proof numbers | MindFluence | "14,327 users" - bias, not fluff |
| Anchoring / pricing figures | MindFluence | Reference points for value perception |
| Authority signals | MindFluence | Named sources, credentials, media logos |
| Scarcity / urgency cues | MindFluence | Genuine time/quantity limits |
| Power words | Both | Serve SEO sentiment + bias function |
| Minimum word count (600+) | RankWise | Thin content penalty threshold |

**Joint triple prompt template:**
```
Triple pipeline:
1) RankWise SEO brief for [topic]. Keyword: [kw]. Language: [xx].
2) MindFluence generate from that brief. Tone: [expert-calm/warm-human/bold-sell].
3) human-ai-legacy humanize the MindFluence output. Preserve SEO structure + bias markers.
4) RankWise audit the final result.
```

**human-ai-legacy invocation for triple pipeline:**
```
PIPELINE: cleanup(skipped: SEO+bias elements) → specificity → tone(skipped: from MindFluence) → rhythm → proofread
```

---

## License

MIT

---

## GitHub Description

```
AI skill for rewriting machine-generated text to sound human-written across 9 languages. Legacy v3; active version is human-ai 4.1. Skills.sh: https://www.skills.sh/madeval/humanai
```

## GitHub Tags

`ai` `anti-ai` `copywriting` `humanization` `humanizer` `llm` `multilingual` `prompt-engineering` `skill` `text-rewriting`
