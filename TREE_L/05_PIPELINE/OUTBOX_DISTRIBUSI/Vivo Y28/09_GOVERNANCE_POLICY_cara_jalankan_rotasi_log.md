# CARA MENJALANKAN ROTASI LOG MANUAL

## Prinsip
- Rotasi log dijalankan MANUAL, atas perintah L0 saja.
- Tidak ada rotasi otomatis terjadwal di fase ini.

## Langkah Manual
1. Buka folder log:
   D:\MICO_SSOT\TREE_L\06_RUNTIME\LOGS\

2. Periksa file log aktif.
   - Jika file utama lebih dari 10MB atau sudah berumur >1 hari, lakukan rotasi.

3. Putar file:
   - Ganti nama file utama menjadi .1, .2, .3 berurutan.
   - Setelah .3, kompres menjadi .zip dan pindahkan ke ARCHIVE\.

4. Simpan bukti rotasi:
   - Catat waktu, nama file, dan SHA256 setiap file.
   - Simpan ke 08_EVIDENCE\RUNTIME\.

## Larangan
- Jangan hapus log lama.
- Jangan mengaktifkan Task Scheduler/Cron.
- Jangan ubah log yang sudah diarsip.
