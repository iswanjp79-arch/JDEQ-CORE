#!/bin/bash
OUT="/var/log/mico-jdeq/DIGITAL_MIRROR.json"
HASH_OUT="/var/log/mico-jdeq/DIGITAL_MIRROR.sha256"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
HOST=$(hostname)
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null | head -1)
FUNNEL_URL="https://${HOST}.tail2a1291.ts.net"
SERVICE_LIST=""
for svc in ssh tailscaled systemd-networkd; do
  s=$(systemctl is-active "$svc" 2>/dev/null)
  e=$(systemctl is-enabled "$svc" 2>/dev/null)
  SERVICE_LIST="${SERVICE_LIST}${svc}:active=${s},enabled=${e};"
done

LOAD=$(cut -d' ' -f1-3 /proc/loadavg)
MEM=$(free -h | awk '/^Mem:/ {print $3"/"$2}')
DISK=$(df -h / | awk 'NR==2 {print $4" free of "$2}')
SSH_PASSWD=$(sudo grep -E '^PasswordAuthentication' /etc/ssh/sshd_config | awk '{print $2}')

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "hostname": "$HOST",
  "tailscale_ip": "$TAILSCALE_IP",
  "funnel_url": "$FUNNEL_URL",
  "services": "$SERVICE_LIST",
  "load": "$LOAD",
  "memory": "$MEM",
  "disk": "$DISK",
  "ssh_password_authentication": "$SSH_PASSWD",
  "status": "DIGITAL_MIRROR_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== DIGITAL MIRROR OUTPUT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
