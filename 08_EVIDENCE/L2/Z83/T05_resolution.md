# L2-Z83-T05 — SSH Connections Resolution

Tanggal: 2026-09-11
Node: Z83 (markas-utama), Tailscale 100.67.36.31

## Klasifikasi 6 koneksi L1

| # | Peer | Port | Owner | Klasifikasi |
|---|---|---|---|---|
| 1 | 172.217.114.4 | 443 | rclone pid 2242 | Google API |
| 2 | 192.200.0.112 | 443 | tailscaled | Tailscale control |
| 3 | 172.237.72.43 | 443 | tailscaled | Tailscale DERP |
| 4 | 199.165.136.100 | 443 | tailscaled | Tailscale DERP |
| 5 | 192.168.1.1 | 67 | dhclient enp1s0 | DHCP |
| 6 | 192.168.1.1 | 67 | dhclient wlan0 | DHCP |

## Mesh Tailscale
- 100.67.36.31 markas-utama (Z83, linux)
- 100.124.50.70 kapal-induk (PC-i5, windows) direct 192.168.1.4:41641
- 100.127.153.2 v2352 (Android) idle

## SSH logins (peer)
- 100.124.50.70 (PC-i5) recurring
- 100.127.153.2 (Android v2352) recurring
- 192.168.1.4 (LAN) setup awal

## Verdict
T05 CLOSED. Zero unknown connections.
Semua teridentifikasi: rclone + tailscaled + dhcpclient.

Status: L2-Z83 AUDIT_READY -> CLOSED
