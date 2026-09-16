# ============================================================
# [STATUS: FOR EXECUTION / RFC]
# Kode: MJD-DOLA-AUD-004
# Revisi: R0
# Tanggal: 16-09-2026
# Pemilik: DOLA
# Disahkan: L0 — Iswan Juman Pancoro, ST
# SHA256: [dihitung setelah disimpan]
# ============================================================

# LAPORAN ANALISIS — BUKU OVER HANDLE vs AGENT HANDOFF

## 1. DASAR
Input L0: pengalaman teknisi gedung Hotel Ciputra Semarang — buku over handle
antar shift (pagi/sore/malam). Pertanyaan: bedanya dengan handoff antar agen
di MICO-JDEQ?

## 2. BUKU OVER HANDLE — TEKNISI GEDUNG
- Fokus   : kontinuitas fisik (HVAC/Chiller, genset, panel listrik, plumbing)
- Sifat   : naratif, manual, catatan tangan
- Isi     : status alat (running/standby/trouble) + pending work orders
- Titik lemah : bergantung kedisiplinan personal + kejelasan tulisan

## 3. AGENT HANDOFF — MICO-JDEQ
- Fokus   : keutuhan konteks logika, batas wewenang, provenance
- Sifat   : deterministik, format baku (YAML/MD), hash SHA-256
- Jalur   : Gateway (Jarvis) → DOLA → Agen Spesialis
- Titik lemah : tidak kenal lelah, tapi menuntut kepatuhan format mutlak

## 4. TABEL KOMPARASI

| Dimensi | Buku Over Handle | Agent Handoff |
|---|---|---|
| Pelaku | Teknisi A → Teknisi B | Jarvis → DOLA → Agen |
| Media | Buku fisik / logbook | Markdown + YAML + SHA-256 |
| Objek | Status mesin, suhu, tekanan | Status kode, dokumen, Task Card |
| Validasi | Paraf kepala shift | Hash SHA-256 + sah L0 |
| Risiko | Info terlewat (kelelahan) | Gagal eksekusi (format salah) |

## 5. FILOSOFI YANG SAMA
Keduanya mencegah blind spot saat estafet penugasan:
- Buku over handle → gedung tidak terbakar karena info shift malam hilang
- Agent handoff  → sistem tidak korup karena konteks antar-agen lepas

## 6. PERBEDAAN INTI
- Buku over handle : manusia → manusia, media fisik, validasi sosial (paraf)
- Agent handoff    : sistem → sistem, media digital, validasi kriptografis
- Skala kepercayaan : over handle = kepercayaan personal, handoff = kepercayaan hash

## 7. KESIMPULAN
MICO-JDEQ memindahkan disiplin teknik gedung (over handle) ke bentuk digital
yang tidak bergantung ingatan manusia. Prinsipnya identik: cegah titik buta
saat shift berganti. Bedanya hanya medium dan cara validasi.

---
Ditetapkan: AG-003 atas perintah L0
Tanggal : 16 September 2026
Status  : FINAL