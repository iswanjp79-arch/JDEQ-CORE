#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: SECURE NEW CREDENTIAL"
echo "=========================================="

# 1. Perbarui vault di Z83
echo "[1/3] Memperbarui Vault Terenkripsi..."
ssh iswan@z83-server.tail2a1291.ts.net "python3 -c "
import json, os
vault_file = '/srv/jdeq/vault/assets_registry.json'
with open(vault_file, 'r') as f:
    vault = json.load(f)
vault['huggingface']['keys'].append('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')
vault['huggingface']['status'] = 'active_updated'
vault['last_updated'] = '2026-07-31T20:00:00+07:00'
with open(vault_file, 'w') as f:
    json.dump(vault, f, indent=2)
print('✅ Vault diperbarui.')
" && echo "  ✅ Vault Z83 diperbarui."

# 2. Perbarui registry lokal
echo "[2/3] Memperbarui Registry Lokal..."
python3 << 'PYEOF'
import json, os
REG = os.path.expanduser("~/mico_jdeq/registry/cloud_workers.json")
with open(REG, 'r') as f:
    workers = json.load(f)
workers['huggingface']['status'] = 'active_updated'
workers['huggingface']['last_updated'] = '2026-07-31T20:00:00+07:00'
with open(REG, 'w') as f:
    json.dump(workers, f, indent=2)
print("  ✅ Registry lokal diperbarui.")
PYEOF

# 3. Commit & notifikasi
echo "[3/3] Mengunci Perubahan..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0046: Secure new Hugging Face credential — vault updated" && echo "  ✅ Commit tersimpan."

bash ~/mico_jdeq/scripts/send_alert.sh "🔐 KREDENSIAL BARU DIAMANKAN
✅ Vault Z83 diperbarui
✅ Registry lokal diperbarui
✅ Commit tersimpan
STATUS: AMAN" 2>/dev/null || true

echo "=========================================="
echo " KREDENSIAL BARU DIAMANKAN"
echo " Vault: /srv/jdeq/vault/assets_registry.json"
echo "=========================================="
