#!/usr/bin/env pwsh
# HUMAN-AI Integrity Validator (PowerShell 5.1+)
# Validates cross-references and language coverage across all skill files.
# Usage: powershell -File scripts/validate.ps1 [-Verbose]
param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Errors = 0
$Warnings = 0

function Write-Pass { param($msg) Write-Host ("  [PASS] " + $msg) -ForegroundColor Green }
function Write-Fail { param($msg) $script:Errors++; Write-Host ("  [FAIL] " + $msg) -ForegroundColor Red }
function Write-Warn { param($msg) $script:Warnings++; Write-Host ("  [WARN] " + $msg) -ForegroundColor Yellow }
function Write-Check { param($msg) Write-Host ("[CHECK] " + $msg) -ForegroundColor Cyan }

$Languages = @("en","ru","uk","de","fr","es","pt","it","pl")
$Tones = @("expert","biz","human","social","landing","article","case")
$VerifyFlags = @{
    en = "[VERIFY"; ru = "[ПРОВЕРИТЬ"; uk = "[ПЕРЕВІРИТИ"; de = "[PRÜFEN"
    fr = "[VÉRIFIER"; es = "[VERIFICAR"; pt = "[VERIFICAR"; it = "[VERIFICARE"; pl = "[SPRAWDZIĆ"
}
$Stage5Checks = @{
    en = "EN:"; ru = "RU:"; uk = "UK:"; de = "DE:"
    fr = "FR:"; es = "ES:"; pt = "PT:"; it = "IT:"; pl = "PL:"
}

# ============================================
Write-Host ""
Write-Check "1. SKILL.md YAML Frontmatter"
$skillContent = Get-Content (Join-Path $RepoRoot "SKILL.md") -Raw -Encoding UTF8

if ($skillContent -match "name:\s+human-ai") { Write-Pass "name: human-ai" } else { Write-Fail "name field missing or incorrect" }
if ($skillContent -match 'version:\s+"4\.0"') { Write-Pass "version: 4.0" } else { Write-Fail "version field missing or incorrect" }
if ($skillContent -match "languages:") { Write-Pass "languages field present" } else { Write-Fail "languages field missing" }
if ($skillContent -match "pipeline_stages:\s+5") { Write-Pass "pipeline_stages: 5" } else { Write-Fail "pipeline_stages field missing or incorrect" }

# ============================================
Write-Host ""
Write-Check "2. Language coverage in shared/ files"

# Build language name lookup
$LangNames = @{}
$LangNames["en"] = "English"
$LangNames["ru"] = "Russian"
$LangNames["uk"] = "Ukrainian"
$LangNames["de"] = "German"
$LangNames["fr"] = "French"
$LangNames["es"] = "Spanish"
$LangNames["pt"] = "Portuguese"
$LangNames["it"] = "Italian"
$LangNames["pl"] = "Polish"

$bwContent = Get-Content (Join-Path $RepoRoot "shared\burned-words.md") -Raw -Encoding UTF8
$amContent = Get-Content (Join-Path $RepoRoot "shared\ai-markers.md") -Raw -Encoding UTF8
$slContent = Get-Content (Join-Path $RepoRoot "shared\specificity-ladder.md") -Raw -Encoding UTF8
$rtContent = Get-Content (Join-Path $RepoRoot "shared\rhythm-tables.md") -Raw -Encoding UTF8

