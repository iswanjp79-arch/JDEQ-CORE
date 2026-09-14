# P2-2 — ALERT CHANNEL SPEC

## Transport
- Jalur: Tailscale mesh (private overlay)
- Bukan jalur publik
- Bukan lewat internet terbuka
- Bukan lewat SSOT tulis dari edge

## Titik Akhir
| Peran | Node | Keterangan |
|---|---|---|
| Sender | PC-i5 (KAPAL-INDUK) | Satu-satunya pengirim alert |
| Receiver | Vivo Y28 | Terminal mobile L0 |
| Receiver opsional | Z83 | Cadangan, bila aktif |

## Autentikasi
- Mutual peer auth via Tailscale identity
- Setiap pesan alert ditandatangani dengan command_id unik
- Nonce + timestamp wajib ada
- Replay ditolak

## Pesan
- Format: JSON (schema terpisah: alert_message_schema.json)
- Ukuran maksimum: 4 KB per pesan
- Rate limit: 30 pesan / menit
- Dedup window: 5 menit

## Batas
- Edge (Vivo, Infinix, HP Mini) TIDAK menulis ke SSOT
- Hanya PC-i5 yang menulis ke SSOT
- Pull-only: receiver menarik, bukan sender mendorong
