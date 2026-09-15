# P1 EXECUTION GUIDE — Petunjuk Siap-Tempel
Kode   : MICO-P1-EXECUTION-GUIDE-001
Status : SAH — 2026-09-16 (L0 ACC)
Fungsi : Petunjuk operasional untuk verifikasi, backup, dan pemulihan P1

## 1. BACA BERKAS SUMBER
Set-Location "D:\MICO_SSOT"
Get-Content "09_GOVERNANCE\P1-PLANNING\MICO-JDEQ-CORE-LOGIC.json" -Encoding UTF8
Get-Content "09_GOVERNANCE\P1-PLANNING\MICO-JDEQ-SYSTEM-MANIFEST.md" -Encoding UTF8
Get-Content "09_GOVERNANCE\ADR\ADR-005_REKONSILIASI_GOVERNANCE_V21.md" -Encoding UTF8
Get-Content "09_GOVERNANCE\ADR\ADR-005-REV1.md" -Encoding UTF8
Get-Content "09_GOVERNANCE\ADR\ADR-006-LAYER-MODEL-CANONICAL.md" -Encoding UTF8
Get-Content "09_GOVERNANCE\P1-PLANNING\MICO-JDEQ-MASTER-PLAN-v1.0.md" -Encoding UTF8

## 2. VERIFIKASI SHA256
pwsh -NoProfile -File "09_GOVERNANCE\TOOLS\PORTABLE\mico-verify.ps1"
# Expected: Total: OK=24  MISMATCH=0  MISSING=0

## 3. BUAT DIREKTORI (JIKA BELUM ADA)
New-Item -ItemType Directory -Force -Path "12_BACKUP\MONUMENTS" | Out-Null
New-Item -ItemType Directory -Force -Path "08_EVIDENCE" | Out-Null
New-Item -ItemType Directory -Force -Path "09_GOVERNANCE\P1-PLANNING" | Out-Null

## 4. SIMPAN BERKAS (JIKA PERLU)
# Rencana Induk v1.0 (sudah ada, jangan timpa):
# 09_GOVERNANCE\P1-PLANNING\MICO-JDEQ-MASTER-PLAN-v1.0.md

## 5. SALINAN CADANGAN SEBELUM UBAH ADR
Copy-Item "09_GOVERNANCE\ADR\ADR-005_REKONSILIASI_GOVERNANCE_V21.md" `
          "12_BACKUP\ADR-005-ORIGINAL-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
Copy-Item "09_GOVERNANCE\ADR\ADR-006-LAYER-MODEL-CANONICAL.md" `
          "12_BACKUP\ADR-006-ORIGINAL-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

## 6. HITUNG & CATAT BUKTI
Get-ChildItem "09_GOVERNANCE\ADR\ADR-005-REV1.md",
              "09_GOVERNANCE\ADR\ADR-006-LAYER-MODEL-CANONICAL.md",
              "09_GOVERNANCE\P1-PLANNING\MICO-JDEQ-MASTER-PLAN-v1.0.md" |
    Get-FileHash -Algorithm SHA256 |
    ForEach-Object { "$($_.Hash)  $($_.Path)" } |
    Out-File "08_EVIDENCE\P1-KEY-HASH-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt" -Encoding ascii

## 7. YANG DILARANG SEBELUM L0 MENYETUJUI
- git commit --no-verify (bypass hook)
- Menimpa ADR/V.21 yang sudah disahkan
- Modifikasi SSOT tanpa referensi ADR
- Compress-Archive / ZIP tanpa izin tertulis
- Push ke remote tanpa commit valid

## 8. ALUR BAKU
Baca → Susun → Tampilkan → Tunggu L0 → Kunci