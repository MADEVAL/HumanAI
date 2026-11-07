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
| 0 | «verbessert die Sicherheit» |
| 1 | «verbessert die WordPress-Sicherheit» |
| 2 | «blockiert Brute-Force-Login-Angriffe» |
| 3 | «blockiert durchschnittlich 8.400 Brute-Force-Versuche pro Tag» |
| 4 | «blockiert 8.400 Angriffe/Tag - Login-Seite bleibt für echte Nutzer erreichbar» |

### French
| Rung | Example |
|------|---------|
| 0 | «améliore la sécurité» |
| 1 | «améliore la sécurité WordPress» |
| 2 | «bloque les attaques par force brute» |
| 3 | «bloque en moyenne 8 400 tentatives par jour» |
| 4 | «bloque 8 400 attaques/jour - la page de connexion reste disponible» |

### Spanish
| Rung | Example |
|------|---------|
| 0 | «mejora la seguridad» |
| 1 | «mejora la seguridad de WordPress» |
| 2 | «bloquea ataques de fuerza bruta» |
| 3 | «bloquea un promedio de 8.400 intentos por día» |
| 4 | «bloquea 8.400 ataques/día - la página de inicio sigue disponible» |

### Portuguese
| Rung | Example |
|------|---------|
| 0 | «melhora a segurança» |
| 1 | «melhora a segurança do WordPress» |
| 2 | «bloqueia ataques de força bruta» |
| 3 | «bloqueia em média 8.400 tentativas por dia» |
| 4 | «bloqueia 8.400 ataques/dia - página de login continua disponível» |

### Italian
| Rung | Example |
|------|---------|
| 0 | «migliora la sicurezza» |
| 1 | «migliora la sicurezza di WordPress» |
| 2 | «blocca gli attacchi di forza bruta» |
| 3 | «blocca in media 8.400 tentativi al giorno» |
| 4 | «blocca 8.400 attacchi/giorno - la pagina di login resta disponibile» |

### Polish
| Rung | Example |
|------|---------|
| 0 | «poprawia bezpieczeństwo» |
| 1 | «poprawia bezpieczeństwo WordPress» |
| 2 | «blokuje ataki brute-force» |
| 3 | «blokuje średnio 8400 prób dziennie» |
| 4 | «blokuje 8400 ataków/dzień - strona logowania pozostaje dostępna» |

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
