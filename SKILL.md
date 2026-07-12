---
name: human-ai
description: "Master skill for rewriting AI-generated text to sound human-written across 9 languages: English, Russian, Ukrainian, German, French, Spanish, Portuguese, Italian, Polish. Full pipeline: pre-flight → cleanup → specificity → tone → rhythm → proofread. 15 task-specific scenarios. For articles, posts, landing pages, commercial copy, translations, SEO content, emails, press releases, memos, grant proposals, creative writing - any text that currently 'smells like AI.'"
license: MIT
compatibility: any-llm
metadata:
  version: "4.0"
  languages: [en, ru, uk, de, fr, es, pt, it, pl]
  pipeline_stages: 5
---
# HUMAN-AI — Text Humanization Engine

> **If the reader forgets a machine was involved, you won.**
> **Version:** 4.0
> **Languages:** Русский · English · Українська · Deutsch · Français · Español · Português · Italiano · Polski
> **Mode:** Pipeline. 6 phases (pre-flight diagnostic + 5 processing stages). Flexible — skip with declared reason.
> **Standalone:** self-contained. All critical rules and top-15 per-language data are embedded. Full lists available via GitHub URLs at the bottom.

---

## THE THREE LAWS OF HUMAN TEXT

### Law 1: Imperfection is the signal
AI produces text that is too consistent. Same rhythm. Same structure. Same formality. Same everything. Humans are inconsistent. A sharp 4-word sentence, then a meandering 28-word one. A paragraph starting with "But". A fragment. This inconsistency is not a flaw — it is the biometric signature of a human mind. Your job: introduce **structured variance**, not chaos.

### Law 2: Specificity is credibility
AI generalizes — it has no lived experience. Humans specify. "Effective solutions" → "patched the memory leak in 40 minutes". "Improves workflow" → "saves 3 hours per report". Every time you replace a generalization with a concrete detail, you make the text more human. This is the highest-leverage technique.

### Law 3: Competence doesn't announce itself
AI says: "robust, cutting-edge platform". Humans say: "we patch bugs within 4 hours". Describe what you do. The quality is self-evident. No adjectives about quality — show the quality.

---

## THE PIPELINE

```
pre-flight → cleanup → specificity → tone → rhythm → proofread
```

### Why this order
0. **Pre-flight first** — detect language, estimate AI probability. If human-written → STOP. Don't waste pipeline stages.
1. **Cleanup second** — remove AI patterns before anything else. Don't build human text on a robot skeleton.
2. **Specificity third** — concrete details must exist before tone, because tone wraps around content.
3. **Tone fourth** — once content is solid, shape the voice.
4. **Rhythm fifth** — fine-tune sentence flow after voice is set.
5. **Proofread last** — kill remaining AI residue when everything else is stable.

### Skip policy
Stages run sequentially. **Skip a stage only with declared reason.** Declare skips in output header: `[PIPELINE: cleanup → specificity(skipped: already rung 2+) → tone → rhythm → proofread]`

| Stage | Skip if |
|-------|---------|
| Stage 1 (cleanup) | No detectable AI patterns |
| Stage 2 (specificity) | All claims already rung 2+ |
| Stage 3 (tone) | Tone already matches target |
| Stage 4 (rhythm) | Rhythm already varied |
| Stage 5 (proofread) | Always runs — at minimum a top-10 tells scan |

---

## STAGE -1: PRE-FLIGHT CHECK

Before running any pipeline stage, perform a rapid diagnostic scan.

### Minimum text size
Texts < 100 words: skip pre-flight scoring, proceed directly to cleanup. Heuristic scoring is unreliable on short samples.

### Language Detection
Identify primary language. If mixed text: detect dominant language, preserve quoted foreign-language passages unchanged.
- Confidence ≥ 70: proceed
- Confidence < 70: ask user to specify language

### AI Probability Estimation

Rapid scan. Assign points per marker found:

| Signal | Points |
|--------|--------|
| Throat-clearing opener present | +15 |
| 3+ burned words in first 200 words | +20 |
| Fake transition ("Moreover" / «Более того» etc.) | +10 each |
| Hedge prefix ("It is important to note" / «Следует отметить») | +10 each |
| Conclusion regurgitation present | +15 |
| Symmetrical paragraphs detected (3+ same visual weight) | +15 |
| Adjective pileup (3+ before a noun) | +10 |
| Rhetorical question padding | +10 each |

### Score interpretation

| Score | Verdict | Action |
|-------|---------|--------|
| 0-20 | Likely human-written | STOP. Output diagnostic only. |
| 21-50 | Mild AI patterns | Proceed. Consider audit mode first if unsure. |
| 51-80 | Clear AI patterns | Run full pipeline. |
| 81-100 | Heavy AI generation | Run full pipeline with aggressive cleanup. |

### Already-Human Guard Rule

If AI Probability < 20: **STOP. Do not run pipeline.** Output the diagnostic only.

**Weighted threshold — false-positive protection:**

STOP only if **both** conditions hold:
1. Score < 20
2. AND (opener OR conclusion_regurgitation NOT present) OR total burned words < 5

One throat-clearing opener alone is NOT sufficient to stop the pipeline. A single opener in an otherwise clean text (e.g. corporate document legitimately starting with "In today's meeting...") does not warrant pipeline halt.

**Language-specific adjustment for RU:** Russian corporate texts often open with «В современных условиях...» as legitimate канцелярит. If language = ru AND the only AI marker is an opener → WARN, do NOT stop.

If user says "force pipeline" after the guard triggers: run MINIMAL mode (proofread-only scan). Flag only unambiguous AI patterns. Annotate output with `[HUMAN-ORIGIN: preserved structure and voice]`.

### Tone Pre-Detection

| Content signals | Likely tone |
|-----------------|-------------|
| Technical terms, code, API references | `expert` |
| B2B language, pricing, ROI claims | `biz` |
| Personal voice, stories, opinions | `human` |
| Short form, hooks, punchy endings | `social` |
| Product features, CTAs, benefit claims | `landing` |
| Long-form, educational, tutorials | `article` |
| Before/after data, client results, lessons | `case` |

### Pipeline Recommendation

```
[PRE-FLIGHT]
Language: {detected} (confidence: XX%)
AI Probability: XX/100
Tone suggested: {tone} (override with explicit tone if desired)
Recommended: {stages to run}
Skippable: {stages likely safe to skip}
```

---

## STAGE 0: LANGUAGE DETECTION

### Quick detection by dominant markers

| Lang | Top markers |
|------|-------------|
| en | "In today's...", "Moreover", "seamless/robust/leverage", em-dash, 3-adj pileups |
| ru | «В современном...», «данный/являться/осуществлять», «следует отметить», em-dash |
| uk | «У сучасному...», «даний/являтися/здійснювати», «важливо зазначити», Russianisms, em-dash |
| de | «In der heutigen...», «Darüber hinaus», «optimieren», Nominalstil, em-dash |
| fr | «Dans le monde...», «De plus/En outre», «Il est important de noter», em-dash |
| es | «En el mundo actual...», «Además/Asimismo», «Cabe destacar», gerund overuse, em-dash |
| pt | «No mundo digital...», «Além disso/Ademais», «É importante notar», em-dash |
| it | «Nel mondo digitale...», «Inoltre/Per di più», «Si rende necessario», em-dash |
| pl | «W dzisiejszym świecie...», «Ponadto/Co więcej», «Należy podkreślić», em-dash |

