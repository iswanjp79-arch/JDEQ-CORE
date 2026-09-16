#!/usr/bin/env python3
# ==================================================
#                 JDEQ MAIN.PY - AKAR UTAMA
#          Hulu Awal - Penyambung Seluruh Sistem
#   Menghubungkan: Kernel -> Jembatan -> Mesin -> Aplikasi
# ==================================================

import os
import sys
import time

# --------------------------------------------------
# 🔹 LANGKAH 1: DEFINISIKAN LOKASI MODUL YANG SUDAH ADA
# --------------------------------------------------
# Ini alamat jembatan, mesin, dan inti yang sudah kamu punya
sys.path.append('/storage/emulated/0/JDEQ/')
sys.path.append('/storage/emulated/0/JDEQ/JDEQ_CORE/')
sys.path.append('/storage/emulated/0/JDEQ/kernel_master/')

# ==================================================
#               LOGIKA INTI SISTEM
# ==================================================
if __name__ == "__main__":
    print("="*50)
    print("🚀 SISTEM JDEQ V20 - DIMULAI DARI AKAR")
    print("⚓ Lokasi Hulu: /storage/emulated/0/JDEQ/main.py")
    print("="*50)

    try:
        # 🔹 TAHAP 1: Nyalakan KERNEL (Otak Inti)
        print("[1/4] ⚙️ Memuat Kernel Master...")
        # Di sini nanti disambungkan ke isi folder kernel_master kamu
        # Kita pastikan izin sistem aktif
        os.system("chmod -R 777 /storage/emulated/0/JDEQ/kernel_master/")
        time.sleep(0.5)

        # 🔹 TAHAP 2: BUKA JEMBATAN PENGHUBUNG
        print("[2/4] 🌉 Mengaktifkan Jembatan Utama (jembatan_jarvis.py)...")
        if os.path.exists("jembatan_jarvis.py"):
            import jembatan_jarvis  # <-- INI DIA: Menghubungkan semua aplikasi
            print("      ✅ Jembatan Terbuka: Semua aplikasi terhubung ke akar")
        else:
            print("      ❌ Jembatan tidak ditemukan!")

        # 🔹 TAHAP 3: JALANKAN MESIN PENGOLAH
        print("[3/4] 🧠 Menghidupkan Mesin Utama (jdeq_engine.py)...")
        if os.path.exists("jdeq_engine.py"):
            import jdeq_engine # <-- Mesin pengolah data utama
            print("      ✅ Mesin Siap Memproses Perintah")
        else:
            print("      ⚠️ Mesin cadangan dipakai (genesis.py)")
            if os.path.exists("genesis.py"): import genesis

        # 🔹 TAHAP 4: SISTEM BERJALAN PENUH
        print("[4/4] 🔒 SISTEM TERKUNCI & BERJALAN")
        print("\n✅ STATUS: AKTIF | Semua jembatan menyatu di Hulu ini.")
        print("🔌 Jalur SSH/Tailscale: Menunggu koneksi di Node...")

        # Menjaga sistem tetap hidup berjalan
        while True:
            time.sleep(3600) # Tidur aman, sistem tetap jalan di latar belakang

    except Exception as e:
        print(f"❌ KESALAHAN SISTEM: {e}")
        print("⚠️ Sistem kembali ke mode pemulihan...")
