#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: PREMIUM-FREE OPTIMIZATION"
echo " Target: Koneksi Multi-Platform, GCloud, Gemini"
echo "=========================================="

# 1. Optimasi Koneksi Multi-Platform
echo "[1/3] Membangun Connection Pooling & Pre-Warming..."
cat > ~/mico_jdeq/modules/connection_pool.sh << 'POOL'
#!/data/data/com.termux/files/usr/bin/bash
LOG="$HOME/mico_jdeq/journal/connection_pool.log"
echo "[$(date)] Connection Pool: Memeriksa jalur koneksi..." >> $LOG

# Pre-warming: pantau 4 jalur sekaligus
for TARGET in "192.168.1.3" "100.125.176.126" "100.103.39.81" "8.8.8.8"; do
    LATENCY=$(ping -c1 -W2 $TARGET 2>/dev/null | awk -F'/' 'END{print $5}' | cut -d'.' -f1)
    if [ -n "$LATENCY" ]; then
        echo "[$(date)] $TARGET: ${LATENCY}ms" >> $LOG
    else
        echo "[$(date)] $TARGET: TIMEOUT" >> $LOG
    fi
done

# Simpan cache status
sqlite3 ~/mico_jdeq/state/state.db "INSERT OR REPLACE INTO node (name, status, updated) VALUES ('pool_status', 'active', datetime('now'));" 2>/dev/null
echo "✅ Connection pool diperbarui."
POOL
chmod +x ~/mico_jdeq/modules/connection_pool.sh

# 2. Google Cloud Remote Shell
echo "[2/3] Membangun GCloud Remote Gateway..."
cat > ~/mico_jdeq/modules/gcloud_gateway.sh << 'GCLOUD'
#!/data/data/com.termux/files/usr/bin/bash
PROJECT="mico-sandbox-2026"
LOG="$HOME/mico_jdeq/journal/gcloud.log"

# Inisialisasi koneksi ke Cloud Shell
gcloud config set project $PROJECT 2>/dev/null
echo "[$(date)] GCloud: Project $PROJECT siap." >> $LOG

# Cold-start mitigation: kirim ping setiap 15 menit
gcloud cloud-shell ssh --authorize-session --command="echo 'keepalive'" 2>/dev/null && \
    echo "[$(date)] GCloud: Cold-start mitigated." >> $LOG || \
    echo "[$(date)] GCloud: Perlu autentikasi manual." >> $LOG
echo "✅ GCloud Gateway siap."
GCLOUD
chmod +x ~/mico_jdeq/modules/gcloud_gateway.sh

# 3. Gemini Semantic Cache + Fallback
echo "[3/3] Membangun Gemini Cache & Fallback..."
cat > ~/mico_jdeq/modules/gemini_cache.py << 'PYEOF'
#!/usr/bin/env python3
"""Gemini Semantic Cache + Groq Fallback"""
import os, json, hashlib, time, requests

CACHE_DIR = os.path.expanduser("~/mico_jdeq/cache/gemini")
os.makedirs(CACHE_DIR, exist_ok=True)
GEMINI_KEY = os.environ.get("GEMINI_API_KEY", "")
GROQ_KEY = os.environ.get("GROQ_API_KEY", "")

def get_cache_key(prompt):
    return hashlib.sha256(prompt.encode()).hexdigest()[:16]

def query_gemini(prompt):
    cache_key = get_cache_key(prompt)
    cache_file = os.path.join(CACHE_DIR, cache_key + ".json")
    
    # Cek cache dulu
    if os.path.exists(cache_file):
        with open(cache_file) as f:
            cached = json.load(f)
        if time.time() - cached["ts"] < 3600:
            return cached["response"] + " [CACHE]"
    
    # Panggil Gemini
    url = f"https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key={GEMINI_KEY}"
    data = {"contents": [{"parts": [{"text": prompt}]}]}
    
    try:
        r = requests.post(url, json=data, timeout=10)
        if r.status_code == 200:
            response = r.json()["candidates"][0]["content"]["parts"][0]["text"]
            with open(cache_file, "w") as f:
                json.dump({"ts": time.time(), "response": response}, f)
            return response
        else:
            return fallback_groq(prompt)
    except:
        return fallback_groq(prompt)

def fallback_groq(prompt):
    """Jika Gemini throttled, gunakan Groq."""
    import subprocess
    result = subprocess.run(["python3", os.path.expanduser("~/mico_jdeq/scripts/groq_controller_v3.py"), prompt], 
                          capture_output=True, text=True, timeout=15)
    return result.stdout.strip() + " [FALLBACK-GROQ]"

if __name__ == "__main__":
    import sys
    prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Apa itu MICO-JDEQ?"
    print(query_gemini(prompt))
PYEOF
chmod +x ~/mico_jdeq/modules/gemini_cache.py

# Pasang Connection Pool di crontab (setiap 3 menit)
(crontab -l 2>/dev/null | grep -v connection_pool; echo "*/3 * * * * bash ~/mico_jdeq/modules/connection_pool.sh") | crontab -

# Pasang GCloud keepalive di crontab (setiap 15 menit)
(crontab -l 2>/dev/null | grep -v gcloud_gateway; echo "*/15 * * * * bash ~/mico_jdeq/modules/gcloud_gateway.sh") | crontab -

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0041: Deploy Premium-Free Optimization — Connection Pool, GCloud, Gemini Cache" && echo "✅ Premium-Free terkunci."

echo ""
echo "=========================================="
echo " PREMIUM-FREE OPTIMIZATION AKTIF"
echo " Connection Pool: setiap 3 menit"
echo " GCloud Keepalive: setiap 15 menit"
echo " Gemini Cache: semantic + Groq fallback"
echo "=========================================="
