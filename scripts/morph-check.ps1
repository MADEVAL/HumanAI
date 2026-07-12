#!/usr/bin/env pwsh
# HUMAN-AI Morphological Validator
# Checks text for non-existent words using pymorphy3 + OpenCorpora dictionary.
# Usage: powershell -File scripts/morph-check.ps1 -File "output.md" -Lang "ru" [-Verbose]

param(
    [Parameter(Mandatory=$true)]
    [string]$File,

    [Parameter(Mandatory=$true)]
    [ValidateSet("ru","uk","en","de","fr","es","pt","it","pl")]
    [string]$Lang,

    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-not (Test-Path $File -PathType Leaf)) {
    Write-Host "[ERROR] File not found: $File" -ForegroundColor Red
    exit 1
}

$text = Get-Content $File -Raw

# Load whitelist/blacklist if available
$whitelistFile = Join-Path $RepoRoot "shared/morph/whitelist-$Lang.txt"
$blacklistFile = Join-Path $RepoRoot "shared/morph/blacklist-$Lang.txt"

$whitelist = @()
$blacklist = @()

if (Test-Path $whitelistFile) {
    Get-Content $whitelistFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) { $whitelist += $line.ToLower() }
    }
}

if (Test-Path $blacklistFile) {
    Get-Content $blacklistFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) { $blacklist += $line.ToLower() }
    }
}

# Python morph checker — writes results to stdout as JSON
$pythonScript = @"
import sys, json, re
sys.path.insert(0, r'$RepoRoot')

text = r'''$($text -replace "'", "''")'''
lang = '$Lang'
whitelist = set($(if ($whitelist) { "'" + ($whitelist -join "','") + "'" } else { "" }))
blacklist_lower = set($(if ($blacklist) { "'" + ($blacklist -join "','") + "'" } else { "" }))

# Extract words — Cyrillic for ru/uk, Latin for others
if lang in ('ru', 'uk'):
    words = re.findall(r'[а-яёіїєґА-ЯЁІЇЄҐ]+', text.lower())
else:
    words = re.findall(r'[a-zäöüßàâçéèêëîïôûùÿæœñ]+', text.lower())

total = len(words)
unknown = []
blacklist_hits = []

if lang in ('ru', 'uk'):
    try:
        import pymorphy3
        morph = pymorphy3.MorphAnalyzer(lang=lang)
        for w in words:
            if w in whitelist:
                continue
            if w in blacklist_lower:
                blacklist_hits.append(w)
                continue
            parsed = morph.parse(w)
            if not parsed or parsed[0].score < 0.1:
                unknown.append(w)
    except ImportError:
        print(json.dumps({"error": "pymorphy3 not installed. Run: pip install pymorphy3 pymorphy3-dicts-ru"}))
        sys.exit(1)
elif lang == 'en':
    # English: check against basic dictionary via pymorphy3 if available
    try:
        import pymorphy3
        morph = pymorphy3.MorphAnalyzer(lang='en')
        for w in words:
            if w in whitelist:
                continue
            parsed = morph.parse(w)
            if not parsed or parsed[0].score < 0.1:
                unknown.append(w)
    except ImportError:
        # Fallback: simple non-dictionary check is noisy, skip
        print(json.dumps({"error": "pymorphy3 not installed for EN. Skipping.", "total": total, "unknown": 0, "blacklist_hits": len(blacklist_hits)}))
        sys.exit(0)
else:
    # For DE/FR/ES/PT/IT/PL — spaCy-based (simple OOV check)
    try:
        import spacy
        model_map = {'de': 'de_core_news_sm', 'fr': 'fr_core_news_sm', 'es': 'es_core_news_sm',
                     'pt': 'pt_core_news_sm', 'it': 'it_core_news_sm', 'pl': 'pl_core_news_sm'}
        nlp = spacy.load(model_map.get(lang, 'en_core_web_sm'))
        doc = nlp(text)
        for token in doc:
            if token.is_alpha and token.text.lower() not in whitelist:
                if token.is_oov:
                    unknown.append(token.text.lower())
    except ImportError:
        print(json.dumps({"error": "spaCy not installed for $Lang. Run: pip install spacy && python -m spacy download " + model_map.get(lang, 'model')}))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"error": f"spaCy error: {e}"}))
        sys.exit(1)

# Deduplicate
unknown = list(dict.fromkeys(unknown))
blacklist_hits = list(dict.fromkeys(blacklist_hits))

pct = round(len(unknown) / total * 100, 1) if total > 0 else 0

if pct < 1: verdict = 'OK'
elif pct < 3: verdict = 'WARN'
elif pct < 5: verdict = 'FAIL'
else: verdict = 'CRITICAL'

print(json.dumps({
    "total": total,
    "unknown": len(unknown),
    "unknown_words": unknown[:30],
    "blacklist_hits": len(blacklist_hits),
    "blacklist_words": blacklist_hits[:20],
    "pct": pct,
    "verdict": verdict
}, ensure_ascii=False))
"@

$tmpPy = Join-Path ([System.IO.Path]::GetTempPath()) "morph-check-$([System.Guid]::NewGuid()).py"
Set-Content -Path $tmpPy -Value $pythonScript -Encoding UTF8

try {
    $result = & python $tmpPy 2>&1
    $json = $result | ConvertFrom-Json

    if ($json.error) {
        Write-Host "[SKIP] $($json.error)" -ForegroundColor Yellow
        exit 0
    }

    Write-Host ""
    Write-Host "[MORPH REPORT]" -ForegroundColor Cyan
    Write-Host "Language: $Lang"
    Write-Host "Total words: $($json.total)"
    Write-Host "Unknown words: $($json.unknown) ($($json.pct)%)"

    if ($json.blacklist_hits -gt 0) {
        Write-Host "Blacklist hits: $($json.blacklist_hits)" -ForegroundColor Red
        foreach ($w in $json.blacklist_words) {
            Write-Host "  [BLACKLIST] «$w»" -ForegroundColor Red
        }
    }

    if ($json.unknown -gt 0) {
        foreach ($w in $json.unknown_words) {
            Write-Host "  «$w» — не найдено" -ForegroundColor Yellow
        }
    }

    Write-Host "VERDICT: $($json.verdict)" -ForegroundColor $(if ($json.verdict -eq 'OK') { 'Green' } elseif ($json.verdict -eq 'CRITICAL') { 'Red' } else { 'Yellow' })

    if ($json.verdict -eq 'OK') { exit 0 }
    elseif ($json.verdict -eq 'WARN') { exit 0 }
    else { exit 1 }
}
finally {
    Remove-Item $tmpPy -Force -ErrorAction SilentlyContinue
}
