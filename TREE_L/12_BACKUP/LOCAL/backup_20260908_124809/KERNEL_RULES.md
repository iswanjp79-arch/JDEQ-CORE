# KERNEL_RULES.md

## 1. TUJUAN
File ini adalah aturan inti logika PC-i5 (KAPAL-INDUK) dalam MICO-JDEQ.  
Semua keputusan lokal harus tunduk pada aturan di bawah ini.

## 2. STATE MACHINE
Status sistem hanya boleh berpindah dalam urutan berikut:

IDLE → INTAKE → VALIDATE → PROCESS → STORE → EVIDENCE → OUTPUT → IDLE

Jika status tidak dikenal, sistem wajib kembali ke IDLE dan mencatat kejadian.

## 3. RULES
1. Setiap pekerjaan harus punya Task Card aktif.
2. Tanpa ACC L0, tidak ada eksekusi mutasi.
3. Data masuk wajib dicatat waktunya.
4. Data keluar wajib memiliki hash SHA256.
5. File lama tidak boleh ditimpa. Buat file baru jika ada perubahan.

## 4. VALIDATION
- Cek format input: hanya JSON, CSV, Markdown, atau teks biasa.
- Cek ukuran file: maksimal 50MB per file untuk pemrosesan lokal.
- Cek hash: setiap file hasil harus cocok dengan hash yang dilaporkan.
- Jika validasi gagal, file dipindah ke 99_ARCHIVE dan tidak diproses.

## 5. DECISION
Keputusan hanya boleh diambil oleh:
- L0 untuk keputusan arsitektur.
- DOLA untuk keputusan governance.
- Jarvis untuk arahan teknis yang sudah disetujui.
- DeepSeek untuk keputusan teknis terbatas sesuai SPK.

Keputusan penting yang menyangkut perubahan sistem wajib dicatat di ADR.

## 6. GUARDRAILS
- Dilarang menyimpan secret di file teks.
- Dilarang mengakses folder di luar izin yang diberikan.
- Dilarang menjalankan perintah yang belum dikonfirmasi.
- Dilarang menghapus log tanpa hash pengganti.
- Dilarang menginstal software baru tanpa Task Card.

## 7. ROUTING
- File masukan dari luar → 02_DATA\RAW
- File yang sudah divalidasi → 02_DATA\CURATED
- File hasil proses → 02_DATA\KNOWLEDGE
- File tugas antar-agen → 05_PIPELINE\SPOOLER
- File bukti → 08_EVIDENCE\RUNTIME
- File keputusan → 09_GOVERNANCE\ADR
