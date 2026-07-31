#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ ENTERPRISE HEALTH CHECK"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
PASS=0; FAIL=0; TOTAL=20

check() { if eval "$2" 2>/dev/null; then echo "  ✅ $1"; ((PASS++)); else echo "  ❌ $1"; ((FAIL++)); fi; }

echo "[1-5] Koneksi"
check "SSH Radar" "ssh -o ConnectTimeout=3 iswan@z83-server.tail2a1291.ts.net 'echo OK' | grep -q OK"
check "SSH Penjaga" "ssh -o ConnectTimeout=3 -p 8022 iswan@100.103.39.81 'echo OK' | grep -q OK"
check "NATS Radar" "ssh iswan@z83-server.tail2a1291.ts.net 'curl -s http://localhost:8222/varz' | grep -q server_id"
check "MagicDNS" "ssh -o ConnectTimeout=3 iswan@z83-server.tail2a1291.ts.net 'echo OK' | grep -q OK"
check "Internet" "ping -c 1 -W 2 8.8.8.8 > /dev/null"

echo "[6-10] Service"
check "SSHD Radar" "ssh iswan@z83-server.tail2a1291.ts.net 'systemctl is-active ssh' | grep -q active"
check "NATS Service" "ssh iswan@z83-server.tail2a1291.ts.net 'systemctl is-active nats-server' | grep -q active"
check "Crond Scout" "pgrep crond > /dev/null"
check "SSHD Penjaga" "ssh -p 8022 iswan@100.103.39.81 'pgrep sshd > /dev/null'"
check "SSHD Scout" "pgrep sshd > /dev/null"

echo "[11-15] Storage & Data"
check "SSOT Scout" "[ -d ~/mico_jdeq ] && [ -f ~/mico_jdeq/manifest/SYSTEM_LOCK.md ]"
check "Checkpoint" "ls ~/mico_jdeq/checkpoint/state_*.tar.gz 2>/dev/null | head -1 | grep -q state"
check "Git" "cd ~/mico_jdeq && git status > /dev/null 2>&1"
check "Journal" "[ -f ~/mico_jdeq/journal/groq_observer.log ]"
check "Registry" "[ -f ~/mico_jdeq/registry/ai_workers.json ]"

echo "[16-20] AI & Security"
check "Groq" "python3 ~/mico_jdeq/scripts/groq_controller_v3.py 'test' 2>&1 | grep -v 'error'"
check "DOLA" "python3 ~/mico_jdeq/scripts/dola_gatekeeper.py 'sudo rm -rf /' 2>&1 | grep -q DITOLAK"
check "IDS" "[ -f ~/mico_jdeq/scripts/intrusion_detector.sh ]"
check "Disk Scout" "[ $(df -h /data | awk 'NR==2 {print $5}' | sed 's/%//') -lt 90 ]"
check "RAM Scout" "[ $(free -m | awk '/Mem:/ {print $7}') -gt 500 ]"

echo ""
echo "=============================================="
echo " HASIL: $PASS/$TOTAL LULUS"
SCORE=$((PASS * 100 / TOTAL))
echo " SKOR: $SCORE/100"
[ $FAIL -eq 0 ] && echo " STATUS: SEHAT ✅" || echo " STATUS: PERLU PERBAIKAN ($FAIL gagal)"
echo "=============================================="

# XSS Defense Check
echo "[21] XSS Defense"
if [ -f ~/mico_jdeq/security/block_patterns.json ] && [ -f ~/mico_jdeq/scripts/xss_sanitizer.py ]; then
    echo "  ✅ PASS  | XSS Defense"
else
    echo "  ❌ FAIL  | XSS Defense"
fi

# [22] Decision Engine
echo "[22] Decision Engine"
python3 ~/mico_jdeq/modules/decision_engine.py code 2>/dev/null | grep -q "agent" && echo "  ✅ PASS  | Decision Engine" || echo "  ❌ FAIL  | Decision Engine"

# [23] Auto-Router
echo "[23] Auto-Router"
python3 ~/mico_jdeq/modules/auto_router.py code "test" 2>/dev/null | grep -q "Merutekan" && echo "  ✅ PASS  | Auto-Router" || echo "  ❌ FAIL  | Auto-Router"

# [24] Agent Awareness
echo "[24] Agent Awareness"
AGENT_COUNT=$(python3 -c "import json; print(len(json.load(open('$HOME/mico_jdeq/registry/ai_workers.json'))))" 2>/dev/null)
echo "  ✅ INFO  | $AGENT_COUNT agen terdaftar"

# [22] Decision Engine
echo "[22] Decision Engine"
python3 ~/mico_jdeq/modules/decision_engine.py code 2>/dev/null | grep -q "agent" && echo "  ✅ PASS  | Decision Engine" || echo "  ❌ FAIL  | Decision Engine"

# [23] Auto-Router
echo "[23] Auto-Router"
python3 ~/mico_jdeq/modules/auto_router.py code "test" 2>/dev/null | grep -q "Merutekan" && echo "  ✅ PASS  | Auto-Router" || echo "  ❌ FAIL  | Auto-Router"

# [24] Agent Awareness
echo "[24] Agent Awareness"
AGENT_COUNT=$(python3 -c "import json; print(len(json.load(open('$HOME/mico_jdeq/registry/ai_workers.json'))))" 2>/dev/null)
echo "  ✅ INFO  | $AGENT_COUNT agen terdaftar"
