# Scenario: Full Rewrite (Default)

**Use when:** Any text needs the complete 5-stage humanization pipeline.

**Pipeline:** cleanup → specificity → tone → rhythm → proofread

**Auto-detect:** Language (from text) + Tone (from context: B2B→biz, tech→expert, blog→human, social→social, landing→landing, long-form→article, portfolio→case).

**User can override:** Language, Tone.

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

[Rewritten text]

---
[CHANGELOG]
- Opener removed: [what]
- Burned words: [count + list]
- Specificity: [N claims rung X→Y]
- Tone: [profile] - [key changes]
- Rhythm: [N same-length runs broken], [N fragments added]
```

## Skip conditions
- No AI patterns → skip cleanup
- All claims rung 2+ → skip specificity
- Tone already matches → skip tone
- Rhythm already varied → skip rhythm

Declare all skips. Proofread always runs (minimal scan).
