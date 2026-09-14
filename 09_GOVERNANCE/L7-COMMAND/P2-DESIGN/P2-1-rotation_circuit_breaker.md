# P2-1 — ROTATION CIRCUIT BREAKER

## Tujuan
Menghentikan rotasi otomatis bila terjadi kegagalan berulang,
supaya tidak menimbulkan kerusakan kaskade atau spam log.

## Parameter
| Parameter | Nilai |
|---|---|
| Ambang gagal | 10 kegagalan |
| Jendela waktu | 60 detik |
| Aksi saat open | BLOCKED, hentikan rotasi |
| Cooldown reset | 15 menit |
| Log | Satu baris per transisi |

## Kondisi Trip
- Gagal rename > 10 kali dalam 60 detik
- Disk I/O error berulang
- Lock tidak bisa diperoleh 10 kali beruntun
- Hash verify gagal 3 kali beruntun

## Setelah Open
1. Tulis satu entri: ROTATION_CB_OPEN
2. Tidak ada rotasi otomatis sampai cooldown selesai
3. Manual rotation masih diizinkan (dengan catatan audit)
4. Notifikasi ke jalur alert P2-2

## Reset
- Otomatis setelah 15 menit tanpa kegagalan
- Manual oleh L0 via flag yang dijelaskan di runbook

