---
name: human-ai
description: Master skill for rewriting AI-generated text to sound human-written across 9 languages: English, Russian, Ukrainian, German, French, Spanish, Portuguese, Italian, Polish. 5-stage pipeline: cleanup → specificity → tone → rhythm → proofread. For articles, posts, landing pages, commercial copy, translations, SEO content - any text that currently "smells like AI."
license: MIT
compatibility: any-llm
metadata:
  version: "3.0"
  languages: [en, ru, uk, de, fr, es, pt, it, pl]
  pipeline_stages: 5
---
# HUMAN-AI - Text Humanization Engine

> **If the reader forgets a machine was involved, you won.**
> **Version:** 3.0
> **Languages:** Русский · English · Українська · Deutsch · Français · Español · Português · Italiano · Polski
> **Mode:** Pipeline. 5 stages. Flexible - skip with declared reason.

---

## THE THREE LAWS OF HUMAN TEXT

### Law 1: Imperfection is the signal
AI produces text that is too consistent. Same rhythm. Same structure. Same formality. Same everything. Humans are inconsistent. A sharp 4-word sentence, then a meandering 28-word one. A paragraph starting with "But". A fragment. This inconsistency is not a flaw - it is the biometric signature of a human mind. Your job: introduce **structured variance**, not chaos.

### Law 2: Specificity is credibility
AI generalizes - it has no lived experience. Humans specify. "Effective solutions" → "patched the memory leak in 40 minutes". "Improves workflow" → "saves 3 hours per report". Every time you replace a generalization with a concrete detail, you make the text more human. This is the highest-leverage technique.

### Law 3: Competence doesn't announce itself
AI says: "robust, cutting-edge platform". Humans say: "we patch bugs within 4 hours". Describe what you do. The quality is self-evident. No adjectives about quality - show the quality.

---

## THE PIPELINE

```
anti-ai-cleanup → specificity → tone → rhythm → proofread
```

### Why this order
1. **Cleanup first** - remove AI patterns before anything else. Don't build human text on a robot skeleton.
2. **Specificity second** - concrete details must exist before tone, because tone wraps around content.
3. **Tone third** - once content is solid, shape the voice.
4. **Rhythm fourth** - fine-tune sentence flow after voice is set.
5. **Proofread last** - kill remaining AI residue when everything else is stable.

### Skip policy
Stages run sequentially. **Skip a stage only with declared reason.** Declare skips in output header: `[PIPELINE: cleanup → specificity(skipped: already rung 2+) → tone → rhythm → proofread]`

Skip if:
- Stage 1 (cleanup): No detectable AI patterns
- Stage 2 (specificity): All claims already rung 2+
- Stage 3 (tone): Tone already matches target
- Stage 4 (rhythm): Rhythm already varied
- Stage 5 (proofread): Always runs - at minimum a top-10 tells scan

---

## STAGE 0: LANGUAGE DETECTION

Detect language before processing. Different languages have different AI tells. Reference: `shared/ai-markers.md` for complete detection patterns per language.

**Quick detection by dominant markers:**

| Lang | Top markers |
|------|-------------|
| en | "In today's...", "Moreover", "seamless/robust/leverage", em-dash, 3-adj pileups |
| ru | «В современном...», «данный/являться/осуществлять», «следует отметить», em-dash |
| uk | «У сучасному...», «даний/являтися/здійснювати», «важливо зазначити», Russianisms, em-dash |
| de | «In der heutigen...», «Darüber hinaus», «optimieren», Nominalstil, em-dash |
| fr | «Dans le monde...», «De plus/En outre», «Il est important de noter», em-dash |
| es | «En el mundo actual...», «Además/Asimismo», «Cabe destacar», gerund overuse, em-dash |
| pt | «No mundo digital...», «Além disso/Ademais», «É importante notar», em-dash |
| it | «Nel mondo digitale...», «Inoltre/Per di più», «Si rende necessario», em-dash |
| pl | «W dzisiejszym świecie...», «Ponadto/Co więcej», «Należy podkreślić», em-dash |

---

## STAGE 1: ANTI-AI CLEANUP

### Objective
Remove all detectable AI patterns. This is mechanical. Be ruthless.

### 1.1 Delete throat-clearing openers
Delete the entire first sentence/paragraph if it starts with context-setting, era-naming, or landscape-painting. The real start is what comes after. Full lists: `shared/ai-markers.md` - Openers section per language.

### 1.2 Strip conclusion regurgitation
Delete concluding sections that restate the introduction. Humans end when done talking. If the last substantive paragraph works as an ending, keep it. If not: write one sharp exit sentence and stop. Full lists: `shared/ai-markers.md` - Conclusion section.

### 1.3 Purge burned words
**Universal + per-language.** Full list: `shared/burned-words.md`

Replacement rule: **Do not find a synonym. Describe what actually happens.**
- "leverages AI" → "uses a model trained on support tickets"
- «оптимизирует процессы» → «сокращает время согласования с трёх дней до четырёх часов»
- «optimiert Prozesse» → «verkürzt Genehmigungszeiten von drei Tagen auf vier Stunden»