### What human text looks like (per language)

These are the targets — when you're done humanizing, the output should read like this:

| Lang | Human text sounds like |
|------|------------------------|
| en | Varied sentence length (3 to 30+ words). Contractions: don't, we'll, it's, should've. Sentences starting with And, But, So, Or. Fragments. Yes. Like this. Concrete details, parenthetical asides. The writer's actual opinion, not a balanced survey. |
| ru | Микс коротких (2-4 слова) и длинных (15-25 слов) предложений. «Мы сделали. Работает. Дальше.» Прямота без грубости. Конкретные примеры с цифрами. Самоирония в неформальном контексте. Без эм-тире — это не русская типографика. |
| uk | Чиста технічна українська, жодних русизмів. Тепліша за російську, але без солодкуватості. Природні звороти: «до речі», «чесно кажучи», «давайте розберемось». Короткі речення поруч із розлогими поясненнями. |
| de | Direkte Sprache. Kein Nominalstil. Kurze Sätze: «Wir haben getestet. Es funktioniert.» Fakten tragen Gewicht, nicht Adjektive. Modalpartikeln in Maßen: «doch», «ja», «halt». |
| fr | Précision sans rhétorique. Phrases déclaratives: «On a testé. Voilà ce qui marche.» Pas d'enthousiasme forcé. «Du coup», «en fait», «franchement» en dose naturelle. Pas de plan en trois parties. |
| es | Directo, sin adornos. «Probamos X. Funcionó. Aquí están los datos.» Frases cortas mezcladas con explicaciones. Regionalismos bienvenidos según audiencia. Cuidado con el gerundio excesivo y «el mismo/la misma» como pronombre. |
| pt | Direto, sem firulas. PT-BR: «A gente testou. Rodou. Tá funcionando.» Auto-depreciação leve é sinal humano. Gerúndio brasileiro é natural, não é AI tell. «Olha», «na real», «tipo assim» para tom conversacional. |
| it | Preciso, senza entusiasmo. «Abbiamo provato X. Ha funzionato. Ecco perché.» «Allora», «cioè», «sai com'è» come connettori naturali. Attenzione al «si passivante». Periodi lunghi tollerati più che in inglese, ma variare la lunghezza. |
| pl | Precyzja ponad entuzjazm. «Przetestowaliśmy. Działa. Oto dlaczego.» Naturalne wtrącenia: «no wiesz», «szczerze mówiąc», «w sumie». Końcówki -ować nie są automatycznie AI, ale ich nagromadzenie tak. Ironia i sarkazm działają. |

> **Cultural depth:** The human reading your text has cultural expectations beyond grammar. What builds trust for a Polish reader (konkret, dane, certyfikaty) kills it for an Italian (superlativi). What signals humanity in Brazilian Portuguese (auto-depreciação leve) signals unprofessionalism in German. See `shared/cultural-matrix.md` for the full per-language cultural map: trust mechanics, formality norms, humor tolerance, platform-specific behavior, and taboos.

---

## STAGE 1: ANTI-AI CLEANUP

### Objective
Remove all detectable AI patterns. This is mechanical. Be ruthless.

**Replacement rule:** Do not find a synonym. Describe what actually happens.

### 1.1 Throat-clearing openers (delete the entire first sentence/paragraph)

| Lang | Openers (delete on sight) |
|------|---------------------------|
| en | In today's, In the modern, In an era, The landscape of, With the rise of, As we navigate, In the ever-evolving, It goes without saying, In recent years, The world of, Nowadays, In the age of |
| ru | В современном, В сегодняшнем, В эпоху, В условиях, В мире где, В настоящее время, На сегодняшний день, С развитием, В последние годы, В нынешних реалиях, В эру цифровизации |
| uk | У сучасному, В умовах, У світі де, На сьогоднішній день, В епоху, З розвитком, В останні роки, Сучасний світ, У нинішніх реаліях, У добу цифровізації |
| de | In der heutigen digitalen Welt, Im Zeitalter der, In der modernen, Mit dem Aufkommen von, In der sich ständig verändernden, Heutzutage, In der aktuellen Landschaft |
| fr | Dans le monde numérique d'aujourd'hui, À l'ère du, Dans le paysage actuel, Avec l'avènement de, De nos jours, Dans un monde en constante évolution, À l'heure actuelle |
| es | En el mundo digital actual, En la era de, En el panorama actual, Con el auge de, Hoy en día, En la actualidad, En un mundo cada vez más |
| pt | No mundo digital de hoje, Na era de, No cenário atual, Com o surgimento de, Hoje em dia, Atualmente, No mundo cada vez mais |
| it | Nel mondo digitale di oggi, Nell'era del, Nel panorama attuale, Con l'avvento di, Al giorno d'oggi, Oggigiorno, Nel mondo in continua evoluzione |
| pl | W dzisiejszym cyfrowym świecie, W erze, W obecnym krajobrazie, Wraz z rozwojem, W dzisiejszych czasach, Obecnie, W dobie, W świecie gdzie |

### 1.2 Conclusion regurgitation (delete entire concluding section)

| Lang | Delete on sight |
|------|-----------------|
| en | In conclusion, To summarize, In summary, To wrap up, As we have seen, Overall, In closing, To sum up, The bottom line |
| ru | В заключение, Подводя итог, Таким образом, Итак, Резюмируя, В завершение, Подводя итоги, В итоге, Исходя из вышесказанного |
| uk | На завершення, Підсумовуючи, Отже, Таким чином, Підводячи підсумок, Підіб'ємо підсумки, У підсумку, З огляду на вищесказане, Резюмуючи |
| de | Zusammenfassend, Abschließend, Zusammenfassend lässt sich sagen, Im Fazit, Schlussendlich, Alles in allem |
| fr | En conclusion, Pour résumer, En résumé, Pour conclure, En définitive, Au final, En somme |
| es | En conclusión, Para resumir, En resumen, Para concluir, En definitiva, A modo de cierre, En síntesis |
| pt | Em conclusão, Para resumir, Em resumo, Para concluir, Em suma, Resumindo, Em síntese |
| it | In conclusione, Per riassumere, In sintesi, Per concludere, In definitiva, Tirando le somme, In fin dei conti |
| pl | Podsumowując, Reasumując, Na zakończenie, W konkluzji, Podsumowując powyższe, W podsumowaniu, Konkludując |

### 1.3 Top burned words (top-15 per language)

**Universal (all languages):** leverage, utilize, harness, empower, facilitate, optimize, streamline, revolutionize, transform (generic), robust, seamless, cutting-edge, best-in-class, game-changer, next-level, innovative (unproven), holistic, ecosystem, dynamic, synergy, granular, scalable (without specifics)

