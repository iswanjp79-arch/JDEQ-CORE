Param(
  [string]$PayloadFile = "D:\MICO_SSOT\08_EVIDENCE\alert\tests\payload.json",
  [string]$EvidenceDir = "D:\MICO_SSOT\08_EVIDENCE\alert\tests",
  [string]$Webhook = "http://127.0.0.1/api/v1/alerts",
  [string]$SmtpServer = "127.0.0.1",
  [int]$SmtpPort = 25,
  [string]$From = "alert@mico.local",
  [string]$To = "oncall@example.com",
  [string]$SyslogHost = "127.0.0.1",
  [int]$SyslogPort = 6514
)

New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null
$timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
$payload = Get-Content -Raw -Path $PayloadFile -ErrorAction Stop

# Webhook
$webhookOut = Join-Path $EvidenceDir ("webhook_response-local-" + $timestamp + ".txt")
try {
  $resp = Invoke-RestMethod -Uri $Webhook -Method Post -Body $payload -ContentType "application/json" -TimeoutSec 15 -ErrorAction Stop
  $resp | Out-File -FilePath $webhookOut -Encoding utf8
} catch {
  $_.Exception.Message | Out-File -FilePath $webhookOut -Encoding utf8
}

# SMTP
$smtpOut = Join-Path $EvidenceDir ("smtp_send-local-" + $timestamp + ".err")
try {
  Send-MailMessage -SmtpServer $SmtpServer -Port $SmtpPort -From $From -To $To -Subject "Test Alert Local Forwarder" -Body $payload -ErrorAction Stop
  "SMTP_OK" | Out-File -FilePath $smtpOut -Encoding utf8
} catch {
  $_.Exception.Message | Out-File -FilePath $smtpOut -Encoding utf8
}

# Syslog via TCP simple emitter
$syslogOut = Join-Path $EvidenceDir ("syslog_send-local-" + $timestamp + ".err")
try {
  $client = New-Object System.Net.Sockets.TcpClient
  $client.Connect($SyslogHost, $SyslogPort)
  $stream = $client.GetStream()
  $msg = "<14>1 $((Get-Date).ToString("o")) local-forwarder - - - $payload"
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg + "`n")
  $stream.Write($bytes,0,$bytes.Length)
  $stream.Flush()
  $stream.Close()
  $client.Close()
  "SYSLOG_SENT" | Out-File -FilePath $syslogOut -Encoding utf8
} catch {
  $_.Exception.Message | Out-File -FilePath $syslogOut -Encoding utf8
}

# Checksum and result
$sha = (Get-FileHash -Algorithm SHA256 -Path $PayloadFile).Hash
"$sha *$PayloadFile" | Out-File -FilePath (Join-Path $EvidenceDir ("payload-local-" + $timestamp + ".sha256")) -Encoding ascii
"FORWARD_COMPLETE $timestamp" | Out-File -FilePath (Join-Path $EvidenceDir ("forward-result-" + $timestamp + ".txt")) -Encoding utf8

Write-Output "Local forwarder run complete. Evidence in $EvidenceDir"
