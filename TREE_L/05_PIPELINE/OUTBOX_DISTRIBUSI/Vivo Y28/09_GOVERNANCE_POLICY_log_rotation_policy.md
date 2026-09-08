# LOG ROTATION POLICY — MICO-JDEQ PC-i5

## Pemicu Rotasi
- Ukuran file mencapai 10MB ATAU
- Periode harian (setiap 24 jam)
- Mana yang tercapai lebih dulu, itu yang memicu rotasi.

## Salinan Aktif
- Maksimal 5 file log aktif.
- Setelah melebihi 5, file paling lama dirotasi.

## Kompresi Arsip
- Setelah file log mencapai nomor urut 3 (contoh: app.log.3), wajib dikompresi menjadi `.gz`.
- File terkompresi dipindahkan ke folder arsip.

## Lokasi Arsip
- D:\MICO_SSOT\TREE_L\06_RUNTIME\LOGS\ARCHIVE\

## Larangan
- TIDAK BOLEH menimpa file log lama.
- File log lama hanya boleh diarsipkan atau dihapus sesuai kebijakan retensi.
