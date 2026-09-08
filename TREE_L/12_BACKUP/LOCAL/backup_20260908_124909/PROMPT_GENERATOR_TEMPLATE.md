# PROMPT GENERATOR TEMPLATE — MICO-JDEQ

Gunakan format ini untuk setiap perintah ke agen. Isi bagian dalam kurung.

## ROLE
[Nama agen / peran spesifik]

## CONTEXT
- Proyek: MICO-JDEQ
- Node: PC-i5 (KAPAL-INDUK)
- RAM: 16GB, SSD: 128GB
- Prinsip: Capability ≠ Installation

## TASK
[Tulis tugas spesifik yang diminta]

## CONSTRAINTS
- Dilarang instalasi software baru.
- Dilarang akses di luar folder yang diizinkan.
- Dilarang hardcode secret/API key.
- Batas waktu: [menit] menit.
- Jika ragu, berhenti dan tanya L0.

## OUTPUT_FORMAT
[JSON / Markdown / teks biasa]
Contoh JSON:
{
  "status": "BERHASIL / SEBAGIAN / GAGAL",
  "fase": "FASE_X",
  "hasil": "...",
  "file_bukti": "...",
  "sha256": "...",
  "catatan": "..."
}

## VALIDATION
- Semua file output wajib di-hash SHA256.
- Bukti disimpan di 08_EVIDENCE\RUNTIME\.
- Laporan akhir tanpa basa-basi.

## EVIDENCE_REQUIRED
- Nama file
- Lokasi file
- SHA256
- Waktu selesai
