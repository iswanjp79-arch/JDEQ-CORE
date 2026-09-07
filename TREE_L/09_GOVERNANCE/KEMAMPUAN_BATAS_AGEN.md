# KEMAMPUAN & BATAS AGEN — PC-i5 (KAPAL-INDUK)

## Prinsip
- PC-i5 = Heavy Local Worker.
- Vivo Y28 = Thin Client, dilarang komputasi berat.
- Z83 = Mandor Node, indeks & log.
- Cloud = Cadangan / Worker hanya jika perlu.

## Kapasitas Aman yang Sudah Dikunci
- RAM maksimal untuk AI: 8 GB.
- Disk C maksimal 80% — jangan penuh.
- Tanpa GPU: embedding besar WAJIB lewat cloud worker.
- Jangan jalankan 2 tugas berat bersamaan.

## Yang Boleh Dilakukan Agen
- PowerShell/Bash: atur OS, folder, izin, jaringan.
- Python: embedding ringan, query lokal, RAG kecil.
- JSON: semua pesan antar agen.

## Yang Dilarang
- Menginstal model AI besar (>1 GB) di C:.
- Menjalankan 2 pipeline embedding bersamaan.
- Menyentuh KERNEL_LAYER_LOCK.json tanpa Task Card.
- Menambah folder selain 14 pilar tanpa izin L0.

## EOS / EOF
- EOS: Akhir sesi pengembangan.
- EOF: Akhir file log/bukti.
- Setiap sesi wajib menulis EOF di log terakhir.
