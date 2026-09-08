# SERVER RULE — Kolom K2 (Tandon Server)

## Kebijakan
1. Server hanya dihidupkan saat dibutuhkan (on-demand).
2. Hanya bind ke 127.0.0.1 atau Tailscale IP (100.x).
3. Folder yang disajikan: 02_DATA\TANDON_UPDATE.
4. Tidak boleh membuka port ke 0.0.0.0.
5. Setelah selesai, wajib matikan server dengan `server_off.ps1`.

## Cara Pakai
- Mulai server:
  python "D:\MICO_SSOT\TREE_L\04_APLIKASI\LOCAL_SERVER\server_on.py"
- Matikan server:
  & "D:\MICO_SSOT\TREE_L\04_APLIKASI\LOCAL_SERVER\server_off.ps1"

## Larangan
- Dilarang memodifikasi file di dalam TANDON_UPDATE saat server aktif.
- Dilarang menjalankan server_on.py dua kali tanpa mematikan yang lama.
- Dilarang mengganti port tanpa Task Card.
