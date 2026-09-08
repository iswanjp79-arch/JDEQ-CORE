# ETIKET GAYA — MICO Fasad

## Daftar Profil
- Organik    : warna alam, bentuk organik, santai.
- Industrial : beton/baja, sudut tegas, siaga.
- Minimalis  : monokrom, ruang longgar, fokus.

## Cara Kerja
Skrip `inject_fasad.ps1` membaca `MICO_ESTETIKA.json`.
Jika CPU Load > 75%, fasad otomatis memakai profil `industrial` sebagai tanda bahaya.
Jika CPU Load normal, fasad memakai profil `organik`.

## Pengembangan
Untuk menambah profil baru, cukup tambah blok baru di dalam `MICO_ESTETIKA.json`.
Jangan mengubah struktur dasar tanpa ACC L0.
