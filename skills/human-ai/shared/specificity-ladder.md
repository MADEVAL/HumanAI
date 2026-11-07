# Specificity Ladder - Abstraction to Concrete

> **The Golden Question:** For every claim ask: *How, exactly?*
> **Target:** Every claim at rung 0-1 → rung 2+. Aim for rung 3 when data supports it.
> **No-invention rule:** You may supply plausible examples flagged [VERIFY]. You may NOT invent facts, statistics, names.

---

## The Ladder

| Rung | Type | Signal |
|------|------|--------|
| 0 | Pure abstraction | No evidence, no mechanism |
| 1 | Domain-scoped | Applies to X field / Y platform |
| 2 | Mechanism-named | Explains HOW |
| 3 | Quantified | Numbers attached |
| 4 | Consequence-stated | Shows the RESULT |

---

## Rung Examples by Language

### English
| Rung | Example |
|------|---------|
| 0 | "improves security" |
| 1 | "improves WordPress security" |
| 2 | "blocks brute-force login attacks" |
| 3 | "blocks 8,400 brute-force attempts/day on average" |
| 4 | "blocks 8,400 attacks/day - login page stays available for real users" |

### Russian
| Rung | Example |
|------|---------|
| 0 | «повышает безопасность» |
| 1 | «повышает безопасность WordPress» |
| 2 | «блокирует атаки перебора паролей» |
| 3 | «блокирует в среднем 8400 попыток перебора в день» |
| 4 | «блокирует 8400 попыток в день - страница входа остаётся доступной» |

### Ukrainian
| Rung | Example |
|------|---------|
| 0 | «підвищує безпеку» |
| 1 | «підвищує безпеку WordPress» |
| 2 | «блокує атаки перебору паролів» |
| 3 | «блокує в середньому 8400 спроб перебору на день» |
| 4 | «блокує 8400 спроб на день - сторінка входу залишається доступною» |

### German
| Rung | Example |
|------|---------|
| 0 | «verbessert Lieferzeiten» |
| 1 | «verbessert Lieferzeiten im Online-Handel» |
| 2 | «bündelt Bestellungen und optimiert Routen automatisch» |
| 3 | «verkürzt Auslieferung von 3 Tagen auf 4 Stunden» |
| 4 | «Lieferung in 4h statt 3 Tagen - Retourenquote sank um 22%, Stammkundenbestellungen stiegen um 40%» |

### French
| Rung | Example |
|------|---------|
| 0 | «améliore l'expérience client» |
| 1 | «améliore l'expérience en magasin» |
| 2 | «réduit le temps d'attente en caisse» |
| 3 | «réduit l'attente de 7 à 2 minutes par client» |
| 4 | «attente réduite de 7 à 2 min - le client suivant voit un caissier libre, pas une file» |

### Spanish
| Rung | Example |
|------|---------|
| 0 | «mejora la productividad» |
| 1 | «mejora la productividad administrativa» |
| 2 | «automatiza la generación de informes semanales» |
| 3 | «reduce 12 horas de papeleo semanal a 3 horas» |
| 4 | «12h a 3h de papeleo semanal - el equipo recupera un día entero de trabajo cada semana» |

### Portuguese
| Rung | Example |
|------|---------|
| 0 | «aumenta vendas» |
| 1 | «aumenta vendas no e-commerce» |
| 2 | «integra PIX e mostra frete em tempo real» |
| 3 | «cresceu de 40 para 127 pedidos/dia em 3 meses» |
| 4 | «de 40 a 127 pedidos/dia - taxa de abandono de carrinho caiu de 68% para 12%» |

### Italian
| Rung | Example |
|------|---------|
| 0 | «ottimizza la produzione» |
| 1 | «ottimizza la linea di imbottigliamento» |
| 2 | «riduce gli scarti regolando temperatura e velocità» |
| 3 | «riduce scarti del 18% nella linea di imbottigliamento» |
| 4 | «-18% scarti sulla linea - risparmio di 47.000 euro/anno in materia prima [VERIFY]» |

### Polish
| Rung | Example |
|------|---------|
| 0 | «usprawnia obsługę klienta» |
| 1 | «usprawnia obsługę w dziale supportu» |
| 2 | «automatyzuje odpowiedzi na najczęstsze zapytania» |
| 3 | «skraca czas odpowiedzi z 48h do 4h, automatyzując 70% zapytań» |
| 4 | «odpowiedź w 4h zamiast 48h - 70% spraw zamkniętych w pierwszej wiadomości, bez eskalacji» |

---

## Abstraction Detector (EN - applies to all languages with equivalent words)

Scan for these triggers:
- "improves" / "enhances" / "boosts" / "increases" (without a number or mechanism)
- "efficient" / "productivity" / "performance" / "quality" (without measurement)
- "solution" / "platform" / "ecosystem" / "framework" (without concrete description)
- "state-of-the-art" / "advanced" / "modern" / "sophisticated" (without specifics)
- "better" / "faster" / "stronger" / "smarter" (without comparison point)
- "helps you" / "allows you to" / "enables" (without saying HOW)
- "user-friendly" / "intuitive" / "easy to use" (without saying what makes it so)
- "comprehensive" / "complete" / "end-to-end" / "all-in-one" (without what's included)
- "real-time" (without saying what happens in real time)
- "scalable" (without saying to what scale or how)

---

## Six Enrichment Techniques

### 1. Show-Don't-Tell Swap
Bad: "Our support is fast and helpful."
Good: "We reply within 4 hours. Weekends too. Most issues solved in one reply."

### 2. Mechanism Reveal
Bad: "The algorithm detects anomalies."
Good: "The algorithm compares each new data point against the 90-day rolling average. Points outside 2.5 standard deviations get flagged."

### 3. Number Injection
Bad: "handles thousands of requests per second"
Good: "handles ~12,000 requests/sec under normal load [VERIFY: confirm actual throughput]"

### 4. Scenario Example (micro-story)
Bad: "The tool helps prevent shipping errors."
Good: "A warehouse worker scans a box. The tablet shows a green check - right item, right address. Last month that happened 37 times."

### 5. Comparison Ground
Bad: "Fast."
Good: "Loads under 200ms. Industry average for similar tools: 800ms."

### 6. Negative Space Detail
Bad: "A complete development platform."
Good: "We build your backend, API, database. We don't build your mobile app. We have partners for that. We'll connect you."

---

## Verify Flag Format

- EN: `[VERIFY: what needs checking]`
- RU: `[ПРОВЕРИТЬ: что нужно уточнить]`
- UK: `[ПЕРЕВІРИТИ: що потрібно уточнити]`
- DE: `[PRÜFEN: was zu klären ist]`
- FR: `[VÉRIFIER: ce qui doit être confirmé]`
- ES: `[VERIFICAR: qué necesita confirmación]`
- PT: `[VERIFICAR: o que precisa ser confirmado]`
- IT: `[VERIFICARE: cosa va confermato]`
- PL: `[SPRAWDZIĆ: co wymaga potwierdzenia]`
