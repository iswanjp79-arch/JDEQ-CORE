# F1 NODE INVENTORY  2026-09-14

Status    : READ_ONLY_DISCOVERY
Authority : L0
Evidence  : 08_EVIDENCE/L7-OPERATIONAL/control_room/status_20260914.json

---

## CONTROL MODEL

- DI RUMAH  : PC-i5 (host) + Vivo Y28 via USB ADB (kabel tembaga, anti-latensi)
- DI LUAR   : Vivo Y28 (host)  5 node lain via Tailscale

---

## NODE 1  PC-i5 (kapal-induk)

| Field | Value |
|---|---|
| Status | ONLINE |
| OS / Arch | Windows 10 Enterprise / 64-bit |
| CPU | Intel Core i5-3470 @ 3.20GHz |
| Core / Thread | 4 / 4 |
| RAM | 16 GB |
| Disk C | 89.9 GB used / 28.7 GB free |
| GPU | NVIDIA GeForce GT 730 |
| Uptime | 7j 11m |
| Python | 3.14.7 |
| Docker | 29.7.2 |
| Git | 2.55.0 |
| Tailscale IP | 100.124.50.70 |
| Provenance | PowerShell Win32_* / python --version / docker --version / git --version |

---

## NODE 2  Z83 (markas-utama)

| Field | Value |
|---|---|
| Status | ONLINE |
| OS / Arch | Ubuntu Linux / x86_64 |
| CPU | Intel Atom x5-Z8350 @ 1.44GHz |
| Core | 4 |
| RAM | 3.2 GB (2.5 GB available) |
| Swap | 7.7 GB |
| Disk / | 56 GB total / 30 GB free |
| GPU | Intel Atom Integrated |
| Uptime | 5d 19h |
| Python | 3.14.4 |
| Docker | 29.1.3 |
| Git | 2.53.0 |
| Tailscale IP | 100.67.36.31 |
| Provenance | SSH from PC-i5, uname / lscpu / free / df / uptime / tailscale ip |

---

## NODE 3  Vivo Y28 (v2352)

| Field | Value |
|---|---|
| Status | ONLINE |
| OS / Arch | Android 12 (kernel 5.10.246) / aarch64 |
| CPU model | UNKNOWN (kernel tidak expose via /proc/cpuinfo) |
| Core | >=3 (terdeteksi processor 0-2) |
| RAM | 7.6 GB total (2.8 GB available) |
| Swap | 8 GB (3.6 GB used) |
| Disk / | 4.4 GB total / 0 free / 100% FULL |
| GPU | UNKNOWN (getprop ro.hardware.vulkan kosong) |
| Uptime | 1d 13h |
| Load average | 19.15 / 17.98 / 17.72 (SANGAT TINGGI) |
| Python | 3.14.6 |
| Git | 2.55.0 |
| Tailscale (device) | ONLINE |
| Tailscale (Termux daemon) | NOT_RUNNING |
| Provenance | Termux shell: uname / cat proc/cpuinfo / free / df / uptime / tailscale ip |
