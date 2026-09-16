import json
import os

path = "/storage/emulated/0/JDEQ/core/jdeq_master_v3.7.json"

if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as file:
        data = json.load(file)
    print("="*40)
    print(f"  {data['system']} | STATUS: {data['status']}")
    print("="*40)
    print("📌 KOMPONEN SISTEM:")
    for nama, tugas in data["components"].items():
        print(f"   • {nama.upper():<8} : {tugas}")
    print("\n🎯 TUJUAN UTAMA:")
    for tujuan in data["purpose"]:
        print(f"   - {tujuan}")
    print("\n🔒 HUKUM DASAR:")
    print(f"   • Aturan Umum : {data['rules']['aturan_umum']}")
    print(f"   • Kehendak Arsitek : {data['rules']['kehendak_arsitek']}")
    print("="*40)
    print("[✅] SISTEM JDEQ AKTIF • BERKELUARGA LENGKAP")
else:
    print("[❌] File doktrin tidak ditemukan!")
