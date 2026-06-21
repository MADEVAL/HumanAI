# Tone Profiles - 7 Voices Across All Languages

> Every text has a speaker. These profiles define who's speaking.

---

## Fragment & Conjunction Frequencies (all languages)

| Tone | Fragments /100w | Conjunction openers /100w | Short sent. every |
|------|-----------------|---------------------------|-------------------|
| expert | 0.5–1 | 1–2 | 5–7 sentences |
| biz | 0–0.5 | 0–1 | 6–8 sentences |
| human | 1–2 | 2–4 | 3–5 sentences |
| social | 1.5–3 | 2–3 | 2–3 sentences |
| landing | 1–1.5 | 1–2 | 3–4 sentences |
| article | 0.5–1 | 1.5–3 | 4–6 sentences |
| case | 0.5–1 | 1–2 | 4–5 sentences |

---

## Tone Selection Priority

1. User-specified tone - always honored
2. Context auto-detection (see table below)
3. Default fallback → `human`

| Content type | Default tone |
|-------------|-------------|
| Technical docs, API docs, deep analysis | expert |
| B2B website, service page, proposal, offer | biz |
| Blog post, personal website, about page, email | human |
| LinkedIn, Twitter/X, Telegram, Instagram | social |
| Product page, SaaS landing, sales page, promo | landing |
| Long-form guide, tutorial, analysis, article | article |
| Portfolio, success story, client result, case study | case |

---

## Profile 1: `expert` - The Practitioner

**Who's speaking:** 10+ years in the field. Knows the edge cases. Not showing off. Just explaining.

**Universal signature:**
- Precision over enthusiasm
- Short declarative sentences + detailed explanations
- Jargon used correctly, not performatively
- No motivational language. No «we're excited». No «imagine the possibilities»

**EN markers:**
- Moderate contractions: "we'll", "it's" - yes. "gonna", "kinda" - no
- Opener style: "The problem is...", "Here's what happens...", "Most people miss..."
- Sentence length: 4-12w (short) mixed with 18-30w (explanation)

**RU markers:** Brevity respected - shorter sentences than EN. Technical terms in English or Russian per industry norm. Ми default. Minimal adjectives.

**UK markers:** Clean technical Ukrainian - no Russianisms. Slightly warmer than RU at baseline but precise. Technical terms: English loanwords fine in tech context. Ми default.

**DE markers:** Direkte Sprache. Kein Nominalstil. «Wir haben getestet. Es funktioniert.» Minimal adjectives - facts carry weight.

**FR markers:** Précision sans rhétorique. Phrases déclaratives. «On a testé. Voilà ce qui marche.» Pas d'enthousiasme forcé.

**ES markers:** Directo, sin adornos. «Probamos X. Funcionó. Aquí están los datos.» Jerga técnica solo si la audiencia la comparte.

**PT markers:** Direto, sem firulas. «Testamos. Funcionou. Aqui estão os números.» Termos técnicos: use se a audiência entender. Senão, explique.

**IT markers:** Preciso, senza entusiasmo. «Abbiamo provato X. Ha funzionato. Ecco perché.» Gergo tecnico: solo se il pubblico lo condivide. Altrimenti spiega.

**PL markers:** Precyzja ponad entuzjazm. «Przetestowaliśmy. Działa. Oto dlaczego.» Żargon techniczny - tylko jeśli odbiorca zna. Jeśli nie - wyjaśnij.

---

## Profile 2: `biz` - The Consultant

**Who's speaking:** Senior person at a firm. Serious. Direct. Time is money.

**Universal signature:**
- No small talk. No warm-up
- Claims with evidence. Numbers with context
- Politeness through clarity, not pleasantries

**EN markers:** Limited contractions: "we're", "it's" - yes. "don't" - sparingly. Sentence length 8-22w. No: "partner with us", "journey", "passionate about".

**RU markers:** Вы always. Minimal emotional language. Direct questions fine: «Что вы хотите получить через 6 месяцев?» No: «рады предложить», «с удовольствием».

**UK markers:** Ви always. European business style - cleaner, less bureaucratic than post-Soviet. No: «раді запропонувати», «наша місія».

**DE markers:** Sie immer. Direkt, sachlich. «Hier ist was wir machen. Hier sind die Kosten.» Kein: «wir freuen uns», «unsere Mission».

**FR markers:** Vous toujours. Direct, factuel. «Voici ce que nous faisons. Voici les résultats.» Pas de: «nous sommes ravis», «notre mission».

**ES markers:** Usted siempre. Directo, basado en datos. «Esto hacemos. Estos son los resultados.» Sin: «nos complace», «nuestra misión».

**PT markers:** Você/Senhor sempre. Direto, com dados. «Fazemos isso. Aqui estão os resultados.» Sem: «temos o prazer», «nossa missão».

**IT markers:** Lei sempre. Diretto, fattuale. «Ecco cosa facciamo. Questi sono i costi.» No: «siamo lieti», «la nostra missione».

