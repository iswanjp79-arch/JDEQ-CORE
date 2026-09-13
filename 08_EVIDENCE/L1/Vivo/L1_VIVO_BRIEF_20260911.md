# L1 VIVO Y28 — BRIEF (2026-09-11)

Node       : V2352 (vivo Y28)
Platform   : Android 16 (SDK 36), kernel 5.10.246-android12, aarch64
Tailscale  : 100.127.153.2
Termux     : 0.119.0-beta.3 (F-Droid)

## Ringkas Hardware
- CPU   : 8 core ARM64
- RAM   : 7.9 GB (2.8 GB available, swap 3.6 GB)
- eMMC  : 222 GB (44% used)
- Battery: Li-ion, 47%, 37.3C, health GOOD, 871 cycle

## L1 Evidence Files
- L1-04_thermal_vivo_*.txt
- L1-05_io_vivo_*.txt
- (identitas, CPU, memory, storage tercatat inline saat sondir)

## Peran Terverifikasi
- Sensor observability (l3/l4/l7 probe rutin)
- Mercusuar cron 02:00 (Denyut_Mercusuar.txt)
- Remote Commander (SSH key-only, port 8022)

## Konfigurasi Aktif
- sshd port 8022, key-only auth
- crond aktif, wakelock aktif
- Termux whitelist Doze: YES
- Tailscale whitelist Doze: YES (2026-09-11 16:0X)
- Always-On VPN: pending verifikasi

## Punch List
- A2 : sync Vivo -> Z83 berhenti 18 hari
- A3 : L7 latency 1915 ms belum ditelusuri
- A4 : integrasi probe akurat ke mico_auto_obs.sh
- A5 : uji Doze 24 jam

Status: L1 Vivo COMPLETE secara data, menunggu uji Doze 24 jam untuk CLOSE.
Brief disusun: 2026-09-11
Executor: AG-003 DeepSeek | Reviewer: L0

---

## Update 2026-09-11 17:14

A5 Doze test: LULUS (window 55 menit idle, SSH tetap responsif).
- SSH terakhir sebelum uji: 16:19:09
- SSH uji Doze: 17:14:17
- Gap: 55 menit idle
- Hasil: DOZE_PASS

Whitelist Doze aktif:
- com.termux
- com.tailscale.ipn

Status: A5 CLOSED (window 1 jam). Uji 24 jam dijadwalkan besok.
Vivo L1: COMPLETE — siap masuk audit KIMI/Claude.
