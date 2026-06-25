#!/usr/bin/env pwsh
<#
.SYNOPSIS
    HUMAN-AI Benchmark Runner with ZeroGPT external validation.
.PARAMETER ApiKey
    ZeroGPT API key. Falls back to ZEROGPT_API_KEY env var.
.PARAMETER OutputFile
    JSON results path (default: tests/benchmark/zerogpt-results.json).
.PARAMETER MaxTexts
    Limit number of texts (for testing).
.PARAMETER SkipApi
    Dry run: show what would be tested without calling API.
.PARAMETER DelaySeconds
    Delay between API calls (default: 1).
#>
param(
    [string]$ApiKey,
    [string]$OutputFile,
    [int]$MaxTexts = 0,
    [switch]$SkipApi,
    [int]$DelaySeconds = 1
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-not $ApiKey) {
    $ApiKey = $env:ZEROGPT_API_KEY
}

if (-not $OutputFile) {
    $OutputFile = Join-Path $RepoRoot "tests\benchmark\zerogpt-results.json"
}

# --------------------------------------------------
# Discovery
# --------------------------------------------------
$tests = @()

$benchDir = Join-Path $RepoRoot "tests\benchmark"
$aiDir = Join-Path $benchDir "ai-texts"
if (Test-Path $aiDir -PathType Container) {
    Get-ChildItem $aiDir -Recurse -Filter "*.md" | ForEach-Object {
        $lang = $_.Directory.Name
        $type = $_.BaseName
        $raw = Get-Content $_.FullName -Raw -Encoding UTF8
        $clean = $raw -replace '^#[^\n]*\n\s*\n', ''
        $clean = $clean.Trim()
        if ($clean.Length -ge 50) {
            $tests += [PSCustomObject]@{ Id = "ai/$lang/$type"; Category = "ai"; Language = $lang; Type = $type; Text = $clean; File = $_.FullName }
        }
    }
}

$humanDir = Join-Path $benchDir "human-texts"
if (Test-Path $humanDir -PathType Container) {
    Get-ChildItem $humanDir -Filter "*.md" | ForEach-Object {
        $raw = Get-Content $_.FullName -Raw -Encoding UTF8
        $clean = $raw -replace '^#[^\n]*\n\s*\n', ''
        $clean = $clean.Trim()
        if ($clean.Length -ge 50) {
            $tests += [PSCustomObject]@{ Id = "human/$($_.BaseName)"; Category = "human"; Language = "en"; Type = $_.BaseName; Text = $clean; File = $_.FullName }
        }
    }
}

$edgeDir = Join-Path $benchDir "edge-cases"
if (Test-Path $edgeDir -PathType Container) {
    Get-ChildItem $edgeDir -Filter "*.md" | ForEach-Object {
        $raw = Get-Content $_.FullName -Raw -Encoding UTF8
        $clean = $raw -replace '^#[^\n]*\n\s*\n', ''
        $clean = $clean.Trim()
        if ($clean.Length -ge 50) {
            $tests += [PSCustomObject]@{ Id = "edge/$($_.BaseName)"; Category = "edge"; Language = "en"; Type = $_.BaseName; Text = $clean; File = $_.FullName }
        }
    }
}

# Counters
$aiCount = ($tests | Where-Object { $_.Category -eq "ai" }).Count
$humanCount = ($tests | Where-Object { $_.Category -eq "human" }).Count
$edgeCount = ($tests | Where-Object { $_.Category -eq "edge" }).Count

Write-Host "========================================"
Write-Host " HUMAN-AI ZeroGPT Benchmark Runner" -ForegroundColor Cyan
Write-Host "========================================"
Write-Host ""
Write-Host "  Tests discovered: $($tests.Count)"
Write-Host "    AI texts:       $aiCount"
Write-Host "    Human texts:    $humanCount"
Write-Host "    Edge cases:     $edgeCount"
Write-Host ""

if ($MaxTexts -gt 0 -and $tests.Count -gt $MaxTexts) {
    Write-Host "  Limiting to first $MaxTexts tests." -ForegroundColor Yellow
    $tests = $tests | Select-Object -First $MaxTexts
}

if ($SkipApi) {
    Write-Host "  DRY RUN - no API calls." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Would process:" -ForegroundColor Yellow
    foreach ($t in $tests) {
        Write-Host "    $($t.Id) -- $($t.Text.Length) chars"
    }
    Write-Host ""
    Write-Host "  Set ZEROGPT_API_KEY and run without -SkipApi to execute."
    exit 0
}

if (-not $ApiKey) {
    Write-Host "  ERROR: No API key. Set ZEROGPT_API_KEY env var or use -ApiKey." -ForegroundColor Red
    exit 2
}

# --------------------------------------------------
# Run detection
# --------------------------------------------------
$results = [System.Collections.ArrayList]::new()
$total = $tests.Count
$idx = 0
$headers = @{ "Content-Type" = "application/json"; "ApiKey" = $ApiKey }
$uri = "https://api.zerogpt.com/api/detect/detectText"

