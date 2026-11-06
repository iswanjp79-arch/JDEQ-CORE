# Risk Matrix — MICO-JDEQ

| ID | Risiko | Peluang | Dampak | Prioritas | Mitigasi |
|----|--------|---------|--------|-----------|----------|
| R1 | Duplikasi 182 nama folder menyebabkan import/script salah target | Tinggi | Tinggi | Kritis | Konsolidasi ke satu root produksi, karantina folder lama (ADR-0001) |
| R2 | Fitur butuh root (sepolicy_adjust, init_hook) tidak jalan di Y28 | Tinggi | Sedang | Tinggi | Buat fallback non-root, tandai fitur ini sebagai opsional |
| R3 | GitHub Actions belum pernah tervalidasi jalan sukses | Sedang | Sedang | Sedang | Cek tab Actions manual, tambah status badge di README |
| R4 | Vault/API key ter-commit tidak sengaja ke repo publik | Rendah | Kritis | Tinggi | Tambahkan .gitignore untuk folder vault/, audit sebelum tiap push |
| R5 | Registry.json rusak akibat edit manual bersamaan dari banyak agen | Sedang | Tinggi | Tinggi | Validasi JSON otomatis sebelum commit (sudah ada di sync_registry.sh) |
