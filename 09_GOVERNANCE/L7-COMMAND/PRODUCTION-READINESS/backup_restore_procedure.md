# BACKUP / RESTORE PROCEDURE - runtime_state

## Tujuan
Melindungi state kritis runtime L7:
- nonces.jsonl (anti-replay)
- commands.jsonl (anti-duplikat)
- sequence.jsonl (monotonik)
- circuit_breaker.json (state sekring)

Kehilangan direktori ini = replay bisa lolos, sequence reset, CB dari nol.

## Alat
Modul: 09_GOVERNANCE/L7-COMMAND/RUNTIME/l7_backup.py
- backup(src, dst)  : salin state + tulis MANIFEST.sha256.json
- restore(src, dst) : verifikasi MANIFEST, lalu salin balik
- Bila verifikasi gagal, restore membatalkan diri (no partial)

## Prosedur Backup Rutin
1. Tentukan tujuan: D:\MICO_SSOT\12_BACKUP\L7-STATE\<tanggal>
2. Jalankan python -c dengan sys.path.insert ke RUNTIME, panggil backup()
3. Verifikasi MANIFEST.sha256.json ada di tujuan

## Prosedur Restore
1. Pastikan runtime TIDAK aktif
2. Jalankan python -c dengan sys.path.insert, panggil restore()
3. Bila restored: jalankan test_rt_harness.py untuk verifikasi
4. Bila verify_failed: JANGAN paksa, ambil backup lain

## Uji Otomatis
test_rollback.py menjalankan siklus penuh:
populate -> hash -> backup -> loss -> restore -> verify hash -> regresi RT

## Jadwal Rekomendasi
- Backup sebelum rilis/aktivasi
- Backup harian bila runtime aktif
- Simpan minimal 3 generasi terakhir