foreach ($lang in $Languages) {
    $name = $LangNames[$lang]
    $upperLang = $lang.ToUpper()

    # burned-words.md
    if ($bwContent -match ("## " + [regex]::Escape($name))) {
        Write-Pass ("burned-words.md [" + $lang + "]")
    } else {
        Write-Fail ("burned-words.md [" + $lang + "] not found")
    }

    # ai-markers.md
    if ($amContent -match ("## " + [regex]::Escape($name))) {
        Write-Pass ("ai-markers.md [" + $lang + "]")
    } else {
        Write-Fail ("ai-markers.md [" + $lang + "] not found")
    }

    # specificity-ladder.md
    if ($slContent -match ("### " + [regex]::Escape($name))) {
        Write-Pass ("specificity-ladder.md [" + $lang + "]")
    } else {
        Write-Warn ("specificity-ladder.md [" + $lang + "] not found")
    }

    # rhythm-tables.md openers
    $openerPattern = "Opener categories - " + $upperLang
    if ($rtContent -match [regex]::Escape($openerPattern)) {
        Write-Pass ("rhythm-tables.md [" + $lang + "] openers")
    } else {
        Write-Warn ("rhythm-tables.md [" + $lang + "] openers not found")
    }

    # Conjunctions
    $conjPattern = $upperLang + ":"
    if ($rtContent -match [regex]::Escape($conjPattern)) {
        Write-Pass ("rhythm-tables.md [" + $lang + "] conjunctions")
    } else {
        Write-Warn ("rhythm-tables.md [" + $lang + "] conjunctions not found")
    }
}

# ============================================
Write-Host ""
Write-Check "3. Cultural matrix language coverage"

$cmPath = Join-Path $RepoRoot "shared\cultural-matrix.md"
if (Test-Path $cmPath) {
    Write-Pass "cultural-matrix.md exists"
    $cmContent = Get-Content $cmPath -Raw -Encoding UTF8
    foreach ($lang in $Languages) {
        $name = $LangNames[$lang]
        if ($cmContent -match ("### " + [regex]::Escape($name))) {
            Write-Pass ("cultural-matrix.md [" + $lang + "]")
        } else {
            Write-Warn ("cultural-matrix.md [" + $lang + "] section not found")
        }
    }
    # Check master table has all 9 columns
    $tableColumns = ($cmContent -split "`n" | Select-String -Pattern "\| Dimension" -Context 0,2)[0].Line
    if ($tableColumns) {
        $columnCount = ([regex]::Matches($tableColumns, "\|")).Count - 1
        if ($columnCount -ge 9) {
            Write-Pass "cultural-matrix.md master table: $columnCount language columns (need >=9)"
        } else {
            Write-Warn "cultural-matrix.md master table: $columnCount columns (need >=9)"
        }
    }
    # Check formality table has all 9
    if ($cmContent -match "EN.*RU.*UK.*DE.*FR.*ES.*PT.*IT.*PL") {
        Write-Pass "cultural-matrix.md cross-language summary table present"
    } else {
        Write-Warn "cultural-matrix.md cross-language summary incomplete"
    }
} else {
    Write-Fail "cultural-matrix.md not found in shared/"
}

# ============================================
Write-Host ""
Write-Check "5. Tone profile coverage (7 profiles x 9 languages)"

$tpContent = Get-Content (Join-Path $RepoRoot "shared\tone-profiles.md") -Raw -Encoding UTF8
$langMarkers = @{}
$langMarkers["en"] = "EN markers"; $langMarkers["ru"] = "RU markers"
$langMarkers["uk"] = "UK markers"; $langMarkers["de"] = "DE markers"
$langMarkers["fr"] = "FR markers"; $langMarkers["es"] = "ES markers"
$langMarkers["pt"] = "PT markers"; $langMarkers["it"] = "IT markers"
$langMarkers["pl"] = "PL markers"

foreach ($tone in $Tones) {
    # Extract tone section
    $tonePattern = '## Profile \d+: `' + $tone + '`'
    if ($tpContent -match $tonePattern) {
        # Find section boundaries
        $startIdx = $tpContent.IndexOf($matches[0])
        $nextSection = $tpContent.IndexOf("## Profile", $startIdx + 1)
        if ($nextSection -lt 0) { $nextSection = $tpContent.Length }
        $toneSection = $tpContent.Substring($startIdx, $nextSection - $startIdx)

        foreach ($lang in $Languages) {
            $marker = $langMarkers[$lang]
            if ($toneSection.Contains($marker)) {
                if ($Verbose) { Write-Pass ("tone-profiles.md [" + $tone + "/" + $lang + "]") }
            } else {
                Write-Fail ("tone-profiles.md [" + $tone + "/" + $lang + "] missing (" + $marker + ")")
            }
        }
    } else {
        Write-Fail ("tone-profiles.md tone section '" + $tone + "' not found")
    }
}

