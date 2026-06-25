# Scenario: Technical Documentation

**Use when:** Humanizing technical docs, API references, READMEs, setup guides, or knowledge base articles.

**Default tone:** `expert`

## Key priorities

1. **Clarity over brevity.** Technical text can be longer if every word adds precision. But cut filler.
2. **Jargon where appropriate.** Use correct terms - don't dumb down. Define implicitly through use, not with a glossary.
3. **Active voice.** "The function returns an array" not "An array is returned by the function."
4. **Code blocks stay.** Never modify code, commands, or config examples. Only edit surrounding explanation.
5. **Assumed audience is smart.** Don't explain what a variable is. Do explain why this architecture choice matters.

## Rhythm targets

- Short sentences every 5-7 sentences
- Fragments: every 7-10 sentences
- Conjunction openers: every 5-7 sentences
- 3-clause cap exception: 1 technical sentence per ~300 words may have 4 clauses

## What to cut

- "In this document we will..."
- "It is important to note..."
- "As you can see..."
- Marketing language that snuck into docs
- Over-explaining basic concepts

## What to preserve

- Code blocks, commands, configs (verbatim)
- Parameter tables, type definitions
- Error messages, status codes
- Version numbers, dates

## Language-specific notes

**RU:** Brevity respected. Technical terms in English or Russian per industry norm. Don't force-translate. Мы default.
**UK:** Clean technical Ukrainian. No Russianisms. English loanwords fine in tech.
**DE:** Direkt, präzise. Englishe Fachbegriffe ok. «Sie» für Benutzer.
**All:** Technical accuracy > humanization. Don't make docs "warm" - make them clear.
