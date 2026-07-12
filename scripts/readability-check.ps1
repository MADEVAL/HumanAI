#!/usr/bin/env pwsh
# HUMAN-AI Readability Validator (ReadSightPy integration)
# Measures text readability using ReadSightPy and compares input vs output.
# Usage: powershell -File scripts/readability-check.ps1 -Input "original.txt" -Output "humanized.txt" -Lang "ru"

param(
    [Parameter(Mandatory=$true)]
    [string]$Input,

    [Parameter(Mandatory=$false)]
    [string]$Output,

    [Parameter(Mandatory=$true)]
    [ValidateSet("ru","uk","en","de","fr","es","pt","it","pl")]
    [string]$Lang,

    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Input -PathType Leaf)) {
    Write-Host "[ERROR] Input file not found: $Input" -ForegroundColor Red
    exit 1
}

$inputText = Get-Content $Input -Raw
$outputText = if ($Output -and (Test-Path $Output)) { Get-Content $Output -Raw } else { $null }

# Language code mapping for ReadSightPy
$langMap = @{
    ru = "ru"; uk = "uk"; en = "en-us"; de = "de-1996"
    fr = "fr"; es = "es"; pt = "pt"; it = "it"; pl = "pl"
}
$rsLang = $langMap[$Lang]

$pythonScript = @"
import sys, json

input_text = r'''$($inputText -replace "'", "''")'''
output_text = r'''$(if ($outputText) { $outputText -replace "'", "''" } else { "" })'''
lang = '$rsLang'

try:
    from readsight import ReadSight
except ImportError:
    print(json.dumps({"error": "ReadSightPy not installed. Run: pip install readsight"}))
    sys.exit(1)

rs = ReadSight(lang)
supported = rs.get_supported_formulas()
formulas_used = [f for f in ['gunning_fog', 'lix', 'smog_index', 'flesch_reading_ease', 'coleman_liau']
                 if f in supported]

def analyze(text, label):
    if not text.strip():
        return {"label": label, "error": "empty text"}
    stats = rs.analyze(text)
    results = {}
    for f in formulas_used:
        r = rs.score(f, text)
        results[f] = {"score": round(r.score, 1), "interpretation": r.interpretation}
    return {
        "label": label,
        "words": stats.word_count,
        "sentences": stats.sentence_count,
        "avg_syllables": round(stats.average_syllables_per_word, 2),
        "avg_words_per_sentence": round(stats.average_words_per_sentence, 1),
        "formulas": results
    }

input_analysis = analyze(input_text, "INPUT")
output_analysis = analyze(output_text, "OUTPUT") if output_text.strip() else None

result = {"input": input_analysis, "output": output_analysis, "formulas_used": formulas_used, "lang": lang}
print(json.dumps(result, ensure_ascii=False))
"@

$tmpPy = Join-Path ([System.IO.Path]::GetTempPath()) "readability-$([System.Guid]::NewGuid()).py"
Set-Content -Path $tmpPy -Value $pythonScript -Encoding UTF8

try {
    $result = & python $tmpPy 2>&1
    $json = $result | ConvertFrom-Json

    if ($json.error) {
        Write-Host "[SKIP] $($json.error)" -ForegroundColor Yellow
        exit 0
    }

    Write-Host ""
    Write-Host "[READABILITY REPORT]" -ForegroundColor Cyan
    Write-Host "Language: $Lang ($($json.lang))"
    Write-Host "Formulas: $($json.formulas_used -join ', ')"

    Write-Host ""
    Write-Host ("{0,-15} {1,10} {2,10} {3,8} {4,8}" -f "Metric", "Words", "Sent.", "Syll/W", "W/Sent")
    Write-Host ("{0,-15} {1,10} {2,10} {3,8} {4,8}" -f "INPUT", $json.input.words, $json.input.sentences, $json.input.avg_syllables, $json.input.avg_words_per_sentence)

    if ($json.output) {
        Write-Host ("{0,-15} {1,10} {2,10} {3,8} {4,8}" -f "OUTPUT", $json.output.words, $json.output.sentences, $json.output.avg_syllables, $json.output.avg_words_per_sentence)
        Write-Host ""

        $improved = 0
        $same = 0
        $worse = 0

        foreach ($f in $json.formulas_used) {
            $inScore = $json.input.formulas.$f.score
            $outScore = $json.output.formulas.$f.score
            $inInt = $json.input.formulas.$f.interpretation
            $outInt = $json.output.formulas.$f.interpretation

            # For Flesch: higher = better. For Fog/LIX/SMOG: lower = better
            $isFlesch = $f -eq "flesch_reading_ease"
            if ($isFlesch) {
                $delta = $outScore - $inScore
            } else {
                $delta = $inScore - $outScore
            }

            $arrow = if ($delta -gt 0.5) { "↑ better" } elseif ($delta -lt -0.5) { "↓ worse" } else { "→ same" }
            $color = if ($delta -gt 0.5) { "Green" } elseif ($delta -lt -0.5) { "Red" } else { "White" }

            Write-Host ("  {0,-25} {1,6} → {2,6}  [{3}→{4}] {5}" -f $f, $inScore, $outScore, $inInt, $outInt, $arrow) -ForegroundColor $color

            if ($delta -gt 0.5) { $improved++ } elseif ($delta -lt -0.5) { $worse++ } else { $same++ }
        }

        Write-Host ""
        Write-Host "SUMMARY: $improved improved, $same unchanged, $worse worse"

        if ($worse -eq 0 -and $improved -ge 1) {
            Write-Host "VERDICT: Readability improved" -ForegroundColor Green
            exit 0
        } elseif ($worse -le 1) {
            Write-Host "VERDICT: Readability stable" -ForegroundColor Yellow
            exit 0
        } else {
            Write-Host "VERDICT: Readability degraded" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "[INFO] No output file provided — baseline metrics only" -ForegroundColor Yellow
    }
}
finally {
    Remove-Item $tmpPy -Force -ErrorAction SilentlyContinue
}
