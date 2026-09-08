# PROTEKSI PIPA — ELEVASI & BEGESTING DIGITAL

## Prinsip
- Pipa data (watchdog_pipeline.py) tidak boleh kempet oleh beban Windows.
- Dijalankan dalam wadah dengan prioritas dan afinitas terkunci.
- Wrapper: wadah_pipa.ps1

## Cara Pakai
1. Buka PowerShell Administrator.
2. Jalankan:
   & "D:\MICO_SSOT\TREE_L\05_PIPELINE\wadah_pipa.ps1"

## Aturan
- Prioritas default: AboveNormal.
- CPU affinity default: 0xE (core 1-3).
- Jangan jalankan watchdog langsung tanpa wadah.
- Jika sudah berjalan, wadah akan mendeteksi dan menolak duplikasi.

## Pemulihan
- Hentikan proses jika perlu:
  Get-Process python | Where-Object { $_.Path -like "*python*" } | Stop-Process -Force
