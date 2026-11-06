#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY 3 PILAR UTAMA"
echo "=========================================="

radar() { ssh iswan@z83-server.tail2a1291.ts.net "$@"; }
penjaga() { ssh -p 8022 iswan@100.103.39.81 "$@"; }

# Pilar 1: Hugging Face
echo "[1/4] Pilar Data & Model: Hugging Face"
radar "pip install huggingface_hub transformers && echo '✅ Hugging Face terpasang'"

# Pilar 2: GitHub Copilot CLI
echo "[2/4] Pilar Kode & Repositori: GitHub Copilot CLI"
radar "npm install -g @github/copilot-cli && echo '✅ Copilot CLI terpasang'"

# Pilar 3: Gemini 3.0 Worker
echo "[3/4] Pilar Intelijen: Gemini 3.0"
cat > ~/mico_jdeq/scripts/gemini_worker.py << 'GEMINI'
#!/usr/bin/env python3
import os, sys, json, requests
API_KEY = os.environ.get("GEMINI_API_KEY", "")
URL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent"
def tanya(prompt):
    headers = {"Content-Type": "application/json"}
    data = {"contents": [{"parts": [{"text": prompt}]}]}
    r = requests.post(f"{URL}?key={API_KEY}", headers=headers, json=data)
    return r.json()["candidates"][0]["content"]["parts"][0]["text"] if r.status_code == 200 else json.dumps({"error": r.text})
if __name__ == "__main__":
    print(tanya(" ".join(sys.argv[1:])) if len(sys.argv) > 1 else "Usage: gemini_worker.py <prompt>")
GEMINI
chmod +x ~/mico_jdeq/scripts/gemini_worker.py

# Pilar 4: Hubungkan semua ke SSOT
echo "[4/4] Sinkronisasi ke SSOT"
cat >> ~/mico_jdeq/registry/ai_workers.json << 'REG'
{
  "hugging_face": {"role": "model_hub", "plane": "data", "status": "active"},
  "github_copilot": {"role": "code_assistant", "plane": "compute", "status": "active"},
  "gemini_3": {"role": "multimodal", "plane": "intelligence", "status": "active"},
  "groq": {"role": "planner", "plane": "intelligence", "status": "active_contracted"}
}
REG

echo "=========================================="
echo " 3 PILAR TERPASANG. SEMUA TUNDUK POLICY ENGINE."
echo "=========================================="