# ============================================
Write-Host ""
Write-Check "6. SKILL.md Stage 0 language detection table"

foreach ($lang in $Languages) {
    $tablePattern = "\| " + $lang + " \|"
    if ($skillContent -match $tablePattern) {
        Write-Pass ("Stage 0 table: " + $lang)
    } else {
        Write-Fail ("Stage 0 table: " + $lang + " missing")
    }
}

# ============================================
Write-Host ""
Write-Check "7. SKILL.md Stage 5 language-specific checks"

foreach ($lang in $Languages) {
    $checkStr = $Stage5Checks[$lang]
    $checkPattern = "\*\*" + [regex]::Escape($checkStr) + "\*\*"
    if ($skillContent -match $checkPattern) {
        Write-Pass ("Stage 5 check: " + $lang)
    } else {
        Write-Fail ("Stage 5 check: " + $lang + " missing")
    }
}

# ============================================
Write-Host ""
Write-Check "8. Verify flags (SKILL.md + specificity-ladder.md)"

$specContent = Get-Content (Join-Path $RepoRoot "shared\specificity-ladder.md") -Raw -Encoding UTF8

foreach ($lang in $Languages) {
    $flag = $VerifyFlags[$lang]
    $escapedFlag = [regex]::Escape($flag)

    if ($skillContent -match $escapedFlag) {
        Write-Pass ("SKILL.md verify flag: " + $lang)
    } else {
        Write-Fail ("SKILL.md verify flag: " + $lang + " missing")
    }

    if ($specContent -match $escapedFlag) {
        Write-Pass ("specificity-ladder.md verify flag: " + $lang)
    } else {
        Write-Fail ("specificity-ladder.md verify flag: " + $lang + " missing")
    }
}

# ============================================
Write-Host ""
Write-Check "9. SKILL.md output format language codes"

$langListPattern = "LANG: en / ru / uk / de / fr / es / pt / it / pl"
if ($skillContent -match [regex]::Escape($langListPattern)) {
    Write-Pass "Output format LANG line contains all 9 codes"
} else {
    Write-Fail "Output format LANG line incomplete or missing"
}

# ============================================
Write-Host ""
Write-Check "10. README language table rows"

# Native names for RU readme check
$ruNativeNames = @{}
$ruNativeNames["en"] = "English"
$ruNativeNames["ru"] = "Русский"
$ruNativeNames["uk"] = "Українська"
$ruNativeNames["de"] = "Deutsch"
$ruNativeNames["fr"] = "Français"
$ruNativeNames["es"] = "Español"
$ruNativeNames["pt"] = "Português"
$ruNativeNames["it"] = "Italiano"
$ruNativeNames["pl"] = "Polski"

$readmeEn = Get-Content (Join-Path $RepoRoot "README.md") -Raw -Encoding UTF8
$readmeRu = Get-Content (Join-Path $RepoRoot "README.ru.md") -Raw -Encoding UTF8

foreach ($lang in $Languages) {
    $name = $LangNames[$lang]
    if ($readmeEn.Contains($name)) {
        Write-Pass ("README.md: " + $name)
    } else {
        Write-Warn ("README.md: " + $name + " not in language table")
    }
    $nativeName = $ruNativeNames[$lang]
    if ($readmeRu.Contains($nativeName)) {
        Write-Pass ("README.ru.md: " + $nativeName)
    } else {
        Write-Warn ("README.ru.md: " + $nativeName + " not in language table")
    }
}

# ============================================
Write-Host ""
Write-Check "11. Scenario files tone references"

