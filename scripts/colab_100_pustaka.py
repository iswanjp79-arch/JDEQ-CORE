# ============================================
# MICO-JDEQ: 100 PUSTAKA PYTHON - CLOUD COMPUTE
# Jalankan di Google Colab (Runtime > Run all)
# ============================================

import subprocess, sys, time

def run(cmd):
    print(f"\n>>> {cmd[:80]}...")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"✅ BERHASIL")
    else:
        print(f"❌ GAGAL: {result.stderr[:100]}")
    return result.returncode == 0

# Daftar 100 pustaka (10 kategori x 10 pustaka)
PUSTAKA = [
    # Kategori 1: Pemrosesan Data
    "numpy", "pandas", "scipy", "pyarrow", "pydantic",
    "marshmallow", "cerberus", "python-dateutil", "pytz", "openpyxl",
    
    # Kategori 2: AI & Machine Learning
    "transformers", "tokenizers", "safetensors", "huggingface-hub", "accelerate",
    "datasets", "evaluate", "scikit-learn", "sentence-transformers", "peft",
    
    # Kategori 3: Jaringan & Komunikasi
    "requests", "aiohttp", "httpx", "websocket-client", "paho-mqtt",
    "nats-py", "grpcio", "protobuf", "pyzmq", "zeromq",
    
    # Kategori 4: Basis Data
    "sqlalchemy", "redis", "psycopg2-binary", "pymongo", "duckdb",
    "sqlite-utils", "dataset", "tinydb", "chromadb", "qdrant-client",
    
    # Kategori 5: Keamanan
    "cryptography", "bcrypt", "pyjwt", "paramiko", "python-jose",
    "passlib", "pynacl", "certifi", "hashlib", "hmac",
    
    # Kategori 6: Visualisasi
    "matplotlib", "seaborn", "plotly", "dash", "streamlit",
    "prometheus-client", "rich", "tqdm", "colorama", "tabulate",
    
    # Kategori 7: Otomatisasi
    "click", "typer", "pyyaml", "toml", "python-dotenv",
    "invoke", "fabric", "watchdog", "schedule", "apscheduler",
    
    # Kategori 8: Pipeline
    "prefect", "luigi", "joblib", "ray", "dlt",
    "fastparquet", "csvkit", "xlrd", "openpyxl", "pyarrow",
    
    # Kategori 9: IoT & MQTT
    "paho-mqtt", "gmqtt", "aiomqtt", "asyncio-mqtt", "nats-py",
    "amqp", "kombu", "pika", "celery", "mqttools",
    
    # Kategori 10: AI Generatif
    "openai", "anthropic", "langchain", "langchain-community", "llama-cpp-python",
    "guidance", "vllm", "gguf", "haystack", "chromadb"
]

print("=" * 50)
print(" MICO-JDEQ: INSTALASI 100 PUSTAKA PYTHON")
print(" Target: Cloud Compute (Mark V)")
print("=" * 50)

# Update pip
run("pip install --upgrade pip setuptools wheel")

# Instal semua pustaka
PASS = 0
FAIL = 0
for i, pkg in enumerate(PUSTAKA, 1):
    print(f"\n[{i}/100] {pkg}")
    if run(f"pip install {pkg}"):
        PASS += 1
    else:
        FAIL += 1

print("\n" + "=" * 50)
print(f" HASIL: {PASS}/100 BERHASIL, {FAIL} GAGAL")
print("=" * 50)

# Simpan daftar pustaka terinstal
run("pip freeze > /content/mico_jdeq_requirements.txt")
print("\n✅ Daftar pustaka tersimpan di /content/mico_jdeq_requirements.txt")

# ============================================
# TENSORFLOW LITE - KOMPATIBEL VIVO Y28
# ============================================
print("\n[TENSORFLOW LITE] Instalasi versi ringan...")
run("pip install tensorflow==2.12.0 --extra-index-url https://termux-user-repository.github.io/pypi/ 2>/dev/null || pip install tflite-runtime 2>/dev/null || echo 'TensorFlow Lite akan diinstal manual'")
