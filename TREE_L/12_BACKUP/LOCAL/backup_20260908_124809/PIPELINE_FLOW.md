# PIPELINE_FLOW.md

## ALUR PIPA DATA MICO-JDEQ — PC-i5

INPUT
  ↓
VALIDATE
  ↓
CLASSIFY
  ↓
TRANSFORM
  ↓
PROCESS
  ↓
STORE
  ↓
EVIDENCE
  ↓
OUTPUT

## LANGKAH

### 1. INPUT
- Terima file dari folder 02_DATA\RAW
- Catat waktu masuk, sumber, dan nama file.

### 2. VALIDATE
- Periksa format file.
- Periksa ukuran file.
- Periksa hash jika tersedia.
- File gagal validasi dipindah ke 99_ARCHIVE.

### 3. CLASSIFY
- Tentukan tipe data: dokumen, log, gambar, database, konfigurasi.
- Tentukan prioritas: RENDAH, SEDANG, TINGGI, TERTINGGI.

### 4. TRANSFORM
- Konversi data ke format standar: JSON atau CSV.
- Bersihkan karakter aneh.
- Buang data duplikat.

### 5. PROCESS
- Jalankan skrip/agen yang ditugaskan sesuai Task Card.
- Batas waktu eksekusi: maksimal 10 menit untuk pekerjaan lokal.
- Jika gagal, ulangi maksimal 2 kali, lalu lapor.

### 6. STORE
- Simpan hasil ke 02_DATA\CURATED atau 02_DATA\KNOWLEDGE.
- Gunakan nama file: nama_YYYYMMDD_HHmmss.ekstensi.

### 7. EVIDENCE
- Hitung SHA256 hasil akhir.
- Simpan bukti ke 08_EVIDENCE\RUNTIME.
- Format bukti sesuai EVIDENCE_TEMPLATE.json.

### 8. OUTPUT
- Kirim hasil ke folder tujuan yang ditentukan dalam Task Card.
- Jika output tidak digunakan, simpan ke 99_ARCHIVE.
