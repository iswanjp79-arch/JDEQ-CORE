import os, time, requests, json, logging

# Konfigurasi Node (Tailscale IPs)
NODES = {
    "PC_i5": "100.124.50.70",
    "Z83": "100.67.36.31",
    "HP_Mini": "100.92.105.35",
    "Colab_Cloud": "100.68.220.49" # IP Colab Worker Anda
}

logging.basicConfig(level=logging.INFO, format='%(asctime)s [SWARM] %(message)s')

def check_node_health(ip, port=11434):
    try:
        requests.get(f"http://{ip}:{port}/api/tags", timeout=2)
        return True
    except:
        return False

def route_task(prompt):
    # [CLOUD_SHIFTER] Cek koneksi internet & Colab
    if check_node_health(NODES["Colab_Cloud"]):
        logging.info("State: ONLINE. Mengalihkan beban berat ke Colab Cloud (GPU).")
        target_ip = NODES["Colab_Cloud"]
    else:
        # [MICO_JDEQ_CLUSTER] Failover lokal
        logging.info("State: OFFLINE/LOCAL. Menggunakan Swarm Lokal.")
        if check_node_health(NODES["PC_i5"]):
            target_ip = NODES["PC_i5"]
        elif check_node_health(NODES["Z83"]):
            target_ip = NODES["Z83"]
        else:
            logging.error("Semua node mati!")
            return None

    # Eksekusi ke target
    try:
        res = requests.post(f"http://{target_ip}:11434/api/generate", json={
            "model": "qwen2.5:7b", "prompt": prompt, "stream": False
        }, timeout=120)
        return res.json().get("response")
    except Exception as e:
        logging.error(f"Routing Gagal: {e}")
        return None

if __name__ == "__main__":
    logging.info("Swarm Router Aktif. Menunggu perintah...")
    # Simulasi trigger
    hasil = route_task("Sebutkan satu kalimat afirmasi kedaulatan data.")
    print(f"Hasil: {hasil}")