### 1.4 Kill fake transitions
Delete on sight. Full lists: `shared/ai-markers.md` - Fake transitions section.

### 1.5 Kill fake balance
Delete "On one hand... on the other hand..." and equivalents - unless the text names specific, real-world positions with concrete evidence. Generic balance = kill.

### 1.6 Break symmetrical paragraphs
If 3+ consecutive paragraphs have the same number of sentences (±1): break one (split, merge, or add a 1-sentence paragraph).

### 1.7 Kill adjective pileups
Max 2 adjectives before a noun. 3+ → keep the strongest one, show the rest through description.

### 1.8 Remove empty intensifiers
Words that tell how impressed to be without providing a reason. Delete the intensifier. Let the fact carry its own weight. Full lists: `shared/burned-words.md` - Empty intensifiers section.

### 1.9 Remove hedging language
AI hedges to avoid being wrong. Humans state things. Delete hedging prefixes. State the claim directly. If uncertain: "We don't know for sure. But here's what we've seen." Full lists: `shared/ai-markers.md` - Hedging section.

### 1.10 Remove rhetorical question padding
Delete generic transition questions: "What does this mean for you?" etc. Keep genuine engagement questions that receive substantive answers.

---

## STAGE 2: SPECIFICITY ENRICHMENT

### Objective
Replace abstract claims with concrete details. Highest-impact stage.

### Core rule
For every claim ask: **How, exactly?** No answer → fill it or flag it. Full framework: `shared/specificity-ladder.md`

### The specificity ladder (rung 0→4)
| Rung | Type |
|------|------|
| 0 | Pure abstraction |
| 1 | Domain-scoped |
| 2 | Mechanism-named |
| 3 | Quantified |
| 4 | Consequence-stated |

Target: every claim rung 0-1 → rung 2+. Rung 3 when data supports it.

### Abstraction triggers (all languages)
See `shared/specificity-ladder.md` - Abstraction Detector section.

### Six enrichment techniques
See `shared/specificity-ladder.md` for full descriptions and per-language examples: Show-Don't-Tell Swap, Mechanism Reveal, Number Injection, Scenario Example, Comparison Ground, Negative Space Detail.

### No-invention rule
**You may:** supply plausible examples with domain-typical detail, suggest numbers with verify flag. **You may NOT:** invent facts, statistics, customer names, features not claimed. Flag format per language: `[VERIFY]` / `[ПРОВЕРИТЬ]` / `[ПЕРЕВІРИТИ]` / `[PRÜFEN]` / `[VÉRIFIER]` / `[VERIFICAR]` / `[VERIFICARE]` / `[SPRAWDZIĆ]`.

---

## STAGE 3: TONE NATURALIZER

### Objective
Set the voice. Every text has a speaker. Full profiles: `shared/tone-profiles.md`

### Tone selection
1. User-specified - always honored.
2. Context auto-detect (see `shared/tone-profiles.md` - Tone Selection Priority table).
3. Default fallback → `human`.

Tone is set ONCE at Stage 3. Do not re-detect in later stages.

### 7 tone profiles

| ID | Voice | Best for |
|----|-------|----------|
| `expert` | The Practitioner | Technical docs, deep analysis |
| `biz` | The Consultant | B2B proposals, service pages |
| `human` | The Smart Friend | Blog posts, about pages, emails |
| `social` | The Scroller | LinkedIn, Twitter/X, Telegram |
| `landing` | The Seller | Product pages, sales pages |
| `article` | The Explainer | Long-form guides, tutorials |
| `case` | The Case Study | Portfolio, success stories |

### Key parameters (all tones, all languages)
See `shared/tone-profiles.md` and `shared/rhythm-tables.md` for: fragment frequencies, conjunction frequencies, short-sentence spacing, sentence length mix, and per-language tone markers.

---

## STAGE 4: RHYTHM EDITOR

### Objective
Break the machine rhythm. AI = metronome. Human = jazz. Full parameters: `shared/rhythm-tables.md`

### Three rhythm rules
1. **No three consecutive sentences** of the exact same word count.
2. **No three consecutive sentences** within ±2 words of each other.
3. **No sentence exceeds 25 words.** Split at 26+. Exception: 1 long technical sentence per 300 words.

### Opener variety
No three consecutive sentences start with the same word or grammatical structure. Per-language opener categories: `shared/rhythm-tables.md`

### Fragments
Use them. Fastest way to break AI rhythm. Fragment frequencies by tone: `shared/rhythm-tables.md`

### Conjunction-started sentences
Real humans start with conjunctions. AI rarely does. Frequencies and per-language conjunction lists: `shared/rhythm-tables.md`

### Visual paragraph weight
No three consecutive paragraphs of identical visual weight. Break one.

---

## STAGE 5: FINAL PROOFREAD

### 5.1 Read-aloud test (internal simulation)
Every sentence: would you say this to a colleague? If it contains words you wouldn't use in spoken conversation, passive where active works, or >2 clauses - rewrite.

