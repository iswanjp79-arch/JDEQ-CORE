# PETA PORT & SOCKET RESMI MICO-JDEQ

## Prinsip
- Port adalah jenis pipa, bukan titik lokasi.
- Socket adalah titik temu IP + Port.
- Satu shaft utama: Tailscale/SSH, jangan buka port lain tanpa ACC L0.

## PORT RESMI
| Port | Fungsi | Jaringan | Status |
|------|--------|----------|--------|
| 22   | SSH/WSL | Tailscale/Lokal | TERBUKA |
| 8022 | SSH Windows | Tailscale/Lokal | TERBUKA |
| 1883 | Mosquitto MQTT | Lokal | DITAHAN |
| 8080 | Tandon Local HTTP | Lokal | SESUAI KEBUTUHAN |
| 5432 | PostgreSQL | Lokal | NONAKTIF |
| 11434| Ollama/LLM | Lokal | NONAKTIF |
| 5037 | ADB | Lokal/USB | TERBUKA |
| 3240 | USBIP | Lokal | TERBUKA |

## SOCKET RESMI
| Socket | Layanan | Catatan |
|--------|---------|---------|
| 100.124.50.70:8022 | KAPAL-INDUK SSH | Akses utama dari Vivo/Z83 |
| 127.0.0.1:8080 | Tandon HTTP | Saat offline |
| 127.0.0.1:1883 | Mosquitto Lokal | Monitoring |