$scenarioDir = Join-Path $RepoRoot "scenarios"
$scenarioFiles = Get-ChildItem $scenarioDir -Filter "*.md"
foreach ($file in $scenarioFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content.Contains($defaultTonePattern)) {
        # Extract tone from backticks after "Default tone:"
        $toneMatch = [regex]::Match($content, 'Default tone:\*\*\s*`(\w+)`')
        if (-not $toneMatch.Success) {
            $toneMatch = [regex]::Match($content, 'Default tone:\s*`(\w+)`')
        }
        if ($toneMatch.Success) {
            $tone = $toneMatch.Groups[1].Value
            if ($tone -in $Tones) {
                Write-Pass ($file.Name + ": tone '" + $tone + "' valid")
            } else {
                Write-Warn ($file.Name + ": tone '" + $tone + "' not in known tones")
            }
        } else {
            Write-Warn ($file.Name + ": Default tone format not recognized")
        }
    } else {
        Write-Warn ($file.Name + ": no Default tone specified")
    }
}

# ============================================
Write-Host ""
Write-Check "12. Em-dash policy check"

$allMdFiles = Get-ChildItem $RepoRoot -Recurse -Include "*.md" | Where-Object { $_.FullName -notlike "*\.git\*" }
$emDashTotal = 0
foreach ($file in $allMdFiles) {
    $fname = $file.Name
    # ai-markers and burned-words reference em-dash as bad examples
    if ($fname -eq "ai-markers.md" -or $fname -eq "burned-words.md") { continue }
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $count = ([regex]::Matches($content, "[\u2014\u2013]")).Count
    if ($count -gt 0) {
        if ($Verbose) { Write-Warn ($fname + ": " + $count + " em-dash(es)") }
        $emDashTotal += $count
    }
}

if ($emDashTotal -eq 0) {
    Write-Pass "No em-dashes found in skill content files"
} else {
    Write-Warn ("Found " + $emDashTotal + " em-dash(es) in skill files")
}

# ============================================
Write-Host ""
Write-Check "13. File tree consistency"

$treeFiles = @(
    "SKILL.md","README.md","README.ru.md","CHANGELOG.md","EVAL.md","KNOWN_LIMITATIONS.md","LICENSE",".gitignore","PLAN.md",
    "shared/burned-words.md","shared/ai-markers.md","shared/tone-profiles.md",
    "shared/specificity-ladder.md","shared/rhythm-tables.md","shared/language-template.md",
    "shared/cultural-matrix.md",
    "scenarios/full-rewrite.md","scenarios/blog-post.md","scenarios/landing-page.md",
    "scenarios/social-post.md","scenarios/seo-article.md","scenarios/case-study.md",
    "scenarios/commercial-offer.md","scenarios/email.md","scenarios/technical-doc.md",
    "scenarios/translation-fix.md","scenarios/press-release.md","scenarios/internal-memo.md",
    "scenarios/grant-proposal.md","scenarios/creative-writing.md","scenarios/product-update.md",
    "scripts/validate.ps1","scripts/validate.sh",
    "scripts/zerogpt-detect.ps1","scripts/zerogpt-detect.sh","scripts/run-benchmark.ps1","scripts/run-benchmark.sh",
    "scripts/morph-check.ps1","scripts/readability-check.ps1","scripts/run-eval.ps1","scripts/clause-check.ps1",
    "examples/en-blog-post.md","examples/en-landing.md","examples/en-social.md",
    "examples/ru-blog-post.md","examples/ru-landing.md","examples/ru-social.md",
    "examples/uk-blog-post.md","examples/uk-social.md",
    "examples/de-blog-post.md","examples/de-email.md",
    "examples/fr-blog-post.md","examples/fr-social.md",
    "examples/es-blog-post.md","examples/es-landing.md",
    "examples/pt-blog-post.md","examples/pt-social.md",
    "examples/it-blog-post.md","examples/it-landing.md",
    "examples/pl-blog-post.md","examples/pl-social.md"
)