Write-Host ""
Write-Host "========================================"
Write-Host " Running ZeroGPT detection..." -ForegroundColor Cyan
Write-Host "========================================"
Write-Host ""

foreach ($test in $tests) {
    $idx++
    $progress = "[$idx/$total]"
    
    try {
        $body = @{ input_text = $test.Text } | ConvertTo-Json -Depth 1 -Compress
        $resp = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "application/json" -TimeoutSec 30
        
        $data = $resp.data
        $aiProb = 0.0
        $label = ""
        
        if ($data) {
            if ($data.isAi) { $aiProb = [double]$data.isAi }
            elseif ($data.aiProbability) { $aiProb = [double]$data.aiProbability }
            elseif ($data.percentage) { $aiProb = [double]$data.percentage }

            if ($aiProb -le 1.0) {
                $aiProb = [math]::Round($aiProb * 100.0, 1)
            } else {
                $aiProb = [math]::Round($aiProb, 1)
            }
            
            if ($data.textRating) { $label = $data.textRating }
            elseif ($data.result) { $label = $data.result }
        }
        
        $verdict = switch ($true) {
            { $aiProb -ge 80.0 } { "HEAVY_AI" }
            { $aiProb -ge 50.0 } { "LIKELY_AI" }
            { $aiProb -ge 25.0 } { "MIXED" }
            { $aiProb -ge 10.0 } { "LIKELY_HUMAN" }
            default { "HUMAN" }
        }
        
        $null = $results.Add([PSCustomObject]@{
            Id = $test.Id
            Category = $test.Category
            Language = $test.Language
            Type = $test.Type
            AIScore = $aiProb
            Label = $label
            Verdict = $verdict
            TextLength = $test.Text.Length
            Success = $true
            Error = ""
        })
        
        Write-Host "  $progress $verdict".PadRight(28) + " $($test.Id)".PadRight(35) + " ${aiProb}% AI"
    }
    catch {
        $errMsg = $_.Exception.Message
        try {
            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $errBody = $reader.ReadToEnd()
                $reader.Close()
                $httpCode = $_.Exception.Response.StatusCode.value__
                $errMsg = "HTTP $httpCode : $errBody"
            }
        } catch {}
        
        $null = $results.Add([PSCustomObject]@{
            Id = $test.Id
            Category = $test.Category
            Language = $test.Language
            Type = $test.Type
            AIScore = $null
            Label = ""
            Verdict = "ERROR"
            TextLength = $test.Text.Length
            Success = $false
            Error = $errMsg
        })
        
        Write-Host "  $progress ERROR".PadRight(28) + " $($test.Id)".PadRight(35) + " -- $errMsg" -ForegroundColor Red
    }
    
    if ($DelaySeconds -gt 0 -and $idx -lt $total) {
        Start-Sleep -Seconds $DelaySeconds
    }
}

# --------------------------------------------------
# Report
# --------------------------------------------------
Write-Host ""
Write-Host "========================================"
Write-Host " BENCHMARK RESULTS" -ForegroundColor Cyan
Write-Host "========================================"
Write-Host ""

$cats = $results | Group-Object -Property Category
foreach ($cat in $cats) {
    $valid = $cat.Group | Where-Object { $_.Success }
    $errors = ($cat.Group | Where-Object { -not $_.Success }).Count
    
    if ($valid.Count -gt 0) {
        $avg = [math]::Round(($valid | Measure-Object -Property AIScore -Average).Average, 1)
        $minVal = ($valid | Measure-Object -Property AIScore -Minimum).Minimum
        $maxVal = ($valid | Measure-Object -Property AIScore -Maximum).Maximum
        Write-Host "  [$($cat.Name)]" -ForegroundColor Yellow
        Write-Host "    Count:   $($cat.Count) texts ($($valid.Count) ok, $errors errors)"
        Write-Host "    Avg AI:  $avg%"
        Write-Host "    Range:   $minVal% - $maxVal%"
    }
    else {
        Write-Host "  [$($cat.Name)]" -ForegroundColor Yellow
        Write-Host "    Count:   $($cat.Count) texts (all failed)"
    }
    Write-Host ""
}

# --------------------------------------------------
# Save JSON
# --------------------------------------------------
$report = [PSCustomObject]@{
    Generated = (Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz")
    Skill = "human-ai"
    Version = "3.0"
    Detector = "ZeroGPT"
    ApiEndpoint = $uri
    TotalTests = $results.Count
    Successful = ($results | Where-Object { $_.Success }).Count
    Failed = ($results | Where-Object { -not $_.Success }).Count
    Results = @($results)
}

$report | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $OutputFile -Encoding UTF8
Write-Host "  Results saved to: $OutputFile" -ForegroundColor Cyan
Write-Host ""
