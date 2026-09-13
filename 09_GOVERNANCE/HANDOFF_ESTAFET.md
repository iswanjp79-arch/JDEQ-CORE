# ============================================
# MICO-JDEQ HANDOFF — ESTAFET KE CHAT BARU
# Tanggal: 2026-09-13
# Otoritas: L0 — Iswan Juman Pancoro, ST
# ============================================

## 1. IDENTITAS SISTEM
- Nama: MICO-JDEQ (Adaptive Control System)
- SSOT Lokal: D:\MICO_SSOT\
- Git branch: master
- Git user: Iswan Juman Pancoro <iswanjp79@gmail.com>
- Secondary OneDrive: rinawatimadina@gmail.com

## 2. DOKTRIN TERKUNCI
- MICO-ARCH-TANDEM-001: PC-i5/Z83 = bastion · worker = LAN-only
- MICO-DOC-MEGAZORD-001: Inner Zone tanpa Tailscale
- MICO-DOC-SOVEREIGN-001: Alat ikut kebutuhan
- MICO-L2-SEC-005: Layer 2 closed
- ADR-003: Layer 3 Execution (M1-M5 + Dead-Path Circuit Breaker)

## 3. ATURAN KERAS
- Tanpa kontrak L0 = tanpa eksekusi
- Awan = penasihat · bukan eksekutor
- Bukti dulu · klaim kemudian
- Zero Direct Execution di worker RAM-kecil
- Semua perintah ke worker = one-shot dari PC-i5

## 4. TOPOLOGI FISIK
- Router: Tenda XP80DB (RT/RW Net) · 192.168.1.1
- WiFi: SSID iswan · Channel 6 · 20MHz
- PC-i5: 192.168.1.4 (Windows) · Tailscale 100.124.50.70
- HP Mini: 192.168.1.6 (Debian 13 antiX) · MAC wlan1 00:e0:34:30:1d:ec
- Z83: Tailscale 100.67.36.31 · LAN belum onboard
- Vivo Y28: Tailscale · mobile terminal
- Infinix: standby · belum onboard
- Aspire One: standby · belum onboard

## 5. YANG SUDAH SELESAI
Layer 2:
- UFW aktif HP Mini (22/tcp dari LAN) + autostart via cron
- Udev rule dongle no-autosuspend
- IP statis HP Mini via dhcpcd.conf
- GUI trim: 6 XDG autostart dinonaktifkan

Layer 3:
- M1 Local Observer: OK (snapshot CPU/RAM/disk)
- M2 Path Safety: OK (VALID/BLOCKED)
- M3 PC5 Collector: OK (pull-only)
- M4 Alert Engine: OK (HEALTHY/DEGRADED/FAULT/BLOCKED)
- M5 External Sync: OK (git commit dari PC-i5)
- Commit evidence: COMMITTED

## 6. LOKASI FILE PENTING
- Modul L3: D:\MICO_SSOT\L3-modules\ (5 file .py)
- Evidence: D:\MICO_SSOT\08_EVIDENCE\<modul>\
- Governance: D:\MICO_SSOT\09_GOVERNANCE\
- ADR-003: D:\MICO_SSOT\09_GOVERNANCE\ADR-003-L3-Execution.txt
- Akun & peran: D:\MICO_SSOT\09_GOVERNANCE\AKUN_DAN_PERAN.md

## 7. BATAS HARDWARE (diterima)
- Port LAN HP Mini: RUSAK
- Dongle RTL8188FTV: loss 15-20% (batas fisik)
- HP Mini via WiFi dongle = satu-satunya jalur

## 8. YANG BELUM
- Onboard Z83/Aspire/Infinix (butuh SSH key)
- Runner/scheduler untuk M1-M4 (belum ada cron/task)
- Dual-Perimeter enforcement di HP Mini (block outbound)
- Integrasi m5 push ke remote

## 9. PRINSIP KOMUNIKASI
- Bahasa teknis · padat · langsung
- Analitik = rekomendasi · bukti = jaminan
- L0 pegang keputusan · agen eksekusi
- Tanda tangani setiap keputusan dengan kode

## 10. TASK PENDING (untuk sesi baru)
- Fix potential: M1-M4 perlu scheduler (cron Windows Task Scheduler)
- Onboard node lain
- Dual-Perimeter lock HP Mini (UFW deny outgoing non-LAN)
- Push git ke remote (belum ada remote URL)

## 11. LINK CHAT SEBELUMNYA
[https://chat.deepseek.com/a/chat/s/7c11b30f-050b-4ba9-8ac8-6661bddfaa43]

# ============================================
# END OF HANDOFF
# ============================================