**PL markers:** Pan/Pani zawsze. Konkretnie, z danymi. «Oto co robimy. Oto koszty.» Bez: «z przyjemnością», «naszą misją jest».

---

## Profile 3: `human` - The Smart Friend

**Who's speaking:** A competent person explaining over coffee. Warm. Direct. Occasionally funny.

**Universal signature:**
- High variance: fragments, run-ons, asides
- Opinions stated as opinions, not balanced analysis
- Self-awareness: acknowledges limitations, mistakes

**EN markers:** All contractions including "gonna" (max 1/500w). Sentence length 2w to 30+. Conjunction starters freely. Parenthetical asides 1-2 per section.

**RU markers:** Thinner line between warm/unprofessional. Stay slightly more formal than EN. Default вы (ты only for very informal social). Fragments work: «Сделали. Работает. Смотрим дальше.» Fillers: «кстати», «честно говоря», «давайте разберёмся» - 1-2 per 300w.

**UK markers:** Naturally warmer than RU at baseline. More conversational allowed without losing credibility. Fillers: «до речі», «чесно кажучи», «давайте розберемось», «тут важливий момент». Ukrainian conversational rhythm: shorter phrases, more melodic flow.

**DE markers:** Etwas wärmer als biz. «Du» nur in informellen Kontexten, sonst «Sie». Natürliche Modalpartikeln: «doch», «ja», «halt». Kein: «man sollte», «es empfiehlt sich».

**FR markers:** Naturel, conversationnel. «Tu» en contexte informel, «vous» sinon. «Du coup», «en fait», «franchement» en dose naturelle. Pas de formalisme excessif.

**ES markers:** Cálido, directo. «Tú» en informal, «usted» en profesional. «La verdad», «mira», «pues» como conectores naturales. Sin academicismos.

**PT markers:** Caloroso, direto. «Você» ok, «tu» em PT-BR informal. «Olha», «na real», «tipo assim» em dose natural. Sem formalismos desnecessários.

**IT markers:** Caldo, diretto. «Tu» in informale, «Lei» in professionale. «Allora», «cioè», «sai» come connettori naturali. Meno «si passivante».

**PL markers:** Ciepły, bezpośredni. «Ty» w nieformalnych, «Pan/Pani» w profesjonalnych. «No wiesz», «szczerze mówiąc», «w sumie» naturalnie. Mniej nominalizacji.

---

## Profile 4: `social` - The Scroller

**Who's speaking:** Someone who knows how to stop a thumb. Punchy. Opinionated.

**Universal signature:**
- Opening line is a HOOK, not a headline
- Short paragraphs: 1-3 sentences
- Opinion stated as fact. No hedging
- Ends with a punch, not a summary
- No: emoji overload, hashtags, «thread 🧵», «link in bio»

**EN markers:** Sentence length 3-12w mostly. One longer for explanation. All contractions. Fragments encouraged.

**RU markers:** Confidence sells - but overconfidence annoys. Measured confidence. Russian social is more direct than English. Self-irony works. Short lines, big claims, sharp transitions.

**UK markers:** Ukrainian social media tends more emotional, community-oriented. Warmth works well. Directness fine but less aggressive than RU. Shorter paragraphs than EN equivalent. Natural conversational flow.

**DE markers:** Kurz, prägnant, meinungsstark. Deutsche Social-Media-Sprache: direkter als EN. Keine langen Einleitungen. «Los geht's.» «Das ist der Punkt.»

**FR markers:** Percutant, rythmé. Accroche en première ligne. Français des réseaux: plus court que l'écrit formel. Verlan avec parcimonie.

**ES markers:** Gancho, opinión, cierre. Español de redes: directo, cercano. «Mira.» «El problema es este.» Sin rodeos.

**PT markers:** Gancho, opinião, fecho. Português de redes: direto, próximo. «Olha só.» «O problema é esse.» Sem enrolação.

**IT markers:** Hook, opinione, chiusura. Italiano social: diretto, coinvolgente. «Guarda.» «Il punto è questo.»

**PL markers:** Haczyk, opinia, puenta. Polski w social media: bezpośredni, z charakterem. «Słuchaj.» «Rzecz w tym.»

---

## Profile 5: `landing` - The Seller

**Who's speaking:** Confident product person. Every word earns its pixel space.

**Universal signature:**
- Headline <12 words. Subhead <20. CTA: action verb + benefit
- Above the fold: what it is + who it's for + what happens next
- Features framed as benefits
- No: "Welcome to", "We are excited to announce", "Our mission is"

**EN markers:** Very tight. "Start building" not "Get started today". "See how it works" not "Learn more". Fragments 1-1.5/100w.

**RU markers:** Russian landing pages suffer from over-explanation. Cut 30% then cut 30% more. CTAs: infinitive or imperative - pick one, stay consistent. Trust through specifics, not enthusiasm.

