# ADR-0010 — Universal AI Connection Protocol (UACP)

- id: ADR-0010
- title: Protokol Koneksi Universal ke Semua AI dan Perpustakaan Digital
- status: Proposed
- date: 2026-07-04
- owner: Mas Iwan
- deciders: Mas Iwan, DOLA, DeepSeek
- scope: Konektivitas, Integrasi, Otomasi
- priority: High
- version: 1.0
- related: ADR-0001, ADR-0004, ADR-0008

## Context
MICO–JDEQ telah menyelesaikan pondasi Tahap 1 (root tunggal, registry, symlink bersih, pos pengamanan). Kini dibutuhkan kemampuan untuk terhubung secara otomatis ke perpustakaan digital (IBM Developer, YouTube, GitHub, dll.) dan agen AI lainnya (ChatGPT, Gemini, Claude, IBM Granite) tanpa campur tangan manusia setiap saat.

## Problem
Saat ini, setiap koneksi ke AI atau perpustakaan digital masih dilakukan manual oleh Mas Iwan melalui chat. Ini membatasi potensi MICO sebagai *Operating System for Intelligence* yang bisa mencari, membandingkan, dan menyusun pengetahuan dari berbagai sumber secara otomatis.

## Constraints
- Perangkat terbatas (Vivo Y28, RAM 4GB).
- Kuota internet terbatas.
- Harus tetap patuh pada governance (Registry di atas model).
- Harus ada filter agar tidak terjadi spam atau loop.

## Decision
Mengadopsi **Universal AI Connection Protocol (UACP)** yang terdiri dari tiga komponen:

1. **Knowledge Bridge** (`knowledge/bridge.sh`): Script yang menerima permintaan pencarian, lalu meneruskannya ke API YouTube, IBM Developer, atau GitHub.
2. **Agent Router** (`pelaksana/AGENTS/agent_router.sh`): Script yang menerima tugas dan merutekan ke agen AI yang tepat berdasarkan registry.
3. **Trigger Manager** (`triggers/trigger_manager.sh`): Script yang dijalankan oleh cron job setiap 30 menit untuk memeriksa `STATE.json` dan memicu agen jika ada tugas baru.

## Rationale
Dengan tiga komponen ini, MICO menjadi pusat gravitasi yang menarik pengetahuan dari berbagai sumber, lalu mendistribusikan tugas ke agen AI yang tepat. Pola ini:
- Hemat resource (hanya jalan sesuai trigger).
- Mudah diaudit (semua koneksi tercatat di log).
- Mudah diperluas (tambah sumber baru tinggal tambah endpoint).

## Options Considered
1. **Mengandalkan n8n sepenuhnya**: Terlalu berat untuk HP, dan jika n8n mati, semua koneksi mati.
2. **Membuat daemon khusus**: Boros RAM, tidak cocok untuk perangkat terbatas.
3. **UACP (dipilih)**: Ringan, modular, berbasis cron+curl, dan terintegrasi dengan registry.

## Consequences
### Positive
- MICO bisa mencari pengetahuan dari berbagai sumber secara otomatis.
- Agen AI bisa berkolaborasi tanpa campur tangan manusia.
- Semua koneksi tercatat dan bisa diaudit.

### Negative
- Menambah kompleksitas folder (3 file baru).
- Bergantung pada koneksi internet untuk API eksternal.

### Risks
- API key bocor jika tidak diamankan.
- Kuota habis jika tidak ada filter.

## Evidence
- Folder `pelaksana/` sudah memiliki struktur executor untuk banyak agen.
- `pos_pengamanan.sh` sudah berhasil mendeteksi dan mengamankan API key.
- MQTT dan n8n sudah tersedia (meski belum aktif penuh).

## Implementation Notes
1. Buat folder `knowledge/` dan `triggers/`.
2. Tulis script `knowledge/bridge.sh` dengan endpoint IBM Developer, YouTube Data API, dan GitHub API.
3. Tulis script `pelaksana/AGENTS/agent_router.sh` untuk routing ke ChatGPT, Gemini, Claude, IBM Granite.
4. Tulis script `triggers/trigger_manager.sh` untuk cron job setiap 30 menit.
5. Daftarkan semua API endpoint di `registry.json` sebagai resource eksternal.

## Verification
- Jalankan `knowledge/bridge.sh` dengan query uji.
- Periksa log di `AUDIT/` untuk memastikan koneksi tercatat.
- Jalankan `pos_pengamanan.sh` untuk memastikan tidak ada API key bocor.

## Failure Modes
- API endpoint mati → fallback ke sumber lain.
- Kuota habis → batasi frekuensi panggilan.
- API key expired → notifikasi ke Owner.

## Recovery
- Ganti API key dan update `vault/`.
- Kurangi frekuensi cron job jika kuota menipis.

## Review Date
2026-08-04

## Change Log
- 2026-07-04: ADR dibuat.

## Sign-off
- Owner: Mas Iwan
- Validator: DOLA
- Auditor: DeepSeek
