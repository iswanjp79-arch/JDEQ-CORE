import os, time, logging, subprocess

# Setup Logging
logging.basicConfig(filename='~/mico/autopilot.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

TRIGGER_FILE = os.path.expanduser("~/mico/01_INBOX/trigger.heal")

def check_system():
    # Contoh: Cek RAM, Disk, Service
    mem = os.popen("free -m | awk 'NR==2{printf \"%.2f\", $3*100/$2 }'").read()
    if float(mem) > 85.0:
        logging.warning(f"RAM tinggi: {mem}%. Memicu self-heal.")
        trigger_heal()
    
    # Cek service NATS
    status = subprocess.run(["systemctl", "is-active", "--quiet", "nats-server"])
    if status.returncode != 0:
        logging.error("NATS mati! Restarting...")
        subprocess.run(["systemctl", "restart", "nats-server"])

def trigger_heal():
    with open(TRIGGER_FILE, "w") as f:
        f.write("HEAL_REQUESTED")

if __name__ == "__main__":
    logging.info("MICO Autopilot Z83 Aktif (Event-Driven).")
    while True:
        # Cek trigger file
        if os.path.exists(TRIGGER_FILE):
            logging.info("Trigger file terdeteksi. Menjalankan pembersihan.")
            os.remove(TRIGGER_FILE)
            subprocess.run(["sync"])
            subprocess.run(["echo", "3", ">", "/proc/sys/vm/drop_caches"]) # Butuh sudo
            
        check_system()
        time.sleep(60) # Siklus 60 detik
