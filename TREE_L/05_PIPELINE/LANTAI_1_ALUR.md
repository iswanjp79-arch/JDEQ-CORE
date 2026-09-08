# LANTAI 1 ALUR DATA DASAR MICO-JDEQ

## Prinsip
- Alur berjalan satu arah secara logis.
- Tidak ada daemon yang selalu hidup.
- Setiap kolom hanya aktif saat dipanggil.

## Diagram Alur

INPUT (dari Vivo/agen lokal)
        ↓
[ K1 ] GATEWAY_DAEMON  →  Validasi & routing awal
        ↓
[ K2 ] LOCAL_SERVER    →  Sajikan data dari tandon (on-demand)
        ↓
[ KP1 ] SANITATION_DAEMON →  Bersihkan log/staging (event-driven)
        ↓
[ KP2 ] SYNC_RCLONE    →  Kirim cadangan/remote (periodik)

## Status Kolom
- K1  : LULUS_QC_SIAP_COR (folder: 05_PIPELINE\GATEWAY_DAEMON)
- K2  : LULUS_QC_SIAP_COR (folder: 04_APLIKASI\LOCAL_SERVER)
- KP1 : LULUS_QC_SIAP_COR (folder: 06_RUNTIME\SANITATION_DAEMON)
- KP2 : LULUS_QC_SIAP_COR (folder: 05_PIPELINE\SYNC_RCLONE)

## Aturan Lantai 1
1. Belum ada otomasi alur penuh. Semua masih manual/on-demand.
2. Flow check hanya membaca, tidak mengeksekusi.
3. Tandon server hanya menyala jika dibutuhkan.
4. Sanitasi hanya berjalan saat idle.
5. Sinkronisasi rclone hanya sesuai jadwal atau perintah L0.
