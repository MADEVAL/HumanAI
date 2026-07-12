# Scenario: Translation Fix (De-Translation)

**Use when:** Making translated text sound like it was originally written in the target language. Removing source-language ghost patterns.
**Default tone:** `human`

## Core principle
A good translation doesn't sound translated. It sounds like the author wrote it in your language.

## Key Priorities
1. Identify the ghost language — detect source-language patterns haunting the text
2. Extract meaning, discard phrasing — ask what is this actually saying, then express it as a native speaker would
3. Fix paragraph structure — restructure to target-language norms (EN: topic→development→conclusion, RU: longer/digressive, UK: European brevity, DE: longer tolerated, FR: structured but not formulaic)
4. Clean punctuation — kill semicolons (EN→RU/UA), replace em-dashes (all→all flag), add contractions (RU/UA→EN)
5. Read aloud in target language — would a native speaker ever say these words in this order? If no, go back

## What to Cut
- Source-language ghost patterns (Slavic passives, noun chains, clause stacking)
- Em-dashes (replace always — an AI tell)
- Semicolons in RU/UA target texts
- Forced subjects and article artifacts (EN→other)
- Double-translation artifacts (EN→RU→UA)

## What to Preserve
- The original meaning and intent
- Technical terminology that is the same across languages
- Proper names, numbers, and dates
- Formatting that is standard in the target language

## Rhythm Targets
| Parameter | Value |
|----------|-------|
| Fragment spacing | Per target language norms |
| Conjunction spacing | Per target language norms |
| Max consecutive same category | Per target language norms |

## Language Notes
- RU→EN: Slavic passive → active · noun chains → verbs · «данный/являться» → describe directly · clause stacking → split into sentences · missing contractions → add · em-dashes → periods/commas
- EN→RU: Forced subjects → drop · «который» chains → split/restructure · semicolons → periods · progressive trap (is building → делает) · articles → restructure
- EN→UK: Word-for-word idioms → natural Ukrainian · Russian intermediaries → direct EN→UA · «даний/являється» → restructure · English sentence rhythm → Ukrainian melodic flow
- Any → DE/FR/ES/PT/IT/PL: Source-language structures → target-language natural equivalents · Punctuation per target convention · Formality per target culture
- Uncovered pairs: Apply general principles - identify non-native constructions, replace with native phrasing

## Pipeline
- Likely needed: all steps (ghost language detection, rephrasing, punctuation fix)
- Often skippable: none for translation fix
- Never skip: step 5 read-aloud test

## Procedure
### Step 1: Identify the ghost language
Read the text. What language patterns are haunting it? Common source→target tells:
- RU→EN: Slavic passives, noun chains, «данный/является» structures, over-formality, clause stacking, missing contractions, em-dashes
- EN→RU: Forced subjects, «который» chains, semicolons, article artifacts, progressive trap
- EN→DE: English word order, missing modal particles, over-formal «Sie» inappropriately
- EN→FR: English sentence structures, missing «on»/«en fait», forced formality
- EN→ES: English gerund patterns, missing subjunctive, forced subjects
- Any→UK: Russian loan structures, over-formality, double-translation artifacts (EN→RU→UA)
- Uncovered pairs: Apply general principles - identify non-native constructions, replace with native phrasing

### Step 2: Extract meaning, discard phrasing
Ask: what is this actually saying? Then: how would a native speaker express this?
Write the native expression. Not the translation of the words.

### Step 3: Fix paragraph structure
Paragraph norms differ by language. EN: topic→development→conclusion. RU: longer, more digressive. UK: European brevity. DE: longer tolerated. FR: structured but not formulaic. Restructure to target-language norms.

### Step 4: Clean punctuation
- EN→RU/UA: kill semicolons, kill em-dashes
- RU/UA→EN: add contractions, replace em-dashes with periods/commas, add variety
- All→all: em-dashes are an AI tell. Replace always.
- Punctuation must match target-language conventions

### Step 5: Read aloud in target language
Would a native speaker ever say these words in this order? If no - it's still a translation. Go back.

## Output format
```
[SOURCE LANG: detected]
[TARGET LANG: specified]
[TRANSLATION ARTIFACTS REMOVED: N]

[Humanized text]

---
[CHANGES]
- Pattern fixes: [list pairs addressed, e.g. "Slavic passives → active (7x)"]
- Formality: [adjusted up/down]
- Punctuation: [em-dashes removed (12x), contractions added (8x)]
```
