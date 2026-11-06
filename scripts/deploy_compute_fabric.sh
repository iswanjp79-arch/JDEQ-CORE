#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY COMPUTE FABRIC"
echo " Pengganti PC i5: Colab + Kaggle"
echo "=========================================="

radar() { ssh iswan@z83-server.tail2a1291.ts.net "$@"; }

# 1. Perbaikan GitHub Copilot CLI
echo "[1/3] Memasang GitHub Copilot CLI..."
radar "sudo apt update && sudo apt install -y gh && gh auth login && gh extension install github/gh-copilot && echo '✅ Copilot CLI terpasang'"

# 2. Compute Fabric: Colab + Kaggle Worker
echo "[2/3] Membangun Compute Fabric..."
cat > ~/mico_jdeq/scripts/compute_fabric.py << 'PYEOF'
import os, sys, json, requests
COLAB_URL = os.environ.get("COLAB_WEBHOOK", "")
KAGGLE_URL = os.environ.get("KAGGLE_WEBHOOK", "")
def jalankan_di_cloud(script):
    try:
        r = requests.post(COLAB_URL, json={"script": script}, timeout=30)
        if r.status_code == 200: return r.text
    except: pass
    try:
        r = requests.post(KAGGLE_URL, json={"script": script}, timeout=30)
        if r.status_code == 200: return r.text
    except: pass
    return json.dumps({"error": "Compute Fabric tidak tersedia"})
if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(jalankan_di_cloud(" ".join(sys.argv[1:])))
    else:
        print("Usage: python3 compute_fabric.py <script>")
PYEOF
chmod +x ~/mico_jdeq/scripts/compute_fabric.py

# 3. Hugging Face S3 Storage
echo "[3/3] Menghubungkan Hugging Face S3..."
cat > ~/mico_jdeq/scripts/hf_storage.py << 'HFEOF'
import os, sys, requests
HF_TOKEN = os.environ.get("HF_TOKEN", "")
HF_USER = "iswanjp79"
def upload(file_path, repo_name):
    headers = {"Authorization": f"Bearer {HF_TOKEN}"}
    url = f"https://huggingface.co/api/datasets/{HF_USER}/{repo_name}/upload"
    with open(file_path, "rb") as f:
        r = requests.put(url, headers=headers, data=f)
    return r.json()
if __name__ == "__main__":
    print("Hugging Face Storage siap.")
HFEOF
chmod +x ~/mico_jdeq/scripts/hf_storage.py

echo "=========================================="
echo " COMPUTE FABRIC SIAP"
echo " Colab + Kaggle menggantikan PC i5"
echo "=========================================="
