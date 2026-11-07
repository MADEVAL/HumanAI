#!/usr/bin/env pwsh
<#
.SYNOPSIS
    ZeroGPT AI detection script for HUMAN-AI skill validation.
    Detects whether text is AI-generated using ZeroGPT's external API.

.DESCRIPTION
    Sends text to ZeroGPT API and returns a structured detection result.
    Used as an EXTERNAL validator for HUMAN-AI skill quality evaluation.
    Not dependent on the skill's own heuristics - provides independent verification.

.PARAMETER Text
    Text to analyze for AI generation.

.PARAMETER File
    Path to a text file to analyze. Reads UTF-8 content.

.PARAMETER ApiKey
    ZeroGPT API key. Falls back to ZEROGPT_API_KEY environment variable.

.PARAMETER Json
    Output raw JSON response from API instead of formatted result.

.PARAMETER Timeout
    API request timeout in seconds (default: 30).

.EXAMPLE
    powershell -File scripts/zerogpt-detect.ps1 -Text "Some text to check"

.EXAMPLE
    powershell -File scripts/zerogpt-detect.ps1 -File "tests/benchmark/ai-texts/en/blog-post.md"

.EXAMPLE
    $env:ZEROGPT_API_KEY = "your-key"
    powershell -File scripts/zerogpt-detect.ps1 -File "input.md" -Json

.NOTES
    Part of HUMAN-AI text humanization skill v3.0+
    API docs: https://app.theneo.io/olive-works-llc/zerogpt-docs/zerogpt-business-api
#>

param(
    [string]$Text,
    [string]$File,
    [string]$ApiKey,
    [switch]$Json,
    [int]$Timeout = 30
)

$ErrorActionPreference = "Stop"

# --- Resolve API Key ---
if (-not $ApiKey) {
    $ApiKey = $env:ZEROGPT_API_KEY
}
if (-not $ApiKey) {
    Write-Error "No API key provided. Use -ApiKey parameter or set ZEROGPT_API_KEY environment variable."
    exit 2
}

# --- Resolve Input ---
$inputText = ""
if ($File) {
    if (-not (Test-Path -LiteralPath $File -PathType Leaf)) {
        Write-Error "File not found: $File"
        exit 1
    }
    $inputText = Get-Content -LiteralPath $File -Raw -Encoding UTF8
    # Strip markdown headers (# Title + blank line) for cleaner detection
    $inputText = $inputText -replace '^#[^\n]*\n\s*\n', ''
    $inputText = $inputText.Trim()
}
elseif ($Text) {
    $inputText = $Text.Trim()
}
else {
    Write-Error "No input provided. Use -Text or -File parameter."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($inputText)) {
    Write-Error "Input text is empty."
    exit 1
}

# --- Validate minimum length (ZeroGPT typically needs 50+ chars) ---
if ($inputText.Length -lt 50) {
    Write-Warning "Text is very short ($($inputText.Length) chars). ZeroGPT may return unreliable results for texts under 50 characters."
}

# --- Call ZeroGPT API ---
$uri = "https://api.zerogpt.com/api/detect/detectText"
$headers = @{
    "Content-Type" = "application/json"
    "ApiKey"        = $ApiKey
}
$body = @{
    input_text = $inputText
} | ConvertTo-Json -Depth 1 -Compress

try {
    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body `
        -ContentType "application/json" -TimeoutSec $Timeout
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = ""
    try {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        $reader.Close()
    } catch {}

    Write-Error "ZeroGPT API request failed (HTTP $statusCode): $errorBody"
    exit 3
}

# --- Parse Response ---
if (-not $response.success) {
    $msg = if ($response.message) { $response.message } else { "Unknown API error" }
    Write-Error "ZeroGPT API error: $msg"
    exit 4
}

$data = $response.data

# --- Output ---
if ($Json) {
    $response | ConvertTo-Json -Depth 3
    exit 0
}

# Parse detection data fields (ZeroGPT response structure)
$aiProbability = 0
$humanProbability = 0
$isHuman = $null
$sentences = @()
$resultLabel = ""
$feedback = ""

# Extract detection fields - ZeroGPT returns various structures
if ($data) {
    $aiProbability = if ($data.isAi) { [double]$data.isAi } elseif ($data.aiProbability) { [double]$data.aiProbability } elseif ($data.percentage) { [double]$data.percentage } else { 0 }
    $humanProbability = if ($data.isHuman) { [double]$data.isHuman } elseif ($data.humanProbability) { [double]$data.humanProbability } else { 0 }
    $isHuman = if ($data.isHuman -ne $null) { $data.isHuman } elseif ($data.textRating) { $data.textRating -match 'human' } else { $null }
    $resultLabel = if ($data.textRating) { $data.textRating } elseif ($data.result) { $data.result } else { "" }
    $feedback = if ($data.feedback) { $data.feedback } else { "" }
    if ($data.sentences) { $sentences = @($data.sentences) }
}

# Fallback: if isHuman field exists, convert to probability
if ($isHuman -eq $true) {
    $aiProbability = [Math]::Max(0, 100 - ($humanProbability * 100))
}
elseif ($aiProbability -gt 0 -and $aiProbability -le 1) {
    # Normalize: if AI probability is 0-1 scale
}
elseif ($aiProbability -gt 1) {
    # Already a percentage
}

$aiScore = if ($aiProbability -le 1 -and $aiProbability -gt 0) {
    [math]::Round($aiProbability * 100, 1)
} else {
    [math]::Round($aiProbability, 1)
}

$verdict = switch ($true) {
    ($aiScore -ge 80) { "HEAVY_AI" }
    ($aiScore -ge 50) { "LIKELY_AI" }
    ($aiScore -ge 25) { "MIXED" }
    ($aiScore -ge 10) { "LIKELY_HUMAN" }
    default { "HUMAN" }
}

# Human-readable output format
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ZeroGPT AI Detection Result" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  AI Probability:   $aiScore%" -ForegroundColor $(if ($aiScore -ge 50) { "Red" } else { "Green" })
Write-Host "  Verdict:          $verdict" -ForegroundColor $(if ($verdict -match 'AI') { "Red" } else { "Green" })
if ($resultLabel) {
    Write-Host "  Label:            $resultLabel"
}
if ($feedback) {
    Write-Host "  Feedback:         $feedback"
}
Write-Host "  Text length:      $($inputText.Length) chars, $(($inputText -split '\s+').Count) words"
if ($sentences.Count -gt 0) {
    Write-Host ""
    Write-Host "  Sentence-level analysis:" -ForegroundColor Yellow
    $aiSentences = $sentences | Where-Object { $_.isHuman -eq $false -or $_.aiProbability -gt 0.5 }
    $humanSentences = $sentences | Where-Object { $_.isHuman -eq $true -or $_.aiProbability -le 0.5 }
    Write-Host "    AI-flagged:     $($aiSentences.Count) sentences"
    Write-Host "    Human-flagged:  $($humanSentences.Count) sentences"
}
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Exit with code indicating verdict
if ($verdict -eq "HEAVY_AI" -or $verdict -eq "LIKELY_AI") {
    exit 10
}
exit 0
