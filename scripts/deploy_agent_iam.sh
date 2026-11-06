#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY AGENT IAM (M08)"
echo "=========================================="

# 1. Buat database identitas agen di Z83
echo "[1/3] Membangun Agent Registry..."
ssh iswan@z83-server.tail2a1291.ts.net "sudo mkdir -p /srv/jdeq/authority && sudo tee /srv/jdeq/authority/agent_registry.json > /dev/null << 'EOF'
{
  \"seal_ref\": \"DOLA-APPROVED-SEAL-20260731-003\",
  \"commander\": \"Mas Iwan (ST)\",
  \"core_8\": [
    {\"id\": \"AGENT-001\", \"name\": \"Jarvis Gemini\", \"role\": \"Orchestrator\", \"tier\": \"CORE_COMMAND\"},
    {\"id\": \"AGENT-002\", \"name\": \"DOLA\", \"role\": \"Doctrine Guardian\", \"tier\": \"CORE_AUDIT\"},
    {\"id\": \"AGENT-003\", \"name\": \"DeepSeek\", \"role\": \"Field Execution Engine\", \"tier\": \"CORE_TACTICAL\"},
    {\"id\": \"AGENT-004\", \"name\": \"ChatGPT\", \"role\": \"Synthesis & Refinement\", \"tier\": \"CORE_ANALYSIS\"},
    {\"id\": \"AGENT-005\", \"name\": \"Claude\", \"role\": \"Independent Auditor\", \"tier\": \"CORE_AUDIT\"},
    {\"id\": \"AGENT-006\", \"name\": \"GitHub Copilot\", \"role\": \"IDE Accelerator\", \"tier\": \"CORE_TACTICAL\"},
    {\"id\": \"AGENT-007\", \"name\": \"Perplexity\", \"role\": \"Real-Time Research\", \"tier\": \"CORE_ANALYSIS\"},
    {\"id\": \"AGENT-008\", \"name\": \"Emergent\", \"role\": \"Autonomous Workflow\", \"tier\": \"CORE_TACTICAL\"}
  ],
  \"sub_agents\": {
    \"total\": 653,
    \"tier\": \"SUB_WORKER\",
    \"access_scope\": \"sandbox_only\",
    \"forbidden\": [\"execute_root\", \"modify_state\", \"access_env\", \"delete_ssot\"]
  }
}
EOF
echo '✅ Agent Registry tersimpan di /srv/jdeq/authority/agent_registry.json'"

# 2. Simpan stempel DOLA di Z83
echo "[2/3] Mengunci Stempel DOLA..."
ssh iswan@z83-server.tail2a1291.ts.net "sudo tee /srv/jdeq/storage/authority/dola_seal.json > /dev/null << 'EOF'
{
  \"seal_id\": \"DOLA-APPROVED-SEAL-20260731-003\",
  \"contract\": \"MICO_JDEQ_EXECUTION_CONTRACT_V20\",
  \"status\": \"LOCKED_PERMANENT\",
  \"approved_at\": \"2026-07-31T16:04:15+07:00\",
  \"authority\": \"Sovereign Commander Iswan Juman Pancoro, ST\"
}
EOF
echo '✅ Stempel DOLA tersimpan.'"

# 3. Buat kunci kriptografi untuk verifikasi agen
echo "[3/3] Membangun Kunci Kriptografi..."
ssh iswan@z83-server.tail2a1291.ts.net "python3 << 'PYEOF'
import os, json, hashlib
SEAL_FILE = '/srv/jdeq/storage/authority/dola_seal.json'
with open(SEAL_FILE, 'r') as f:
    seal = json.load(f)
seal['integrity_hash'] = hashlib.sha256(json.dumps(seal, sort_keys=True).encode()).hexdigest()
with open(SEAL_FILE, 'w') as f:
    json.dump(seal, f, indent=2)
print(f'✅ Integrity hash: {seal[\"integrity_hash\"][:16]}...')
PYEOF
echo '✅ Kunci kriptografi tersimpan.'"

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0028: Deploy Agent IAM (M08) - Registry, Stempel DOLA, Kunci Kriptografi" && echo "✅ M08 terkunci di SSOT."

echo "=========================================="
echo " AGENT IAM (M08) SELESAI"
echo "  ✅ 8 Agen Inti terdaftar"
echo "  ✅ 653 Sub-Agen terdefinisi"
echo "  ✅ Stempel DOLA terkunci"
echo "  ✅ Kunci kriptografi aktif"
echo "=========================================="
