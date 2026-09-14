# P2-2 - ALERT DELIVERY POLICY

## Model: Pull-Only
- PC-i5 = satu-satunya penulis alert ke SSOT
- Edge (Vivo Y28, Infinix, HP Mini) tidak menulis ke SSOT
- Edge hanya menarik (pull) dari PC-i5
- Tidak ada push dari edge

## Transport
- Baseline: GOVERNED_CHANNEL (tidak terikat satu teknologi)
- Inner Zone: channel lokal/gateway sesuai boundary
- Outer transport: OPTIONAL bila diotorisasi eksplisit

## Alur
1. Peristiwa terjadi di PC-i5
2. PC-i5 menulis alert ke SSOT (08_EVIDENCE/L7-OPERATIONAL/alerts/)
3. Vivo Y28 menarik (pull) saat aktif
4. Setelah diterima, Vivo menandai (ack) via file kecil

## Retry & Backoff
| Parameter | Nilai |
|---|---|
| Percobaan maksimum | 3 |
| Backoff | 2s, 8s, 32s |
| Setelah 3 gagal | BLOCKED + notifikasi level L0 |

## Dedup
- Kunci dedup: alert_id
- Jendela: 5 menit
- Duplikat dalam jendela: dibuang, catat DEDUP_DROP

## Batas
- Tidak ada retry tanpa batas
- Tidak ada alert yang dikirim via jalur publik
- Transport tidak sama dengan otorisasi
- Tailscale bukan syarat baseline
