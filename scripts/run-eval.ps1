#!/usr/bin/env pwsh
# HUMAN-AI External EVAL Runner
# Sends original + humanized text to LLM API with EVAL.md prompt for independent evaluation.
# Supports OpenAI and Anthropic APIs.
# Usage: powershell -File scripts/run-eval.ps1 -Original "input.txt" -Humanized "output.md" -ApiKey $env:API_KEY

param(
    [Parameter(Mandatory=$true)]
    [string]$Original,

    [Parameter(Mandatory=$true)]
    [string]$Humanized,

    [ValidateSet("openai","anthropic")]
    [string]$Provider = "openai",

    [string]$ApiKey,

    [string]$Model = "",

    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-not $ApiKey) {
    $ApiKey = if ($Provider -eq "openai") { $env:OPENAI_API_KEY } else { $env:ANTHROPIC_API_KEY }
}

if (-not $ApiKey) {
    Write-Host "[ERROR] No API key. Set OPENAI_API_KEY or ANTHROPIC_API_KEY env variable, or pass -ApiKey." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $Original)) { Write-Host "[ERROR] Original not found: $Original" -ForegroundColor Red; exit 1 }
if (-not (Test-Path $Humanized)) { Write-Host "[ERROR] Humanized not found: $Humanized" -ForegroundColor Red; exit 1 }

$originalText = Get-Content $Original -Raw
$humanizedText = Get-Content $Humanized -Raw

$evalPrompt = Get-Content (Join-Path $RepoRoot "EVAL.md") -Raw

if (-not $Model) {
    $Model = if ($Provider -eq "openai") { "gpt-4o" } else { "claude-3-5-sonnet-20241022" }
}

$pythonScript = @"
import sys, json

original_text = r'''$($originalText -replace "'", "''")'''
humanized_text = r'''$($humanizedText -replace "'", "''")'''
eval_prompt = r'''$($evalPrompt -replace "'", "''")'''
provider = '$Provider'
model = '$Model'
api_key = '$ApiKey'

system_msg = f"""$evalPrompt

You are a quality evaluator. Evaluate the following HUMAN-AI output against the original.

ORIGINAL:
$original_text

HUMAN-AI OUTPUT:
$humanized_text"""

messages = [
    {"role": "system", "content": system_msg},
    {"role": "user", "content": "Produce the EVAL REPORT in the specified format. Be objective and precise."}
]

headers = {"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"}

if provider == "openai":
    import urllib.request, urllib.error
    data = json.dumps({"model": model, "messages": messages, "temperature": 0.1, "max_tokens": 4000}).encode()
    req = urllib.request.Request("https://api.openai.com/v1/chat/completions", data=data, headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            result = json.loads(resp.read())
            content = result["choices"][0]["message"]["content"]
            print(json.dumps({"status": "ok", "content": content, "model": result.get("model", model)}))
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(json.dumps({"status": "error", "error": f"HTTP {e.code}: {body}"}))
elif provider == "anthropic":
    import urllib.request, urllib.error
    data = json.dumps({
        "model": model,
        "max_tokens": 4000,
        "temperature": 0.1,
        "system": system_msg,
        "messages": [{"role": "user", "content": "Produce the EVAL REPORT in the specified format. Be objective and precise."}]
    }).encode()
    req = urllib.request.Request("https://api.anthropic.com/v1/messages", data=data, headers={**headers, "anthropic-version": "2023-06-01", "x-api-key": api_key}, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            result = json.loads(resp.read())
            content = result["content"][0]["text"]
            print(json.dumps({"status": "ok", "content": content, "model": result.get("model", model)}))
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(json.dumps({"status": "error", "error": f"HTTP {e.code}: {body}"}))
"@

$tmpPy = Join-Path ([System.IO.Path]::GetTempPath()) "eval-$([System.Guid]::NewGuid()).py"
Set-Content -Path $tmpPy -Value $pythonScript -Encoding UTF8

try {
    Write-Host "[EVAL] Sending to $Provider ($Model)..." -ForegroundColor Cyan
    $result = & python $tmpPy 2>&1
    $json = $result | ConvertFrom-Json

    if ($json.status -eq "error") {
        Write-Host "[EVAL ERROR] $($json.error)" -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Write-Host "[EVAL REPORT — External LLM]" -ForegroundColor Cyan
    Write-Host "Model: $($json.model)"
    Write-Host ""
    Write-Host $json.content

    exit 0
}
finally {
    Remove-Item $tmpPy -Force -ErrorAction SilentlyContinue
}
