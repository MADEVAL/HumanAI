# Language Template - Add a New Language

> Copy this template to add a new language to HUMAN-AI. Fill in all sections marked `[LANGUAGE]`.

---

## Quick Setup Checklist

- [ ] Add to `shared/burned-words.md` - Burned words + Empty intensifiers
- [ ] Add to `shared/ai-markers.md` - Openers, Conclusions, Transitions, Balance, Hedging, Punctuation tells, Structure tells, Human-language description
- [ ] Add to `shared/tone-profiles.md` - Per-tone language markers (7 profiles)
- [ ] Add to `shared/specificity-ladder.md` - Rung 0→4 examples
- [ ] Add to `shared/rhythm-tables.md` - Opener categories + Conjunction list
- [ ] Add to `SKILL.md` - Lang code to: Stage 0 table (line 64), Output format (line 266), Stage 5 final checks (section 5.4)
- [ ] Add to `README.md` and `README.ru.md` - Language table row
- [ ] Add verify flag to `SKILL.md` line 146 and `shared/specificity-ladder.md`
- [ ] (Optional) Add `examples/[lang]-*.md` - 2-3 before/after examples

---

## Language Data

### Lang code: `[xx]`
### Language name (EN): `[Language Name]`
### Language name (native): `[Native Name]`

### AI Detection Markers

**Openers (delete on sight):**
- `[opener 1]`
- `[opener 2]`
- `[...]`

**Conclusion regurgitation:**
- `[conclusion phrase 1]`
- `[...]`

**Fake transitions:**
- `[transition 1]`
- `[...]`

**Fake balance:**
- `[balance structure 1]`
- `[...]`

**Hedging language:**
- `[hedging phrase 1]`
- `[...]`

**Rhetorical question padding:**
- `[padding question 1]`
- `[...]`

### Burned Words

**Burned words:**
- `[word 1]`, `[word 2]`, `[...]`

**Empty intensifiers:**
- `[intensifier 1]`, `[intensifier 2]`, `[...]`

**Additional markers:**
- `[unique language pattern 1]`
- `[...]`

### Punctuation

- **Em-dash (—):** AI tell. Replace always. (Unified policy - DO NOT change this line.)
- `[other language-specific punctuation tells]`

### Human [Language] sounds like

- `[characteristic 1]`
- `[characteristic 2]`
- `[...]`

---

## Specificity Ladder Examples

| Rung | Type | Example |
|------|------|---------|
| 0 | Pure abstraction | `[abstraction claim]` |
| 1 | Domain-scoped | `[domain claim]` |
| 2 | Mechanism-named | `[mechanism claim]` |
| 3 | Quantified | `[quantified claim]` |
| 4 | Consequence-stated | `[consequence claim]` |

---

## Tone Markers

### `expert` - The Practitioner
- `[language-specific expert markers]`

### `biz` - The Consultant
- `[language-specific biz markers]`

### `human` - The Smart Friend
- `[language-specific human markers]`

### `social` - The Scroller
- `[language-specific social markers]`

### `landing` - The Seller
- `[language-specific landing markers]`

### `article` - The Explainer
- `[language-specific article markers]`

### `case` - The Case Study
- `[language-specific case markers]`

---

## Rhythm Data

### Opener categories
- Subject: `[example]`
- Pronoun: `[example]`
- Conjunction: `[example]`
- Verb: `[example]`
- Prepositional: `[example]`
- Adverbial: `[example]`
- Question: `[example]`
- Fragment: `[example]`

### Conjunctions for sentence starters
`[conj1]`, `[conj2]`, `[conj3]`, `[...]`

---

## Verify Flag
`[LANG_VERIFY_FLAG: what needs checking]`

---

## Replacement Examples

| Bad | Good |
|-----|------|
| `[burned word example]` | `[human replacement]` |
| `[abstraction example]` | `[concrete replacement]` |
| `[generic claim]` | `[specific claim]` |

---

## Language-Specific Notes

- `[cultural note 1]`
- `[formality note]`
- `[address convention]` (formal/informal you, honorifics)
- `[any other unique characteristic]`