foreach ($f in $treeFiles) {
    $path = Join-Path $RepoRoot $f
    if (Test-Path $path -PathType Leaf) {
        if ($Verbose) { Write-Pass ("File exists: " + $f) }
    } else {
        Write-Warn ("File in tree but not on disk: " + $f)
    }
}

# ============================================
Write-Host ""
Write-Check "14. ZeroGPT integration scripts"

$zgScripts = @("zerogpt-detect.ps1", "zerogpt-detect.sh", "run-benchmark.ps1")
foreach ($zgScript in $zgScripts) {
    $zgPath = Join-Path $RepoRoot "scripts\$zgScript"
    if (Test-Path $zgPath -PathType Leaf) {
        Write-Pass ("ZeroGPT script exists: " + $zgScript)
    } else {
        Write-Fail ("ZeroGPT script missing: " + $zgScript)
    }
}

# Check ZeroGPT API key reference in scripts
$runBenchPath = Join-Path $RepoRoot "scripts\run-benchmark.ps1"
if (Test-Path $runBenchPath) {
    $runContent = Get-Content $runBenchPath -Raw -Encoding UTF8
    if ($runContent -match "zerogpt") {
        Write-Pass "run-benchmark.ps1 references ZeroGPT"
    } else {
        Write-Warn "run-benchmark.ps1 may not reference ZeroGPT"
    }
}

# Check that EVAL.md mentions ZeroGPT
$evalPath = Join-Path $RepoRoot "EVAL.md"
if (Test-Path $evalPath) {
    $evalContent = Get-Content $evalPath -Raw -Encoding UTF8
    if ($evalContent -match "ZeroGPT|zerogpt-detect|external.validator") {
        Write-Pass "EVAL.md references ZeroGPT external validator"
    } else {
        Write-Warn "EVAL.md should reference ZeroGPT external validator"
    }
}

# Check annotations.json still consistent
$annotationsPath = Join-Path $RepoRoot "tests\benchmark\annotations.json"
if (Test-Path $annotationsPath) {
    Write-Pass "annotations.json exists (benchmark data)"
} else {
    Write-Fail "annotations.json missing"
}

# ============================================
Write-Host ""
Write-Check "15. SKILL.md self-containment — embedded data vs shared/ links"

if ($skillContent -match "raw.githubusercontent.com") {
    Write-Pass "SKILL.md contains GitHub raw URLs for deep data"
} else {
    Write-Warn "SKILL.md missing GitHub raw URLs for deep data"
}
if ($skillContent -match "Top burned words") {
    Write-Pass "SKILL.md has embedded burned-words table"
} else {
    Write-Warn "SKILL.md may be missing embedded burned-words"
}
if ($skillContent -match "morph-check\.ps1") {
    Write-Pass "SKILL.md references morph-check.ps1"
} else {
    Write-Warn "SKILL.md missing morph-check reference"
}
if ($skillContent -match "readability-check\.ps1") {
    Write-Pass "SKILL.md references readability-check.ps1"
} else {
    Write-Warn "SKILL.md missing readability-check reference"
}
if ($skillContent -match "cultural-matrix\.md") {
    Write-Pass "SKILL.md references cultural-matrix.md"
} else {
    Write-Warn "SKILL.md missing cultural-matrix.md reference"
}

# Fix the undefined variable in scenario checks (check 11)
$defaultTonePattern = "Default tone"

# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ("Errors:   " + $Errors) -ForegroundColor $(if ($Errors -eq 0) { "Green" } else { "Red" })
Write-Host ("Warnings: " + $Warnings) -ForegroundColor $(if ($Warnings -eq 0) { "Green" } else { "Yellow" })
Write-Host ""

if ($Errors -gt 0) {
    Write-Host ("VALIDATION FAILED with " + $Errors + " error(s).") -ForegroundColor Red
    exit 1
} else {
    Write-Host "VALIDATION PASSED." -ForegroundColor Green
    exit 0
}
