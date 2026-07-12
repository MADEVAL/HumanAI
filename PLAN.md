# PLAN — Улучшение HUMAN-AI v3.0 → v4.0

> Дата: 2026-07-12
> Цель: системное усиление слабых мест, выявленных в аудите.

---

## 0. ПРИНЦИПИАЛЬНЫЕ РЕШЕНИЯ (приняты)

- **Em-dash (—)** — удаляется **во всех языках без исключений**. Русская типографика не оправдание. Длинное тире = AI-маркер, точка.
- **Программный энфорсмент интеграций** (RankWise / MindFluence) — не нужен, снимается с плана.

---

## 1. ТРЁХСЛОЙНАЯ ВАЛИДАЦИЯ (архитектурный фундамент)

**Проблема:** self-assessment bias — LLM сам себя оценивает.

**Решение:** три независимых слоя, исполняемых последовательно:

| Слой | Инструмент | Что измеряет | Независимость |
|------|-----------|-------------|:---:|
| 1. Self-eval | LLM (Stage 5.6) | Соблюдение своих же правил | ❌ |
| 2. ReadSightPy | `readsight` (Python) | Читаемость: Flesch, LIX, Fog | ✅ |
| 3. ZeroGPT | API | AI-детекция | ✅ |

**Итоговый контракт качества:** пайплайн считается успешным, если self-eval ≥ 75 **И** ReadSightPy-читаемость улучшилась (output ≥ input) **И** ZeroGPT ≤ 15%.

### 1.1 Интеграция ReadSightPy

