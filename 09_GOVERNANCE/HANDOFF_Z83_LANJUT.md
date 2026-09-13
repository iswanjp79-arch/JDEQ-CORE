# HANDOFF LANJUTAN — SONDIR L1 Z83

## STATUS
Node: Z83 (markas-utama), Ubuntu 26.04 LTS, IP Tailscale 100.67.36.31
Sudah selesai: L1-00, L1-01, L1-02, L1-03, L1-04, L1-05
Belum selesai: L1-06, L1-07, L1-08
Bukti: D:\MICO_SSOT\08_EVIDENCE\L1\Z83\ (6 file sudah ada)

## CARA KERJA
- Terminal Z83 (prompt iswanjp@markas-utama:~$) = Bash/Linux
- Terminal PC-i5 (prompt [KAPAL-INDUK] C:\Windows\system32 $) = PowerShell
- JANGAN tukar. Perintah bash hanya di Z83, perintah PowerShell hanya di PC-i5.
- Output Z83 disimpan ke PC-i5 lewat copy-paste.

## ATURAN
- Read-only di Z83. Tanpa instalasi, tanpa konfigurasi, tanpa layanan.
- Z83 zero-retention: tidak menyimpan file di Z83.
- Bukti disimpan di PC-i5.
- Laporan singkat ke L0. Tanpa drama, tanpa narasi panjang.

## LANJUTKAN
Perintah untuk L1-06 (physical role) di Z83:
  hostname; uptime; systemctl list-units --type=service --state=running | head -20

Setelah itu: L1-07 paspor, L1-08 acceptance, lalu brief ke L0.

## DATA YANG SUDAH DIKUMPULKAN
- L1-00: Linux 7.0.0-31, Ubuntu 26.04, hostname markas-utama
- L1-01: Intel Atom x5-Z8350, 4 core, max 1.92 GHz
- L1-02: RAM 3.4 GB, Swap 8.1 GB
- L1-03: eMMC 57.7 GB, root 56 GB (24 used, 30 free)
- L1-04: 6 thermal zone, 46-49C idle, governor schedutil
- L1-05: LAN 192.168.1.11, WiFi 192.168.1.15, Tailscale 100.67.36.31, keyboard Primax USB

## JANGAN DILAKUKAN
- Jangan buka ulang PC-i5 (sudah CLOSE_WITH_PUNCH_LIST)
- Jangan bahas token, peran agen, atau meta-topik
- Jangan tambah aturan baru
- Jangan kunci folder
- Jangan install apapun