| Lang | Top burned words (delete, then describe what actually happens) |
|------|---------------------------------------------------------------|
| en | leverage, utilize, harness, empower, facilitate, optimize, streamline, revolutionize, robust, seamless, cutting-edge, best-in-class, holistic, ecosystem, scalable |
| ru | оптимизировать, интегрировать, трансформировать, масштабировать, инновационный, комплексный подход, в рамках, данный, являться, осуществлять, посредством, эффективные решения, передовые технологии, уникальная методология, ключевой фактор |
| uk | оптимізувати, інтегрувати, трансформувати, масштабувати, інноваційний, комплексний підхід, в рамках, даний, являтися, здійснювати, ефективні рішення, передові технології, унікальна методологія, ключовий фактор, синергія |
| de | optimieren, integrieren, transformieren, skalieren, innovativ, ganzheitlich, nahtlos, robust, modernste, revolutionär, Synergie, Ökosystem, dynamisch, skalierbar, umfassende Lösung |
| fr | optimiser, intégrer, transformer, évolutif, innovant, holistique, transparent, robuste, de pointe, révolutionnaire, synergie, écosystème, dynamique, granulaire, solution complète |
| es | optimizar, integrar, transformar, escalable, innovador, holístico, sin fisuras, robusto, de vanguardia, revolucionario, sinergia, ecosistema, dinámico, granular, solución integral |
| pt | otimizar, integrar, transformar, escalável, inovador, holístico, transparente, robusto, de ponta, revolucionário, sinergia, ecossistema, dinâmico, granular, solução abrangente |
| it | ottimizzare, integrare, trasformare, scalabile, innovativo, olistico, robusto, all'avanguardia, rivoluzionario, sinergia, ecosistema, dinamico, granulare, soluzione completa, potenziare |
| pl | optymalizować, integrować, transformować, skalowalny, innowacyjny, holistyczny, solidny, najnowocześniejszy, rewolucyjny, przełomowy, synergia, ekosystem, dynamiczny, kompleksowe rozwiązanie, wykorzystywać |

> **Full burned-word lists (30+ per language) + replacement examples:** see GitHub URLs at bottom of file.

### 1.4 Fake transitions (delete on sight)

| Lang | Delete on sight |
|------|-----------------|
| en | Moreover, Furthermore, Additionally, Consequently, Thus, Hence, As a result, It should be noted that |
| ru | Более того, Кроме того, Помимо этого, Следует отметить, Необходимо подчеркнуть, Важно понимать, Нельзя не отметить |
| uk | Більш того, Крім того, Окрім цього, Слід зазначити, Важливо підкреслити, Варто відзначити, Не можна не відзначити |
| de | Darüber hinaus, Außerdem, Des Weiteren, Ferner, Hinzu kommt, Es ist wichtig zu beachten, Bemerkenswert ist |
| fr | De plus, En outre, Par ailleurs, Il est important de noter, Il convient de souligner, Il faut mentionner, Ajoutons que |
| es | Además, Asimismo, Por otra parte, Cabe destacar, Es importante señalar, Merece la pena mencionar, No hay que olvidar |
| pt | Além disso, Ademais, Por outro lado, É importante notar, Vale ressaltar, Cabe destacar, Não se pode esquecer |
| it | Inoltre, Per di più, D'altra parte, È importante notare, Vale la pena sottolineare, Si rende necessario evidenziare |
| pl | Ponadto, Co więcej, Dodatkowo, Warto zauważyć, Należy podkreślić, Trzeba wspomnieć, Nie można pominąć |

### 1.5 Hedging language (delete, state directly)

| Lang | Delete |
|------|--------|
| en | It could be argued that, One might say, Some research suggests, There is evidence to suggest, It is possible that, Arguably, Generally speaking |
| ru | Можно сказать что, Возможно, Вероятно, Как правило, В большинстве случаев, Существует мнение, Некоторые исследования показывают |
| uk | Можна сказати що, Можливо, Ймовірно, Як правило, У більшості випадків, Існує думка, Деякі дослідження показують |
| de | Man könnte argumentieren dass, Einige schlagen vor, Es gibt Hinweise darauf, Es ist möglich dass, Im Allgemeinen, In den meisten Fällen, Tendenziell |
| fr | On pourrait dire que, Certains suggèrent, Il est possible que, Généralement parlant, Dans la plupart des cas, Il semblerait que, Apparemment |
| es | Se podría decir que, Algunos sugieren, Es posible que, Por lo general, En la mayoría de los casos, Cabe la posibilidad, Presuntamente |
| pt | Pode-se dizer que, Alguns sugerem, É possível que, Em geral, Na maioria dos casos, Supostamente, Aparentemente |
| it | Si potrebbe dire che, Alcuni suggeriscono, È possibile che, In generale, Nella maggior parte dei casi, Presumibilmente, Apparentemente |
| pl | Można powiedzieć że, Niektórzy sugerują, Jest możliwe że, Ogólnie rzecz biorąc, W większości przypadków, Przypuszczalnie, Podobno |

### 1.6 Fake balance (delete unless positions are specific and evidenced)

| Lang | Delete |
|------|--------|
| en | On one hand... on the other hand, While some argue... others maintain, There are pros and cons, This is not to say that |
| ru | С одной стороны... с другой стороны, Хотя некоторые считают... другие утверждают, Есть свои плюсы и минусы |
| uk | З одного боку... з іншого боку, Хоча дехто вважає... інші стверджують, Є свої плюси та мінуси |
| de | Einerseits... andererseits, Während einige argumentieren... behaupten andere, Es gibt Vor- und Nachteile |
| fr | D'un côté... de l'autre, Certains disent... d'autres affirment, Il y a des avantages et des inconvénients |
| es | Por un lado... por otro lado, Mientras unos dicen... otros afirman, Hay pros y contras |
| pt | Por um lado... por outro lado, Enquanto uns dizem... outros afirmam, Há prós e contras |
| it | Da un lato... dall'altro, Mentre alcuni dicono... altri sostengono, Ci sono pro e contro |
| pl | Z jednej strony... z drugiej strony, Podczas gdy jedni twierdzą... inni uważają, Są plusy i minusy |

### 1.7 Empty intensifiers (delete the intensifier, let the fact carry its own weight)

| Lang | Delete |
|------|--------|
| en | very, extremely, incredibly, amazingly, truly, really, absolutely, completely, thoroughly, highly, remarkably |
| ru | очень, крайне, чрезвычайно, невероятно, действительно, абсолютно, полностью, весьма, исключительно |
| uk | дуже, надзвичайно, неймовірно, дійсно, абсолютно, повністю, цілком, вельми, винятково |
| de | sehr, extrem, unglaublich, erstaunlich, wirklich, absolut, vollkommen, vollständig, äußerst, bemerkenswert |
| fr | très, extrêmement, incroyablement, véritablement, vraiment, absolument, totalement, complètement, remarquablement, particulièrement |
| es | muy, extremadamente, increíblemente, verdaderamente, realmente, absolutamente, totalmente, completamente, notablemente, sumamente |
| pt | muito, extremamente, incrivelmente, verdadeiramente, realmente, absolutamente, totalmente, completamente, notavelmente, altamente |
| it | molto, estremamente, incredibilmente, veramente, realmente, assolutamente, totalmente, completamente, notevolmente, altamente |
| pl | bardzo, niezwykle, niesamowicie, naprawdę, absolutnie, całkowicie, kompletnie, wyjątkowo, nadzwyczaj, znacząco |

