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
