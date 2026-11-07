#!/usr/bin/env bash
# HUMAN-AI Integrity Validator (Bash)
# Validates cross-references and language coverage across all skill files.
# Usage: bash scripts/validate.sh [--verbose]
set -euo pipefail

VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SKILL_ROOT/../.." && pwd)"
if [[ -f "$REPO_ROOT/skills/human-ai/SKILL.md" && -f "$REPO_ROOT/CHANGELOG.md" ]]; then
    IS_REPO=true
    SCAN_ROOT="$REPO_ROOT"
else
    IS_REPO=false
    SCAN_ROOT="$SKILL_ROOT"
fi

ERRORS=0
WARNINGS=0

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}[PASS]${NC} $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo -e "  ${RED}[FAIL]${NC} $1"; }
warn() { WARNINGS=$((WARNINGS + 1)); echo -e "  ${YELLOW}[WARN]${NC} $1"; }
check() { echo -e "${CYAN}[CHECK]${NC} $1"; }

LANGUAGES=("en" "ru" "uk" "de" "fr" "es" "pt" "it" "pl")
TONES=("expert" "biz" "human" "social" "landing" "article" "case")

declare -A LANG_NAMES=(
    [en]="English" [ru]="Russian" [uk]="Ukrainian" [de]="German"
    [fr]="French" [es]="Spanish" [pt]="Portuguese" [it]="Italian" [pl]="Polish"
)

declare -A RU_NATIVE_NAMES=(
    [en]="English" [ru]="Русский" [uk]="Українська" [de]="Deutsch"
    [fr]="Français" [es]="Español" [pt]="Português" [it]="Italiano" [pl]="Polski"
)

declare -A VERIFY_FLAGS=(
    [en]="\[VERIFY" [ru]="\[ПРОВЕРИТЬ" [uk]="\[ПЕРЕВІРИТИ" [de]="\[PRÜFEN"
    [fr]="\[VÉRIFIER" [es]="\[VERIFICAR" [pt]="\[VERIFICAR" [it]="\[VERIFICARE" [pl]="\[SPRAWDZIĆ"
)

declare -A STAGE5_CHECKS=(
    [en]="EN:" [ru]="RU:" [uk]="UK:" [de]="DE:"
    [fr]="FR:" [es]="ES:" [pt]="PT:" [it]="IT:" [pl]="PL:"
)

# ============================================
echo ""
check "1. SKILL.md YAML Frontmatter"
SKILL_CONTENT=$(cat "$SKILL_ROOT/SKILL.md")

grep -q "name: human-ai" <<< "$SKILL_CONTENT" && pass "name: human-ai" || fail "name field missing"
grep -q 'version: "4.1.1"' <<< "$SKILL_CONTENT" && pass "version: 4.1.1" || fail "version missing or incorrect"
grep -q "languages:" <<< "$SKILL_CONTENT" && pass "languages field present" || fail "languages missing"
grep -q "pipeline_stages: 5" <<< "$SKILL_CONTENT" && pass "pipeline_stages: 5" || fail "pipeline_stages missing"

# ============================================
echo ""
check "2. Language coverage in shared/ files"

for lang in "${LANGUAGES[@]}"; do
    name="${LANG_NAMES[$lang]}"
    
    # burned-words.md
    if grep -q "## $name" "$SKILL_ROOT/shared/burned-words.md" 2>/dev/null; then
        pass "burned-words.md [$lang]"
    else
        fail "burned-words.md [$lang] not found"
    fi
    
    # ai-markers.md
    if grep -q "## $name" "$SKILL_ROOT/shared/ai-markers.md" 2>/dev/null; then
        pass "ai-markers.md [$lang]"
    else
        fail "ai-markers.md [$lang] not found"
    fi
    
    # specificity-ladder.md
    if grep -q "### $name" "$SKILL_ROOT/shared/specificity-ladder.md" 2>/dev/null; then
        pass "specificity-ladder.md [$lang]"
    else
        warn "specificity-ladder.md [$lang] not found"
    fi
    
    # rhythm-tables.md openers
    upper_lang=$(echo "$lang" | tr '[:lower:]' '[:upper:]')
    if grep -q "Opener categories - $upper_lang" "$SKILL_ROOT/shared/rhythm-tables.md" 2>/dev/null; then
        pass "rhythm-tables.md [$lang] openers"
    else
        warn "rhythm-tables.md [$lang] openers not found"
    fi
    
    # Conjunctions in rhythm-tables.md
    if grep -q "$upper_lang:" "$SKILL_ROOT/shared/rhythm-tables.md" 2>/dev/null; then
        pass "rhythm-tables.md [$lang] conjunctions"
    else
        warn "rhythm-tables.md [$lang] conjunctions not found"
    fi
