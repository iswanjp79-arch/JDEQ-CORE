import os
import datetime

# === DOKTRIN JDEQ V.20: KERNEL LAYER SIMULATION ===
BASE_DIR = "/storage/emulated/0/JDEQ"
SUB_DIRS = ["core", "logs", "backup", "checksum", "data_trading"]

class JDEQ_Injeksi:
    def __init__(self):
        self.owner = "ARSITEK ISWAN"
        self.device = "VIVO_Y28"
        self.log_file = f"{BASE_DIR}/logs/kernel_v20.log"

    def build_environment(self):
        """Otomatis nggawe struktur yen ora ana (Anti-Error)"""
        print(f"--- INITIALIZING JDEQ KERNEL FOR {self.owner} ---")
        if not os.path.exists(BASE_DIR):
            return "[❌] ERROR: IJIN STORAGE DURUNG DIAKTIFKE!"
        
        for folder in SUB_DIRS:
            path = os.path.join(BASE_DIR, folder)
            if not os.path.exists(path):
                os.makedirs(path)
                print(f"[✅] LAYER CREATED: {folder}")
        return True

    def write_log(self, msg):
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(self.log_file, "a") as f:
            f.write(f"[{now}] {msg}\n")

    def deploy(self):
        status = self.build_environment()
        if status is True:
            self.write_log("SYSTEM_READY: Kernel Layer Locked")
            print("=============================================")
            print("🛡️  SISTEM TERKUNCI: READY FOR DEPLOYMENT  🛡️")
            print(f"DEVICE  : {self.device}")
            print(f"OWNER   : {self.owner}")
            print("=============================================")
        else:
            print(status)

if __name__ == "__main__":
    app = JDEQ_Injeksi()
    app.deploy()
