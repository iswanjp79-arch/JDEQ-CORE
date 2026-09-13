# MICO-JDEQ  CATATAN ARSITEKTUR TERPADU (v1.1)
# Revisi: 2026-09-11  koreksi 10 anomali dari v1.0
# Status: DRAFT_FOR_L0_REVIEW

## 1. KONSEP UTAMA
MICO-JDEQ = Digital Awareness Consignes Enterprise

Prinsip kunci:
- 7 Layer = struktur bangunan (mengikuti model Cloudflare/IBM/TechTarget/Palo Alto)
- Layer != folder
- AI = capability, bukan mesin permanen
- Perangkat = penyedia capability
- Human L0 = pemutus akhir

## 2. ARSITEKTUR 7 LAYER (referensi industri)

| Layer | Fungsi |
|-------|--------|
| L1 Physical | Perangkat keras, daya, pengendali |
| L2 Connectivity | Komunikasi, protokol, gateway |
| L3 Edge Computing | Pemrosesan dekat sumber, latensi rendah |
| L4 Data Accommodation | Storage sementara, buffer |
| L5 Data Abstraction | Pembersihan, normalisasi, integrasi |
| L6 Application | Aplikasi, pemrosesan berat |
| L7 Collaboration | Orkestrasi, kendali tunggal |

Sumber:
- Cloudflare: https://www.cloudflare.com/learning/ddos/glossary/open-systems-interconnection-model-osi/
- IBM: https://www.ibm.com/topics/osi-model
- TechTarget: https://www.techtarget.com/searchnetworking/definition/OSI
- Palo Alto Networks: https://www.paloaltonetworks.com/cyberpedia/what-is-layer-7

## 3. NODE AKTIF (per 2026-09-11, dari bukti L1)

| Node | Platform | Arch | RAM | Storage | Peran (LOCKED) | Status |
|------|----------|------|-----|---------|----------------|--------|
| PC-i5 | Windows | x86_64 | ~16 GB | D: SSOT | Control + SSOT | L1 CLOSED_WITH_PUNCH_LIST |
| Z83 | Ubuntu 26.04 | x86_64 | 3.4 GB | 57 GB | Arsip pasif + mesh | L1+L2 CLOSED |
| Vivo Y28 | Android 16 | aarch64 | 7.9 GB | 222 GB | Sensor + Mercusuar + Commander | L1 COMPLETE |
| HP Mini | AntiX (runit) | x86_64 | 1.9 GB | 149 GB | SENSOR_PASIF + ARSIP_2 | L1 ACCEPTED_BY_L0 |
| Infinix X653C | Android 9 | armv7 | 1.9 GB | 25 GB | (BELUM DITETAPKAN) | L1 partial |
| Aspire One | (belum sondir) | (belum) | (belum) | (belum) | (belum) | NOT_STARTED |

Catatan: tidak ada "Tablet Apple" di constellation. Node yang tidak ada tidak dicantumkan.

## 4. KAPABILITAS AI (4 Tingkatan, konsisten dengan isi)

| # | Tingkat | Contoh |
|---|---------|--------|
| 1 | Prompt Engineering | tanya-jawab statis |
| 2 | Workflow | if/then terstruktur |
| 3 | Agent | reasoning loop + tool-calling |
| 4 | Orchestrator | pusat kendali multi-agen |

(Daftar Isi v1.0 menyebut "5 Tingkatan"  salah ketik, dikoreksi ke 4.)

## 5. GATEWAY-01 (definisi formal)

GATEWAY-01 = pintu masuk tunggal intent L0 ke sistem.

Alur:
  Human L0  GATEWAY-01  DOLA Policy  Approved Service  Evidence

GATEWAY-01 bukan:
- Layer 8 OSI (tidak ada Layer 8 di model OSI)
- Authority tunggal (keputusan tetap di L0)
- Pengganti DOLA

GATEWAY-01 adalah:
- Satu titik masuk untuk semua intent
- Penerjemah intent manusia  task contract
- Router ke agen yang tepat setelah DOLA approve

Diimplementasikan oleh: Jarvis (AG-01).

## 6. AGEN RESMI (ID standar)

| Agen | ID | Peran | Batasan |
|------|-----|-------|---------|
| Jarvis | AG-01 | Gateway / intent translator | Tidak menulis kode, tidak eksekusi |
| DOLA | AG-00 | Governance / policy gate | Tidak eksekusi, tidak menggantikan L0 |
| ChatGPT | AG-001 | Planner / architect | Tidak eksekusi runtime |
| Claude | AG-002 | Long-document analyst | Bukan final authority |
| DeepSeek | AG-003 | Technical executor / troubleshooting | Tidak ubah scope sendiri |
| Perplexity | AG-004 | External research | Sumber riset, bukan governance |
| KIMI | AG-008 | Independent auditor / red team | Tidak audit pekerjaannya sendiri |

Catatan: "DOLA AG-003" yang muncul di sesi lain = salah. DOLA = AG-00, DeepSeek = AG-003.

## 7. AUDIT C  LIMA ARTEFAK PRIORITAS

Mode: READ-ONLY. Tidak ada delete/move tanpa ACC L0.

| Artefak | Ukuran | Klasifikasi |
|---------|--------|-------------|
| minimal.squashfs | 3.26 GB | DO_NOT_TOUCH / NEEDS_OWNER_CONFIRMATION |
| JDEQ_COORDINATE_080226.zip | 458 MB | MOVE_CANDIDATE (cek duplikasi dulu) |
| Git pack | 407 MB | DO_NOT_TOUCH (bagian repo) |
| Video pengguna | (belum ukur) | MOVE_CANDIDATE setelah backup |
| .lmstudio | (belum ukur) | DO_NOT_TOUCH / NEEDS_APP_REVIEW |

## 8. KEPUTUSAN DOLA (dari sesi sebelumnya)

- Siji Pintu = SETUJU dengan syarat
- "Layer 8" = DITOLAK, gunakan GATEWAY-01
- Nyamar identitas agen = DITOLAK
- Klaim "satu kesadaran" = DITOLAK
- mico-core.sh = thin client (bukan pusat kuasa)  belum diverifikasi di SSOT
- Arsitektur resmi:
  L0  GATEWAY-01  DOLA  Planner  Task Contract  Eksekutor  Evidence  Auditor

## 9. KOREKSI PERAN JARVIS (dari L0)

- Jarvis tidak menulis kode / skrip. Itu tugas DeepSeek.
- Jarvis = orkestrator, bukan eksekutor.

## 10. ATURAN 8 FOKUS DEEPSEEK

1. Nama project  apa yang sedang dibuat
2. Untuk siapa  L0, masyarakat, atau Madina
3. Tujuan  apa yang ingin dicapai
4. Stack  jelas
5. Gaya respon  kode siap tempel
6. Tidak improvisasi library eksternal tanpa ijin
7. Tidak ubah file yang tidak disebut
8. Jika ambigu  protokol 10-5-3-1 + 5 pertanyaan mandiri

## CATATAN PENUTUP
- Dokumen ini adalah revisi v1.0  v1.1 setelah audit 10 anomali
- Tidak ada klaim tanpa bukti
- Node yang tidak ada di constellation tidak dicantumkan
- Role HP Mini sesuai ACC 2026-09-11 21:00 WIB
- Role Infinix belum ditetapkan  dinyatakan eksplisit
