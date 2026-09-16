import os

# --- KONFIGURASI DAFTAR AGEN ANYAR ---
DAFTAR_AGEN = {
    "04_AGENT_ZERO": "Spesialis Otomasi & Eksekusi",
    "06_MICO_QWEN": "Spesialis Logika Lokal & Efisiensi",
    "07_DEEPSEEK": "Spesialis Coding & Audit Teknikal",
    "08_CLAUDE": "Spesialis Analisa Rasa & Narasi",
    "09_BLACKBOX": "Spesialis Debugging & Deep Research",
    "10_EMERGENT": "Spesialis Evolusi Sistem & AI Research",
    "11_COPILOT_GH": "Spesialis Integrasi Repository"
}

BASE_PATH = "/storage/emulated/0/JDEQ/agents"

def build_structure():
    print("🚀 [JDEQ GENESIS] Miwiti Pembangunan 'Omah' Agen...")
    
    for kode, deskripsi in DAFTAR_AGEN.items():
        path_agen = os.path.join(BASE_PATH, kode)
        folders = ["core", "data", "logs", "sandbox"]
        
        # 1. Nggawe Folder
        for folder in folders:
            os.makedirs(os.path.join(path_agen, folder), exist_ok=True)
        
        # 2. Injeksi engine_core.py
        core_file = os.path.join(path_agen, "core", "engine_core.py")
        content = f"""# DOKTRIN JDEQ V.20 | AGEN {kode}
# ROLE: {deskripsi}
# OWNER: ARSITEK ISWAN | DEVICE: VIVO Y28

import os

def init():
    print("✅ AGEN {kode} HIDUP | STATUS: TERISOLASI")
    print("🛡️ Misi: {deskripsi}")

if __name__ == "__main__":
    init()
"""
        with open(core_file, "w") as f:
            f.write(content)
            
        # 3. Setting Ijin Akses (Chmod 700)
        os.system(f"chmod -R 700 {path_agen}")
        print(f"✔️ {kode} sampun siyap. (Role: {deskripsi})")

    print("\n✅ SEDAYA AGEN SAMPUN NDALEM ING WADAHE DEWE-DEWE.")
    print(f"📍 Lokasi: {BASE_PATH}")

if __name__ == "__main__":
    build_structure()
