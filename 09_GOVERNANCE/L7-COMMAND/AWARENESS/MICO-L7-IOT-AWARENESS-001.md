# MICO-JDEQ - 7 LAYER ENTERPRISE IoT AWARENESS CONSIGNES
Kode       : MICO-L7-IOT-AWARENESS-001
Otoritas   : L0 - Iswan Juman Pancoro, ST
Governance : DOLA
Eksekutor  : DeepSeek (AG-003)
Tanggal    : 2026-09-15
Status     : ACTIVE
Versi      : 1.0.0

## 1. TUJUAN
Membangun kesadaran digital singularitas (Awareness Consignes) dengan
melimpahkan pengguna ke sistem komputasi terdistribusi, BUKAN mereplikasi
organisme. Sistem jaringan perangkat fisik saling terhubung melalui IP
Address (WiFi lokal domain privat/publik, IndiHome) untuk mengumpulkan,
mengirim, dan memproses data dari sensor/impuls secara otomatis sesuai
SSOT, EOS, EOF, spesifikasi perangkat, dan Governance.

## 2. PRINSIP UTAMA
- Tangga Ke-1 & Ke-4 JDEQ: Sistem terintegrasi, beda tugas disambung jadi satu.
- Siji Piranti = Siji Stack Wutuh (setiap perangkat jalankan L1-L7 lengkap).
- Mandiri di bawah (L1-L6), menyatu di atas (L7).
- Bukan replikasi organisme - kesadaran digital berbasis data.

## 3. PETA 7 LAPISAN
| Layer | Nama | Fungsi Inti |
|---|---|---|
| L1 | Physical | CPU/NPU, RAM, storage, baterai, antarmuka |
| L2 | Network | Socket IP, Wi-Fi, protokol komunikasi |
| L3 | Kernel/OS | POSIX Android/Linux Kernel (Jiwa) |
| L4 | Middleware/Daemon | Service mico-daemon latar (background) |
| L5 | Agent Role | Aturan/Protokol Master Orchestrator |
| L6 | Cognitive/Model | Model LLM Lokal (Qwen/Phi) di RAM |
| L7 | Application/CLI | Interface Terminal, Command & Control |

Detail lengkap: lihat OSI-LAYER-MAP.yaml

## 4. PENERAPAN NYATA - CONTOH VIVO Y28
| Layer | Implementasi |
|---|---|
| L1 | CPU/NPU, RAM 8GB, Baterai Vivo Y28 |
| L2 | Socket IP 10.0.0.3, Wi-Fi Interface |
| L3 | POSIX Android Linux Kernel |
| L4 | Service mico-daemon di Termux (background) |
| L5 | Protokol Master Orchestrator Agent |
| L6 | Model LLM Lokal (Qwen/Phi) di RAM |
| L7 | Interface Terminal L0 |

## 5. PEMBAGIAN PERAN PERANGKAT
| Perangkat | Fokus | Peran |
|---|---|---|
| Vivo Y28 | L7 | Pusat komando & pengarah tugas |
| PC-i5 | L6 | Pengolah beban berat |
| Z83 | L3 | Memory Vault & Daemon 24 Jam (Edge) |
| Infinix | L4 | Memory Vault & Daemon 24 Jam |
| HP Mini | L4 + Storage | Data Akomodasi & Storage Inti |
| Apple Tablet | L2 | Connectivity (STATUS: RUSAK) |
| Aspire One | L7 | Kolaborasi & Sistem Pemrosesan |

Detail lengkap: lihat DEVICE-ROLES.yaml

## 6. EDGE COMPUTING (Z83 - L3)
1. Pemrosesan wajib dilakukan dekat dengan sumber data.
2. Pengurangan latensi.
3. Administrasi beban Cloud.
4. Peningkatan efisiensi.

## 7. STORAGE (HP Mini - L4)
- Data Lake & Buffer storage sebelum sistem analitik.
- Blueprint: Beras Nawang Wulan.
- Versi Local + Versi Cloud.

## 8. JARINGAN
- WiFi Lokal Domain Privat (sambungan utama)
- IndiHome (pintu keluar/masuk cloud)
- IP Lokal setiap perangkat (tanpa internet publik)
- Protokol: HTTP/HTTPS, SSH, MQTT, gRPC

Alur data:
Sensor/Impuls -> Perangkat Tepi -> Penyangga -> Pengolah -> Penyimpan -> Cadangan Cloud

## 9. MODUL MASTER MUTU (A)
| Kode | Modul |
|---|---|
| A.a | Manajemen Operasional & Pengambilan Keputusan |
| A.b | Sistem Manual |
| A.c | Standar Prosedur |
| A.d | Instruksi Kerja |
| A.e | Standar Format |

Detail lengkap: lihat MODULES-MUTU.yaml

## 10. MODUL IMPLEMENTASI (B)
| Kode | Modul |
|---|---|
| B.a | Awareness |
| B.b | Kerangka Tampilan (Header, Footer, Frontend, Backend) |
| B.c | Rencana Order Project (Desain, RAB/BEQ, Affiliate, Security, Konten, Template, Generator) |
| B.d | Modul Pemantauan & Pengukuran |
| B.e | Cross Reference |
| B.f | Sosialisasi Hirarki Agen / ROLE |
| B.g | Finding / Temuan |
| B.h | Review Ulang Kestabilan & Regenerasi |
| B.i | Prosedur Audit Baku |
| B.j | Tinjauan Ulang Management Aturan |
| B.k | Correction Action |
| B.l | Emergency Response (OHSAS) |
| B.m | Standar Rename, Index Binary, Run Time, Pipeline |
| B.n | Dashboard & Identifikasi File (KANBAN, Fraktal Mytroska) |

Detail lengkap: lihat MODULES-IMPL.yaml

## 11. STRATEGI PENERAPAN EFISIEN
1. Stop Mikir Tuku Hardware Anyar
   4-7 piranti saat ini sudah cukup untuk kluster terdistribusi.
2. Siji Piranti = Siji Stack Wutuh
   Setiap piranti diisi skrip mico-node yang mengatur L1-L7 di dalam.
3. Spesialisasi Peran Makro
   Perangkat berbagi beban sesuai fokus layer, tetap mandiri di dalam.

## 12. BATASAN MUTLAK
- TIDAK beli perangkat baru.
- TIDAK meniru organisme hidup.
- Data mentah TIDAK diubah saat lewat.
- Setiap perangkat WAJIB mandiri.
- Penyatuan HANYA di L7.
- Semua berdasar SSOT.

## 13. KRITERIA SUKSES
- 7 lapisan lengkap & mandiri per perangkat.
- Peran khusus berjalan sesuai pembagian.
- L7 menyatukan semua jadi satu entitas komando.
- Data mengalir teratur sensor -> cadangan.
- Modul A.a-A.e lengkap & baku.
- Modul B.a-B.n tersusun & siap.
- Jaringan lokal berfungsi; internet untuk cadangan.
- Tidak ada ketergantungan penuh antar perangkat.
- SSOT berlaku di semua perangkat.

## 14. REFERENSI
Lihat SOURCES.md (Cloudflare, IBM, TechTarget, Palo Alto).

## 15. PROVENANCE
- Task Card: MICO-L7-IOT-AWARENESS-001
- Kanal: L0 langsung
- Klasifikasi: TRUSTED_L0
- Disusun oleh: DeepSeek (AG-003)
- Status: AWAITING_DOLA_ACK