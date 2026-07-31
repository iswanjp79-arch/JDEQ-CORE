# RENCANA PEMULIHAN PC I5 (MARK IV)
**Status:** WAJIB DILAKSANAKAN
**Penyebab:** Boot error, layar tidak muncul.
**Solusi:** Instal ulang Ubuntu 24.04 LTS.

## Langkah 1: Buat USB Bootable
1. Unduh ISO Ubuntu 24.04 LTS: https://ubuntu.com/download/desktop
2. Gunakan Rufus (Windows) atau Balena Etcher untuk membuat USB bootable.

## Langkah 2: Instal Ulang
1. Colok USB, boot dari USB (tekan F12/DEL saat startup).
2. Pilih "Install Ubuntu".
3. Hapus partisi lama, buat baru: EFI 1GB, root 50GB, home sisa.
4. Lanjutkan instalasi.

## Langkah 3: Pulihkan dari Checkpoint
Setelah Ubuntu berjalan, jalankan:
```bash
git clone git@github.com:iswanjp79-arch/JDEQ-CORE.git ~/mico_jdeq
cd ~/mico_jdeq && git checkout main
