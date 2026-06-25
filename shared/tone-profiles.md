# Tone Profiles - 7 Voices Across All Languages

> Every text has a speaker. These profiles define who's speaking.

---

## Fragment & Conjunction Frequencies (all languages)

Use these as qualitative targets, not exact word-based metrics (LLMs cannot count words reliably).

| Tone | Fragment spacing | Conjunction spacing | Short sent. every |
|------|-----------------|---------------------|-------------------|
| expert | Every 5-7 sentences | Every 5-7 sentences | 5-7 sentences |
| biz | Rare (1-2 per text) | Rare (1-2 per text) | 6-8 sentences |
| human | Every 3-5 sentences | Every 3-5 sentences | 3-5 sentences |
| social | Every 2-3 sentences | Every 2-4 sentences | 2-3 sentences |
| landing | Every 3-4 sentences | Every 5-7 sentences | 3-4 sentences |
| article | Every 4-6 sentences | Every 4-6 sentences | 4-6 sentences |
| case | Every 4-5 sentences | Every 4-6 sentences | 4-5 sentences |

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

**FR markers:** Précision sans rhétorique. Phrases déclaratives: «On a testé. Voilà ce qui marche.» Pas d'enthousiasme forcé. Le subjonctif avec parcimonie (trop de «il faut que» = AI). Préférer «on» à «nous» pour garder la distance professionnelle sans froideur. Éviter «force est de constater», «il convient de noter».

**ES markers:** Directo, sin adornos. «Probamos X. Funcionó. Aquí están los datos.» Jerga técnica solo si la audiencia la comparte. Cuidado con el gerundio excesivo: «estamos optimizando» es AI tell cuando es sistemático. Usar presente simple: «optimizamos». Evitar «el mismo/la misma» como pronombre (calco del inglés «the same»). Subjuntivo natural, no forzado. Regionalismos según audiencia: «vosotros» (ES), «ustedes» (LATAM).

**PT markers:** Direto, sem firulas. PT-BR: «A gente testou. Rodou. Tá funcionando.» - auto-depreciação leve é sinal humano, não falta de profissionalismo. PT-EU: «Testámos. Funcionou. Está estável.» - mais contido. Evitar «o mesmo/a mesma» como pronome (calque do inglês). Gerúndio brasileiro («estamos testando») é NATURAL, não é AI tell. Gerúndio europeu («estamos a testar») idem. «Através de» frequentemente substituível por «com» ou «por».

**IT markers:** Preciso, senza entusiasmo. «Abbiamo provato X. Ha funzionato. Ecco perché.» Gergo tecnico solo se il pubblico lo condivide. «Allora» e «cioè» come connettori naturali (1-2 per paragrafo). Attenzione al «si passivante»: «si rende necessario» è AI tell, sostituire con voce attiva. Evitare «lo stesso/la stessa» come pronome. Periodi lunghi ok in italiano (tollerati più che in inglese), ma variare la lunghezza.

**PL markers:** Precyzja ponad entuzjazm. «Przetestowaliśmy. Działa. Oto dlaczego.» Żargon techniczny tylko jeśli odbiorca zna. Naturalne wtrącenia: «w sumie», «właściwie», «po prostu» w umiarkowanych dawkach (1 na 150-200 słów). Unikać nadmiernej nominalizacji («przeprowadzenie optymalizacji» → «optymalizujemy»). Końcówki -ować nie są automatycznie AI, ale ich nagromadzenie tak.

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

**FR markers:** Vous toujours. Direct, factuel. «Voici ce que nous faisons. Voici les résultats.» Structure: problème → solution → chiffres. Pas de «nous sommes ravis», «notre mission». Le futur simple, pas le conditionnel: «nous livrerons» pas «nous pourrions livrer». Éviter les formules de politesse vides: «nous avons le plaisir de», «dans le cadre de». Chiffres en contexte: pas juste «30%», mais «30% de réduction du temps de traitement, mesuré sur 6 mois».

**ES markers:** Usted siempre. Directo, basado en datos. «Esto hacemos. Estos son los resultados.» Estructura: problema → enfoque → métricas. Sin «nos complace», «nuestra misión». Datos con fuente: «según nuestra medición trimestral». En Latinoamérica, «usted» mantiene profesionalismo sin distancia excesiva. Evitar «sin embargo» y «no obstante» como conectores cada dos frases: variar con punto y frase nueva.

