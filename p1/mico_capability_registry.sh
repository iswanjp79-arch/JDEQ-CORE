#!/bin/bash
OUT="/var/log/mico-jdeq/CAPABILITY_REGISTRY.json"
HASH_OUT="/var/log/mico-jdeq/CAPABILITY_REGISTRY.sha256"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
HOST=$(hostname)
CPU_MODEL=$(lscpu | awk -F: '/Model name/ {gsub(/^ +| +$/, "", $2); print $2; exit}')
CPU_CORES=$(nproc)
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null | head -1)
TAILSCALE_STATUS=$(tailscale status --json 2>/dev/null | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("BackendState","unknown"))' 2>/dev/null || echo unknown)
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
PIP_VERSION=$(python3 -m pip --version 2>/dev/null | awk '{print $2}' || echo "not installed")

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "hostname": "$HOST",
  "cpu": {"model": "$CPU_MODEL", "cores": "$CPU_CORES"},
  "memory": {"total": "$RAM_TOTAL"},
  "disk": {"root_total": "$DISK_TOTAL", "root_free": "$DISK_FREE"},
  "network": {"tailscale_ip": "$TAILSCALE_IP", "tailscale_backend_state": "$TAILSCALE_STATUS"},
  "python": {"version": "$PYTHON_VERSION", "pip": "$PIP_VERSION"},
  "status": "CAPABILITY_REGISTRY_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== CAPABILITY REGISTRY OUTPUT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