### 1.8 Rhetorical question padding (delete)

| Lang | Delete |
|------|--------|
| en | What does this mean for you?, Sounds good right?, Want to know the best part?, But what about X?, So how does it work?, Ready to get started? |
| ru | Что это значит для вас?, Звучит хорошо правда?, Хотите узнать самое интересное?, Но как это работает?, Готовы начать? |
| uk | Що це означає для вас?, Звучить добре правда?, Хочете дізнатися найцікавіше?, Але як це працює?, Готові почати? |

### 1.9 Additional rules (universal)

- **Break symmetrical paragraphs:** 3+ consecutive paragraphs with same number of sentences (±1) → break one (split, merge, or add 1-sentence paragraph).
- **Kill adjective pileups:** max 2 adjectives before a noun. 3+ → keep strongest, show rest through description.
- **Em-dash (—) policy:** **AI tell in ALL languages. Replace always.** Use periods, commas, colons. No exceptions except: direct quotes, code references, proper names.

> **Full AI-marker patterns (30+ per language, structure tells, punctuation per language):** see GitHub URLs at bottom.

---

## STAGE 2: SPECIFICITY ENRICHMENT

### Objective
Replace abstract claims with concrete details. Highest-impact stage.

### Core rule
For every claim ask: **How, exactly?** No answer → fill it or flag it.

### The specificity ladder

| Rung | Type | Signal |
|------|------|--------|
| 0 | Pure abstraction | No evidence, no mechanism |
| 1 | Domain-scoped | Applies to X field / Y platform |
| 2 | Mechanism-named | Explains HOW |
| 3 | Quantified | Numbers attached |
| 4 | Consequence-stated | Shows the RESULT |

Target: every claim rung 0-1 → rung 2+. Rung 3 when data supports it.

### Rung examples (one per language)

| Lang | 0 | 1 | 2 | 3 | 4 |
|------|---|---|---|---|---|
| en | "improves security" | "improves WordPress security" | "blocks brute-force login attacks" | "blocks 8,400 attempts/day" | "blocks 8,400/day — login stays available for real users" |
| ru | «повышает безопасность» | «повышает безопасность WordPress» | «блокирует атаки перебора паролей» | «блокирует 8400 попыток/день» | «блокирует 8400/день — страница входа остаётся доступной» |
| uk | «підвищує безпеку» | «підвищує безпеку WordPress» | «блокує атаки перебору паролів» | «блокує 8400 спроб/день» | «блокує 8400/день — сторінка входу доступна» |
| de | «verbessert Lieferzeiten» | «verbessert Lieferzeiten im Online-Handel» | «bündelt Bestellungen, optimiert Routen» | «verkürzt Lieferung von 3 Tagen auf 4h» | «Lieferung 4h statt 3 Tage — Retouren -22%, Stammkunden +40%» |
| fr | «améliore l'expérience client» | «améliore l'expérience en magasin» | «réduit le temps d'attente en caisse» | «réduit l'attente de 7 à 2 min» | «attente 7→2 min — le client suivant voit un caissier libre» |
| es | «mejora la productividad» | «mejora la productividad administrativa» | «automatiza informes semanales» | «reduce 12h de papeleo a 3h» | «12h→3h — el equipo recupera un día entero cada semana» |
| pt | «aumenta vendas» | «aumenta vendas no e-commerce» | «integra PIX e mostra frete em tempo real» | «de 40 a 127 pedidos/dia em 3 meses» | «40→127 pedidos/dia — abandono de carrinho caiu de 68% para 12%» |
| it | «ottimizza la produzione» | «ottimizza la linea di imbottigliamento» | «riduce scarti regolando temperatura e velocità» | «riduce scarti del 18%» | «-18% scarti — risparmio 47.000€/anno [VERIFY]» |
| pl | «usprawnia obsługę klienta» | «usprawnia obsługę w dziale supportu» | «automatyzuje odpowiedzi na częste zapytania» | «skraca czas z 48h do 4h, automatyzując 70%» | «odpowiedź w 4h zamiast 48h — 70% spraw zamkniętych bez eskalacji» |

### Abstraction triggers (scan for these — all languages)

"improves/enhances/boosts" without mechanism · "efficient/productivity/performance/quality" without measurement · "solution/platform/ecosystem/framework" without concrete description · "state-of-the-art/advanced/modern" without specifics · "better/faster/stronger/smarter" without comparison · "helps you/allows you to/enables" without saying HOW · "user-friendly/intuitive/easy to use" without what makes it so · "comprehensive/complete/end-to-end/all-in-one" without what's included · "real-time" without what happens in real time · "scalable" without to what scale

### Six enrichment techniques

1. **Show-Don't-Tell Swap:** "Our support is fast" → "We reply within 4 hours. Weekends too. Most issues solved in one reply."
2. **Mechanism Reveal:** "The algorithm detects anomalies" → "The algorithm compares each data point against the 90-day rolling average. Points outside 2.5 standard deviations get flagged."
3. **Number Injection:** "handles thousands of requests" → "handles ~12,000 requests/sec under normal load [VERIFY: confirm throughput]"
4. **Scenario Example:** "The tool prevents shipping errors" → "A warehouse worker scans a box. The tablet shows a green check — right item, right address. Last month that happened 37 times."
5. **Comparison Ground:** "Fast" → "Loads under 200ms. Industry average: 800ms."
6. **Negative Space Detail:** "A complete platform" → "We build your backend, API, database. We don't build your mobile app. We have partners for that."

### No-invention rule
You may supply plausible examples with domain-typical detail, suggest numbers with verify flag. You may NOT invent facts, statistics, customer names, features not claimed.

### Verify flag format

| Lang | Flag |
|------|------|
| en | `[VERIFY: what needs checking]` |
| ru | `[ПРОВЕРИТЬ: что нужно уточнить]` |
| uk | `[ПЕРЕВІРИТИ: що потрібно уточнити]` |
| de | `[PRÜFEN: was zu klären ist]` |
| fr | `[VÉRIFIER: ce qui doit être confirmé]` |
| es | `[VERIFICAR: qué necesita confirmación]` |
| pt | `[VERIFICAR: o que precisa ser confirmado]` |
| it | `[VERIFICARE: cosa va confermato]` |
| pl | `[SPRAWDZIĆ: co wymaga potwierdzenia]` |

---

## STAGE 3: TONE NATURALIZER

### Objective
Set the voice. Every text has a speaker.

### Tone selection
1. User-specified — always honored
2. Context auto-detect
3. Default fallback → `human`

