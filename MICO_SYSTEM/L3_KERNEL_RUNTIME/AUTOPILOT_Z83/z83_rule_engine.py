import os, psutil, subprocess
from datetime import datetime

# [ATURAN / RULES]
RULES = {
    "RAM_THRESHOLD": 85.0,       # Persen
    "DISK_THRESHOLD": 90.0,      # Persen
    "SERVICES_REQUIRED": ["nats-server", "mico-jdeq-bootstrap"]
}

# [PEMICU / TRIGGERS]
def check_triggers():
    triggers_fired = []
    
    # Trigger 1: RAM Overload
    ram = psutil.virtual_memory().percent
    if ram > RULES["RAM_THRESHOLD"]:
        triggers_fired.append(f"RAM_OVERLOAD ({ram}%)")

    # Trigger 2: Service Mati
    for svc in RULES["SERVICES_REQUIRED"]:
        status = subprocess.run(["systemctl", "is-active", "--quiet", svc])
        if status.returncode != 0:
            triggers_fired.append(f"SERVICE_DOWN ({svc})")

    return triggers_fired

if __name__ == "__main__":
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Z83 Rule Engine Aktif.")
    triggers = check_triggers()
    if triggers:
        print(f"[TRIGGER FIRED] {triggers}")
        # Tulis ke file trigger untuk ditangkap oleh Autopilot Service
        with open(os.path.expanduser("~/mico/01_INBOX/trigger.heal"), "w") as f:
            f.write(",".join(triggers))
    else:
        print("[STATUS] Z83 Normal. Tidak ada trigger.")
