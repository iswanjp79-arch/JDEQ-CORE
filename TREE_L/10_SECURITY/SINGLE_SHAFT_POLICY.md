# SINGLE SHAFT — KEBIJAKAN JARINGAN MICO-JDEQ

## Inti
PC-i5 hanya memakai satu pintu utama: Tailscale (IP 100.x) atau SSH Tunnel.
Jangan buka port baru tanpa Task Card + ACC L0.

## Alasan
- Setiap port terbuka adalah celah masuk.
- Semakin sedikit port, semakin kecil permukaan serangan.
- Semua layanan lokal cukup lewat localhost (127.0.0.1).

## Aturan
1. Port hanya terbuka untuk jalur resmi.
2. Port baru wajib tercatat di PETA_PORT_SOCKET.md.
3. Layanan luar hanya boleh lewat Tailscale.
4. Firewall default inbound = Block.
