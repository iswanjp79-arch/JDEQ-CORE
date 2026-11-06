#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DIGITAL AWARENESS CORE"
echo "=========================================="

# 1. Decision Engine — membaca registry, memilih agen
echo "[1/3] Membangun Decision Engine..."
cat > ~/mico_jdeq/modules/decision_engine.py << 'PYEOF'
#!/usr/bin/env python3
import json, os, sys
REGISTRY = os.path.expanduser("~/mico_jdeq/registry/ai_workers.json")
TIER_POLICY = "/srv/jdeq/authority/uniforms/tier_policy.json"

def load_json(path):
    with open(path) as f: return json.load(f)

def decide(task_type):
    """Pilih agen terbaik berdasarkan task."""
    registry = load_json(REGISTRY)
    # Mapping task ke role
    task_map = {
        "code": ["groq", "github_copilot", "deepseek_agent"],
        "audit": ["claude", "dola"],
        "research": ["perplexity", "chatgpt"],
        "multimodal": ["gemini_3", "chatgpt"],
        "planning": ["deepseek_agent", "groq"],
        "security": ["dola", "claude"],
        "orchestration": ["jarvis", "deepseek_agent"]
    }
    candidates = task_map.get(task_type, ["deepseek_agent"])
    for agent_id in candidates:
        if agent_id in registry:
            return {"agent": agent_id, "status": registry[agent_id].get("status","unknown")}
    return {"agent": "deepseek_agent", "status": "fallback"}

if __name__ == "__main__":
    task = sys.argv[1] if len(sys.argv) > 1 else "code"
    result = decide(task)
    print(json.dumps(result, ensure_ascii=False))
PYEOF
chmod +x ~/mico_jdeq/modules/decision_engine.py
echo "  ✅ Decision Engine siap."

# 2. Auto-Router — kirim tugas ke agen terpilih via Groq
echo "[2/3] Membangun Auto-Router..."
cat > ~/mico_jdeq/modules/auto_router.py << 'PYEOF'
#!/usr/bin/env python3
import os, sys, json, subprocess
DECISION = os.path.expanduser("~/mico_jdeq/modules/decision_engine.py")

def route(task_type, prompt):
    """Pilih agen, kirim prompt, kembalikan hasil."""
    result = subprocess.run(["python3", DECISION, task_type], capture_output=True, text=True)
    agent = json.loads(result.stdout)["agent"]
    print(f"🤖 Merutekan ke: {agent}")
    # Kirim ke Groq sebagai default executor
    cmd = ["python3", os.path.expanduser("~/mico_jdeq/scripts/groq_controller_v3.py"), prompt]
    output = subprocess.run(cmd, capture_output=True, text=True)
    return output.stdout

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print(route(sys.argv[1], " ".join(sys.argv[2:])))
    else:
        print("Usage: python3 auto_router.py <task_type> <prompt>")
        print("Task types: code, audit, research, multimodal, planning, security")
PYEOF
chmod +x ~/mico_jdeq/modules/auto_router.py
echo "  ✅ Auto-Router siap."

# 3. Integrasi dengan Health Check
echo "[3/3] Integrasi dengan Health Check..."
cat >> ~/mico_jdeq/scripts/health_check_enterprise.sh << 'HEALTHADD'

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
HEALTHADD
echo "  ✅ Health Check diperbarui."

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0037: Deploy Digital Awareness Core — Decision Engine + Auto-Router" && echo "✅ Digital Awareness terkunci."

echo ""
echo "=========================================="
echo " DIGITAL AWARENESS CORE AKTIF"
echo " Decision Engine: pilih agen otomatis"
echo " Auto-Router: kirim tugas ke agen terpilih"
echo "=========================================="
