import os, json

# === JANGKAR VIVO Y28 (Isolasi Kernel) ===
BASE_PATH = "/storage/emulated/0/JDEQ/agents"

def build_environment(agent_name):
    # Desain Layer & Index Otomatis
    agent_dir = os.path.join(BASE_PATH, agent_name)
    layers = ["core", "data", "logs", "sandbox"]
    
    print(f"🏗️  MEMBANGUN WADAH ISOLASI: {agent_name}")
    
    try:
        if not os.path.exists(agent_dir):
            for layer in layers:
                os.makedirs(os.path.join(agent_dir, layer), exist_ok=True)
            
            # Tanam Doktrin Dasar ing jero wadah
            config = {
                "agent_id": agent_name,
                "device": "VIVO_Y28",
                "status": "ISOLATED"
            }
            with open(os.path.join(agent_dir, "core/config.json"), "w") as f:
                json.dump(config, f)
                
            print(f"[✅] WADAH {agent_name} BERHASIL DITANAM.")
        else:
            print(f"[⚠️] WADAH {agent_name} SAMPUN WONTEN.")
    except Exception as e:
        print(f"[❌] GAGAL: {e}")

if __name__ == "__main__":
    # Mas Iwan cukup ganti jeneng agen ing kene kagem 12 agen
    target = "01_DOLA"
    build_environment(target)
