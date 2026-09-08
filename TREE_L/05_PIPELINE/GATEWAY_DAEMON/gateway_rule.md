# GATEWAY RULE — Kolom K1

## Kebijakan
1. Hanya bind ke localhost (127.0.0.1) atau Tailscale IP (100.x).
2. Tidak boleh membuka port ke 0.0.0.0 tanpa ACC L0.
3. Port resmi tercantum di PETA_PORT_SOCKET.md.
4. Setiap koneksi wajib tercatat, tanpa menyimpan payload.
5. Tidak ada routing ke cloud sebelum kolom K1 dinyatakan stabil.

## Port Wajib
- 8022: SSH Windows
- 22: SSH WSL
- 1883: Mosquitto (ditahan)
- 8080: Tandon HTTP (on-demand)
- 5037: ADB
- 3240: USBIP

## Larangan
- Dilarang membuka port baru tanpa Task Card.
- Dilarang memforward port ke eksternal.
- Dilarang menjalankan gateway pada mode write.
