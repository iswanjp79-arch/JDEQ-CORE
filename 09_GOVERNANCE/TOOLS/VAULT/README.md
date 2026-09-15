# MICO-JDEQ VAULT — Ruang Pengendali Lokal
Status   : LOCAL-ONLY · Cloud mirror ditunda (keputusan L0)
Otoritas : L0
Lokasi   : 09_GOVERNANCE/TOOLS/VAULT/

## Fungsi
- Menyimpan Personal Access Token GitHub (dan kredensial lain) terenkripsi AES-256-CBC + PBKDF2 100k.
- Passphrase TIDAK disimpan di disk. Hanya di kepala operator.
- Decoy teks "alien" muncul saat passphrase salah.

## Struktur
- vault-master.ps1  → fungsi inti (NewVault / SetToken / ShowMeta / ShowDecoy)
- vault-rotate.ps1  → rotasi token + commit
- vault-verify.ps1  → verifikasi integritas + passphrase
- vault.bin         → data terenkripsi (di 08_EVIDENCE/VAULT_DATA/)
- vault.meta.json   → metadata (timestamp, versi)
- vault.sha256      → hash untuk deteksi perubahan
- decoy.txt         → pesan pengalih saat decrypt gagal

## Cara Pakai
1. Buat vault pertama kali:
   .\vault-master.ps1 -Action NewVault
2. Isi token (paste saat prompt, bukan di chat):
   .\vault-master.ps1 -Action SetToken
3. Verifikasi:
   .\vault-verify.ps1
4. Rotasi rutin:
   .\vault-rotate.ps1

## Batasan Jujur
- Multi-device sync BELUM ada. Ini fokus lokal murni.
- Passphrase bocor = vault bocor.
- Script tidak bisa mencegah akses disk langsung (file tetap byte acak, aman dari baca biasa).

## Mirror Cloud
Ditunda. Akan diimplementasi setelah local-first stabil.