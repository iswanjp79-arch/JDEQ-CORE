# RUNBOOK: Wake Infinix via Z83 ADB

## Status
- Tailscale IP Infinix : 100.116.64.69
- SSH Port            : 8022
- ADB Path            : /usr/local/bin/mico-wake-infinix.sh
- Cron                : */5 * * * *

## Prosedur
1. Cek reachability: ping -c 2 100.116.64.69
2. Jika unreachable, jalankan: sudo /usr/local/bin/mico-wake-infinix.sh
3. Verifikasi: ping -c 2 100.116.64.69
4. Log: /var/log/mico-jdeq/WAKE_INFINIX.log
