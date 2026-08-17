#!/bin/bash
OUT="/home/iswanjp/mico/p3/DASHBOARD.md"
OBS="/var/log/mico-jdeq/OBSERVABILITY.json"
mkdir -p /home/iswanjp/mico/p3

if [ ! -f "$OBS" ]; then
  echo "# DASHBOARD - data missing" > "$OUT"
  exit 0
fi

{
  echo "# MICO-JDEQ DASHBOARD HARIAN"
  echo ""
  echo "Tanggal: $(date '+%Y-%m-%d')"
  echo "Node: $(hostname)"
  echo ""
  echo "## Status Sistem"
  python3 - <<'PY'
import json
d = json.load(open('/var/log/mico-jdeq/OBSERVABILITY.json'))
print(f"- CPU Load: {d['cpu_load']}")
print(f"- Mem Free: {d['mem_free_gb']} GB")
print(f"- Disk Free: {d['disk_free_gb']} GB")
print(f"- Verifier: {d['verifier_status']}")
print(f"- Task Contracts: {d['task_contract_count']}")
print(f"- Evidence Chain: {d['evidence_chain_length']}")
print(f"- Alerts: {d['alerts'] or 'none'}")
PY
  echo ""
  echo "## Tailscale Funnel"
  echo "https://markas-utama.tail2a1291.ts.net"
  echo ""
  echo "## Verifier Terakhir"
  tail -n 8 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log 2>/dev/null | sed 's/^/    /'
} > "$OUT"