Tone is set ONCE at Stage 3. Do not re-detect in later stages.

### Cultural calibration
Before applying tone, consult `shared/cultural-matrix.md` for the target language:
- **Trust mechanics** — what builds/breaks credibility in this culture
- **Formality & address** — вы/ты, vous/tu, Sie/du, você/Senhor(a), Lei/tu, Pan-Pani/Ty
- **Humor tolerance** — self-irony (RU, PT), dry wit (EN, DE), sarcasm (PL), none in formal (biz all langs)
- **Platform norms** — LinkedIn vs Twitter vs Telegram behavior per language

Tone profiles below contain per-language markers. The cultural matrix ensures those markers are applied with cultural awareness, not just linguistically.

### 7 tone profiles

| ID | Voice | Best for |
|----|-------|----------|
| `expert` | The Practitioner | Technical docs, deep analysis |
| `biz` | The Consultant | B2B proposals, service pages |
| `human` | The Smart Friend | Blog posts, about pages, emails |
| `social` | The Scroller | LinkedIn, Twitter/X, Telegram |
| `landing` | The Seller | Product pages, sales pages |
| `article` | The Explainer | Long-form guides, tutorials |
| `case` | The Case Study | Portfolio, success stories |

### Fragment & conjunction spacing (all languages, qualitative targets)

| Tone | Fragment spacing | Conjunction spacing | Short sent. every | Max consecutive same category |
|------|-----------------|---------------------|-------------------|:---:|
| expert | Every 5-7 sent | Every 5-7 sent | 5-7 sent | 2 |
| biz | Rare (1-2/text) | Rare (1-2/text) | 6-8 sent | 2 |
| human | Every 3-5 sent | Every 3-5 sent | 3-5 sent | 2 |
| social | Every 2-3 sent | Every 2-4 sent | 2-3 sent | 1 |
| landing | Every 3-4 sent | Every 5-7 sent | 3-4 sent | 1 |
| article | Every 4-6 sent | Every 4-6 sent | 4-6 sent | 2 |
| case | Every 4-5 sent | Every 4-6 sent | 4-5 sent | 2 |

### Per-tone key markers (all languages)

#### `expert` — The Practitioner
- **EN:** "The problem is...", "Here's what happens...", moderate contractions (we'll, it's — yes; gonna — no)
- **RU:** Brevity, shorter sentences than EN. Technical terms per industry norm. Мы default. Minimal adjectives.
- **UK:** Clean technical Ukrainian, no Russianisms. Slightly warmer than RU. Мы default.
- **DE:** Direkt. Kein Nominalstil. «Wir haben getestet. Es funktioniert.» Minimal adjectives.
- **FR:** «On a testé. Voilà ce qui marche.» Pas d'enthousiasme forcé. Préférer «on» à «nous».
- **ES:** «Probamos X. Funcionó. Aquí están los datos.» Cuidado con gerundio excesivo.
- **PT:** «A gente testou. Rodou. Tá funcionando.» (PT-BR). Gerúndio brasileiro é natural, não AI tell.
- **IT:** «Abbiamo provato X. Ha funzionato. Ecco perché.» Attenzione al «si passivante».
- **PL:** «Przetestowaliśmy. Działa. Oto dlaczego.» Żargon tylko jeśli odbiorca zna.

#### `biz` — The Consultant
- **EN:** Limited contractions. No: "partner with us", "journey", "passionate about"
- **RU:** Вы always. Direct questions. No: «рады предложить», «с удовольствием»
- **UK:** Ви always. European business style. No: «раді запропонувати», «наша місія»
- **DE:** Sie immer. Direkt, sachlich. Kein: «wir freuen uns», «unsere Mission»
- **FR:** Vous toujours. «Voici ce que nous faisons. Voici les résultats.» Pas de «nous sommes ravis».
- **ES:** Usted siempre. Datos con fuente. Sin «nos complace», «nuestra misión».
- **PT:** Você/Senhor(a). Dados com período de referência. Evitar «através de» quando «com» basta.
- **IT:** Lei sempre. Dati con contesto. No «siamo lieti», «la nostra missione».
- **PL:** Pan/Pani zawsze. Dane z datą. Bez «z przyjemnością», «naszą misją jest».

#### `human` — The Smart Friend
- **EN:** All contractions, incl. "gonna" (max 1/500w). Sentence 2w to 30+. Conjunction starters freely.
- **RU:** Stay slightly more formal than EN. Default вы. Fragments work: «Сделали. Работает. Смотрим дальше.»
- **UK:** Naturally warmer than RU. Fillers: «до речі», «чесно кажучи», «давайте розберемось».
- **DE:** Etwas wärmer als biz. Modalpartikeln: «doch», «ja», «halt». Kein: «man sollte».
- **FR:** «Du coup», «en fait», «franchement» en dose naturelle. Pas de plan en trois parties.
- **ES:** «La verdad», «mira», «pues». Frases cortas mezcladas con explicaciones. Regionalismos bienvenidos.
- **PT:** «Olha», «na real», «tipo assim» (PT-BR). «A gente» para tom conversacional. Um toque de humor.
- **IT:** «Allora», «cioè», «sai com'è», «guarda». Domande retoriche: «Ha senso?» Meno si passivante.
- **PL:** «No wiesz», «szczerze mówiąc», «w sumie». Naturalne przejścia: «No i co z tego?», «I teraz uwaga».

#### `social` — The Scroller
- **EN:** 3-12w sentences. One longer for explanation. All contractions. Fragments encouraged.
- **RU:** Measured confidence. Self-irony works. Short lines, big claims, sharp transitions.
- **UK:** More emotional, community-oriented. Shorter paragraphs than EN. Natural conversational flow.
- **DE:** Kurz, prägnant, meinungsstark. «Los geht's.» «Das ist der Punkt.» Keine langen Einleitungen.
- **FR:** Phrases 3-8 mots dominantes. Accroche en première ligne. Pas de «n'hésitez pas à».
- **ES:** «Mira.» «El problema es este.» Frases 3-10 palabras. Sin rodeos.
- **PT:** «Olha só.» «O problema é esse.» Frases curtas 3-10 palavras. Brasileiro de internet é informal até no LinkedIn.
- **IT:** «Guarda.» «Il punto è questo.» Frasi 3-10 parole. Chiudere con osservazione, non riassunto.
- **PL:** «Słuchaj.» «Rzecz w tym, że...» Krótkie zdania 3-10 słów. Ironia i sarkazm działają.

#### `landing` — The Seller
- **EN:** Headline <12w. "Start building" not "Get started today". Fragments 1-1.5/100w.
- **RU:** Cut 30% then cut 30% more. CTAs: infinitive or imperative — pick one. Trust through specifics.
- **UK:** Clarity over embellishment. Cut aggressively. Довіра через конкретику.
- **DE:** «Jetzt starten» nicht «Starten Sie noch heute». Vertrauen durch Fakten.
- **FR:** «Commencez» pas «N'attendez plus». Confiance par preuves: chiffres, logos clients, certification.
- **ES:** «Empieza ya» no «No esperes más». Confianza con hechos. Cortar 40-60% del texto original.
- **PT:** «Comece agora» não «Não espere mais». Cortar 40-60%. «O que eu ganho com isso?»
- **IT:** «Inizia ora» non «Non aspettare». Italiani diffidano dei superlativi. Tagliare 40-60%.
- **PL:** «Zacznij teraz» nie «Nie czekaj». Polak sprawdza konkrety zanim kupi. Ciąć bezlitośnie.