done

# ============================================
echo ""
check "3. Tone profile coverage (7 profiles x 9 languages)"

TP_CONTENT=$(cat "$SKILL_ROOT/shared/tone-profiles.md")
declare -A LANG_MARKERS=(
    [en]="EN markers" [ru]="RU markers" [uk]="UK markers" [de]="DE markers"
    [fr]="FR markers" [es]="ES markers" [pt]="PT markers" [it]="IT markers" [pl]="PL markers"
)

for tone in "${TONES[@]}"; do
    for lang in "${LANGUAGES[@]}"; do
        marker="${LANG_MARKERS[$lang]}"
        if grep -q "$marker" <<< "$TP_CONTENT"; then
            if $VERBOSE; then pass "tone-profiles.md [$tone/$lang]"; fi
        else
            fail "tone-profiles.md [$tone/$lang] missing ($marker)"
        fi
    done
done

# ============================================
echo ""
check "4. SKILL.md Stage 0 language detection table"

for lang in "${LANGUAGES[@]}"; do
    if grep -q "| $lang |" <<< "$SKILL_CONTENT"; then
        pass "Stage 0 table: $lang"
    else
        fail "Stage 0 table: $lang missing"
    fi
done

# ============================================
echo ""
check "5. SKILL.md Stage 5 language-specific checks"

for lang in "${LANGUAGES[@]}"; do
    check_str="${STAGE5_CHECKS[$lang]}"
    if grep -q "\*\*$check_str\*\*" <<< "$SKILL_CONTENT"; then
        pass "Stage 5 check: $lang"
    else
        fail "Stage 5 check: $lang missing"
    fi
done

# ============================================
echo ""
check "6. Verify flags (SKILL.md + specificity-ladder.md)"

SPEC_CONTENT=$(cat "$SKILL_ROOT/shared/specificity-ladder.md")
for lang in "${LANGUAGES[@]}"; do
    flag="${VERIFY_FLAGS[$lang]}"
    if grep -q "$flag" <<< "$SKILL_CONTENT"; then
        pass "SKILL.md verify flag: $lang"
    else
        fail "SKILL.md verify flag: $lang missing"
    fi
    if grep -q "$flag" <<< "$SPEC_CONTENT"; then
        pass "specificity-ladder.md verify flag: $lang"
    else
        fail "specificity-ladder.md verify flag: $lang missing"
    fi
done

# ============================================
echo ""
check "7. SKILL.md output format language codes"

if grep -q "LANG: en / ru / uk / de / fr / es / pt / it / pl" <<< "$SKILL_CONTENT"; then
    pass "Output format LANG line contains all 9 codes"
else
    fail "Output format LANG line incomplete"
fi

# ============================================
echo ""
check "8. README language table rows"

if [[ -f "$REPO_ROOT/README.md" && -f "$REPO_ROOT/README.ru.md" ]]; then
    README_EN=$(cat "$REPO_ROOT/README.md")
    README_RU=$(cat "$REPO_ROOT/README.ru.md")

    for lang in "${LANGUAGES[@]}"; do
        name="${LANG_NAMES[$lang]}"
        grep -q "$name" <<< "$README_EN" && pass "README.md: $name" || warn "README.md: $name not in table"
        native="${RU_NATIVE_NAMES[$lang]}"
        grep -q "$native" <<< "$README_RU" && pass "README.ru.md: $native" || warn "README.ru.md: $native not in table"
    done
else
    warn "README files are not installed; language table check skipped"
fi

# ============================================
echo ""
check "9. Scenario files tone references"

for f in "$SKILL_ROOT/scenarios/"*.md; do
    fname=$(basename "$f")
    if grep -q "Default tone:" "$f" 2>/dev/null; then
        tone=$(grep "Default tone:" "$f" | sed -n 's/.*Default tone:\*\* `\([^`]*\)`.*/\1/p')
        if [[ -z "$tone" ]]; then
            tone=$(grep "Default tone:" "$f" | sed -n 's/.*Default tone: `\([^`]*\)`.*/\1/p')
        fi
        if [[ " ${TONES[*]} " =~ " ${tone} " ]]; then
            pass "$fname: tone '$tone' valid"
        else
            fail "$fname: tone '$tone' not in known tones"
        fi
    else
        warn "$fname: no Default tone specified"
    fi
