# P2-2 — ALERT DELIVERY POLICY

## Model: Pull-Only
- PC-i5 = satu-satunya penulis alert ke SSOT
- Edge (Vivo Y28, Infinix, HP Mini) tidak menulis ke SSOT
- Edge hanya menarik (pull) dari PC-i5
- Tidak ada push dari edge

## Alur
1. Peristiwa terjadi di PC-i5
2. PC-i5 menulis alert ke SSOT (08_EVIDENCE/L7-OPERATIONAL/alerts/)
3. Vivo Y28 menarik (pull) saat aktif
4. Pull menggunakan Tailscale mesh
5. Setelah diterima, Vivo menandai (ack) via file kecil

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
- Tidak ada alert yang dibaca langsung dari edge tanpa otentikasi
