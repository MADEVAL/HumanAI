# Contributing to HUMAN-AI

## Adding a New Language

1. Copy `shared/language-template.md`
2. Fill in all sections marked `[LANGUAGE]`
3. Add to these files per the checklist in the template:
   - `shared/burned-words.md` - Burned words + Empty intensifiers
   - `shared/ai-markers.md` - Detection patterns (openers, conclusions, transitions, hedging, punctuation tells, human-language description)
   - `shared/tone-profiles.md` - Per-tone language markers (all 7 profiles)
   - `shared/specificity-ladder.md` - Rung 0 to 4 examples
   - `shared/rhythm-tables.md` - Opener categories + Conjunction list
   - `SKILL.md` - Stage 0 table, Stage 5 final checks, verify flag, output format
   - `README.md` and `README.ru.md` - Language table row
4. Add 2+ examples in `examples/[lang]-*.md`
5. Add 1+ test file in `tests/benchmark/ai-texts/[lang]/`
6. Run `powershell -File scripts/validate.ps1` - must pass with 0 errors
7. Submit PR

## Adding a New Scenario

1. Create `scenarios/[name].md`
2. Include these sections:
   - **Use when:** description
   - **Default tone:** one of the 7 profiles
   - **Key priorities:** 3-5 ordered items
   - **Rhythm targets:** fragment spacing, max consecutive category, etc.
   - **What to cut:** specific list
   - **Pipeline Recommendations:** likely needed / often skippable / never skip
3. Add to `SKILL.md` file tree (line ~440)
4. Add to `README.md` and `README.ru.md` architecture trees
5. Run validation script
6. Submit PR

## Adding a New Tone Profile

1. Add to `shared/tone-profiles.md`:
   - Universal signature (who's speaking, key traits)
   - Per-language markers for all 9 languages
2. Add row to length mix table in `shared/rhythm-tables.md`
3. Add to `SKILL.md` tone table and output format
4. Update all scenario files that reference tone lists
5. Run validation script
6. Submit PR

## Commit Convention

- Start with a verb: Add, Fix, Update, Remove, Refactor
- Be specific: "Add Japanese ai-markers and burned words" not "Update shared files"
- One concern per commit where practical

## Validation

Always run before submitting:
```bash
# Windows
powershell -File scripts/validate.ps1

# Linux/macOS
bash scripts/validate.sh
```

The validator checks 11 categories of cross-reference integrity. It must pass with 0 errors. Warnings are acceptable if they are expected (e.g., em-dash references in documentation files).

## Language Quality Standards

When adding or editing language data:

1. **Markers must be authentic.** Native speaker review required for new languages. Machine-translated templates are not acceptable for tone markers.
2. **Examples must be culturally relevant.** Don't translate the WordPress security example. Use a domain that resonates with that language's audience.
3. **Variants noted.** If a language has major regional variants (PT-BR vs PT-EU, ES vs LATAM), note the differences where they affect the humanization rules.
4. **Filler words in context.** "Du coup" is not just a filler - it has specific usage patterns. Know them before listing them.
