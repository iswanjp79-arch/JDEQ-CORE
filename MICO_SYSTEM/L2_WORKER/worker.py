import time
import random
from datetime import datetime
import os

def run_daily_task():
    print(f"[{datetime.now().isoformat()}] Memulai Worker Headless...")
    
    # Simulasi Tugas Harian (Check-in, Baca, Survei)
    tasks = ["Daily Check-in", "Membaca Novel/Drama", "Mengisi Survei"]
    for task in tasks:
        print(f"   [-] Menjalankan: {task}...")
        time.sleep(1) # Simulasi kerja
        print(f"   [+] Sukses: {task}")
        
    # Simulasi Screenshot (Membuat file dummy PNG)
    screenshot_path = "MICO_SYSTEM/08_EVIDENCE/proof_screenshot.png"
    with open(screenshot_path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR") # Header PNG dummy
    
    print(f"[{datetime.now().isoformat()}] Worker Selesai.")
    print(f"Bukti visual disimpan di: {screenshot_path}")

if __name__ == "__main__":
    run_daily_task()
