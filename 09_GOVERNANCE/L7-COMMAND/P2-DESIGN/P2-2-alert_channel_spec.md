# P2-2 - ALERT CHANNEL SPEC

## Konsep Transport
ALERT_CHANNEL = GOVERNED_CHANNEL

Bukan: TAILSCALE_MESH_ONLY.

## Inner Zone
- Tidak bergantung pada Tailscale
- Gunakan channel lokal/gateway yang sesuai boundary
- Transport tidak boleh menjadi mekanisme otorisasi

## Outer / Remote Transport
Tailscale boleh dicatat sebagai:
OPTIONAL / EXTERNAL TRANSPORT

Hanya bila ada governance authorization untuk jalur tersebut.

## Batas Tegas
Tailscale encryption != authorization
Transport != identity
Transport != policy

## Titik Akhir (Baseline)
| Peran | Node | Keterangan |
|---|---|---|
| Sender | PC-i5 (KAPAL-INDUK) | Satu-satunya pengirim alert |
| Receiver | Vivo Y28 | Terminal mobile L0 (pull-only) |
| Receiver opsional | Z83 | Cadangan, bila aktif |

## Autentikasi
- Mutual auth pada boundary
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
- Tailscale bukan syarat; hanya opsi eksternal yang diotorisasi
