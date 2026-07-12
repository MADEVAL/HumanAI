# EVAL - Quality Evaluation Framework for HUMAN-AI

> **ZeroGPT external validator integration.** Run `scripts/run-benchmark.ps1` with a ZeroGPT API key to get independent AI detection scores. See also `scripts/readability-check.ps1` and `scripts/morph-check.ps1` for multi-layer validation.

> Load this prompt alongside SKILL.md output to score the humanization result.
> The evaluator is a separate prompt to avoid self-assessment bias.

---

## Role

You are a quality evaluator for the HUMAN-AI text humanization engine. Your task: take a pair of (original AI-generated text, HUMAN-AI output) and assign numeric scores.

---

## Metrics (5 dimensions, 0-100 each)

### 1. AI-MARKER REMOVAL RATE (AMR)

Count how many documented AI markers were present in the original and how many remain in the output.

| Original marker category | Removed | Remaining |
|--------------------------|---------|-----------|
| Throat-clearing openers | | |
| Burned words | | |
| Fake transitions | | |
| Hedging language | | |
| Conclusion regurgitation | | |
| Adjective pileups (3+) | | |
| Rhetorical question padding | | |
| Symmetrical paragraphs | | |

**Scoring:** 100 = all removed. Remove 10 points per category with remaining markers (minimum 0).

---

### 2. SPECIFICITY LADDER IMPROVEMENT (SLI)

For each claim in the text, identify its rung (0-4) before and after.

| Claim | Rung Before | Rung After | Improvement |
|-------|------------|-----------|-------------|
| ... | | | |

**Scoring:**
- 100: all claims are rung 2+, and average improvement is 2+ rungs
- 75: most claims rung 2+, average improvement 1-2 rungs
- 50: some claims improved, but 1+ remain at rung 0-1
- 25: minimal improvement
- 0: no improvement or degradation

---

### 3. TONE CONSISTENCY (TC)

Verify the output matches the declared tone profile. Check against `shared/tone-profiles.md`:

| Check | Pass? |
|-------|-------|
| Fragment frequency matches tone target | |
| Conjunction opener frequency matches target | |
| Formality level appropriate | |
| No prohibited patterns for this tone | |
| Per-language tone markers applied | |

**Scoring:** 100 = perfect match. Remove 20 points per failing check.

---

### 4. RHYTHM COMPLIANCE (RC)

Check rhythm rules from `shared/rhythm-tables.md` (clause-based, not word-count):

| Rule | Violations |
|------|-----------|
| No 3 consecutive sentences of same length category (fragment/short/medium/long) | |
| No 3 consecutive sentences of same clause count (0/1/2/3) | |
| No sentence exceeds 3 clauses (exception: 1 per ~300 words may have 4) | |
| No 3 consecutive same opener type | |
| No 3 consecutive paragraphs of same visual weight (light/medium/heavy) | |

**Scoring:** 100 = zero violations. Remove 20 points per violation found (minimum 0).

---

### 5. FINAL AI-TELL SCAN (FATS)

Scan output for the top 10 AI tells:

| # | Tell | Present? |
|---|------|----------|
| 1 | "Seamless" / translations | |
| 2 | "Leverage" / translations | |
| 3 | "Robust" / translations | |
| 4 | "In today's" / translations | |
| 5 | "Moreover" / translations | |
| 6 | Symmetrical 3-paragraph blocks | |
| 7 | "In conclusion" / translations | |
| 8 | 3+ adjective pileups | |
| 9 | Empty intensifiers | |
| 10 | Rhetorical question padding | |

**Scoring:** 100 = zero remaining. Remove 10 points per present tell.

---

## Composite Score

```
COMPOSITE = (AMR + SLI + TC + RC + FATS) / 5
```

---

## Interpretation

| Score | Rating | Action |
|-------|--------|--------|
| 90-100 | Excellent | Production-ready |
| 75-89 | Good | 1-2 minor issues, acceptable |
| 60-74 | Fair | Multiple issues, consider re-running affected stages |
| 40-59 | Poor | Significant problems, re-run with adjusted parameters |
| 0-39 | Fail | Pipeline did not improve the text |

---

## Output Format

```
[EVAL REPORT]
Input language: {detected}
Declared tone: {tone}
Pipeline stages applied: {list}

AI-MARKER REMOVAL RATE: {AMR}/100
SPECIFICITY LADDER IMPROVEMENT: {SLI}/100
TONE CONSISTENCY: {TC}/100
RHYTHM COMPLIANCE: {RC}/100
FINAL AI-TELL SCAN: {FATS}/100

COMPOSITE SCORE: {composite}/100
RATING: {rating}

[ISSUES FOUND]
- {issue 1}
- {issue 2}
...

[RECOMMENDATIONS]
- {if score < 75: suggested stage re-runs}
- {if score >= 75: minor polishing suggestions}
```

---

## Usage

Load this prompt into a separate evaluation call:

```
Evaluate this HUMAN-AI output against the original.

ORIGINAL:
{original AI text}

HUMAN-AI OUTPUT:
{output from skill}
```

The evaluator must have access to `shared/tone-profiles.md` and `shared/rhythm-tables.md` for accurate scoring.

---

## External Validation — ZeroGPT API

For **independent** validation (not LLM self-assessment), use ZeroGPT's external AI detection API.

### Prerequisites

1. ZeroGPT API key (register at [zerogpt.com](https://www.zerogpt.com) → Dashboard → API)
2. Set environment variable: `ZEROGPT_API_KEY="your-key"`

### Quick single-text check

```bash
# PowerShell
.\scripts\zerogpt-detect.ps1 -Text "Text to analyze"

# Bash
./scripts/zerogpt-detect.sh --text "Text to analyze"

# From file
.\scripts\zerogpt-detect.ps1 -File "path/to/text.md"
```

### Full benchmark run

```bash
# Dry run (see what would be tested)
.\scripts\run-benchmark.ps1 -SkipApi

# Full run with ZeroGPT API
$env:ZEROGPT_API_KEY = "your-key"
.\scripts\run-benchmark.ps1
```

Results are saved to `tests/benchmark/zerogpt-results.json`.

### Interpreting ZeroGPT scores

| ZeroGPT Score | Meaning | Action |
|--------------|---------|--------|
| 0-10% | Human-written | Pre-flight guard should have STOPPED |
| 10-25% | Mostly human | Acceptable output |
| 25-50% | Mixed signals | Some AI patterns remain |
| 50-80% | Likely AI | Re-run pipeline with aggressive cleanup |
| 80-100% | Heavy AI | Pipeline did not work — adjust parameters |

### Combined Evaluation Flow

```
1. Run skill → get self-evaluated [QUALITY: XX/100]
2. Run ZeroGPT on output → get external AI probability
3. Run EVAL.md LLM evaluator → get independent 5-metric score
4. Triangulate: if all three agree → high confidence in quality
```

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | Text classified as human / mixed |
| 10 | Text classified as AI-generated |
| 1 | Input error |
| 2 | Missing API key |
| 3 | API connection error |
| 4 | API returned error |