done

# ============================================
echo ""
check "10. Em-dash policy check"

EM_COUNT=0
while IFS= read -r -d '' f; do
    # Skip .git directory
    if [[ "$f" == *".git"* ]]; then continue; fi
    # Benchmark fixtures intentionally contain AI markers, including em-dashes.
    if [[ "$f" == *"tests/benchmark"* ]]; then continue; fi
    # ai-markers and burned-words reference em-dash as bad examples
    if [[ "$f" == *"ai-markers.md"* ]] || [[ "$f" == *"burned-words.md"* ]]; then continue; fi
    count=$(grep -Pc '[\x{2014}\x{2013}]' "$f" 2>/dev/null || true)
    if [[ "$count" -gt 0 ]]; then
        EM_COUNT=$((EM_COUNT + count))
        if $VERBOSE; then warn "$(basename "$f"): $count em-dash(es)"; fi
    fi
done < <(find "$SCAN_ROOT" -name "*.md" -print0 2>/dev/null)

if [[ "$EM_COUNT" -eq 0 ]]; then
    pass "No em-dashes found in skill content files"
else
    warn "Found $EM_COUNT em-dash(es) in skill files"
fi

# ============================================
echo ""
check "11. File tree consistency"

TREE_FILES=(
    "SKILL.md" "README.md" "README.ru.md" "CHANGELOG.md" "EVAL.md" "KNOWN_LIMITATIONS.md" "LICENSE" ".gitignore"
    "shared/burned-words.md" "shared/ai-markers.md" "shared/tone-profiles.md"
    "shared/specificity-ladder.md" "shared/rhythm-tables.md" "shared/language-template.md"
    "scenarios/full-rewrite.md" "scenarios/blog-post.md" "scenarios/landing-page.md"
    "scenarios/social-post.md" "scenarios/seo-article.md" "scenarios/case-study.md"
    "scenarios/commercial-offer.md" "scenarios/email.md" "scenarios/technical-doc.md"
    "scenarios/translation-fix.md"
    "scripts/validate.ps1" "scripts/validate.sh"
    "scripts/zerogpt-detect.ps1" "scripts/zerogpt-detect.sh" "scripts/run-benchmark.ps1" "scripts/run-benchmark.sh"
    "examples/en-blog-post.md" "examples/en-landing.md" "examples/en-social.md"
    "examples/ru-blog-post.md" "examples/ru-landing.md" "examples/ru-social.md"
    "examples/uk-blog-post.md" "examples/uk-social.md"
)

for f in "${TREE_FILES[@]}"; do
    if [[ -f "$SKILL_ROOT/$f" || -f "$REPO_ROOT/$f" ]]; then
        if $VERBOSE; then pass "File exists: $f"; fi
    else
        warn "File in tree but not on disk: $f"
    fi
done

# ============================================
echo ""
check "12. ZeroGPT integration scripts"

ZG_SCRIPTS=("zerogpt-detect.ps1" "zerogpt-detect.sh" "run-benchmark.ps1")
for zg_script in "${ZG_SCRIPTS[@]}"; do
    if [[ -f "$SKILL_ROOT/scripts/$zg_script" ]]; then
        pass "ZeroGPT script exists: $zg_script"
    else
        fail "ZeroGPT script missing: $zg_script"
    fi
done

# Check EVAL.md references ZeroGPT
if grep -q "ZeroGPT\|zerogpt-detect\|external.validator" "$SKILL_ROOT/EVAL.md" 2>/dev/null; then
    pass "EVAL.md references ZeroGPT external validator"
else
    warn "EVAL.md should reference ZeroGPT external validator"
fi

# Check annotations.json still present
if $IS_REPO; then
    if [[ -f "$REPO_ROOT/tests/benchmark/annotations.json" ]]; then
        pass "annotations.json exists (benchmark data)"
    else
        fail "annotations.json missing"
    fi
else
    warn "annotations.json is not installed; benchmark data check skipped"
fi

# ============================================
echo ""
echo "========================================"
echo -e "${CYAN}VALIDATION SUMMARY${NC}"
echo "========================================"
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [[ "$ERRORS" -gt 0 ]]; then
    echo -e "${RED}VALIDATION FAILED with $ERRORS error(s).${NC}"
    exit 1
else
    echo -e "${GREEN}VALIDATION PASSED.${NC}"
    exit 0
fi
