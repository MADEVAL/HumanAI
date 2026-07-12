#!/usr/bin/env pwsh
# HUMAN-AI Clause Count Validator
# Checks rhythm rules (no 3+ consecutive same-category sentences, no 4+ clause sentences)
# Usage: powershell -File scripts/clause-check.ps1 -File "output.md"

param(
    [Parameter(Mandatory=$true)]
    [string]$File,

    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $File -PathType Leaf)) {
    Write-Host "[ERROR] File not found: $File" -ForegroundColor Red
    exit 1
}

$text = Get-Content $File -Raw

$pythonScript = @"
import sys, json, re

text = r'''$($text -replace "'", "''")'''

# Simple sentence splitting
sentences = re.split(r'(?<=[.!?])\s+', text)
sentences = [s.strip() for s in sentences if s.strip()]

# Very rough clause counting — count finite verbs and coordinating conjunctions as proxy
def estimate_clauses(sentence):
    words = sentence.split()
    # Count subject+predicate pairs via verb patterns
    # Simple heuristic: count finite verbs in EN, plus conjunctions that join clauses
    verb_patterns = re.findall(r'\b(is|are|was|were|be|been|am|has|have|had|do|does|did|'
                              r'can|could|will|would|shall|should|may|might|must|'
                              r'\w+s\b|\w+ed\b|\w+ing\b)', sentence, re.IGNORECASE)
    # Rough: ~1 clause per finite verb
    count = len(verb_patterns)
    # Subtract auxiliaries that don't add clauses
    if count == 0:
        return 0  # fragment
    return max(1, count)

categories = []
clause_counts = []
for s in sentences:
    c = estimate_clauses(s)
    clause_counts.append(c)
    if c == 0:
        categories.append("Fragment")
    elif c == 1:
        categories.append("Short")
    elif c == 2:
        categories.append("Medium")
    elif c == 3:
        categories.append("Long")
    else:
        categories.append("Very Long")

# Check Rule 1: no 3 consecutive same length category
rule1_violations = []
for i in range(len(categories) - 2):
    if categories[i] == categories[i+1] == categories[i+2]:
        rule1_violations.append({"start": i+1, "category": categories[i], "sentences": sentences[i:i+3]})

# Check Rule 2: no 3 consecutive same clause count
rule2_violations = []
for i in range(len(clause_counts) - 2):
    if clause_counts[i] == clause_counts[i+1] == clause_counts[i+2] and clause_counts[i] > 0:
        rule2_violations.append({"start": i+1, "count": clause_counts[i], "sentences": sentences[i:i+3]})

# Check Rule 3: no sentence exceeds 3 clauses (exception: 1 per ~300 words)
total_words = len(text.split())
allowed_long = max(1, total_words // 300)
rule3_violations = []
long_count = 0
for i, c in enumerate(clause_counts):
    if c >= 4:
        long_count += 1
        if long_count > allowed_long:
            rule3_violations.append({"sentence_num": i+1, "clauses": c, "text": sentences[i]})

print(json.dumps({
    "total_sentences": len(sentences),
    "categories": categories,
    "clause_counts": clause_counts,
    "rule1_violations": len(rule1_violations),
    "rule1_detail": [{"at": v["start"], "cat": v["category"]} for v in rule1_violations[:10]],
    "rule2_violations": len(rule2_violations),
    "rule2_detail": [{"at": v["start"], "count": v["count"]} for v in rule2_violations[:10]],
    "rule3_violations": len(rule3_violations),
    "rule3_detail": [{"sentence": v["sentence_num"], "clauses": v["clauses"]} for v in rule3_violations[:10]]
}, ensure_ascii=False, indent=2))
"@

$tmpPy = Join-Path ([System.IO.Path]::GetTempPath()) "clause-$([System.Guid]::NewGuid()).py"
Set-Content -Path $tmpPy -Value $pythonScript -Encoding UTF8

try {
    $result = & python $tmpPy 2>&1
    $json = $result | ConvertFrom-Json

    Write-Host ""
    Write-Host "[CLAUSE CHECK REPORT]" -ForegroundColor Cyan
    Write-Host "Total sentences: $($json.total_sentences)"

    Write-Host ""
    Write-Host "Rule 1 (no 3 consecutive same length category): $($json.rule1_violations) violations"
    foreach ($v in $json.rule1_detail) {
        Write-Host "  Violation at sentence $($v.at): 3× $($v.cat)" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Rule 2 (no 3 consecutive same clause count): $($json.rule2_violations) violations"
    foreach ($v in $json.rule2_detail) {
        Write-Host "  Violation at sentence $($v.at): 3× $($v.count) clauses" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Rule 3 (max 3 clauses per sentence): $($json.rule3_violations) violations"
    foreach ($v in $json.rule3_detail) {
        Write-Host "  Sentence $($v.sentence): $($v.clauses) clauses" -ForegroundColor Yellow
    }

    $totalViolations = $json.rule1_violations + $json.rule2_violations + $json.rule3_violations
    Write-Host ""
    Write-Host "TOTAL VIOLATIONS: $totalViolations"

    if ($totalViolations -eq 0) {
        Write-Host "VERDICT: Rhythm clean" -ForegroundColor Green
        exit 0
    } elseif ($totalViolations -le 3) {
        Write-Host "VERDICT: Minor rhythm issues" -ForegroundColor Yellow
        exit 0
    } else {
        Write-Host "VERDICT: Significant rhythm violations" -ForegroundColor Red
        exit 1
    }
}
finally {
    Remove-Item $tmpPy -Force -ErrorAction SilentlyContinue
}
