# ADR-0001 — Arsitektur Dasar MICO-JDEQ PC-i5

- Status: Accepted
- Tanggal: 2026-09-07
- Author: L0 / ChatGPT / DeepSeek
- Node: KAPAL-INDUK

## Context
PC-i5 adalah node pekerja berat lokal. Perlu keputusan arsitektur dasar agar tidak over-engineering dan tetap mempertahankan kedaulatan L0.

## Decision
- TREE-L memakai 14 pilar di `D:\MICO_SSOT\TREE_L`.
- Git hanya untuk konfigurasi/manifest/SOP, bukan data besar.
- Data besar disimpan di Drive D/E, bukan di repository.
- Setiap perubahan wajib lewat Task Card + approval.
- Tidak ada instalasi software tanpa bukti kebutuhan dan persetujuan L0.

## Consequences
- Positif: fondasi rapi, mudah audit, sumber daya terjaga.
- Negatif: beberapa pekerjaan menjadi lebih lambat karena wajib dokumentasi.

## Compliance
- UU_MICO_JDEQ.md
- KERNEL_LOCK.md
- SOP-001/002/003

## Evidence
- Hash SHA256 semua file kunci tersimpan di BASELINE_HASHES.json

## SHA256
{placeholder_diisi_setelah_hash}
