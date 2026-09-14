# P2-1 — RESTORE TEST PLAN

| ID | Skenario | Harapan |
|---|---|---|
| RS-01 | Restore arsip utuh | Hash cocok, berkas kembali |
| RS-02 | Restore arsip dengan byte rusak | Verify fail, restore dibatalkan |
| RS-03 | Restore arsip hilang | Fail informatif, tidak ada partial restore |
| RS-04 | Restore saat runtime aktif | DILARANG, wajib STOP dulu |
| RS-05 | Restore ke folder sementara | Sukses, verifikasi hash, tidak menyentuh state aktif |

## Kriteria Lulus
- 5/5 skenario PASS
- Setiap restore menulis 1 entri audit
- Tidak ada pemulihan parsial

