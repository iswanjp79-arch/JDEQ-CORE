# RINGBALK RULE — Pengikat Horizontal Kolom MICO-JDEQ

## Prinsip
- Ringbalk menyatukan K1, K2, KP1, KP2 dalam satu kendali ringan.
- Tidak memproses data besar. Hanya memantau, mengikat, dan melaporkan.

## Fungsi
- Memeriksa keberadaan seluruh folder kolom.
- Memeriksa port utama yang seharusnya aktif.
- Mencatat free RAM sebagai indikator beban.
- Memberikan laporan terpadu untuk L0.

## Aturan
1. Ringbalk tidak boleh mengubah isi folder kolom.
2. Ringbalk hanya read-only, kecuali menulis laporan evidence.
3. RAM idle < 50 MB.
4. Laporan wajib tercatat dengan timestamp.

## Status Kolom
- K1 : Gateway Daemon
- K2 : Tandon Server
- KP1 : Sanitation Daemon
- KP2 : Rclone Sync
