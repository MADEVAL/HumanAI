# Scenario: Full Rewrite (Default)

**Use when:** Any text needs the complete 5-stage humanization pipeline.
**Default tone:** `human`

## Key Priorities
1. Run the complete 5-stage pipeline: cleanup → specificity → tone → rhythm → proofread
2. Auto-detect language from text + tone from context (B2B→biz, tech→expert, blog→human, social→social, landing→landing, long-form→article, portfolio→case)
3. Strip openers, burned words, fake transitions, hedging, adjective pileups, symmetrical paragraphs, rhetorical padding
4. Climb specificity ladder for every claim rung 0-1; flag invented numbers with [VERIFY]
5. Set tone and apply tone-specific markers (contractions, fragments, formality)
6. Break metronome - vary sentence length, openers, add fragments and conjunction starters (`shared/rhythm-tables.md`)
7. Final proofread - read-aloud test, top-10 AI tells scan, max 2 passes

## What to Cut
- AI-generated openers
- Burned words and phrases
- Fake transitions
- Hedging language
- Adjective pileups
- Symmetrical paragraphs
- Rhetorical padding

## What to Preserve
- User-specified language and tone overrides
- Factual content and data
- Proper names and terminology
- Quoted material and code blocks

## Rhythm Targets
| Parameter | Value |
|----------|-------|
| Fragment spacing | Vary sentence length naturally |
| Conjunction spacing | Use conjunction starters naturally |
| Max consecutive same category | 3 |

## Language Notes
- Auto-detected from text using `shared/ai-markers.md`
- User can override language via input

## Pipeline
- Likely needed: cleanup, specificity, tone, rhythm (full pipeline)
- Often skippable: any stage where patterns already correct
- Never skip: proofread

## Skip conditions
- No AI patterns → skip cleanup
- All claims rung 2+ → skip specificity
- Tone already matches → skip tone
- Rhythm already varied → skip rhythm
- Declare all skips. Proofread always runs (minimal scan).

## Procedure
1. Detect language (`shared/ai-markers.md`)
2. Stage 1: Strip openers, burned words, fake transitions, hedging, adjective pileups, symmetrical paragraphs, rhetorical padding
3. Stage 2: Climb specificity ladder for every claim rung 0-1. Flag invented numbers `[VERIFY]`
4. Stage 3: Set tone. Apply tone-specific markers (contractions, fragments, formality)
5. Stage 4: Break metronome. Vary sentence length, openers, add fragments and conjunction starters (`shared/rhythm-tables.md`)
6. Stage 5: Final proofread - read-aloud test, top-10 AI tells scan, max 2 passes

## Output
```
[LANG: detected]
[TONE: detected or specified]
[PIPELINE: full or with skip notes]
[QUALITY: XX/100]

[Rewritten text]

---
[CHANGELOG]
- Opener removed: [what]
- Burned words: [count + list]
- Specificity: [N claims rung X→Y]
- Tone: [profile] - [key changes]
- Rhythm: [N same-category runs broken], [N fragments added]

[STAGE SCORES]
Cleanup: XX | Specificity: XX | Tone: XX | Rhythm: XX | Proofread: XX
```