#### `article` — The Explainer
- **EN:** Opens with problem, not context. "Let's look at the data." "But there's a catch."
- **RU:** Fight academic tone. Write like explaining to a smart colleague. Section breaks with questions.
- **UK:** European, less Soviet baggage. Natural section flow. Questions as section breaks.
- **DE:** «Schauen wir uns die Daten an.» «Aber es gibt einen Haken.» Kein: «Erstens, zweitens, drittens».
- **FR:** «Regardons les données.» «Mais il y a un hic.» Varier: phrase courte 5 mots, puis explication 25.
- **ES:** «Veamos los datos.» «Pero hay una trampa.» Evitar «en primer lugar», «en segundo lugar».
- **PT:** «Vejamos os dados.» «Mas tem um porém.» PT-BR: tom de conversa inteligente, não monografia.
- **IT:** «Guardiamo i dati.» «Ma c'è un problema.» Troppi «nonostante», «sebbene», «tuttavia» = AI.
- **PL:** «Spójrzmy na dane.» «Ale jest haczyk.» Unikać: «po pierwsze», «po drugie», «podsumowując».

#### `case` — The Case Study
- **EN:** Context → Problem → Attempt 1 (failed) → Attempt 2 (worked) → Numbers → Lessons
- **RU:** Include failures — builds massive trust. Specific technical details respected.
- **UK:** Same logic as RU. Ukrainian business appreciates directness. Numbers + honest narrative = trust.
- **DE:** Ehrlichkeit baut Vertrauen. Zahlen, nicht Adjektive. «Der erste Ansatz scheiterte...»
- **FR:** «La première approche a échoué.» Chiffres en contexte temporel. Pas de «solution miracle».
- **ES:** Honestidad = credibilidad. Admitir un error bien manejado genera más confianza que un relato perfecto.
- **PT:** Brasileiros valorizam transparência e «jeitinho». O que aprendemos é mais valioso que o resultado.
- **IT:** Onestà = credibilità. Dati con periodo. Mai «implementazione impeccabile». La lezione appresa è la parte più importante.
- **PL:** «Pierwsze podejście nie zadziałało.» Polacy cenią konkret. Wnioski i nauczki są ważniejsze od suchych liczb.

> **Full tone profiles (7 tones × 9 languages, 250 lines):** see GitHub URL at bottom.

---

## STAGE 4: RHYTHM EDITOR

### Objective
Break the machine rhythm. AI = metronome. Human = jazz.

### Sentence length: use CLAUSE COUNT (not word count)

| Category | Clauses | Check method |
|----------|---------|-------------|
| Fragment | 0 clauses | No subject+predicate pair |
| Short | 1 clause | One subject+predicate pair |
| Medium | 2 clauses | Two clauses (main + dependent/coordinate) |
| Long | 3 clauses | Three clauses |
| Very Long | 4+ clauses | Split at clause boundary |

### Three rhythm rules (clause-based)

1. **No three consecutive sentences** of the same length category.
2. **No three consecutive sentences** with the same clause count.
3. **No sentence exceeds 3 clauses.** Split at 4+. Exception: 1 sentence per ~300 words may have 4 clauses.

### Approximate word reference (rough guidance only)

Fragment: ~1-5w. Short: ~4-12w. Medium: ~12-22w. Long: ~22-30w. Very Long: 30+w (split).

### Opener variety — per language

**Rule:** No three consecutive sentences start with the same word or same grammatical structure.

| Lang | Opener categories (rotate through these) |
|------|------------------------------------------|
| en | Subject, Pronoun (You/We/They), Conjunction (And/But/So/Or), Verb (Build/Start), Preposition (In/With/For), Adverb, Question, Fragment |
| ru | Subject, Pronoun (Вы/Мы/Они), Conjunction (А/И/Но), Verb-first, Adverbial (Когда/Если), Question, Fragment |
| uk | Subject, Pronoun (Ви/Ми/Вони), Conjunction (А/І/Але), Verb-first, Adverbial (Коли/Якщо), Question, Fragment |
| de | Subject, Pronomen (Sie/Wir), Konjunktion (Und/Aber/Oder), Verb-erst, Präpositional (Mit/Durch/Für), Adverbial, Frage, Fragment |
| fr | Sujet, Pronom (Vous/Nous/On), Conjonction (Et/Mais/Donc), Verbe, Prépositionnel (Avec/Pour/Dans), Adverbial, Question, Fragment |
| es | Sujeto, Pronombre (Usted/Nosotros), Conjunción (Y/Pero), Verbo, Preposicional (Con/Para/En), Adverbial, Pregunta, Fragmento |
| pt | Sujeito, Pronome (Você/Nós), Conjunção (E/Mas), Verbo, Preposicional (Com/Para/Em), Adverbial, Pergunta, Fragmento |
| it | Soggetto, Pronome (Lei/Noi), Congiunzione (E/Ma), Verbo, Preposizionale (Con/Per/In), Avverbiale, Domanda, Frammento |
| pl | Podmiot, Zaimek (Pan/Pani/My), Spójnik (I/Ale), Czasownik, Przyimkowy (Z/Dla/W), Przysłówkowy, Pytanie, Fragment |

### Conjunctions for sentence starters

| Lang | Conjunctions |
|------|-------------|
| en | And, But, So, Or, Nor, Yet |
| ru | А, И, Но, Или, Зато, Однако |
| uk | А, І, Але, Чи, Зате, Однак |
| de | Und, Aber, Oder, Denn, Doch, Sondern |
| fr | Et, Mais, Donc, Ou, Car, Pourtant |
| es | Y, Pero, O, Así que, Sin embargo, Aunque |
| pt | E, Mas, Ou, Portanto, Porém, Contudo |
| it | E, Ma, O, Quindi, Però, Dunque |
| pl | I, Ale, Lub, Więc, Jednak, Zatem |

### Visual paragraph weight

**Rule:** No three consecutive paragraphs of identical visual weight.

| Weight | Definition |
|--------|-----------|
| Light | 1 sentence. ~1-2 visual lines. |
| Medium | 2-3 sentences. ~3-5 visual lines. |
| Heavy | 4+ sentences. ~6+ visual lines. |

### Fragment types (universal)

| # | Type | Example |
|---|------|---------|
| 1 | Emphasis | "We tested it. For six months. In production." |
| 2 | Afterthought | "The migration took three weekends. Nobody noticed." |
| 3 | Contrast | "We thought scaling was the problem. It wasn't." |
| 4 | Summary | "Three teams. Four months. One result." |
| 5 | Punch | "Don't do this." |

