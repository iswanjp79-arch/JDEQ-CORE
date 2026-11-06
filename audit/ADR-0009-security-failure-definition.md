# ADR-0009 — Security Baseline & Failure Definition
- Status: Accepted
- Date: 2026-07-03
- Owner: Mas Iwan
- Scope: Keamanan, Definisi Kegagalan

## Security Baseline
1. Registry wajib memiliki hash SHA-256 + timestamp di setiap perubahan.
2. Setiap API key disimpan terenkripsi (gpg) dan tidak boleh dalam plaintext.
3. Agen baru wajib diverifikasi tanda tangan digitalnya sebelum terdaftar.
4. Setiap supply chain (Blackbox CLI, npm, pip) wajib dicek checksum sebelum instalasi.

## Failure Definition
- **Mission Failure:** MICO tidak lagi menjalankan Misi yang tercantum di Constitution.
- **Architecture Failure:** Root produksi terduplikasi atau registry corrupt tanpa recovery.
- **Security Failure:** Ditemukan akses tidak sah atau manipulasi registry.
- **Governance Failure:** ADR diubah tanpa persetujuan Owner.
- **Ethics Failure:** Sistem menjalankan perintah yang membahayakan manusia.

## Health Score (Minimum)
Setiap minggu, sistem wajib melaporkan:
- Governance: jumlah ADR aktif, jumlah ADR superseded
- Security: jumlah percobaan akses tidak sah
- Knowledge: jumlah record di knowledge base
- Recovery: status backup terakhir
