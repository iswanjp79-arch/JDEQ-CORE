# SSID TRIGGERED SYNC — Vivo Mobil Tangki via Tunnel Tailscale

## Tujuan
Vivo Y28 hanya memompa/mentransfer data saat terhubung ke Wi-Fi tertentu.
Saat lepas Wi-Fi, klep otomatis tertutup. Kuota seluler tetap aman.

## Peran
- Vivo Y28 = Mobil tangki air (pengirim/penerima data saat ada Wi-Fi).
- PC-i5 = Tandon utama (penerima data).
- Tailscale = Tunnel pelindung (WireGuard encrypted).

## Aturan
1. Transfer hanya aktif jika SSID target terdeteksi.
2. SSID target ditentukan oleh L0, contoh: WIFI-GRATIS.
3. Saat tidak ada SSID target, tidak boleh transfer lewat kuota seluler.
4. Semua data masuk ke 02_DATA\TANDON_UPDATE.
5. Setiap transfer wajib dicatat hash SHA256.

## Implementasi di Vivo (Termux)
- Skrip ringan memantau SSID aktif.
- Jika SSID cocok, jalankan rsync/scp via Tailscale ke PC-i5.
- Jika SSID berubah, hentikan proses transfer dan matikan koneksi.

## Implementasi di PC-i5
- Cukup siapkan folder tandon dan pencatatan evidence.
- Tidak perlu service tambahan.

## Keamanan
- Tidak menyimpan password Wi-Fi di dalam skrip.
- Gunakan Tailscale IP 100.x untuk koneksi.
- Transfer hanya lewat tunnel terenkripsi.

## Status
- Menunggu penerapan skrip Termux di Vivo.
- Dokumen ini sebagai landasan tata kelola.
