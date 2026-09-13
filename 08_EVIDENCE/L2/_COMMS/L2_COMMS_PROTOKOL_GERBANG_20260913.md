# L2 — KOMUNIKASI, PROTOKOL, GERBANG
# Tanggal: 2026-09-13
# Otoritas: L0 (Iswan Juman Pancoro, ST)
# Mode: READ_ONLY evidence
# Generated: 2026-09-13 02:15:59

## 1. PROTOKOL TRANSPORT

| Lapis | Protokol | Port | Keterangan |
|---|---|---|---|
| Overlay mesh | Tailscale (WireGuard) | UDP 41641 | Jalur utama antar node |
| Remote shell | SSH | 22 (Linux), 8022 (Termux Android) | Kendali dari PC-i5 |
| Android debug | ADB | TCP 5037 (lokal), USB | Infinix via Z83 |
| DERP relay | Tailscale | UDP 443 | Fallback saat direct gagal |

## 2. TOPOLOGI

Router ISP (192.168.1.1)
  |
  +-- LAN 192.168.1.x
  |     +-- PC-i5 (192.168.1.4)
  |     +-- Aspire (192.168.1.7) [saat live]
  |     +-- HP Mini (192.168.1.6) [saat bangun]
  |     +-- Z83 (markas-utama)
  |     +-- Vivo (192.168.1.5)
  |     +-- Infinix (192.168.1.2)
  |
  +-- Tailscale mesh (100.64.0.0/10)
        +-- kapal-induk  100.124.50.70
        +-- markas-utama 100.67.36.31
        +-- antix1-1     100.123.139.63
        +-- hp-mini      100.92.105.35
        +-- madina       100.79.91.60
        +-- v2352        100.127.153.2

## 3. GATEWAY

- Default gateway: 192.168.1.1 (Ethernet 2, PC-i5)
- DNS: 192.168.1.1, 114.114.114.114
- Tailscale DNS: 100.100.100.100
- DERP terdekat: Singapore (sin) 21ms
- DERP cadangan: Hong Kong 60ms, Bengaluru 65ms
- UDP NAT: direct (103.105.55.147:58619)

## 4. STATUS RUNTIME (snapshot)

| Node | Ping | SSH/ADB | Status |
|---|---|---|---|
| PC-i5 (kapal-induk) | lokal | - | AKTIF |
| Z83 (markas-utama) | OK | SSH 22 OK | AKTIF |
| Vivo (v2352) | OK | SSH 8022 OK | AKTIF |
| Aspire (antix1-1) | drop | drop | SLEEP (live OS, ephemeral) |
| HP Mini | drop | drop | SLEEP (WiFi dongle autosuspend) |
| Infinix (madina) | drop | (tanpa sshd) | SLEEP (Android Doze) |
| Tablet Apple | - | - | DI SERVIS (bukan bagian L2) |

## 5. DEFINISI LUNAS

L2-Komunikasi dinyatakan LUNAS bila:

- Protokol transport sudah didefinisikan dan dipakai (✅)
- Topologi gateway sudah dipetakan (✅)
- Aturan firewall permanen sudah terkunci di node yang bisa dikunci (✅)
- Node yang tidur tidak merusak sistem — status runtime dicatat apa adanya (✅)
- Heartbeat direkam saat node bangun, otomatis re-handshake via tailscaled (✅)

LUNAS bukan berarti "semua node nyala 24/7". LUNAS = aturan dan jalur sudah tetap; status runtime fleksibel.

## 6. TEMUAN MINOR

- MIN-L2C-001: Aspire ephemeral — butuh /root/start.sh tiap boot
- MIN-L2C-002: HP Mini WiFi dongle autosuspend — butuh manual bangun
- MIN-L2C-003: Infinix tanpa sshd — hanya ADB via Z83
- MIN-L2C-004: Vivo/Infinix tanpa root — tidak bisa iptables

## 7. ACCEPTANCE

- Disetujui L0: ISWAN JUMAN PANCORO, ST
- Tanggal: 2026-09-13
- Status: ACCEPTED_BY_L0
