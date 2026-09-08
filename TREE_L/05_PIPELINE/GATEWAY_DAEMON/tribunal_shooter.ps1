# tribunal_shooter.ps1  PC-i5 Local Tribunal Shooter

param(
    [Parameter(Mandatory=$true)]
    [string]$Prompt
)

$ErrorActionPreference = "Stop"

$base = "D:\MICO_SSOT\TREE_L"
$tribunalInbox = "$base\09_GOVERNANCE\TRIBUNAL\INBOX"
$evDir = "$base\08_EVIDENCE\RUNTIME"

$groqKey = $env:GROQ_API_KEY
$geminiKey = $env:GEMINI_API_KEY

if (-not $groqKey -and -not $geminiKey) {
    Write-Output "ERROR: GROQ_API_KEY dan GEMINI_API_KEY belum diset."
    Write-Output "Gunakan: `$env:GROQ_API_KEY='...'; `$env:GEMINI_API_KEY='...'; .\tribunal_shooter.ps1 'prompt'"
    exit 1
}

function Tulis-Envelope {
    param($Provider, $Model, $Status, $Answer)

    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $envelope = [PSCustomObject]@{
        provider = $Provider
        model = $Model
        status = $Status
        answer = $Answer
        timestamp = $timestamp
    } | ConvertTo-Json -Compress

    $ts = Get-Date -Format "yyyyMMdd_HHmmss_ffff"
    $filename = "$Provider_$ts.json"
    $filePath = Join-Path $tribunalInbox $filename
    $envelope | Set-Content -Path $filePath -Encoding UTF8

    $hash = (Get-FileHash $filePath -Algorithm SHA256).Hash
    $evidence = @"
=== TRIBUNAL EVIDENCE ===
Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
File: $filePath
SHA256: $hash
Provider: $Provider
Status: $Status
"@
    $evidencePath = Join-Path $evDir "TRIBUNAL_${Provider}_${ts}.txt"
    $evidence | Set-Content -Path $evidencePath -Encoding UTF8

    Write-Output "$Provider : $Status"
    Write-Output "File : $filePath"
    Write-Output "Hash : $hash"
}

function Kirim-Groq {
    param($Prompt)

    $model = "openai/gpt-oss-120b"
    $headers = @{
        "Authorization" = "Bearer $groqKey"
        "Content-Type"  = "application/json"
    }
    $body = @{
        model = $model
        messages = @(@{ role = "user"; content = $Prompt })
        max_tokens = 100
    } | ConvertTo-Json -Compress

    try {
        $resp = Invoke-RestMethod -Uri "https://api.groq.com/openai/v1/chat/completions" `
            -Method Post -Headers $headers -Body $body
        $answer = $resp.choices[0].message.content.Trim()
        Tulis-Envelope -Provider "groq" -Model $model -Status "HTTP_200" -Answer $answer
    } catch {
        $status = "HTTP_" + [int]$_.Exception.Response.StatusCode
        Tulis-Envelope -Provider "groq" -Model $model -Status $status -Answer $_.Exception.Message
    }
}

function Kirim-Gemini {
    param($Prompt)

    $model = "gemini-3.8-flash"
    $uri = "https://generativelanguage.googleapis.com/v1beta/models/$model`?key=$geminiKey"
    $body = @{
        contents = @(@{ parts = @(@{ text = $Prompt }) })
    } | ConvertTo-Json -Compress

    try {
        $resp = Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $body
        $answer = $resp.candidates[0].content.parts[0].text.Trim()
        Tulis-Envelope -Provider "gemini" -Model $model -Status "HTTP_200" -Answer $answer
    } catch {
        $status = "HTTP_" + [int]$_.Exception.Response.StatusCode
        Tulis-Envelope -Provider "gemini" -Model $model -Status $status -Answer $_.Exception.Message
    }
}

if ($groqKey) { Kirim-Groq -Prompt $Prompt }
if ($geminiKey) { Kirim-Gemini -Prompt $Prompt }
