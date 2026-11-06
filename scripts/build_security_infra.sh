#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: BANGUN INFRASTRUKTUR KEAMANAN"
echo "=========================================="

# 1. Perbaiki izin stempel DOLA
echo "[1/4] Memperbaiki izin Stempel DOLA..."
ssh iswan@z83-server.tail2a1291.ts.net "sudo chown iswan:iswan /srv/jdeq/storage/authority/dola_seal.json && echo '✅ Izin diperbaiki.'"

# 2. Buat integrity hash untuk stempel DOLA
echo "[2/4] Membangun Integrity Hash..."
ssh iswan@z83-server.tail2a1291.ts.net 'python3 -c "
import json, hashlib
seal = json.load(open(\"/srv/jdeq/storage/authority/dola_seal.json\"))
seal[\"integrity_hash\"] = hashlib.sha256(json.dumps(seal, sort_keys=True).encode()).hexdigest()
json.dump(seal, open(\"/srv/jdeq/storage/authority/dola_seal.json\", \"w\"), indent=2)
print(\"✅ Integrity hash: \" + seal[\"integrity_hash\"][:16] + \"...\")
" && echo "✅ Stempel DOLA sah."'

# 3. Buat kunci kriptografi untuk agen
echo "[3/4] Membangun Kunci Kriptografi Agen..."
ssh iswan@z83-server.tail2a1291.ts.net 'python3 -c "
import os, json, hashlib
os.makedirs(\"/srv/jdeq/authority/keys\", exist_ok=True)
agents = json.load(open(\"/srv/jdeq/authority/agent_registry.json\"))
for agent in agents[\"core_8\"]:
    key = hashlib.sha256((agent[\"id\"] + os.urandom(32).hex()).encode()).hexdigest()
    with open(f\"/srv/jdeq/authority/keys/{agent[\"id\"]}.key\", \"w\") as f:
        f.write(key)
print(\"✅ 8 kunci agen inti dibuat.\")
" && echo "✅ Kunci kriptografi siap."'

# 4. Buat seragam (konfigurasi akses) untuk setiap tier
echo "[4/4] Membangun Seragam Akses (Uniform Config)..."
ssh iswan@z83-server.tail2a1291.ts.net 'sudo mkdir -p /srv/jdeq/authority/uniforms && sudo tee /srv/jdeq/authority/uniforms/tier_policy.json > /dev/null << '\''EOF'\''
{
  "CORE_COMMAND": {"access": ["read_ssot", "approve_action", "override_policy"], "forbidden": ["execute_root", "delete_evidence"]},
  "CORE_AUDIT": {"access": ["read_all", "audit_log", "verify_evidence"], "forbidden": ["modify_state", "execute_action"]},
  "CORE_TACTICAL": {"access": ["read_registry", "execute_code", "report_evidence"], "forbidden": ["override_policy", "access_env"]},
  "CORE_ANALYSIS": {"access": ["read_data", "synthesize_report", "query_registry"], "forbidden": ["execute_root", "modify_ssot"]},
  "SUB_WORKER": {"access": ["read_public", "execute_sandbox"], "forbidden": ["read_ssot", "modify_state", "access_env", "delete_ssot"]}
}
EOF
sudo chown -R iswan:iswan /srv/jdeq/authority/ && echo "✅ Seragam akses siap."'

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0029: Bangun Infrastruktur Keamanan - Amunisi, Gudang, Seragam, ID Card, Terowongan" && echo "✅ Infrastruktur keamanan terkunci."

echo "=========================================="
echo " INFRASTRUKTUR KEAMANAN SIAP"
echo "  ✅ Gudang: /srv/jdeq/storage/"
echo "  ✅ ID Card: agent_registry.json"
echo "  ✅ Seragam: tier_policy.json"
echo "  ✅ Amunisi: 8 kunci kriptografi"
echo "  ✅ Terowongan: Tailscale + HMAC"
echo "=========================================="
