# Rhythm Tables - Sentence Flow Parameters

> **Core principle:** AI text is a metronome. Human text is jazz. Break the beat.

---

## Sentence Length Categories (primary system)

LLMs cannot reliably count exact words. Use syntactic categories instead:

| Category | Definition | LLM can verify? |
|----------|-----------|-----------------|
| **Fragment** | 0 clauses. No subject+predicate pair. "Yes. Like this." | YES - trivial |
| **Short** | 1 clause. One subject+predicate pair with minimal modifiers. | YES - syntactic |
| **Medium** | 2 clauses. Main clause + one dependent/coordinate, or 1 clause with substantial modifiers. | YES - syntactic |
| **Long** | 3 clauses. Main + two dependents, or complex embedding. | YES - syntactic |
| **Very Long** | 4+ clauses. Split at clause boundary. | YES - syntactic |

### How to check clause count

A clause = a subject+predicate pair (explicit or implied).
- "The server crashed." = 1 clause (short)
- "We fixed the bug and deployed the patch." = 2 clauses (medium: "We fixed" + "deployed")
- "After we fixed the bug, which had been open for three weeks, we deployed the patch." = 3 clauses (long)
- "The server crashed, we investigated, found the root cause, and deployed a fix all within the same hour." = 4+ clauses (very long) -- split this

---

## Three Rhythm Rules (clause-based)

1. **No three consecutive sentences** of the same length category (fragment/short/medium/long).

2. **No three consecutive sentences** with the same clause count.
   Example violation: 1-clause, 1-clause, 1-clause in a row. Fix: vary to 1, 2, 1 or 1, 2, 0 (fragment).

3. **No sentence exceeds 3 clauses.** 4+ clauses: split at the natural clause boundary.
   Exception: 1 sentence per ~300 words may have 4 clauses (for necessary technical detail).

### Approximate word-count reference (for rough guidance only)

LLMs estimate word counts poorly. These are ballpark targets, NOT strict rules:

| Category | ~Words |
|----------|--------|
| Fragment | 1-5w |
| Short | 4-12w |
| Medium | 12-22w |
| Long | 22-30w |
| Very Long | 30+w (split) |

---

## Length Mix by Tone

| Tone | Fragment spacing | Short % | Medium % | Long % | Max consecutive same category |
|------|-----------------|---------|----------|--------|-------------------------------|
| expert | Every 5-7 sent | ~20% | ~50% | ~30% | 2 |
| biz | Every 6-8 sent | ~20% | ~55% | ~25% | 2 |
| human | Every 3-5 sent | ~25% | ~45% | ~30% | 2 |
| social | Every 2-3 sent | ~35% | ~55% | ~10% | 1 |
| landing | Every 3-4 sent | ~30% | ~50% | ~20% | 1 |
| article | Every 4-6 sent | ~20% | ~50% | ~30% | 2 |
| case | Every 4-5 sent | ~20% | ~55% | ~25% | 2 |

**"Max consecutive same category"**: the maximum allowed run of identical length category before you MUST vary. `social` and `landing` are strictest (max 1) because they need the most aggressive rhythm breaks.

---

## Opener Variety

**Rule:** No three consecutive sentences start with the same word or same grammatical structure.

### Opener categories - EN
Subject, Pronoun (You/We/They), Conjunction (And/But/So/Or), Verb (Build/Start), Preposition (In/With/For), Adverb, Question, Fragment.

### Opener categories - RU
Subject, Pronoun (Вы/Мы/Они), Conjunction (А/И/Но), Verb-first, Adverbial (Когда/Если), Question, Fragment.

### Opener categories - UK
Subject, Pronoun (Ви/Ми/Вони), Conjunction (А/І/Але), Verb-first, Adverbial (Коли/Якщо), Question, Fragment.

### Opener categories - DE
Subject, Pronomen (Sie/Wir), Konjunktion (Und/Aber/Oder), Verb-erst, Präpositional (Mit/Durch/Für), Adverbial, Frage, Fragment.

### Opener categories - FR
Sujet, Pronom (Vous/Nous/On), Conjonction (Et/Mais/Donc), Verbe, Prépositionnel (Avec/Pour/Dans), Adverbial, Question, Fragment.

### Opener categories - ES
Sujeto, Pronombre (Usted/Nosotros), Conjunción (Y/Pero), Verbo, Preposicional (Con/Para/En), Adverbial, Pregunta, Fragmento.

### Opener categories - PT
Sujeito, Pronome (Você/Nós), Conjunção (E/Mas), Verbo, Preposicional (Com/Para/Em), Adverbial, Pergunta, Fragmento.

### Opener categories - IT
Soggetto, Pronome (Lei/Noi), Congiunzione (E/Ma), Verbo, Preposizionale (Con/Per/In), Avverbiale, Domanda, Frammento.

### Opener categories - PL
Podmiot, Zaimek (Pan/Pani/My), Spójnik (I/Ale), Czasownik, Przyimkowy (Z/Dla/W), Przysłówkowy, Pytanie, Fragment.

---

## Conjunction-Started Sentences

| Tone | Per 100 words (approximate) |
|------|---------------------------|
| expert | 1-2 |
| biz | 0-1 |
| human | 2-4 |
| social | 2-3 |
| landing | 1-2 |
| article | 1.5-3 |
| case | 1-2 |

### Conjunctions by language
- EN: And, But, So, Or, Nor, Yet
- RU: А, И, Но, Или, Зато, Однако
- UK: А, І, Але, Чи, Зате, Однак
- DE: Und, Aber, Oder, Denn, Doch, Sondern
- FR: Et, Mais, Donc, Ou, Car, Pourtant
- ES: Y, Pero, O, Así que, Sin embargo, Aunque
- PT: E, Mas, Ou, Portanto, Porém, Contudo
- IT: E, Ma, O, Quindi, Però, Dunque
- PL: I, Ale, Lub, Więc, Jednak, Zatem

**Note on conjunction frequency counting:** LLMs cannot reliably count per-100-words. Instead, aim for the feel: in `human` tone, roughly every 5-6 sentences starts with a conjunction. In `biz` tone, maybe 1-2 per paragraph. Use the frequency as a qualitative target, not an exact metric.

---

## Visual Paragraph Weight

**Rule:** No three consecutive paragraphs of identical visual weight.

| Weight | Definition |
|--------|-----------|
| **Light** | 1 sentence (fragment or short). ~1-2 visual lines. |
| **Medium** | 2-3 sentences. ~3-5 visual lines. |
| **Heavy** | 4+ sentences. ~6+ visual lines. |

**Fix strategy:** Split a heavy into two mediums. Merge two lights. Insert a light paragraph between two mediums.

---

## Fragment Types (universal)

| # | Type | Function | Example |
|---|------|----------|---------|
| 1 | Emphasis | Breaks a statement into pieces for dramatic effect | "We tested it. For six months. In production." |
| 2 | Afterthought | Adds an observation after the main thought | "The migration took three weekends. Nobody noticed." |
| 3 | Contrast | States the opposite of what the reader expects | "We thought scaling was the problem. It wasn't." |
| 4 | Summary | Condenses the preceding into punchy units | "Three teams. Four months. One result." |
| 5 | Punch | One blunt statement. No follow-up | "Don't do this." |
