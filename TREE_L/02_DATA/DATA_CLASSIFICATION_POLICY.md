# DATA CLASSIFICATION POLICY — 02_DATA

## Kategori
- RAW      : Data mentah hasil tarik, belum diolah
- STAGING  : Data sementara menunggu validasi
- CURATED  : Data bersih dan siap digunakan
- KNOWLEDGE: Data pengetahuan / doktrin / modul
- SCHEMA   : Definisi struktur data (JSON/SQL)
- MANIFEST : Daftar inventaris & lineage data

## Aturan
- Data ≠ Database. Engine simpan di 04_APLIKASI.
- Jangan letakkan secret/kredensial di sini.
- Setiap data masuk wajib dicatat di MANIFEST.
