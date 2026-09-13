# L3-TC-03 — PERIMETER LOCK CLOSED
Tanggal: 2026-09-13
Otoritas: L0 — Iswan Juman Pancoro, ST

## Yang Selesai
1. UFW aktif (IPv4 + IPv6 policy DROP)
2. Rule SSH LAN: 22/tcp ALLOW dari 192.168.1.0/24
3. Saned (port 6566) dinonaktifkan total
4. CUPS (port 631) hanya di localhost
5. Cron service diperbaiki (foreground via runit)
6. rc.local rewrite: /usr/sbin/ufw --force enable
7. mico-spool.sh refresh berjalan
8. Sudoers b/c/d ditambahkan

## Verifikasi
- Port 22: True (dari LAN)
- Port 6566: False (tertutup)
- Port 631: False (localhost only)
- Zombie: 0
- Cron: run (runit)
- Spool: refresh normal

## Backup
- /etc/rc.local.bak-preL3TC03
- /etc/iptables/rules.v4.bak-preL3TC03
- /etc/sv/cron/run.bak-preL3TC03
- D:\MICO_SSOT\L3-backups\hpmini-grub\grub_2026-09-13_1904.bak

## Status
CLOSED.
