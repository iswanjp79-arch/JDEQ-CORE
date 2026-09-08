# SOP-003 — Agen = Pekerja Kontrak (SPK)

## Tujuan
Menghindari agen bekerja bebas dan menyebabkan halusinasi/kerusakan.

## Aturan
- Setiap agen wajib memiliki Task Card: role, context, boundary, input/output, timeout, recovery.
- Tidak ada agen yang boleh eksekusi di luar Task Card.
- Setiap output harus disertai evidence.

## Implementasi
- Gunakan template Task Card standar.
- Validasi output agen sebelum digunakan.
- Agen tidak boleh memutuskan arsitektur sendiri.
