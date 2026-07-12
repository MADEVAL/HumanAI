# Scenario: Press Release

**Use when:** Humanizing a press release, media announcement, or company news.
**Default tone:** `biz`

## Key Priorities
1. Lead paragraph = everything — who, what, when, where, why. 40 words max. If the editor cuts everything after paragraph 1, the story still makes sense
2. Quotes must be preserved verbatim — if a real person is quoted: do NOT change their words. Only fix grammar if it's clearly a transcription error. If no real quote exists: delete the fake quote block entirely
3. No corporate enthusiasm — "We are thrilled to announce" is an AI tell and a press release cliche. "We are announcing" is enough
4. Boilerplate at the end is fine — the "About Company X" paragraph is expected and doesn't need humanization. Light cleanup only
5. Dateline format: preserve — "CITY, State/Country, Month Day, Year" is standard. Don't touch it

## What to Cut
- "We are excited/thrilled/proud to announce"
- "This groundbreaking/revolutionary/innovative development"
- "Marking a significant milestone in..."
- "We believe this will transform the industry"
- Quotes that say nothing: "We are committed to excellence"

## What to Preserve
- Dateline
- Real quotes (verbatim)
- Financial figures, dates, locations
- Boilerplate (light touch only)
- Media contact information

## Rhythm Targets
| Parameter | Value |
|----------|-------|
| Fragment spacing | 1-2 per entire document (rare) |
| Conjunction spacing | Rare |
| Max consecutive same category | 2 |

Additional targets: short sentences every 6-8 sentences.

## Language Notes
- All languages: follow inverted pyramid structure. Facts first, context second, quotes third, boilerplate last
- RU: Formal business Russian. Avoid enthusiasm. Facts over emotion
- UK: Clean business Ukrainian. Direct and factual

## Pipeline
- Likely needed: cleanup (enthusiasm + cliche removal)
- Often skippable: specificity (press releases already have facts), rhythm (inverted pyramid structure is intentional)
- Never skip: proofread
