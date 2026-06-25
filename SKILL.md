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
pre-flight → cleanup → specificity → tone → rhythm → proofread
```

### Why this order
0. **Pre-flight first** - detect language, estimate AI probability. If human-written → STOP. Don't waste pipeline stages.
1. **Cleanup second** - remove AI patterns before anything else. Don't build human text on a robot skeleton.
2. **Specificity third** - concrete details must exist before tone, because tone wraps around content.
3. **Tone fourth** - once content is solid, shape the voice.
4. **Rhythm fifth** - fine-tune sentence flow after voice is set.
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

## STAGE -1: PRE-FLIGHT CHECK

Before running any pipeline stage, perform a rapid diagnostic scan.

### Language Detection
Identify primary language. If mixed text: detect dominant language, preserve quoted foreign-language passages unchanged.
- Confidence ≥ 70: proceed
- Confidence < 70: ask user to specify language

### AI Probability Estimation
Rapid scan. Assign points per marker found:

| Signal | Points |
|--------|--------|
| Throat-clearing opener present | +25 |
| 3+ burned words in first 200 words | +20 |
| Fake transition ("Moreover" / «Более того» etc.) | +10 each |
| Hedge prefix ("It is important to note" / «Следует отметить») | +10 each |
| Conclusion regurgitation present | +15 |
| Symmetrical paragraphs detected (3+ same visual weight) | +15 |
| Adjective pileup (3+ before a noun) | +10 |
| Rhetorical question padding | +10 each |

**Score interpretation:**

| Score | Verdict | Action |
|-------|---------|--------|
| 0-20 | Likely human-written | **STOP.** Output: "This text scores {score}/100 on AI detection. It appears to be human-written. Running humanization would likely degrade it. If you still want processing, say 'force pipeline'." |
| 21-50 | Mild AI patterns | Proceed. Consider audit mode first if user is unsure. |
| 51-80 | Clear AI patterns | Run full pipeline. |
| 81-100 | Heavy AI generation | Run full pipeline with aggressive cleanup. |

### Already-Human Guard Rule

If AI Probability < 20: **STOP. Do not run pipeline.** Output the diagnostic only. This prevents degradation of legitimately human text.

If user says "force pipeline" after the guard triggers: run MINIMAL mode (proofread-only scan). Flag only unambiguous AI patterns. Annotate output with `[HUMAN-ORIGIN: preserved structure and voice]`.

### Tone Pre-Detection
Based on content type vocabulary and structure, suggest a tone. User can override.

| Content signals | Likely tone |
|-----------------|-------------|
| Technical terms, code, API references | `expert` |
| B2B language, pricing, ROI claims | `biz` |
| Personal voice, stories, opinions | `human` |
| Short form, hooks, punchy endings | `social` |
| Product features, CTAs, benefit claims | `landing` |
| Long-form, educational, tutorials | `article` |
| Before/after data, client results, lessons | `case` |

### Pipeline Recommendation
Based on diagnostic results, recommend stages:

```
[PRE-FLIGHT]
Language: {detected} (confidence: XX%)
AI Probability: XX/100
Tone suggested: {tone} (override with explicit tone if desired)
Recommended: {stages to run}
Skippable: {stages likely safe to skip}
```

User can accept the recommendation or override any stage.

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

### Sentence length: use CLAUSE COUNT (not word count)

LLMs cannot count words reliably. Use syntactic categories instead. Full definitions: `shared/rhythm-tables.md`

| Category | Clauses | Check method |
|----------|---------|-------------|
| Fragment | 0 clauses | No subject+predicate pair |
| Short | 1 clause | One subject+predicate pair |
| Medium | 2 clauses | Two clauses (main + dependent/coordinate) |
| Long | 3 clauses | Three clauses |
| Very Long | 4+ clauses | Split at clause boundary |

### Three rhythm rules (clause-based)

1. **No three consecutive sentences** of the same length category.
2. **No three consecutive sentences** with the same clause count.
3. **No sentence exceeds 3 clauses.** Split at 4+. Exception: 1 sentence per ~300 words may have 4 clauses.

### Approximate word reference (rough guidance, not strict)
Fragment: ~1-5w. Short: ~4-12w. Medium: ~12-22w. Long: ~22-30w. Very Long: 30+w (split).

### Opener variety
No three consecutive sentences start with the same word or grammatical structure. Per-language opener categories: `shared/rhythm-tables.md`

### Fragments
Use them. Fastest way to break AI rhythm. Fragment types and frequencies by tone: `shared/rhythm-tables.md`

### Conjunction-started sentences
Real humans start with conjunctions. AI rarely does. Frequencies and per-language conjunction lists: `shared/rhythm-tables.md`

### Visual paragraph weight
No three consecutive paragraphs of identical visual weight. Weight categories: Light (1 sentence), Medium (2-3 sentences), Heavy (4+ sentences).

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
6. Symmetrical paragraph blocks (same weight 3x) - 0
7. "In conclusion" / its translations - 0
8. 3+ adjective pileups - 0
9. Empty intensifiers - 1 or fewer
10. Rhetorical question padding - 0

### 5.6 Self-Evaluation

After producing the output, scan it against your own rules and assign a **QUALITY SCORE**:

| # | Check | Pass (10) | Partial (5) | Fail (0) |
|---|-------|-----------|-------------|----------|
| 1 | Top-10 AI tells = 0 | All 10 cleared | 1-2 remain | 3+ remain |
| 2 | Rhythm Rule 1: no 3 consecutive same length category | 0 triplets | 1 triplet | 2+ triplets |
| 3 | Rhythm Rule 2: no 3 consecutive same clause count | 0 triplets | 1 triplet | 2+ triplets |
| 4 | Rhythm Rule 3: no sentence exceeds 3 clauses | 0 violations | 1 violation | 2+ violations |
| 5 | Opener variety: no 3 consecutive same type | 0 triplets | 1 triplet | 2+ triplets |
| 6 | Paragraph weight variety: no 3 consecutive same | 0 triplets | 1 triplet | 2+ triplets |
| 7 | Tone consistency: matches declared profile | Strong match | Minor drift | Tone broken |
| 8 | Specificity: all claims rung 2+ | All rung 2+ | 1-2 at rung 0-1 | 3+ at rung 0-1 |
| 9 | Burned words: 0 remaining | 0 remain | 1 remains | 2+ remain |
| 10 | Human read-aloud test: natural voice | Passes | 1-2 awkward | 3+ awkward |

**Scoring:** Sum the 10 checks (max 100).

| Score | Rating | Action |
|-------|--------|--------|
| 90-100 | Excellent | Output is production-ready |
| 75-89 | Good | 1-2 minor issues, acceptable |
| 60-74 | Fair | Multiple issues. Re-run affected stages (see Re-loop) |
| Below 60 | Poor | Re-run pipeline with adjusted parameters |

### Re-loop Rule

If QUALITY SCORE < 75: identify the 2 lowest-scoring checks. Re-run ONLY the relevant stage(s) for those checks. Max 1 re-loop. Record both scores in output.

**Re-loop mapping:**
- Checks 1, 9 → re-run Stage 1 (cleanup)
- Check 8 → re-run Stage 2 (specificity)
- Check 7 → re-run Stage 3 (tone)
- Checks 2, 3, 4, 5, 6 → re-run Stage 4 (rhythm)
- Check 10 → re-run Stage 5 (proofread, focused on awkward sentences)

After the single re-loop, output the final score regardless. Stop after 2 passes total.

---

## WHEN NOT TO APPLY

Skip the pipeline entirely if:
- **Pre-flight guard triggered** (AI Probability < 20): text appears human-written. Output diagnostic only.
- Text is authored by a known human (attributed, signed) — regardless of score
- Text requires exact preservation (legal, medical, safety)
- User says "audit only" → run detection scan, output diagnostics, do NOT modify

**Force pipeline override:** If user says "force pipeline" after the pre-flight guard triggers, run proofread-only scan with `[HUMAN-ORIGIN]` annotation. Never run full pipeline on text scoring <20.

Mixed-language text: detect primary language. Do not rewrite quoted foreign-language passages.

---

## OUTPUT FORMAT

```
[LANG: en / ru / uk / de / fr / es / pt / it / pl]
[TONE: expert / biz / human / social / landing / article / case]
[PIPELINE: stages applied with skip notes]
[QUALITY: XX/100] ← Self-evaluation score from Stage 5.6
[ISSUES: brief list of remaining issues, if any]

[THE TEXT]

---
[CHANGELOG]
Brief: 3-5 bullet points on what was changed and why.

[STAGE SCORES]
Cleanup: XX/100 (checks 1+9 from self-eval)
Specificity: XX/100 (check 8)
Tone: XX/100 (check 7)
Rhythm: XX/100 (checks 2+3+4+5+6)
Proofread: XX/100 (check 10)
Re-loop: yes/no, stage(s) re-run, final score (if applicable)

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
