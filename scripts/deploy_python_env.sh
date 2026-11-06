#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
LOG="$HOME/mico_jdeq/journal/pylib_deploy.log"
echo "[$(date)] MEMULAI DEPLOY 100 PUSTAKA PYTHON" | tee $LOG

# ===== LANGKAH 1: BUAT FOLDER & ISOLASI =====
echo "[1/10] Membangun Folder Environment..." | tee -a $LOG
mkdir -p ~/mico_jdeq/pylib/{core,env,logs,requirements}
python3 -m venv ~/mico_jdeq/pylib/env/jdeq_env
source ~/mico_jdeq/pylib/env/jdeq_env/bin/activate
echo "✅ Environment terisolasi di ~/mico_jdeq/pylib/env/jdeq_env" | tee -a $LOG

# ===== LANGKAH 2: IJIN STORAGE =====
echo "[2/10] Memeriksa Izin Storage..." | tee -a $LOG
termux-setup-storage 2>/dev/null || echo "⚠️ Izin storage sudah ada atau tidak diperlukan." | tee -a $LOG
echo "✅ Izin storage OK" | tee -a $LOG

# ===== LANGKAH 3: SIAPKAN NANO =====
echo "[3/10] Menyiapkan Nano Editor..." | tee -a $LOG
which nano > /dev/null || pkg install -y nano
echo "✅ Nano siap" | tee -a $LOG

# ===== LANGKAH 4-5: TULIS & SIMPAN KODE =====
echo "[4-5/10] Menulis Kode Instalasi 100 Pustaka..." | tee -a $LOG

# --- Kategori 1: Pemrosesan Data (10) ---
cat > ~/mico_jdeq/pylib/requirements/01_data_processing.txt << 'EOF'
numpy
pandas
scipy
pyarrow
pydantic
pydantic-core
marshmallow
cerberus
python-dateutil
pytz
EOF

# --- Kategori 2: AI & Machine Learning (10) ---
cat > ~/mico_jdeq/pylib/requirements/02_ai_ml.txt << 'EOF'
transformers
tokenizers
safetensors
sentence-transformers
huggingface-hub
accelerate
peft
datasets
evaluate
scikit-learn
EOF

# --- Kategori 3: Jaringan & Komunikasi (10) ---
cat > ~/mico_jdeq/pylib/requirements/03_networking.txt << 'EOF'
requests
aiohttp
httpx
websocket-client
paho-mqtt
nats-py
grpcio
protobuf
zeromq
pyzmq
EOF

# --- Kategori 4: Basis Data & Penyimpanan (10) ---
cat > ~/mico_jdeq/pylib/requirements/04_database.txt << 'EOF'
sqlalchemy
redis
psycopg2-binary
pymongo
duckdb
sqlite-utils
dataset
tinydb
chromadb
qdrant-client
EOF

# --- Kategori 5: Keamanan & Kriptografi (10) ---
cat > ~/mico_jdeq/pylib/requirements/05_security.txt << 'EOF'
cryptography
bcrypt
pyjwt
paramiko
python-jose
passlib
hashlib
hmac
pynacl
certifi
EOF

# --- Kategori 6: Visualisasi & Pemantauan (10) ---
cat > ~/mico_jdeq/pylib/requirements/06_visualization.txt << 'EOF'
matplotlib
seaborn
plotly
dash
streamlit
prometheus-client
rich
tqdm
colorama
tabulate
EOF

# --- Kategori 7: Otomatisasi & Skrip (10) ---
cat > ~/mico_jdeq/pylib/requirements/07_automation.txt << 'EOF'
click
typer
pyyaml
toml
python-dotenv
invoke
fabric
watchdog
schedule
apscheduler
EOF

# --- Kategori 8: Alur Data & Pipeline (10) ---
cat > ~/mico_jdeq/pylib/requirements/08_pipeline.txt << 'EOF'
prefect
luigi
joblib
ray
dlt
pyarrow
fastparquet
openpyxl
xlrd
csvkit
EOF

# --- Kategori 9: MQTT & IoT (10) ---
cat > ~/mico_jdeq/pylib/requirements/09_iot.txt << 'EOF'
paho-mqtt
gmqtt
aiomqtt
asyncio-mqtt
nats-py
mqttools
amqp
kombu
pika
celery
EOF

# --- Kategori 10: AI Generatif & LLM (10) ---
cat > ~/mico_jdeq/pylib/requirements/10_genai.txt << 'EOF'
openai
anthropic
langchain
langchain-community
llama-cpp-python
guidance
vllm
gguf
haystack
chromadb
EOF

# ===== GABUNG SEMUA =====
cat ~/mico_jdeq/pylib/requirements/*.txt | sort -u > ~/mico_jdeq/pylib/requirements/all_100.txt
echo "✅ 100 pustaka tercatat di all_100.txt" | tee -a $LOG

# ===== LANGKAH 6: CHMOD (kecuali log) =====
echo "[6/10] Mengatur izin file..." | tee -a $LOG
chmod +x ~/mico_jdeq/pylib/requirements/*.txt 2>/dev/null || true
echo "✅ Izin file diatur" | tee -a $LOG

# ===== LANGKAH 7: UJI TEST =====
echo "[7/10] Uji Test Instalasi..." | tee -a $LOG
TOTAL=$(wc -l < ~/mico_jdeq/pylib/requirements/all_100.txt)
echo "Total pustaka yang akan diinstal: $TOTAL" | tee -a $LOG

# ===== LANGKAH 8: VERIFIKASI =====
echo "[8/10] Verifikasi Environment..." | tee -a $LOG
python3 --version | tee -a $LOG
pip --version | tee -a $LOG
echo "✅ Environment siap" | tee -a $LOG

# ===== LANGKAH 9: LOG =====
echo "[9/10] Menyimpan Log..." | tee -a $LOG
echo "Log tersimpan di: $LOG" | tee -a $LOG

# ===== LANGKAH 10: DEPLOY =====
echo "[10/10] MEMULAI DEPLOY..." | tee -a $LOG
pip install --upgrade pip setuptools wheel 2>&1 | tee -a $LOG

PASS=0; FAIL=0
while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    echo "📦 Menginstal: $pkg" | tee -a $LOG
    if pip install "$pkg" 2>&1 | tee -a $LOG; then
        echo "  ✅ $pkg" | tee -a $LOG
        PASS=$((PASS+1))
    else
        echo "  ❌ $pkg GAGAL" | tee -a $LOG
        FAIL=$((FAIL+1))
    fi
done < ~/mico_jdeq/pylib/requirements/all_100.txt

echo "" | tee -a $LOG
echo "==========================================" | tee -a $LOG
echo " DEPLOY SELESAI: $PASS/$TOTAL LULUS" | tee -a $LOG
[ $FAIL -gt 0 ] && echo " GAGAL: $FAIL pustaka" | tee -a $LOG
echo "==========================================" | tee -a $LOG