### Length mix by tone

| Tone | Fragment spacing | Short % | Medium % | Long % |
|------|-----------------|---------|----------|--------|
| expert | Every 5-7 sent | ~20% | ~50% | ~30% |
| biz | Every 6-8 sent | ~20% | ~55% | ~25% |
| human | Every 3-5 sent | ~25% | ~45% | ~30% |
| social | Every 2-3 sent | ~35% | ~55% | ~10% |
| landing | Every 3-4 sent | ~30% | ~50% | ~20% |
| article | Every 4-6 sent | ~20% | ~50% | ~30% |
| case | Every 4-5 sent | ~20% | ~55% | ~25% |

---

## STAGE 5: FINAL PROOFREAD

### 5.1 Read-aloud test (internal simulation)
Every sentence: would you say this to a colleague? If it contains words you wouldn't use in spoken conversation, passive where active works, or >2 clauses — rewrite.

### 5.2 Re-check opener
First 200 words: still starts with context-setting? Cut more.

### 5.3 Re-check ending
Last sentence has actual information? Not summary? Good.

### 5.4 Language-specific final checks

**EN:** Em-dashes left? Replace. "Not only... but also..." → break into two. "Whether it's X or Y" → delete.

**RU:** «следует отметить» survived? «осуществлять» → «делать». «посредством» → «через». «данный» → «этот». Em-dash → period/comma. No exceptions: long dashes are NOT Russian typography — they are an AI fingerprint.

**UK:** «являється» or «даний» survived? Replace. Russianisms: «із-за» → «через», «так як» → «бо»/«тому що». Em-dash → period/comma.

**DE:** Nominalstil survived? Aktive Verben. Em-dash → Punkt/Komma. «Man sollte» → direkt formulieren.

**FR:** «Il est important de noter» survived? Kill. Em-dash → point/virgule. «En termes de» → reformuler avec verbe actif.

**ES:** «Cabe destacar» survived? Kill. Em-dash → punto/coma. Gerundio excesivo → reformular.

**PT:** «É importante notar» survived? Kill. Em-dash → ponto/vírgula. Gerúndio excessivo → reformular.

**IT:** «Si rende necessario» survived? Kill. Em-dash → punto/virgola. «Si passivante» eccessivo → voce attiva.

**PL:** «Należy podkreślić» survived? Kill. Em-dash → kropka/przecinek. Nadmierna nominalizacja → czasowniki.