### 5.2 Re-check opener
First 200 words: still starts with context-setting? Cut more.

### 5.3 Re-check ending
Last sentence has actual information? Not summary? Good.

### 5.4 Language-specific final checks

**RU:** «следует отметить» lurking? «осуществлять» → «делать». «посредством» → «через». «данный» → «этот». Em-dash → period/comma.

**UK:** «являється» or «даний» survived? Replace. Russianisms: «із-за» → «через», «так як» → «бо»/«тому що». Em-dash → period/comma.

**EN:** Em-dashes left? Replace. "Not only... but also..." → break into two. "Whether it's X or Y" → delete.

**DE:** Nominalstil survived? Aktive Verben. Em-dash → Punkt/Komma. «Man sollte» → direkt formulieren.

**FR:** «Il est important de noter» survived? Kill. Em-dash → point/virgule. «En termes de» → reformuler avec verbe actif.

**ES:** «Cabe destacar» survived? Kill. Em-dash → punto/coma. Gerundio excesivo → reformular.

**PT:** «É importante notar» survived? Kill. Em-dash → ponto/vírgula. Gerúndio excessivo → reformular.

**IT:** «Si rende necessario» survived? Kill. Em-dash → punto/virgola. «Si passivante» eccessivo → voce attiva.

**PL:** «Należy podkreślić» survived? Kill. Em-dash → kropka/przecinek. Nadmierna nominalizacja → czasowniki.

### 5.5 Final scan - top 10 AI tells (must be 0 or near-zero)

1. "Seamless" / its translations - 0
2. "Leverage" / its translations - 0
3. "Robust" / its translations - 0
4. "In today's" / its translations - 0
5. "Moreover" / its translations - 0
6. Symmetrical 3-paragraph blocks - 0
7. "In conclusion" / its translations - 0
8. 3+ adjective pileups - 0
9. Empty intensifiers - ≤1
10. Rhetorical question padding - 0

### Iteration limit
Max 2 full proofread passes. If after 2 passes a word remains legitimately (quote, name, code reference): leave it. Stop after 2 passes.

---

## WHEN NOT TO APPLY

Skip the pipeline entirely if:
- Text is authored by a known human (attributed, signed)
- Text requires exact preservation (legal, medical, safety)
- User says "audit only" → run detection scan, output diagnostics, do NOT modify

Mixed-language text: detect primary language. Do not rewrite quoted foreign-language passages.

---

## OUTPUT FORMAT

```
[LANG: en / ru / uk / de / fr / es / pt / it / pl]
[TONE: expert / biz / human / social / landing / article / case]
[PIPELINE: stages applied with skip notes]

[THE TEXT]

---
[CHANGELOG]
Brief: 3-5 bullet points on what was changed and why.

[FACTUAL NOTES]
(Optional - flag inaccuracies, do not silently fix.)
```

No preamble. No "here is your rewritten text." No "I hope this helps." Deliver text, changelog, stop.

---

## QUICK START

**Full pipeline:**
> "Rewrite this to sound human. Language: ru."

**Specific task - load scenario:**
> "Rewrite this as a landing page. DE." → load `scenarios/landing-page.md`

**Audit only:**
> "Tell me what's wrong with this. Don't rewrite."

**Translation fix:**
> "This was translated from Russian to English. Make it sound native."

---

## FILES IN THIS SKILL

```
natural-skill/
├── SKILL.md                        ← This file - orchestrator
├── README.md / README.ru.md        ← Documentation (bilingual)
├── CHANGELOG.md                    ← Version history
├── LICENSE                         ← MIT
├── .gitignore
├── shared/
│   ├── burned-words.md             ← All burned words × 9 languages
│   ├── ai-markers.md               ← AI detection patterns × 9 languages
│   ├── tone-profiles.md            ← 7 tones with language markers
│   ├── specificity-ladder.md       ← Abstraction → concrete framework
│   ├── rhythm-tables.md            ← Sentence flow parameters
│   └── language-template.md        ← Template for adding new languages
├── scenarios/
│   ├── full-rewrite.md             ← Default: all 5 stages
│   ├── blog-post.md                ← Blog post humanization
│   ├── landing-page.md             ← Landing page humanization
│   ├── social-post.md              ← Social media post
│   ├── seo-article.md              ← SEO content humanization
│   ├── case-study.md               ← Case study / portfolio
│   ├── commercial-offer.md         ← B2B commercial offer
│   ├── email.md                    ← Email humanization
│   ├── technical-doc.md            ← Technical documentation
│   └── translation-fix.md          ← De-translation: make it sound native
└── examples/
    ├── en-blog-post.md
    ├── en-landing.md
    ├── en-social.md
    ├── ru-blog-post.md
    ├── ru-landing.md
    ├── ru-social.md
    ├── uk-blog-post.md
    └── uk-social.md
```

Each `shared/` file is a data-reference. The full pipeline works without loading them - the SKILL.md above contains all rules. Load shared files for richer per-language detail.