ReadSightPy (https://github.com/MADEVAL/ReadSightPy) — библиотека читаемости для 86 языков, 17 формул, TeX-слоговой движок.

**Что даёт скиллу:**
- **Flesch Reading Ease (Oborneva)** для русского — объективная метрика «человечности» текста
- **LIX** для всех 9 языков — универсальная читаемость
- **Gunning Fog** — измерение сложности (AI-текст имеет аномальный Fog)
- **SMOG** — годы обучения, нужные для понимания текста

**Интеграция:**
```
scripts/readability-check.ps1  ← новый скрипт
  - Принимает файл с текстом
  - Вызывает ReadSightPy для языка текста
  - Возвращает: Flesch, LIX, Fog, SMOG
  - Сравнивает input vs output
  - Exit code: 0 = улучшение, 1 = без изменений, 2 = ухудшение
```

**Метрики по языкам (минимальный набор):**

| Язык | Формулы |
|------|---------|
| en | Flesch + FKGL + LIX + Fog |
| ru | Flesch (Oborneva) + FKGL + LIX + Fog |
| uk | LIX + Fog + SMOG |
| de | Flesch (Amstad) + WSTF + LIX + Fog |
| fr | Flesch (Kandel-Moles) + LIX + Fog |
| es | Flesch + Fernandez-Huerta + LIX + Fog |
| pt | Flesch (Martins) + LIX + Fog |
| it | Flesch + Gulpease + LIX + Fog |
| pl | FOG-PL + LIX + Fog |

### 1.2 ReadSightPy-бенчмарк

Добавить в `tests/benchmark/`:
```
tests/benchmark/
├── readability-baseline.json    ← baseline-показатели для каждого тестового файла
└── readability-results.json     ← результаты прогона (автогенерация)
```

`readability-baseline.json` — эталонные метрики читаемости для каждого AI-текста ДО humanization. После humanization — сравнение: читаемость должна вырасти (Flesch ↑, Fog ↓).

---

## 2. МОРФОЛОГИЧЕСКИЙ ВАЛИДАТОР (ВСЕ 9 ЯЗЫКОВ)

**Проблема:** AI-модели генерируют несуществующие слова: искажённые формы, кальки, выдуманные падежные окончания. LLM не знает, что слово не существует — он сам его придумал. Это касается всех 9 языков, но механизм проверки разный.

**Решение:** внешний морфологический анализатор, который проверяет каждое слово на наличие в словаре языка.

### 2.1 Инструменты по языкам

| Язык | Инструмент | Словарь | Покрытие |
|------|-----------|---------|:---:|
| **RU** | `pymorphy3` | OpenCorpora (390K+ словоформ) | ✅ отличное |
| **UK** | `pymorphy3` | OpenCorpora (UK-секция) | ⚠️ базовое |
| **EN** | `spaCy` `en_core_web_lg` | 500K+ слов | ✅ отличное |
| **DE** | `spaCy` `de_core_news_lg` | морфология + лемматизация | ✅ хорошее |
| **FR** | `spaCy` `fr_core_news_lg` + Lefff | морфология + глагольные формы | ✅ хорошее |
| **ES** | `spaCy` `es_core_news_lg` | морфология + лемматизация | ✅ хорошее |
| **PT** | `spaCy` `pt_core_news_lg` | морфология + лемматизация | ✅ хорошее |
| **IT** | `spaCy` `it_core_news_lg` | морфология + лемматизация | ✅ хорошее |
| **PL** | `spaCy` `pl_core_news_lg` + Morfeusz2 | морфология + лемматизация | ✅ хорошее |

**pymorphy3** — специализированный морфологический анализатор для русского (и частично украинского). Даёт score уверенности для каждого разбора. Слова с score = 0 — не найдены в словаре OpenCorpora.

**spaCy** — общий NLP-фреймворк. Для романских и германских языков — лемматизация + POS-tagging. Слова без леммы или с неизвестным POS — кандидаты на «не существует».

### 2.2 Унифицированный интерфейс

Скрипт `scripts/morph-check.ps1` (обёртка над Python) — единый для всех 9 языков:

```
morph-check.ps1 -File "output.md" -Lang "ru"
morph-check.ps1 -File "output.md" -Lang "de"
morph-check.ps1 -File "output.md" -Lang "fr"
```

Внутри — диспетчеризация к нужному движку (pymorphy3 для RU/UK, spaCy для остальных).

### 2.3 Как работает (RU — pymorphy3)

```python
import pymorphy3
morph = pymorphy3.MorphAnalyzer()

def check_word(word):
    parsed = morph.parse(word)
    if not parsed or parsed[0].score == 0:
        return "NOT_RUSSIAN"  # слово не найдено в OpenCorpora
    return parsed[0].normal_form
```

### 2.4 Как работает (EN/DE/FR/ES/PT/IT/PL — spaCy)

```python
import spacy

nlp = spacy.load("de_core_news_lg")  # пример для немецкого

def check_word(word, lang):
    doc = nlp(word)
    token = doc[0]
    # Слово подозрительно если:
    # 1. POS = X (unknown) или лемма не найдена
    # 2. is_oov = True (out-of-vocabulary)
    if token.pos_ == "X" or token.is_oov:
        return "NOT_IN_VOCABULARY"
    return token.lemma_
```

### 2.5 Выходной формат (единый для всех языков)

```
[MORPH REPORT]
Language: ru
Total words: 342
Unknown words: 7 (2.0%)
├── «оптимизируемость»     — не найдено в OpenCorpora
├── «трансформационность»  — не найдено в OpenCorpora
├── «имплементирование»    — калька с английского, в blacklist
├── «автоматизированность» — окказионализм, не в словаре
├── «функционализировать»  — выдуманный глагол
├── «пользователецентричный» — не найдено
└── «нейросетевой»         — допустимое новообразование [WARN]

VERDICT: 5 critical / 1 warn / 1 acceptable
```

```
[MORPH REPORT]
Language: de
Total words: 287
Unknown words: 3 (1.0%)
├── «Optimierbarkeit»      — nicht im Vokabular (möglicher Neologismus)
├── «Transformationalität» — nicht im Vokabular
└── «implementierungsmäßig» — nicht im Vokabular, Anglizismus

VERDICT: 3 critical
```

### 2.6 Пороги (единые для всех языков)

| % неизвестных слов | Вердикт |
|-------------------|---------|
| < 1% | OK |
| 1-3% | WARN — проверить вручную |
| 3-5% | FAIL — вероятная AI-генерация |
| > 5% | CRITICAL — текст непригоден |

### 2.7 Ограничения

- Не видит неологизмы, уже вошедшие в язык
- Не видит технические термины
- Ложные срабатывания на именах собственных

**Решение:** whitelist + blacklist для каждого языка:

```
shared/morph/
├── whitelist-ru.txt       ← допустимые слова вне словаря
├── blacklist-ru.txt       ← известные AI-кальки (подозрительны даже если есть в словаре)
├── whitelist-de.txt
├── blacklist-de.txt
├── whitelist-fr.txt
├── blacklist-fr.txt
├── whitelist-es.txt
├── blacklist-es.txt
├── whitelist-pt.txt
├── blacklist-pt.txt
├── whitelist-it.txt
├── blacklist-it.txt
├── whitelist-pl.txt
├── blacklist-pl.txt
├── whitelist-en.txt
├── blacklist-en.txt
├── whitelist-uk.txt
└── blacklist-uk.txt
```

### 2.8 Приоритет внедрения

| Фаза | Языки | Инструмент |
|------|-------|-----------|
| **1** | RU | pymorphy3 + OpenCorpora |
| **2** | UK, EN, DE | pymorphy3 (UK) + spaCy (EN, DE) |
| **3** | FR, ES, PT, IT, PL | spaCy (все) |

---

## 3. УСИЛЕНИЕ PRE-FLIGHT GUARD

**Проблема:** одно throat-clearing opener (+25 баллов) = STOP пайплайна, даже если текст человеческий.

**Решение:**

### 3.1 Минимальный размер текста для pre-flight

Тексты < 100 слов: pre-flight не работает осмысленно. Слишком мало данных для эвристики.
```
Если слов < 100 → пропустить pre-flight → сразу в cleanup
```

### 3.2 Взвешенный порог

Вместо жёсткого «opener = +25 = STOP»:
- 1 opener без других маркеров = не останавливать
- 1 opener + 2+ других категорий маркеров = останавливать

Новое правило:
```
STOP только если:
  (opener OR conclusion_regurgitation) AND (burned_words ≥ 3 OR fake_transitions ≥ 2 OR hedging ≥ 2)
  
ИЛИ score ≥ 50 в любом случае
```

### 3.3 Уточнение для русского языка

Русские корпоративные тексты часто открываются «В современных условиях...» — это не AI, это канцелярит. Добавить:
```
Если язык = ru И единственный маркер = opener → WARN, не STOP
```

---

## 4. РАСШИРЕНИЕ ТЕСТОВОГО ПОКРЫТИЯ

### 4.1 Тестовые AI-тексты для DE/FR/ES/PT/IT/PL

Сейчас: по 1 файлу (только blog-post) на каждый язык. Нужно минимум 3 жанра:

| Язык | Сейчас | Нужно |
|------|--------|-------|
| DE | blog-post | + email, + landing |
| FR | blog-post | + email, + social |
| ES | blog-post | + email, + landing |
| PT | blog-post | + email, + social |
| IT | blog-post | + email, + landing |
| PL | blog-post | + email, + social |

Всего: +12 тестовых файлов.

### 4.2 Примеры (examples/) для DE/FR/ES/PT/IT/PL

Сейчас: 0. Нужно минимум 2 примера на язык:
- `examples/de-blog-post.md`
- `examples/de-landing.md`
- `examples/fr-blog-post.md`
- `examples/fr-social.md`
- ... (по 2 на язык = 12 новых)

### 4.3 Edge-case аннотации

`tests/benchmark/annotations.json` — добавить аннотации для 5 edge-case файлов.

---

## 5. УНИФИКАЦИЯ СЦЕНАРИЕВ

**Проблема:** 15 сценариев — 4 разных формата. LLM должен парсить по-разному.

**Решение:** единый шаблон сценария (обновить `CONTRIBUTING.md` и переписать все сценарии):

```markdown
# Scenario: [Название]

**Use when:** [описание]
**Default tone:** `[tone]`

## Key Priorities
1. ...
2. ...

## What to Cut
- ...
- ...

## What to Preserve
- ...
- ...

## Rhythm Targets
| Параметр | Значение |
|----------|---------|
| Fragment spacing | Every N sentences |
| Conjunction spacing | Every N sentences |
| Max consecutive same category | N |

## Language Notes
- RU: ...
- UK: ...
- DE: ...

## Pipeline
- Likely needed: [stages]
- Often skippable: [stages]
- Never skip: [stages]
```

Все 15 сценариев привести к этому формату.

---

## 6. CLAUSE-COUNT: ПЕРЕХОД НА ВНЕШНИЙ ПОДСЧЁТ

**Проблема:** LLM не может надёжно считать clauses. Ритм-правила нарушаются не по вине следования инструкции, а по вине неспособности посчитать.

**Решение:** на этапе proofread (Stage 5) добавить пункт о внешней проверке:

```
5.5 Clause Count Verification (опционально — внешний скрипт)

scripts/clause-check.ps1 -File "output.md"
```

Скрипт на Python:
```python
import re

def count_clauses(sentence):
    # Простой подход: считаем финитные глаголы + союзы как прокси для clauses
    # Более точный — spaCy dependency parse
    ...
```

**Важно:** это НЕ замена clause-count правилам в SKILL.md. Правила остаются. Это внешний валидатор, который ловит нарушения, пропущенные LLM.

Реализация — фаза 2 (после морфо-валидатора).

---

## 7. ВНЕШНИЙ EVAL-РАННЕР

**Проблема:** EVAL.md требует отдельного LLM-вызова, но никто этого не делает.

**Решение:** скрипт, автоматизирующий внешнюю оценку:

```
scripts/run-eval.ps1
  - Принимает: original.txt + humanized.txt
  - Отправляет EVAL.md промпт + оба текста в LLM API (OpenAI/Anthropic)
  - Возвращает 5-метричный отчёт
```

Интегрировать в `run-benchmark.ps1` как дополнительный слой.

---

## 8. ФИКСЫ КОНСИСТЕНТНОСТИ

### 8.1 Версионирование
- `README.md:3` badge `version-1.0` → `version-3.0`
- `KNOWN_LIMITATIONS.md:11` «v4» → удалить, заменить на актуальную версию

### 8.2 Валидатор — дополнить список сценариев
`scripts/validate.ps1:295-303` — добавить в `$treeFiles` недостающие сценарии:
`press-release.md`, `internal-memo.md`, `grant-proposal.md`, `product-update.md`

### 8.3 Bash-версия run-benchmark
Создать `scripts/run-benchmark.sh` — аналог `run-benchmark.ps1` для Linux/Mac.

---

## 9. ДОРОЖНАЯ КАРТА

### Фаза 1 (ближайшая) — базовая инструментализация
- [ ] Самодостаточный SKILL.md: вшить топ-данные × 9 языков, заменить ссылки на raw-url
- [ ] Морфо-валидатор RU: `scripts/morph-check.ps1` + `shared/morph/` (whitelist + blacklist)
- [ ] Интеграция ReadSightPy: `scripts/readability-check.ps1`
- [ ] Расширение `validate.ps1` (сценарии + badge fix + проверка SKILL.md ↔ shared/)
- [ ] Pre-flight guard: правила минимального размера и взвешенного порога

### Фаза 2 (средняя) — покрытие и унификация
- [ ] Морфо-валидаторы UK + EN + DE (pymorphy3 + spaCy)
- [ ] Унификация 15 сценариев под единый формат
- [ ] 12 новых AI-тестов для DE/FR/ES/PT/IT/PL
- [ ] 12 новых примеров (examples/)
- [ ] Edge-case аннотации в annotations.json
- [ ] `scripts/run-benchmark.sh` (Bash)
- [ ] `scripts/run-eval.ps1` (внешний EVAL-раннер)

### Фаза 3 (дальняя) — продвинутая валидация
- [ ] Морфо-валидаторы FR, ES, PT, IT, PL (spaCy)
- [ ] Clause-count валидатор: `scripts/clause-check.ps1`
- [ ] `readability-baseline.json` + интеграция в benchmark
- [ ] CI: добавить morph-check + readability-check в `validate.yml`

---

## 10. САМОДОСТАТОЧНЫЙ SKILL.md

**Проблема:** SKILL.md (546 строк) на ~40% состоит из ссылок «см. shared/...» вместо самих данных. В standalone-режиме (просто system prompt в GPT/Claude) LLM знает правила, но не имеет списков слов и маркеров. Это снижает качество cleanup.

**Решение:** SKILL.md должен быть самодостаточным для standalone-запуска, с GitHub-ссылками на полные данные для углублённой обработки.

### 10.1 Что вшить в SKILL.md

| Данные | Сейчас | Сделать |
|--------|:---:|---------|
| Burned words (топ-15/язык) | ссылка на shared | **вшить компактной таблицей** |
| AI openers (топ-5/язык) | частично в Stage 0 | **вшить полный топ-5** |
| Fake transitions (топ-5/язык) | ссылка | **вшить** |
| Hedging (топ-5/язык) | ссылка | **вшить** |
| Empty intensifiers (топ-5/язык) | ссылка | **вшить** |
| Conclusion regurgitation (топ-5/язык) | ссылка | **вшить** |
| Tone profiles — ключевые маркеры | ссылка на shared | **вшить 2-3 маркера/тон/язык** |
| Specificity ladder — примеры | только EN вшито | **вшить по 1 примеру/язык** |
| Rhythm — opener categories | ссылка | **вшить opener categories × 9** |

### 10.2 Что оставить GitHub-ссылками

| Данные | Причина |
|--------|---------|
| Полные списки burned words (30-40/язык) | редкий use-case, раздует SKILL.md |
| Полные tone profiles (7 тонов × 9 языков) | 250 строк, нужны только для deep-аудита |
| `EVAL.md` | отдельный LLM-вызов |
| `shared/language-template.md` | только для контрибьюторов |
| Скрипты (`validate.ps1`, `zerogpt-detect.ps1` и др.) | не для LLM |

### 10.3 Принцип «ссылкок GitHub»

Для углублённой обработки SKILL.md содержит прямые raw-ссылки:

```
> Полный список burned words: https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/burned-words.md
> Tone profiles: https://raw.githubusercontent.com/MADEVAL/Natural-skill/main/shared/tone-profiles.md
```

LLM может сходить по ссылке (web fetch) и прочитать полный список, если задача требует глубокой зачистки.

### 10.4 Целевой размер

| Файл | Сейчас | Цель |
|------|--------|------|
| SKILL.md | 546 строк | ~1200 строк |
| Из них правил | 400 строк | 400 строк (без изменений) |
| Из них вшитых данных | 50 строк | ~700 строк (+650) |
| Из них ссылок | 100 строк | ~100 строк (формат меняется) |

### 10.5 Правило обновления

При добавлении языка (например, японский):
1. Обновить `shared/` — полные данные (как сейчас)
2. Обновить SKILL.md — топ-15 слов, топ-5 маркеров
3. Прогнать `validate.ps1` — проверить консистентность SKILL.md ↔ shared/

### 10.6 Отличие от текущей архитектуры

```
Сейчас:
  SKILL.md → ссылается → shared/

После:
  SKILL.md
  ├── вшитые топ-данные (standalone — хватает для 80% задач)
  └── raw-ссылки → shared/ (deep mode — для 20% сложных задач)
        └── shared/ — single source of truth (не дублируется, а детализируется)
```

---

## 11. ИТОГОВАЯ АРХИТЕКТУРА v4.0

```
natural-skill/
├── SKILL.md                          ← самодостаточный оркестратор (~1200 строк)
│                                        вшиты топ-данные + raw-ссылки на shared/
├── PLAN.md                           ← этот файл
├── shared/
│   ├── burned-words.md
│   ├── ai-markers.md
│   ├── tone-profiles.md
│   ├── specificity-ladder.md
│   ├── rhythm-tables.md
│   ├── language-template.md
│   └── morph/                        ← NEW
│       ├── whitelist-ru.txt / blacklist-ru.txt
│       ├── whitelist-uk.txt / blacklist-uk.txt
│       ├── whitelist-en.txt / blacklist-en.txt
│       ├── whitelist-de.txt / blacklist-de.txt
│       ├── whitelist-fr.txt / blacklist-fr.txt
│       ├── whitelist-es.txt / blacklist-es.txt
│       ├── whitelist-pt.txt / blacklist-pt.txt
│       ├── whitelist-it.txt / blacklist-it.txt
│       └── whitelist-pl.txt / blacklist-pl.txt
├── scripts/
│   ├── validate.ps1 / .sh            ← обновлён
│   ├── zerogpt-detect.ps1 / .sh
│   ├── run-benchmark.ps1 / .sh       ← +.sh NEW
│   ├── morph-check.ps1              ← NEW
│   ├── readability-check.ps1        ← NEW
│   ├── run-eval.ps1                 ← NEW
│   └── clause-check.ps1             ← NEW (фаза 3)
├── scenarios/                        ← унифицированы (15 файлов)
├── examples/                         ← расширены (+12 файлов)
└── tests/benchmark/
    ├── annotations.json              ← расширен
    ├── readability-baseline.json     ← NEW
    ├── ai-texts/                     ← расширен (+12 файлов)
    ├── human-texts/
    └── edge-cases/                   ← аннотированы
```