**PT markers:** Você/Senhor(a) sempre. Direto, com dados. «Fazemos isso. Aqui estão os resultados.» Sem «temos o prazer», «nossa missão». PT-BR: «você» é padrão B2B, «senhor(a)» apenas em contextos muito formais. PT-EU: «o senhor/a senhora» ou tratamento pelo cargo. Dados com período de referência: «redução de 40% no tempo de resposta (jan-mar 2025)». Evitar «através de» quando «com» basta.

**IT markers:** Lei sempre. Diretto, fattuale. «Ecco cosa facciamo. Questi sono i costi.» No «siamo lieti», «la nostra missione». Dati con contesto: «+22% di fatturato YoY (misurato su 3 trimestri)». Struttura chiara: situazione → intervento → risultato → prossimo passo. Evitare «non si può non notare», «è doveroso sottolineare». Il Lei formale è standard B2B italiano, non suona distante.

**PL markers:** Pan/Pani zawsze. Konkretnie, z danymi. «Oto co robimy. Oto koszty.» Bez «z przyjemnością», «naszą misją jest». Polski B2B ceni konkret ponad wszystko. Dane z datą: «wzrost o 35% r/r (dane za Q1-Q3 2025)». Unikać: «w ramach», «w zakresie», «w odniesieniu do» — zastąpić konkretnym czasownikiem. «Szanowni Państwo» tylko w pierwszym kontakcie, potem przejść do rzeczy.

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

**FR markers:** Naturel, conversationnel. «Tu» en contexte informel, «vous» sinon. «Du coup», «en fait», «franchement» en dose naturelle (1 tous les 150-200 mots). Une question rhétorique de temps en temps: «Vous voyez le problème?» Pas de formalisme excessif. Le vrai français parlé n'est pas celui des dissertations. Éviter le plan en trois parties. Une digression personnelle légère est un signal humain, pas une erreur.

**ES markers:** Cálido, directo. «Tú» en informal, «usted» en profesional — pero incluso con «usted» se puede ser cálido. «La verdad», «mira», «pues» como conectores naturales. Frases cortas mezcladas con explicaciones más largas. El español hablado usa muchas más preguntas que el escrito: «¿Y sabes qué pasó?» funciona. Evitar el tono de ensayo académico. Regionalismos bienvenidos si cuadran con la audiencia.

**PT markers:** Caloroso, direto. PT-BR: «Olha», «na real», «tipo assim» em dose natural. «A gente» em vez de «nós» para tom conversacional. Frases curtas intercaladas com explicações. PT-EU: tom ligeiramente mais contido mas ainda próximo. «Portanto» e «contudo» guardar para textos formais — aqui usar «então» e «mas». Um toque de humor auto-depreciativo é sinal humano em ambas as variantes.

**IT markers:** Caldo, diretto. «Tu» in informale, «Lei» in professionale. «Allora», «cioè», «sai com'è», «guarda» come connettori naturali (1-2 per paragrafo). Domande retoriche ogni tanto: «Ha senso?» Meno «si passivante»: «si può notare» → «nota che». Una battuta o osservazione personale leggera distingue l'umano dall'AI. Il ritmo italiano parlato è più veloce e frammentato dello scritto formale.

**PL markers:** Ciepły, bezpośredni. «Ty» w nieformalnych, «Pan/Pani» w profesjonalnych — ale nawet z «Pan/Pani» można być naturalnym. «No wiesz», «szczerze mówiąc», «w sumie», «po prostu» w naturalnych dawkach. Polak w rozmowie używa więcej pytań i wtrąceń niż w piśmie. Dopuszczalna lekka autodeprecjacja. Unikać szablonu «wstęp-rozwinięcie-zakończenie». Naturalne przejścia: «No i co z tego?», «I teraz uwaga», «A właśnie» zamiast «ponadto», «należy zauważyć».

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

**FR markers:** Percutant, rythmé. Accroche en première ligne, pas de contexte. Français des réseaux: plus court que l'écrit formel, plus de questions directes. «Le problème?» «La solution?» Verlan avec parcimonie (1 max par post, si audience française). Phrases de 3-8 mots dominantes. Une plus longue pour l'explication. Pas de «n'hésitez pas à», «dans cet article nous allons». Commencer par le constat, finir par la conséquence.

**ES markers:** Gancho, opinión, cierre. Español de redes: directo, cercano. «Mira.» «El problema es este.» Sin rodeos. Frases de 3-10 palabras. Hashtags solo si nativos de la plataforma. El español de LinkedIn es más formal que Twitter/Instagram — ajustar. En Latinoamérica, más emoción es aceptable. En España, más ironía. Una pregunta al final para engagement: «¿A ti te ha pasado?»

