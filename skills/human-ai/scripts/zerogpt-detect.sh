#!/usr/bin/env bash
#
# ZeroGPT AI detection script for HUMAN-AI skill validation.
# Detects whether text is AI-generated using ZeroGPT's external API.
#
# Usage:
#   ./scripts/zerogpt-detect.sh --text "Some text to check"
#   ./scripts/zerogpt-detect.sh --file "tests/benchmark/ai-texts/en/blog-post.md"
#   ZEROGPT_API_KEY="your-key" ./scripts/zerogpt-detect.sh --file "input.md" --json
#
# Options:
#   --text TEXT       Text to analyze
#   --file PATH       Path to a text file to analyze
#   --apikey KEY      ZeroGPT API key (env: ZEROGPT_API_KEY)
#   --json            Output raw JSON instead of formatted result
#   --timeout SEC     Request timeout in seconds (default: 30)
#   --help            Show this help
#
# Exit codes:
#   0   Text classified as human or mixed
#   1   Input error (no text/file provided)
#   2   Authentication error (no API key)
#   3   API connection error
#   4   API returned error
#   10  Text classified as AI-generated
#
# API docs: https://app.theneo.io/olive-works-llc/zerogpt-docs/zerogpt-business-api

set -euo pipefail

# --- Defaults ---
TIMEOUT=30
API_URL="https://api.zerogpt.com/api/detect/detectText"
INPUT_TEXT=""
INPUT_FILE=""
API_KEY="${ZEROGPT_API_KEY:-}"
OUTPUT_JSON=false

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --text)
            INPUT_TEXT="$2"
            shift 2
            ;;
        --file)
            INPUT_FILE="$2"
            shift 2
            ;;
        --apikey)
            API_KEY="$2"
            shift 2
            ;;
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --help|-h)
            head -30 "$0" | grep -E '^#( |$)' | sed 's/^# \?//'
            exit 0
            ;;
        *)
            echo "ERROR: Unknown argument: $1"
            echo "Use --help for usage."
            exit 1
            ;;
    esac
done

# --- Validate API Key ---
if [ -z "$API_KEY" ]; then
    echo "ERROR: No API key provided. Use --apikey or set ZEROGPT_API_KEY env var."
    exit 2
fi

