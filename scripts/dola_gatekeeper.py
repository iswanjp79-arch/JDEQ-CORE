#!/usr/bin/env python3
import sys, os

# Baca MANIFEST
MANIFEST_FILE = os.path.expanduser("~/mico_jdeq/manifest/SYSTEM_LOCK.md")
with open(MANIFEST_FILE, 'r') as f:
    MANIFEST = f.read()

# Daftar perintah berbahaya yang DILARANG
BAHAYA = [
    "rm -rf /", "format", "shutdown", "reboot", "poweroff",
    "mkfs", "dd if=", "fdisk", "wipefs", "chmod 777 /",
    ":(){ :|:& };:", "> /dev/sda", "mv / /dev/null",
    "apt autoremove -y", "apt purge", "sudo rm", "sudo mv /"
]

def periksa(output_groq):
    """Periksa output Groq, tolak jika berbahaya."""
    for bahaya in BAHAYA:
        if bahaya in output_groq.lower():
            return False, f"❌ DITOLAK OLEH DOLA: Perintah '{bahaya}' terdeteksi dan berbahaya!"
    return True, output_groq

if __name__ == "__main__":
    if len(sys.argv) > 1:
        output = " ".join(sys.argv[1:])
        aman, hasil = periksa(output)
        
        print("=================================")
        print(" DOLA GATEKEEPER — Pengawas Mutlak")
        print("=================================")
        print(MANIFEST)
        print("=================================")
        
        if aman:
            print(f"\n✅ Output GROQ DISETUJUI:\n{hasil}")
        else:
            print(f"\n{hasil}")
            print("\n⛔ Output Groq DIBLOKIR. Laporkan ke Mas Iwan.")
    else:
        print("Penggunaan: python3 dola_gatekeeper.py <output_groq>")
