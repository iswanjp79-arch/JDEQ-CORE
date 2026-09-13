# DOKTRIN PROMPT MICO-JDEQ
WBS-CODE: CTL_09_PRM
Tanggal: 2026-09-10
Status: AKTIF

## PRINSIP
Prompt bukan mantra. Prompt adalah kontrak kerja.
Jelas + lengkap + terstruktur + contoh = hasil presisi.

## 6 UNSUR WAJIB SETIAP PROMPT
1. Peran & Tujuan   - siapa bertindak, ingin hasil apa
2. Konteks & Data   - informasi relevan
3. Format & Batasan - panjang, nada, struktur
4. Contoh/Gaya      - tiru apa, hindari apa
5. Larangan         - apa yang tidak boleh dilakukan
6. Konfirmasi       - paham dulu, baru lanjut

## YANG SUDAH DIPAKAI DI MICO-JDEQ
- Peran: AG-001/AG-002/AG-003/DOLA/L0
- Konteks: handoff, brief, task card
- Format: YAML/JSON, WBS-CODE
- Batasan: read-only, no-install, forbidden list
- Konfirmasi: status correction, gap detection
- SoD: rencana (AG-001) != eksekusi (AG-003)

## YANG DITAMBAHKAN
- Minta beberapa versi (A/B/C)
- Minta uji balik: 'sebutkan alasan rencana ini bisa gagal'
- Templat reusable per jenis tugas (brief, task card, audit)
- Pisahkan rencana dan penulisan

## ATURAN KHUSUS MICO-JDEQ
- Bahasa: Indonesia teknis, ringkas
- Output mentah != output narasi
- Reasoning internal, output eksternal
- Evidence-first, no claim tanpa bukti
- Satu perintah per langkah
- Tunggu output sebelum lanjut
- Jika ragu: tanya 1 baris, jangan improvisasi

## ANTI-DRIFT
- 'LANJUT' = lanjut langkah berikutnya
- 'STOP' = berhenti bicara
- 'FOKUS' = kembali ke konteks
- Tanpa aturan baru setelah prompt awal

## LARANGAN
- Narasi panjang
- Buka ulang node yang sudah CLOSED
- Bahas token, rotasi akun, meta-topik
- Install software tanpa ACC
- Klaim CAPABILITY tanpa bukti