**PT markers:** Gancho, opinião, fecho. PT-BR de redes: «Olha só.» «O problema é esse.» Sem enrolação. Frases curtas (3-10 palavras), máxima 1 longa para contexto. Brasileiro de internet é informal até no LinkedIn — «você» e contrações («pra», «tá») são naturais. Emoji com moderação (1-2). PT-EU: ligeiramente mais contido mas ainda direto. Terminar com pergunta ou provocação, não com resumo.

**IT markers:** Hook, opinione, chiusura. Italiano social: diretto, coinvolgente. «Guarda.» «Il punto è questo.» Frasi 3-10 parole. Una domanda secca funziona: «Ti è mai successo?» LinkedIn Italia è più formale di Twitter/Instagram — «Lei» può restare ma il tono è più diretto del testo aziendale. Niente «non esitate a contattarci». Chiudere con un'osservazione che fa riflettere, non con un riassunto.

**PL markers:** Haczyk, opinia, puenta. Polski w social media: bezpośredni, z charakterem. «Słuchaj.» «Rzecz w tym, że...» Krótkie zdania (3-10 słów). Polak w internecie ceni konkret i nie boi się opinii. Ironia i sarkazm działają (z umiarem). LinkedIn Polska: bardziej profesjonalny ale nie sztywny. Zakończenie: mocna puenta albo pytanie do czytelnika. Nie: «zapraszamy do kontaktu», «link w bio».

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

**FR markers:** Pages d'atterrissage françaises: concises, bénéfices clairs. «Commencez» pas «N'attendez plus». «Essayez gratuitement» pas «Profitez de notre offre». Confiance par les preuves: chiffres, logos clients (si réels), certification. Pas de superlatifs vides. Structure: problème → notre solution → résultat concret → CTA. Éviter le jargon marketing anglicisé: «scalable», «disruptif», «holistique». Préférer: «qui grandit avec vous», «qui change la donne», «complet».

**ES markers:** Landing pages en español: concisas, beneficio claro. «Empieza ya» no «No esperes más». «Pruébalo gratis» no «Descubre nuestra oferta». Confianza con hechos, no entusiasmo. Estructura: dolor → alivio → prueba → acción. En España, tono más directo. En Latinoamérica, ligeramente más cálido pero sin perder concisión. Eliminar «bienvenido a», «nos complace presentar». Cada palabra debe responder «¿por qué debería importarme?»

**PT markers:** Landing pages em português: concisas, benefício claro. «Comece agora» não «Não espere mais». «Teste grátis» não «Aproveite nossa oferta». Confiança por fatos, não entusiasmo. PT-BR: tom mais energético aceitável («acabe com», «chega de»). PT-EU: mais contido, fatos falam mais que adjetivos. Estrutura: problema → como resolvemos → prova → CTA. Cortar 40-60% do texto original. Cada frase deve responder: «o que eu ganho com isso?»

**IT markers:** Landing page italiane: concise, beneficio chiaro. «Inizia ora» non «Non aspettare». «Prova gratuita» non «Scopri la nostra offerta». Fiducia con i fatti, non l'entusiasmo. Italiani diffidano dei superlativi — più dati, meno aggettivi. Struttura: problema → soluzione → evidenza → CTA. Niente «benvenuti in», «siamo orgogliosi di». Tagliare il 40-60%. Ogni frase deve rispondere a: «cosa ci guadagno?»

**PL markers:** Polskie landing page: konkretne, korzyść na pierwszym planie. «Zacznij teraz» nie «Nie czekaj». «Wypróbuj za darmo» nie «Skorzystaj z naszej oferty». Zaufanie przez fakty, nie entuzjazm. Polak sprawdza konkrety zanim kupi — dane, certyfikaty, referencje. Struktura: problem → nasze rozwiązanie → dowód → CTA. Ciąć bezlitośnie: polskie strony często cierpią na nadmiar tekstu. Każde zdanie niech odpowiada na: «co ja z tego mam?»

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

**FR markers:** Articles longs en français: pas académiques. «Regardons les données.» «Mais il y a un hic.» Pas de plan en trois parties imposé. Structure naturelle: question → exploration → découverte. Le français écrit formel aime les phrases longues — résister. Varier: phrase courte de 5 mots, puis explication de 25. Section breaks avec des questions: «Pourquoi ça marche?» Éviter «en effet», «en outre», «par ailleurs» comme béquilles. Une opinion personnelle de l'auteur est un signal humain.

