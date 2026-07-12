# Scenario: Technical Documentation

**Use when:** Humanizing technical docs, API references, READMEs, setup guides, or knowledge base articles.
**Default tone:** `expert`

## Key Priorities
1. Clarity over brevity — technical text can be longer if every word adds precision. But cut filler
2. Jargon where appropriate — use correct terms, don't dumb down. Define implicitly through use, not with a glossary
3. Active voice — "The function returns an array" not "An array is returned by the function"
4. Code blocks stay — never modify code, commands, or config examples. Only edit surrounding explanation
5. Assumed audience is smart — don't explain what a variable is. Do explain why this architecture choice matters

## What to Cut
- "In this document we will..."
- "It is important to note..."
- "As you can see..."
- Marketing language that snuck into docs
- Over-explaining basic concepts
- "Simply", "just", "easily" (never true in docs)

## What to Preserve
- Code blocks, commands, configs (verbatim)
- Parameter tables, type definitions
- Error messages, status codes
- Version numbers, dates
- Security warnings and compliance notes

## Rhythm Targets
| Parameter | Value |
|----------|-------|
| Fragment spacing | Every 7-10 sentences |
| Conjunction spacing | Every 5-7 sentences |
| Max consecutive same category | 2 |

Additional targets: short sentences every 5-7 sentences. 3-clause cap exception: 1 technical sentence per ~300 words may have 4 clauses.

## API Reference Specifics
- Parameter tables: Never modify the table content. You may clean up marketing language in the surrounding description
- Code examples: Preserve verbatim. Even comments in code stay unless they're clearly AI-generated filler comments
- Error messages: Preserve exact wording. Developers search for error messages. Changing them breaks searchability
- Endpoint descriptions: The "what this does" sentence can be cleaned. The request/response schemas cannot
- "Before you begin" / Prerequisites sections: These are often AI-padded. Cut to actual requirements: Node 18+, API key, that's it

## Language Notes
- RU: Brevity respected. Мы default. Technical English loanwords fine
- UK: Clean technical Ukrainian. No Russianisms
- DE: Direkt, prazise. Aktiv statt Passiv
- All: Technical accuracy > humanization. If humanization would make something ambiguous, keep the original

## Pipeline
- Likely needed: cleanup (remove marketing spillover)
- Often skippable: rhythm (technical docs have natural structural variance), tone (if already expert), specificity (if data-rich)
- Never skip: proofread
- Code and config blocks are NEVER modified
