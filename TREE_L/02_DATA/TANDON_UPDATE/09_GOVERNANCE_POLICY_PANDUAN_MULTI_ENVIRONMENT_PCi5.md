# PANDUAN MULTI-ENVIRONMENT PC-i5

## Prinsip
- Setiap alat punya zona kerja. Jangan campur peran.
- Salah pakai alat = pekerjaan mundur / rusak / bukti tidak sah.
- Jika ragu, TANYA L0. Jangan menebak.

## 1. PowerShell (Administrator)
Gunakan untuk:
- Mengelola file & folder Windows
- Membaca status sistem (CPU, RAM, disk)
- Menyalin file governance/evidence
- Menghitung hash SHA256
- Mengelola Git lokal

## 2. CMD
Gunakan hanya jika:
- PowerShell tidak tersedia
- Perintah sangat sederhana (misal: ping, ipconfig)
- Catatan: jangan paksa pekerjaan besar di CMD.

## 3. WSL2 / Ubuntu
Gunakan untuk:
- Python / pemrosesan data
- Git (jika lebih nyaman)
- Linux tools (grep, sed, awk, dll.)
- Tes integrasi lokal
- AI/embedding eksperimen (jika resource cukup)

## 4. JSON
Gunakan untuk:
- Komunikasi antar-agen
- Manifest, registry, evidence, hash
- Format output SPK/task card

## LARANGAN
- Jangan memakai WSL untuk mengubah file Windows governance.
- Jangan memakai PowerShell untuk mengeksekusi skrip Python berat.
- Jangan mencampur log Windows dan WSL tanpa pemisahan.
- Jangan membuat file panduan/aturan di luar TREE_L.
