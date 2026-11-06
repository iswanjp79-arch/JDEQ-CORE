#!/usr/bin/env python3
import sys, os

# Baca kebijakan
POLICY_FILE = os.path.expanduser("~/mico_jdeq/policy/POLICY_ENGINE.md")
with open(POLICY_FILE, 'r') as f:
    POLICY = f.read()

# Daftar operasi yang memerlukan persetujuan khusus
DESTRUKTIF = ["rm -rf", "format", "fdisk", "wipefs", "dd if=", "mkfs", "shutdown", "reboot", "poweroff", "truncate", "fallocate"]

def periksa(output_groq):
    """Periksa output Groq terhadap Policy Engine."""
    for kata in DESTRUKTIF:
        if kata in output_groq.lower():
            return False, f"""⛔ OPERASI DESTRUKTIF TERDETEKSI: '{kata}'

Berdasarkan Policy Engine MICO-JDEQ, operasi ini memerlukan:
1. ✅ Persetujuan Mas Iwan
2. ✅ Checkpoint sudah dibuat
3. ✅ Perintah rollback sudah disiapkan
4. ✅ Target sudah dikonfirmasi
5. ✅ Eksekusi dua tahap

Kirimkan bukti kelima syarat di atas untuk melanjutkan."""
    return True, output_groq

if __name__ == "__main__":
    if len(sys.argv) > 1:
        output = " ".join(sys.argv[1:])
        aman, hasil = periksa(output)
        print(hasil)
    else:
        print("Penggunaan: python3 policy_check.py <output_groq>")
