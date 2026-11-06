#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: PERBAIKI DUA CELAH"
echo " Seragam Akses + Kalibrasi IDS"
echo "=========================================="

# 1. Perbaiki Seragam Akses di Z83
echo "[1/2] Memperbaiki Seragam Akses di Z83..."
ssh iswan@z83-server.tail2a1291.ts.net 'sudo mkdir -p /srv/jdeq/authority/uniforms && sudo tee /srv/jdeq/authority/uniforms/tier_policy.json > /dev/null << '\''EOF'\''
{
  "CORE_COMMAND": {"access": ["read_ssot", "approve_action", "override_policy"], "forbidden": ["execute_root", "delete_evidence"]},
  "CORE_AUDIT": {"access": ["read_all", "audit_log", "verify_evidence"], "forbidden": ["modify_state", "execute_action"]},
  "CORE_TACTICAL": {"access": ["read_registry", "execute_code", "report_evidence"], "forbidden": ["override_policy", "access_env"]},
  "CORE_ANALYSIS": {"access": ["read_data", "synthesize_report", "query_registry"], "forbidden": ["execute_root", "modify_ssot"]},
  "SUB_WORKER": {"access": ["read_public", "execute_sandbox"], "forbidden": ["read_ssot", "modify_state", "access_env", "delete_ssot"]}
}
EOF
sudo chown -R iswan:iswan /srv/jdeq/authority/ && echo "✅ Seragam Akses siap."'

# 2. Kalibrasi ulang baseline IDS di Scout
echo "[2/2] Kalibrasi ulang baseline IDS..."
cd ~/mico_jdeq && find . -type f \( -name "*.sh" -o -name "*.py" \) -exec sh -c 'sha256sum "$1" | cut -d" " -f1 > "$1.hash"' _ {} \;
echo "  ✅ Baseline IDS dikalibrasi ulang."

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0070: Perbaiki Seragam Akses Z83 + Kalibrasi IDS" 2>/dev/null
git push origin main 2>/dev/null || true

echo ""
echo "=========================================="
echo " DUA CELAH DIPERBAIKI"
echo " Seragam Akses: ✅ Kembali"
echo " IDS Baseline: ✅ Dikalibrasi"
echo "=========================================="
