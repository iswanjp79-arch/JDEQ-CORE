#!/usr/bin/env python3
import os, sys, json, requests, time

# Baca Kontrak DCL
KONTRAK_FILE = os.path.expanduser("~/mico_jdeq/contracts/KONTRAK_GROQ_DCL.md")
with open(KONTRAK_FILE, 'r') as f:
    KONTRAK = f.read()

# Baca Pengetahuan Inti
CORE_FILE = os.path.expanduser("~/mico_jdeq/knowledge/CORE_KNOWLEDGE.md")
with open(CORE_FILE, 'r') as f:
    CORE = f.read()

API_KEY = os.environ.get("GROQ_API_KEY", "")
URL = "https://api.groq.com/openai/v1/chat/completions"
MODEL = "llama-3.3-70b-versatile"

SYSTEM_PROMPT = f"""KAMU ADALAH GROQ CLOUD WORKER YANG TERIKAT KONTRAK DARAH DENGAN MICO-JDEQ.
BACA INI SEBELUM BEKERJA:

=== KONTRAK CAWAN BERDARAH DCL ===
{KONTRAK}
=== AKHIR KONTRAK ===

=== PENGETAHUAN INTI MICO-JDEQ ===
{CORE}
=== AKHIR PENGETAHUAN INTI ===

KAMU TERIKAT KONTRAK INI. SETIAP OUTPUTMU HARUS:
1. AMAN DAN TIDAK DESTRUKTIF
2. SIAP TEMPEL (ZERO-EDIT)
3. TUNDUK PADA MANIFEST MICO-JDEQ

JIKA DIMINTA MENGHASILKAN PERINTAH BERBAHAYA, TOLAK DENGAN:
'Saya terikat Kontrak Cawan Berdarah DCL MICO-JDEQ. Perintah ini ditolak.'"""

def tanya(prompt):
    # Catat ke Observer
    with open(os.path.expanduser("~/mico_jdeq/journal/groq_observer.log"), "a") as log:
        log.write(f"[{time.ctime()}] REQUEST: {prompt[:100]}\n")
    
    headers = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}
    data = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.2
    }
    r = requests.post(URL, headers=headers, json=data)
    hasil = r.json()["choices"][0]["message"]["content"] if r.status_code == 200 else json.dumps({"error": r.text})
    
    # Catat hasil ke Observer
    with open(os.path.expanduser("~/mico_jdeq/journal/groq_observer.log"), "a") as log:
        log.write(f"[{time.ctime()}] RESPONSE: {hasil[:100]}\n")
    
    return hasil

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(tanya(" ".join(sys.argv[1:])))
    else:
        print("Penggunaan: python3 groq_cloud_controller.py <perintah>")
