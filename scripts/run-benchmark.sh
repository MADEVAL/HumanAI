#!/usr/bin/env bash
# HUMAN-AI Benchmark Runner (Bash) with ZeroGPT external validation.
# Usage: bash scripts/run-benchmark.sh [--api-key KEY] [--max-texts N] [--skip-api] [--delay N]

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_KEY="${ZEROGPT_API_KEY:-}"
OUTPUT_FILE=""
MAX_TEXTS=0
SKIP_API=false
DELAY=1

while [[ $# -gt 0 ]]; do
    case "$1" in
        --api-key) API_KEY="$2"; shift 2 ;;
        --max-texts) MAX_TEXTS="$2"; shift 2 ;;
        --skip-api) SKIP_API=true; shift ;;
        --delay) DELAY="$2"; shift 2 ;;
        --output) OUTPUT_FILE="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE="$REPO_ROOT/tests/benchmark/zerogpt-results.json"
fi

BENCH_DIR="$REPO_ROOT/tests/benchmark"
AI_DIR="$BENCH_DIR/ai-texts"

echo ""
echo "=== HUMAN-AI BENCHMARK RUNNER ==="
echo "Benchmark dir: $BENCH_DIR"
echo "Output: $OUTPUT_FILE"
echo ""

# Discover test files
declare -a TESTS=()
while IFS= read -r -d '' file; do
    rel="${file#$AI_DIR/}"
    lang="$(echo "$rel" | cut -d/ -f1)"
    type="$(basename "$rel" .md)"
    # Strip YAML/markdown headers: remove first heading and blank line after
    text="$(sed '1{/^#/d}; /^\s*$/{/^$/d}' "$file" | head -c 10000)"
    if [ ${#text} -ge 50 ]; then
        TESTS+=("ai/$lang/$type|$lang|$type|$file")
    fi
done < <(find "$AI_DIR" -name "*.md" -print0)

echo "Discovered ${#TESTS[@]} AI test files"

if [ "$MAX_TEXTS" -gt 0 ] && [ "$MAX_TEXTS" -lt "${#TESTS[@]}" ]; then
    TESTS=("${TESTS[@]:0:$MAX_TEXTS}")
    echo "Limited to $MAX_TEXTS texts"
fi

if [ "$SKIP_API" = true ]; then
    echo ""
    echo "DRY RUN — would test:"
    for entry in "${TESTS[@]}"; do
        id="$(echo "$entry" | cut -d'|' -f1)"
        echo "  $id"
    done
    echo ""
    exit 0
fi

if [ -z "$API_KEY" ]; then
    echo "ERROR: No API key set. Use --api-key or ZEROGPT_API_KEY env var."
    exit 2
fi

echo ""
echo "Running ZeroGPT checks..."

RESULTS='{"version":"1.0","timestamp":"'"$(date -Iseconds)"'","results":{'
FIRST=true

count=0
total=${#TESTS[@]}

for entry in "${TESTS[@]}"; do
    count=$((count + 1))
    id="$(echo "$entry" | cut -d'|' -f1)"
    lang="$(echo "$entry" | cut -d'|' -f2)"
    type="$(echo "$entry" | cut -d'|' -f3)"
    file="$(echo "$entry" | cut -d'|' -f4)"

    echo -n "  [$count/$total] $id ... "

    # Strip first heading and following blank lines for clean text
    text="$(sed '1{/^#/d}; /^\s*$/{/^$/d}' "$file" | head -c 5000)"

    # Call ZeroGPT API
    response="$(curl -s -X POST "https://api.zerogpt.com/api/detect" \
        -H "ApiKey: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "$(jq -n --arg text "$text" '{input_text: $text}')" 2>&1 || true)"

    if echo "$response" | jq -e '.data' > /dev/null 2>&1; then
        ai_prob="$(echo "$response" | jq -r '.data.aiPercentage // .data.fakePercentage // 0')"
        result="$(echo "$response" | jq -r '.data.isHuman // "unknown"')"
        echo "$ai_prob% AI ($result)"
        if [ "$FIRST" = false ]; then RESULTS+=","; fi
        RESULTS+="\"$id\": {\"ai_probability\": $ai_prob, \"result\": \"$result\", \"language\": \"$lang\", \"type\": \"$type\"}"
        FIRST=false
    else
        echo "API error"
    fi

    if [ "$count" -lt "$total" ]; then
        sleep "$DELAY"
    fi
done

RESULTS+='}}'

echo "$RESULTS" | jq '.' > "$OUTPUT_FILE"
echo ""
echo "Results saved to: $OUTPUT_FILE"
echo "Done."
