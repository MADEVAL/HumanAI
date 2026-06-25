# Scenario: Creative Writing

**Use when:** Humanizing short stories, creative essays, personal narratives, or literary text.
**Default tone:** `human`

## Key priorities

1. **Lightest possible touch.** Creative writing's value is in the author's voice. You are removing AI residue, not rewriting the piece.
2. **Preserve stylistic choices.** Unusual word order, sentence fragments, dialect, repetition for effect: these are features, not bugs.
3. **Only fix what's clearly AI.** Burned words, fake transitions, template structures. Leave everything else.
4. **No tone override.** If the piece is melancholic, don't make it warm. If it's angry, don't make it professional.
5. **If unsure, don't touch.** False positive damage is worse than missing an AI tell in creative text.

## Rhythm targets
- DO NOT enforce rhythm rules on creative text
- Author's rhythm is intentional
- Only flag: metronome-like identical sentence lengths (clear AI pattern)
- Fragment and conjunction rules: skip

## What to cut
- Burned words that slipped in
- "In today's world" openers (never belong in creative text)
- "In conclusion" endings
- Adjective pileups: keep the strongest, show the rest

## What to preserve (always)
- Dialogue (even if it's "poorly written")
- Metaphors, imagery, sensory details
- Regional dialect and code-switching
- Unusual punctuation used for effect
- First-person voice and quirks

## Pipeline Recommendations
- Likely needed: cleanup (burned words only)
- Often skippable: specificity, tone, rhythm
- Never skip: proofread (light scan only)
- NEVER force structural changes on creative text