**ES markers:** Artículos largos en español: no académicos. «Veamos los datos.» «Pero hay una trampa.» Estructura natural, no plantilla. El español permite frases largas — variar con cortas cada 4-6 frases. Usar preguntas como rupturas de sección. Evitar «en primer lugar», «en segundo lugar», «finalmente». Conectores naturales: «y entonces», «pero resulta que», «la cuestión es». Una anécdota personal al inicio es más humana que una definición.

**PT markers:** Artigos longos em português: não acadêmicos. «Vejamos os dados.» «Mas tem um porém.» Estrutura natural, não template. PT-BR: tom de conversa inteligente, não de monografia. PT-EU: ligeiramente mais estruturado mas ainda coloquial. Perguntas como quebras de seção. Evitar «primeiramente», «em segundo lugar», «por fim». Transições naturais: «e aí», «acontece que», «o ponto é». Uma história pessoal ou observação do autor diferencia o humano da máquina.

**IT markers:** Articoli lunghi in italiano: non accademici. «Guardiamo i dati.» «Ma c'è un problema.» Struttura naturale, non template. Italiano accademico è riconoscibile: troppi «nonostante», «sebbene», «tuttavia» = AI. Sostituire con frasi più brevi e dirette. Domande come stacchi di sezione: «E quindi?» «Cosa significa in pratica?» Connettori naturali: «e allora», «il fatto è che», «guardiamo meglio». Un'osservazione laterale personale («a proposito...») è umana, non è digressione da tagliare.

**PL markers:** Długie artykuły po polsku: nie akademickie. «Spójrzmy na dane.» «Ale jest haczyk.» Naturalna struktura, nie szablon. Polski tekst akademicki używa strony biernej i nominalizacji — unikać. Pytania jako przerywniki sekcji: «Dlaczego?» «Co z tego wynika?» Naturalne łączniki: «i wtedy», «tylko że», «w czym rzecz». Unikać: «po pierwsze», «po drugie», «podsumowując». Osobista refleksja autora («zauważyłem, że...») odróżnia człowieka od AI.

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

**FR markers:** L'honnêteté crée la confiance. «La première approche a échoué. L'API nous limitait. Le traitement par lots a fonctionné.» Des chiffres, pas des adjectifs. Structure: contexte → problème → échec → solution → résultat → leçon. Les français apprécient la transparence sur les difficultés. Pas de «solution miracle», «résultats exceptionnels». Chiffres en contexte temporel: «en 3 mois», «sur 6 sprints».

**ES markers:** Honestidad = credibilidad. «El primer enfoque no funcionó. La API nos limitaba. Cambiamos a procesamiento por lotes. Funcionó.» Estructura clara con el fracaso intermedio. En España y Latinoamérica, admitir un error bien manejado genera más confianza que un relato perfecto. Cifras con antes/después. Sin «implementación perfecta», «resultados sobresalientes». Lecciones al final: ¿qué haríamos diferente?

**PT markers:** Honestidade = credibilidade. «A primeira abordagem falhou. A API nos limitou. Mudamos para processamento em lote. Funcionou.» Brasileiros valorizam transparência e «jeitinho» — a solução criativa depois do fracasso. Portugueses: fatos e números falam mais que narrativa. Estrutura: contexto → problema → tentativa frustrada → solução → métricas → aprendizado. Sem «resultados excepcionais», «superou expectativas». O que aprendemos é mais valioso que o resultado.

**IT markers:** Onestà = credibilità. «Il primo approccio non ha funzionato. L'API ci limitava. Siamo passati al batch. Ha funzionato.» Italiani rispettano chi ammette le difficoltà. Struttura: contesto → problema → primo tentativo (fallito) → soluzione → numeri → lezione. Dati con periodo: «in 8 settimane», «dal Q2 al Q3». Mai «implementazione impeccabile». La lezione appresa è la parte più importante del caso.

**PL markers:** Szczerość buduje zaufanie. «Pierwsze podejście nie zadziałało. API nas limitowało. Przeszliśmy na batch. Zadziałało.» Polacy cenią konkret i nie lubią lukrowania. Struktura: kontekst → problem → nieudana próba → rozwiązanie → liczby → wnioski. Dane z kontekstem czasowym: «w ciągu 2 miesięcy», «porównanie Q1 vs Q2». Bez «spektakularny sukces», «ponad oczekiwania». Wnioski i nauczki są ważniejsze od suchych liczb.
