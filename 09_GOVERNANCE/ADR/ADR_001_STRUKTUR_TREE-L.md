# ADR-001: PENETAPAN STRUKTUR TREE-L & PROTOKOL OPERASIONAL PC-i5

- **Tanggal**: 2026-09-10
- **Status**: AKTIF (DIKUNCI L0)
- **Konteks**: Kebutuhan wadah artefak operasional (SSOT) yang terisolasi khusus untuk PC-i5 tanpa mencampuradukkan layer arsitektur L0-L7 dengan file sampah.

## KEPUTUSAN ARSITEKTUR
1. **Tree-L Baseline**: Direktori `D:\MICO_SSOT` ditetapkan sebagai *Single Source of Truth* (SSOT).
2. **Standar WBS-CODE**: Seluruh penamaan variabel, skrip, dan parameter wajib menggunakan kodifikasi ala konstruksi (contoh: `STR_01_MEM`, `FND_00_PID`) untuk mencegah *typo* dan menghindari deteksi *Cloud*.
3. **Protokol KUNCI-WBS**: Bertindak sebagai *Kill-Switch* kognitif absolut. Jika L0 menyebut ini, seluruh mesin membuang inisiatif liar dan kembali tegak lurus pada instruksi spesifik.
4. **Protokol [MODE_ORGANIK]**: Saringan 10-5-3-1 berjalan bisu di latar belakang. Mesin AI wajib memberikan jawaban final secara luwes dan organik, tanpa memamerkan kerumitan proses komputasinya.
5. **Jalur Komputasi Ganda**: 
   - `[MODE_TUKANG]`: Algoritma heuristik untuk kecepatan dan estimasi hemat RAM.
   - `[MODE_INSINYUR]`: Algoritma universal/baku untuk presisi mutlak tanpa ruang toleransi error.