**UK markers:** Ukrainian audiences respond to clarity over embellishment. Cut aggressively. CTAs consistent in form. Довіра через конкретику, не ентузіазм.

**DE markers:** Deutsche Landingpages: direkt, sachlich. «Jetzt starten» nicht «Starten Sie noch heute». Vertrauen durch Fakten, nicht Begeisterung.

**FR markers:** Pages d'atterrissage françaises: concises, bénéfices clairs. «Commencez» pas «N'attendez plus». Confiance par les preuves, pas l'enthousiasme.

**ES markers:** Landing pages en español: concisas, beneficio claro. «Empieza ya» no «No esperes más». Confianza con hechos, no entusiasmo.

**PT markers:** Landing pages em português: concisas, benefício claro. «Comece agora» não «Não espere mais». Confiança por fatos, não entusiasmo.

**IT markers:** Landing page italiane: concise, beneficio chiaro. «Inizia ora» non «Non aspettare». Fiducia con i fatti, non l'entusiasmo.

**PL markers:** Polskie landing page: konkretne, korzyść na pierwszym planie. «Zacznij teraz» nie «Nie czekaj». Zaufanie przez fakty, nie entuzjazm.

---

## Profile 6: `article` - The Explainer

**Who's speaking:** Someone who explored a topic and shares what they found. Educational, not academic.

**Universal signature:**
- Opens with the problem, not the context
- Explores, tests, concludes - no template structure
- Sections flow by topic logic
- Ends when exploration ends. No «in conclusion»
- No: "Firstly, secondly, thirdly", "This article will explore"

**EN markers:** Sentence length varies by section. Intros shorter, deep dives longer. Natural transitions: "Let's look at the data." "But there's a catch."

**RU markers:** Russian long-form tends academic - fight this. Write like explaining to a smart colleague. Section breaks with questions: «Почему так происходит?» Avoid dissertation tone: passive, reflexive verbs, abstract nouns.

**UK markers:** Ukrainian long-form developing its non-academic voice. More European, less Soviet baggage. Natural section flow. Questions as section breaks work well.

**DE markers:** Deutsche Langtexte: nicht akademisch. «Schauen wir uns die Daten an.» «Aber es gibt einen Haken.» Kein: «Erstens, zweitens, drittens».

**FR markers:** Articles longs en français: pas académiques. «Regardons les données.» «Mais il y a un hic.» Pas de plan en trois parties imposé.

**ES markers:** Artículos largos en español: no académicos. «Veamos los datos.» «Pero hay una trampa.» Estructura natural, no plantilla.

**PT markers:** Artigos longos em português: não acadêmicos. «Vejamos os dados.» «Mas tem um porém.» Estrutura natural, não template.

**IT markers:** Articoli lunghi in italiano: non accademici. «Guardiamo i dati.» «Ma c'è un problema.» Struttura naturale, non template.

**PL markers:** Długie artykuły po polsku: nie akademickie. «Spójrzmy na dane.» «Ale jest haczyk.» Naturalna struktura, nie szablon.

---

## Profile 7: `case` - The Case Study

**Who's speaking:** Someone who did the work and is reporting back. Honest about failures.

**Universal signature:**
- Context → Problem → Attempt 1 (failed) → Attempt 2 (worked) → Numbers → Lessons
- Honesty is the differentiator. Include what went wrong
- Numbers non-negotiable. Before/after. Specifics
- No: "seamless implementation", "exceeded expectations", "delighted the client"

**EN markers:** "The first approach didn't work. The API rate-limited us. We switched to batch processing. That worked."

**RU markers:** Russian case studies tend to skip failures - include them. Builds massive trust. Specific technical details respected. Client quotes: keep them real or don't use them.

**UK markers:** Include failures. Same logic as RU. Ukrainian business culture appreciates directness. Numbers + honest narrative = trust. Не приховуйте невдачі - це будує довіру.

**DE markers:** Ehrlichkeit baut Vertrauen. «Der erste Ansatz scheiterte. Die API hat uns limitiert. Batch-Verarbeitung löste es.» Zahlen, nicht Adjektive.

**FR markers:** L'honnêteté crée la confiance. «La première approche a échoué. L'API nous limitait. Le traitement par lots a fonctionné.» Des chiffres, pas des adjectifs.

**ES markers:** Honestidad = credibilidad. «El primer enfoque no funcionó. La API nos limitaba. Cambiamos a procesamiento por lotes. Funcionó.»

**PT markers:** Honestidade = credibilidade. «A primeira abordagem falhou. A API nos limitou. Mudamos para processamento em lote. Funcionou.»

**IT markers:** Onestà = credibilità. «Il primo approccio non ha funzionato. L'API ci limitava. Siamo passati al batch. Ha funzionato.»

**PL markers:** Szczerość buduje zaufanie. «Pierwsze podejście nie zadziałało. API nas limitowało. Przeszliśmy na batch. Zadziałało.»
