# DECREE --- DEPRECATION OF "DOLA"

- decree_id: MICO-DECREE-20260912-001
- tanggal: 2026-09-12
- otoritas: L0 (Iswan Juman Pancoro, ST)
- status: AKTIF

## 1. Keputusan

Istilah "DOLA" dinyatakan DEPRECATED di seluruh ekosistem MICO-JDEQ.
Pengganti resmi: MPG (MICO-Policy-Gate) --- jika diperlukan gate
kebijakan prosedural. Jika tidak diperlukan, tidak ada gate tambahan.

## 2. Alasan

- Nama "DOLA" bertabrakan dengan aplikasi Android pihak ketiga (DOLA).
- Makna "DOLA" berkembang liar lewat file yang dipaste antar agen
  (gate, mandor, pengawas logika, kernel), tanpa pernah
  diputuskan resmi oleh L0.
- Membingungkan di struktur SSOT dan berpotensi menyesatkan agen baru.

## 3. Cakupan

- File baru yang ditulis setelah tanggal ini: DILARANG memakai istilah "DOLA".
- File lama yang sudah menyebut "DOLA": tidak diubah. Tetap sebagai
  jejak audit. Siapa yang membaca dan bingung, merujuk ke decree ini.
- Folder `99_ARCHIVE\DOLA_LEGACY_20260912\`: arsip, tidak aktif.

## 4. Konsekuensi

- Referensi `governance: DOLA` di file YAML lama = historical, jangan
  diubah tanpa Task Card baru.
- ADR-002 dan ADR-003 lama tetap berlaku untuk isi keputusannya;
  hanya istilah "DOLA" di dalamnya yang sekarang deprecated.
- Setiap agen yang membaca istilah "DOLA" di file lama wajib
  memahami bahwa itu nama legacy, bukan entitas aktif.

## 5. Referensi

- Scan bukti: `08_EVIDENCE\scan_dola_20260912_205412.txt`
- Arsip folder: `99_ARCHIVE\DOLA_LEGACY_20260912\`
- Laporan kesalahan agen: `09_GOVERNANCE\AGENT_ERRORS\AG-003_ERRORS.md`

## 6. Tanda Tangan

Disahkan oleh: L0 (Iswan Juman Pancoro, ST)
Tanggal: 2026-09-12

END OF DECREE.