# MICO-3L-EXEC-001
# Read-only connectivity test; input IP per device; stop on fail; write evidence + sha256

$Evidence = "D:\MICO_SSOT\08_EVIDENCE\3L-TEST"
New-Item -ItemType Directory -Force -Path $Evidence | Out-Null
$TS = Get-Date -Format "yyyyMMdd-HHmmss"
$Log = "$Evidence\3L-TEST-$TS.txt"

"=== MICO-3L-EXEC-001 ===" | Tee-Object -FilePath $Log
"Host : $env:COMPUTERNAME" | Tee-Object -FilePath $Log -Append
"Date : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Tee-Object -FilePath $Log -Append
"Purpose : Connectivity test only" | Tee-Object -FilePath $Log -Append
"" | Tee-Object -FilePath $Log -Append

function Run-Stage {
  param($StageName, $TargetName)
  $Target = Read-Host "Masukkan IP/alamat $TargetName"
  "" | Tee-Object -FilePath $Log -Append
  "=== $StageName ===" | Tee-Object -FilePath $Log -Append
  "Target : $TargetName ($Target)" | Tee-Object -FilePath $Log -Append
  "Time : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Tee-Object -FilePath $Log -Append
  $PingOK = Test-Connection -ComputerName $Target -Count 2 -Quiet -ErrorAction SilentlyContinue
  "Ping : $PingOK" | Tee-Object -FilePath $Log -Append
  if (-not $PingOK) {
    "RESULT : FAIL — STOP" | Tee-Object -FilePath $Log -Append
    Write-Host "GAGAL. Bukti tersimpan: $Log"
    return $false
  }
  tracert -d -h 8 -w 1000 $Target 2>&1 | Tee-Object -FilePath $Log -Append
  "RESULT : PASS" | Tee-Object -FilePath $Log -Append
  return $true
}

# Stages: Z83, HP Mini, Vivo Y28, Infinix, Aspire One
if (-not (Run-Stage "TAHAP 2 — PC-i5 <-> Z83" "Z83")) { exit }
if (-not (Run-Stage "TAHAP 3 — PC-i5 <-> HP Mini" "HP Mini")) { exit }
if (-not (Run-Stage "TAHAP 4 — PC-i5 <-> Vivo Y28" "Vivo Y28")) { exit }
if (-not (Run-Stage "TAHAP 5 — PC-i5 <-> Infinix" "Infinix")) { exit }
if (-not (Run-Stage "TAHAP 6 — PC-i5 <-> Aspire One" "Aspire One")) { exit }

"--- TAHAP 7 ---" | Tee-Object -FilePath $Log -Append
"FINISH TIME : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Tee-Object -FilePath $Log -Append
"STATUS : ALL TESTED STAGES PASSED" | Tee-Object -FilePath $Log -Append

# create sha256 fingerprint of the log
Get-FileHash -Algorithm SHA256 -Path $Log | ForEach-Object {
  $_.Hash + "  " + $Log
} | Set-Content -Path ($Log + ".sha256.txt") -Encoding ascii

Write-Host "=== SELESAI ==="
Write-Host "Bukti : $Log"
