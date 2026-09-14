# P2-1 — CIRCUIT BREAKER TEST PLAN

| ID | Skenario | Harapan |
|---|---|---|
| CB-01 | 10 gagal dalam 60 detik | CB open, rotasi berikutnya BLOCKED |
| CB-02 | 9 gagal, 1 sukses | CB tetap closed |
| CB-03 | CB open, tunggu 16 menit | CB reset otomatis |
| CB-04 | CB open, manual override L0 | Rotasi manual diizinkan, tercatat |
| CB-05 | CB open, notifikasi alert terkirim | Alert masuk ke jalur P2-2 |

## Kriteria Lulus
- 5/5 skenario PASS
- Setiap transisi CB menulis tepat 1 baris audit
- Tidak ada rotasi otomatis saat CB open

