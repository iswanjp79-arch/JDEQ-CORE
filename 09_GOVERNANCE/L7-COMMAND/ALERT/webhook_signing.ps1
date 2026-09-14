# webhook_signing.ps1
param(
  [string]$payloadFile,
  [string]$secretPath
)
$payload = Get-Content -Raw -Path $payloadFile
$secret = Get-Secret -Path $secretPath
$hmac = New-Object System.Security.Cryptography.HMACSHA256
$hmac.Key = [System.Text.Encoding]::UTF8.GetBytes($secret)
$hash = $hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($payload))
$signature = "sha256=" + ([System.BitConverter]::ToString($hash) -replace "-","").ToLower()
Write-Output $signature
