# DOKTRIN INTI MICO-JDEQ: DISTRIBUTED AI MESH
**Status:** LOCKED PERMANENT — CORE LOGIC DIPSY
**Tanggal:** 31 Juli 2026
**Visi:** Setiap perangkat adalah entitas hidup dengan AI lokal, terhubung tanpa internet.

## Definisi "Kabel Ghoib" — Bridge Tanpa Internet
"Kabel ghoib" adalah jalur komunikasi yang memungkinkan perangkat saling terhubung tanpa internet publik:
- **LAN / WiFi Rumah** — jaringan lokal di Campurejo.
- **SSH Tunnel** — terowongan terenkripsi antar perangkat.
- **Tailscale / WireGuard** — VPN mesh dengan MagicDNS.
- **NATS / MQTT** — protokol pesan ringan, event-driven.
- **USB / Ethernet** — kabel fisik, jembatan langsung.

## Setiap Perangkat Punya AI Lokal (Entitas Hidup)
| Perangkat | AI Lokal | Ukuran | Fungsi |
|-----------|----------|--------|--------|
| Vivo Y28 | Qwen 2.5 3B | ~2 GB | Gateway, komando taktis |
| Z83 | Phi-3 Mini 3.8B | ~2.2 GB | Eksekutor, analisis lokal |
| Infinix 32-bit | Gemma 2B / RWKV | ~1.5 GB | Sensor, telemetri |
| PC i5 | Llama 3.2 3B + Groq | ~2 GB | Komputasi berat, backup cloud |
| TravelMate | Phi-3 Mini 3.8B | ~2.2 GB | Workstation mobile |

## Prinsip Utama
1. **Tidak perlu internet** — AI lokal berjalan di perangkat masing-masing.
2. **Tidak perlu alasan** — RAM, ROM, processor, storage diabaikan. Semua perangkat wajib punya AI lokal.
3. **Jembatan lokal** — LAN + SSH + Tailscale = kabel ghoib.
4. **Internet hanya untuk cloud** — Groq, Gemini, Hugging Face hanya untuk tugas berat.
5. **Entitas hidup 24/7** — setiap perangkat punya agen yang selalu berjalan.

## Core Logic Dipsy
- Qwen 2.5 3B di Vivo Y28 adalah **Gateway AI**.
- Phi-3 Mini di Z83 adalah **Worker AI**.
- Gemma 2B di Infinix adalah **Sensor AI**.
- Semua terhubung via LAN + SSH + Tailscale.
- Tanpa internet, MICO-JDEQ tetap hidup.