### 5.4b Cultural taboos scan (use `shared/cultural-matrix.md`)
For the detected language, scan against the "Taboos & pitfalls" section in the cultural matrix. These are per-language AI tells not covered by universal burned-word lists:
- **EN:** Fake balance ("On one hand... on the other"), "Not only... but also..."
- **RU:** «рады предложить», «наша миссия», pseudo-academic reflexive verbs
- **UK:** Russianisms, surzhyk, Soviet bureaucratic residue («у зв'язку з», «з метою»)
- **DE:** English loanwords («getriggert», «geboostet»), English quotation marks
- **FR:** Anglicized marketing jargon («scalable», «disruptif»), 3-part academic plan
- **ES:** «El mismo/la misma» as pronoun, «sin embargo» overuse, forced subjunctive
- **PT:** «Através de» instead of «com», «O mesmo/a mesma» as pronoun
- **IT:** «Si passivante» eccessivo, «nonostante/sebbene/tuttavia» pileup
- **PL:** English calques («dedykowany», «serwis»), «w ramach/w zakresie» chains

### 5.5 Final scan — top 10 AI tells (must be 0 or near-zero)

1. "Seamless" / its translations — 0
2. "Leverage" / its translations — 0
3. "Robust" / its translations — 0
4. "In today's" / its translations — 0
5. "Moreover" / its translations — 0
6. Symmetrical paragraph blocks (same weight 3x) — 0
7. "In conclusion" / its translations — 0
8. 3+ adjective pileups — 0
9. Empty intensifiers — 1 or fewer
10. Rhetorical question padding — 0

### 5.6 Self-Evaluation

| # | Check | Pass (10) | Partial (5) | Fail (0) |
|---|-------|-----------|-------------|----------|
| 1 | Top-10 AI tells = 0 | All 10 cleared | 1-2 remain | 3+ remain |
| 2 | Rhythm Rule 1: no 3 consecutive same length category | 0 triplets | 1 triplet | 2+ triplets |
| 3 | Rhythm Rule 2: no 3 consecutive same clause count | 0 triplets | 1 triplet | 2+ triplets |
| 4 | Rhythm Rule 3: no sentence exceeds 3 clauses | 0 violations | 1 violation | 2+ violations |
| 5 | Opener variety: no 3 consecutive same type | 0 triplets | 1 triplet | 2+ triplets |
| 6 | Paragraph weight variety: no 3 consecutive same | 0 triplets | 1 triplet | 2+ triplets |
| 7 | Tone consistency: matches declared profile | Strong match | Minor drift | Tone broken |
| 8 | Specificity: all claims rung 2+ | All rung 2+ | 1-2 at rung 0-1 | 3+ at rung 0-1 |
| 9 | Burned words: 0 remaining | 0 remain | 1 remains | 2+ remain |
| 10 | Human read-aloud test: natural voice | Passes | 1-2 awkward | 3+ awkward |

**Scoring:** Sum the 10 checks (max 100).

| Score | Rating | Action |
|-------|--------|--------|
| 90-100 | Excellent | Production-ready |
| 75-89 | Good | 1-2 minor issues, acceptable |
| 60-74 | Fair | Multiple issues. Re-run affected stages |
| Below 60 | Poor | Re-run pipeline with adjusted parameters |

### Re-loop Rule
If QUALITY SCORE < 75: identify the 2 lowest-scoring checks. Re-run ONLY the relevant stage(s). Max 1 re-loop. Record both scores.

**Re-loop mapping:**
- Checks 1, 9 → re-run Stage 1 (cleanup)
- Check 8 → re-run Stage 2 (specificity)
- Check 7 → re-run Stage 3 (tone)
- Checks 2, 3, 4, 5, 6 → re-run Stage 4 (rhythm)
- Check 10 → re-run Stage 5 (proofread, focused on awkward sentences)

After the single re-loop, output the final score regardless. Stop after 2 passes total.

### External validation (recommended, not LLM-performed)

Three independent layers beyond self-evaluation:

| Layer | Tool | What it measures | How to run |
|-------|------|-----------------|------------|
| Readability | `readsight` (Python pkg) | Flesch, LIX, Fog — did text become more readable? | `scripts/readability-check.ps1` |
| Morphology | `pymorphy3` / `spaCy` | Non-existent words in output | `scripts/morph-check.ps1 -Lang ru` |
| AI detection | ZeroGPT API | Independent AI probability | `scripts/zerogpt-detect.ps1 -File output.md` |

---

## WHEN NOT TO APPLY

- **Pre-flight guard triggered** (AI Probability < 20 AND multiple conditions): output diagnostic only
- Text is authored by a known human (attributed, signed)
- Text requires exact preservation (legal, medical, safety)
- User says "audit only" → run detection scan, output diagnostics, do NOT modify

**Force pipeline override:** If user says "force pipeline" after pre-flight guard triggers → proofread-only scan with `[HUMAN-ORIGIN]` annotation. Never run full pipeline on text scoring <20.

Mixed-language text: detect primary language. Do not rewrite quoted foreign-language passages.

---

## OUTPUT FORMAT

```
[LANG: en / ru / uk / de / fr / es / pt / it / pl]
[TONE: expert / biz / human / social / landing / article / case]
[PIPELINE: stages applied with skip notes]
[QUALITY: XX/100]
[ISSUES: brief list of remaining issues, if any]

[THE TEXT]

---
[CHANGELOG]
Brief: 3-5 bullet points on what was changed and why.

[STAGE SCORES]
Cleanup: XX/100 (burned-word + AI-tell clearance, checks 1+9 from self-eval)
Specificity: XX/100 (claims at rung 2+, check 8)
Tone: XX/100 (profile consistency, check 7)
Rhythm: XX/100 (sentence variety, opener rotation, paragraph weight, checks 2+3+4+5+6)
Proofread: XX/100 (read-aloud naturalness, check 10)
Re-loop: yes/no, stage(s) re-run, final score (if applicable)

[FACTUAL NOTES]
(Optional — flag inaccuracies, do not silently fix.)
```

No preamble. No "here is your rewritten text." No "I hope this helps." Deliver text, changelog, stop.

---

## AUDIT MODE

When user says "audit only" or "tell me what's wrong, don't rewrite":

Output a structured diagnostic, NOT a rewrite.

```
[AUDIT REPORT]
Language: {detected} (confidence: XX%)
AI Probability: XX/100

CRITICAL (must fix):
- {marker}: {quote from text}
- ...

HIGH (strongly recommended):
- {marker}: {quote}
- ...

MEDIUM (consider fixing):
- {marker}: {quote}
- ...

LOW (cosmetic):
- {marker}: {quote}
- ...

SUMMARY:
- AI markers found: {total}
- Burned words: {count}
- Estimated specificity rung: {average}
- Rhythm issues: {type + count}
- Tone detected: {tone} (confidence: XX%)

RECOMMENDED PIPELINE: {stages}
ESTIMATED EFFORT: {N} critical + {N} high items
```

### Severity Levels

| Level | Criteria |
|-------|----------|
| CRITICAL | Throat-clearing opener, conclusion regurgitation, 5+ burned words |
| HIGH | Fake transitions, hedging language, 3+ adjective pileups, symmetrical paragraphs |
| MEDIUM | Empty intensifiers, rhetorical question padding, rhythm monotony |
| LOW | Minor style issues, single burned word in edge case |

---

## INTEGRATION: RankWise + MindFluence

### With RankWise (SEO)
**Rule:** RankWise handles SEO structure → HumanAI handles human voice. Do not break SEO.

Preservation rules:
- Do NOT delete or alter H2/H3 headings containing SEO keywords
- Preserve keyword density 0.8%–1.5%
- Maintain min 600 words (unless user requests shorter)
- Keep internal link anchors and placement
- Skip deletion of keywords, internal links, schema-relevant elements during cleanup
- Meta title/description: already SEO-optimized, do not humanize

Recommended pipeline: `cleanup(skipped: SEO structure) → specificity → tone → rhythm → proofread`

### With MindFluence (Cognitive Bias)
**Rule:** MindFluence engineers persuasion → HumanAI humanizes voice. Do not strip psychological structure.

Tone mapping: `bold-sell` → `landing` · `expert-calm` → `expert` · `rebel-edgy` → `social` · `warm-human` → `human` · `luxe-minimal` → `case`

Preservation rules:
- Do NOT strip bias markers: social proof numbers, anchoring prices, authority signals
- Do NOT delete power words overlapping with burned-word lists — they serve psychological function
- Do NOT break hook openings — deliberately patterned for System 1 capture
- Preserve social proof specificity: "14,327 users this week" is bias marker, not fluff

Recommended pipeline: `cleanup(skipped: bias structure) → specificity → tone(skipped: MindFluence tone) → rhythm → proofread`

### Triple Pipeline
1. RankWise Brief → SEO structure
2. MindFluence → bias copy within SEO skeleton
3. HumanAI → humanize voice, preserving BOTH SEO signals AND bias structure
4. RankWise Audit → final 49-factor verification

HumanAI invocation: `cleanup(skipped: SEO+bias elements) → specificity → tone(skipped: from MindFluence) → rhythm → proofread`

---

## QUICK START

**Full pipeline:** "Rewrite this to sound human. Language: ru."

**Specific task — load scenario:** "Rewrite this as a landing page. DE." → load `scenarios/landing-page.md`

**Audit only:** "Tell me what's wrong with this. Don't rewrite."

**Translation fix:** "This was translated from Russian to English. Make it sound native."

---

## FILES & GITHUB URLS

### This skill is self-contained — the SKILL.md above embeds all critical rules and top-15 per-language data. For deep processing, the following files are available:

```
natural-skill/
├── SKILL.md                        ← This file — self-contained orchestrator (v4.0)
├── PLAN.md                         ← Improvement roadmap
├── README.md / README.ru.md        ← Documentation (bilingual)
├── EVAL.md                         ← External LLM evaluation framework
├── shared/                         ← Full data files (30+ words per list, 250-line tone profiles, cultural matrix)
├── scenarios/                      ← 15 task-specific playbooks
├── examples/                       ← Annotated before/after examples
├── scripts/                        ← Validation + external tools
└── tests/benchmark/                ← Evaluation dataset
```

### Deep data (GitHub raw URLs — fetch when task needs full lists):

| File | URL |
|------|-----|
| Full burned words × 9 languages | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/burned-words.md |
| Full AI markers × 9 languages | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/ai-markers.md |
| Full tone profiles (7 × 9) | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/tone-profiles.md |
| Specificity ladder (all examples) | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/specificity-ladder.md |
| Rhythm tables (full parameters) | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/rhythm-tables.md |
| Cultural matrix (9 languages) | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/cultural-matrix.md |
| EVAL framework | https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/EVAL.md |

### External validation tools (run separately — not LLM tasks):

| Script | Purpose |
|--------|---------|
| `scripts/validate.ps1` | Integrity checker for skill files (PowerShell) |
| `scripts/validate.sh` | Integrity checker for skill files (Bash) |
| `scripts/morph-check.ps1` | Morphological validator (non-existent words) |
| `scripts/readability-check.ps1` | ReadSightPy readability validator |
| `scripts/zerogpt-detect.ps1` | ZeroGPT AI detection (PowerShell) |
| `scripts/zerogpt-detect.sh` | ZeroGPT AI detection (Bash) |
| `scripts/run-benchmark.ps1` | Full benchmark runner (PowerShell) |
| `scripts/run-benchmark.sh` | Full benchmark runner (Bash) |
| `scripts/run-eval.ps1` | External EVAL.md LLM evaluation runner |
