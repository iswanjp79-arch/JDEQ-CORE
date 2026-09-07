# NETWORK TOPOLOGY — PC-i5 (KAPAL-INDUK)

## Node & Peran
- PC-i5 (KAPAL-INDUK) : Heavy Local Worker
- Z83                : Mandor Node / NATS server
- Vivo Y28           : Thin Client / Gateway
- Cloud              : Backup / Worker opsional

## Jalur Komunikasi
- Lokal: LAN / USB debugging
- Remote: Tailscale (IP 100.x.x.x)
- Messaging: NATS di Z83
- Format pesan: JSON (wajib)

## Batas Keamanan
- Cloud tidak boleh akses TREE_L langsung.
- Vivo hanya mengirim perintah, bukan menyimpan data inti.
- Data sensitif tetap di PC-i5.
