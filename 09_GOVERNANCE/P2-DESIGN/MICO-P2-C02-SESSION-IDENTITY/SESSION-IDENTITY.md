# MICO-JDEQ · SESSION IDENTITY
Kode   : MICO-P2-C02-SESSION-IDENTITY
Status : DISETUJUI UNTUK PERENCANAAN
Runtime: BELUM DIJALANKAN
Otoritas: L0
Gerbang: DOLA
Dasar  : ADR-0003 · session-safety-gate.md §3-6

## 1. TUJUAN
Identitas sesi milik MICO sendiri, terlepas dari ID penyedia luar.
Jika sesi terputus / ganti penyedia / restart -> identitas MICO tetap dikenali,
tidak mewarisi wewenang otomatis.

## 2. SKEMA IDENTITAS (5 BIDANG)
- MICO_SESSION_ID       : SESI-YYYYMMDD-HHMMSS-AG<n>
- MICO_TASK_ID          : nomor Task Card
- MICO_AGENT_ID         : AG-001 / AG-003 / dst
- MICO_CONTEXT_VERSION  : DOC-YYYY-MM-DD
- MICO_AUTH_STATE       : status kepercayaan

## 3. URUTAN STATUS (TIDAK BOLEH MELOMPAT)
TIDAK DIKENALI -> TIDAK DIPERCAYA -> MENUNGGU JABAT TANGAN ->
TERVERIFIKASI -> DIPERCAYA KHUSUS TUGAS -> MENJALANKAN ->
DIVERIFIKASI -> DITUTUP

Aturan mutlak:
- TIDAK DIPERCAYA -> MENJALANKAN = DILARANG
- Sesi terputus/restart -> kembali TIDAK DIPERCAYA
- Ganti Task Card -> jabat tangan ulang

## 4. JABAT TANGAN (ZHH)
Agen wajib menyebut dengan benar:
1. MICO_SESSION_ID sesi sebelumnya
2. MICO_TASK_ID yang berjalan
3. Ringkasan/hash bukti konteks terakhir
Cocok -> TERVERIFIKASI / DIPERCAYA KHUSUS TUGAS
Tidak cocok/tidak tahu -> DIBLOKIR -> Lapor L0
Tidak ada ZHH = tidak boleh bekerja.

## 5. BATASAN KEPERCAYAAN
Kepercayaan hanya untuk satu tugas, satu sesi, satu agen.
- Selesai tugas -> kepercayaan berakhir
- Pindah Task Card -> jabat tangan ulang
- Ganti penyedia -> jabat tangan ulang
- Ganti perangkat -> jabat tangan ulang
- Tidak ada warisan kepercayaan otomatis.

## 6. BUKTI IDENTITAS
Jalur: 08_EVIDENCE/SESSION/YYYYMMDD-HHMMSS-AG<n>.json
Isi  : mico_session_id, mico_task_id, mico_agent_id, context_version,
       started_at, auth_state_final, handshake_verified,
       previous_session_ref, evidence_sha256
Bukti tidak dihapus. Menjadi bukti abadi rantai sesi.

## 7. KETAHANAN GANTI PENYEDIA
Jika penyedia berubah / sesi reset / konteks hilang:
1. MICO anggap sesi baru = TIDAK DIPERCAYA
2. Minta ZHH
3. Bisa buktikan -> lanjut. Tidak -> mulai dari awal
4. Identitas MICO tetap hidup di SSOT.

## 8. SYARAT LENGKAP
- 5 bidang identitas
- Urutan status
- ZHH
- Batasan kepercayaan
- Jalur bukti
- Penanganan sesi terputus
- Rancangan saja. Belum dijalankan.

## 9. STATUS
DECISION_STATUS      = DISETUJUI UNTUK PERENCANAAN
RUNTIME_ACTIVATION   = NONE
ARCHITECTURE_CHANGE  = NONE
CREDENTIAL_TOUCH     = NONE
GOVERNANCE_GATE      = DOLA
FINAL_AUTHORITY      = L0