# --- Resolve input ---
if [ -n "$INPUT_FILE" ]; then
    if [ ! -f "$INPUT_FILE" ]; then
        echo "ERROR: File not found: $INPUT_FILE"
        exit 1
    fi
    # Read file, strip markdown header lines
    INPUT_TEXT=$(cat "$INPUT_FILE" | sed '1{/^# /d}; 2{/^$/d}')
    INPUT_TEXT=$(echo "$INPUT_TEXT" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
elif [ -n "$INPUT_TEXT" ]; then
    INPUT_TEXT=$(echo "$INPUT_TEXT" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
else
    echo "ERROR: No input provided. Use --text or --file."
    exit 1
fi

if [ -z "$INPUT_TEXT" ]; then
    echo "ERROR: Input text is empty."
    exit 1
fi

# --- Validate minimum length ---
CHAR_COUNT=$(echo "$INPUT_TEXT" | wc -c)
if [ "$CHAR_COUNT" -lt 50 ]; then
    echo "WARNING: Text is very short (${CHAR_COUNT} chars). ZeroGPT may return unreliable results."
fi

# --- Build JSON body (escape for JSON) ---
JSON_BODY=$(python3 -c "
import sys, json
text = sys.stdin.read()
print(json.dumps({'input_text': text}))
" <<< "$INPUT_TEXT" 2>/dev/null || python -c "
import sys, json
text = sys.stdin.read()
print(json.dumps({'input_text': text}))
" <<< "$INPUT_TEXT")

# --- Call ZeroGPT API ---
HTTP_CODE=$(mktemp)
RESPONSE=$(mktemp)

curl_cmd=(
    curl -s -w "%{http_code}" -o "$RESPONSE"
    -X POST "$API_URL"
    -H "Content-Type: application/json"
    -H "ApiKey: $API_KEY"
    -d "$JSON_BODY"
    --connect-timeout 10
    --max-time "$TIMEOUT"
)

if ! HTTP_STATUS=$("${curl_cmd[@]}" 2>/dev/null); then
    echo "ERROR: Failed to connect to ZeroGPT API."
    rm -f "$HTTP_CODE" "$RESPONSE"
    exit 3
fi

RESPONSE_BODY=$(cat "$RESPONSE")
rm -f "$HTTP_CODE" "$RESPONSE"

if [ "$HTTP_STATUS" != "200" ]; then
    echo "ERROR: ZeroGPT API returned HTTP $HTTP_STATUS"
    echo "$RESPONSE_BODY"
    exit 3
fi

# --- Parse response ---
SUCCESS=$(echo "$RESPONSE_BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('success', False))" 2>/dev/null || echo "false")

if [ "$SUCCESS" != "True" ]; then
    MSG=$(echo "$RESPONSE_BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message', 'Unknown error'))" 2>/dev/null || echo "Unknown error")
    echo "ERROR: ZeroGPT API error: $MSG"
    echo "Full response: $RESPONSE_BODY"
    exit 4
fi

# --- Output ---
if [ "$OUTPUT_JSON" = true ]; then
    echo "$RESPONSE_BODY"
    exit 0
fi

# Extract values
AI_PROB=$(echo "$RESPONSE_BODY" | python3 -c "
import sys, json
d=json.load(sys.stdin)
data = d.get('data', {})
# Try multiple possible field names
ai = data.get('isAi') or data.get('aiProbability') or data.get('percentage') or 0
if isinstance(ai, (int, float)) and ai <= 1:
    ai = ai * 100
print(round(float(ai), 1))
" 2>/dev/null || echo "0")

LABEL=$(echo "$RESPONSE_BODY" | python3 -c "
import sys, json
d=json.load(sys.stdin)
data = d.get('data', {})
print(data.get('textRating', data.get('result', '')))
" 2>/dev/null || echo "")

FEEDBACK=$(echo "$RESPONSE_BODY" | python3 -c "
import sys, json
d=json.load(sys.stdin)
data = d.get('data', {})
print(data.get('feedback', ''))
" 2>/dev/null || echo "")

WORD_COUNT=$(echo "$INPUT_TEXT" | wc -w | tr -d ' ')

# --- Determine verdict ---
VERDICT="HUMAN"
if (( $(echo "$AI_PROB >= 80" | bc -l 2>/dev/null || echo 0) )); then
    VERDICT="HEAVY_AI"
elif (( $(echo "$AI_PROB >= 50" | bc -l 2>/dev/null || echo 0) )); then
    VERDICT="LIKELY_AI"
elif (( $(echo "$AI_PROB >= 25" | bc -l 2>/dev/null || echo 0) )); then
    VERDICT="MIXED"
elif (( $(echo "$AI_PROB >= 10" | bc -l 2>/dev/null || echo 0) )); then
    VERDICT="LIKELY_HUMAN"
fi

# --- Pretty output ---
echo ""
echo "========================================"
echo " ZeroGPT AI Detection Result"
echo "========================================"
echo ""
echo "  AI Probability:   ${AI_PROB}%"
echo "  Verdict:          ${VERDICT}"
if [ -n "$LABEL" ]; then
    echo "  Label:            ${LABEL}"
fi
if [ -n "$FEEDBACK" ]; then
    echo "  Feedback:         ${FEEDBACK}"
fi
echo "  Text length:      ${CHAR_COUNT} chars, ${WORD_COUNT} words"
echo ""
echo "========================================"

# Exit with code
if [ "$VERDICT" = "HEAVY_AI" ] || [ "$VERDICT" = "LIKELY_AI" ]; then
    exit 10
fi
exit 0
