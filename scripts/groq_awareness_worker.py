#!/usr/bin/env python3
import os, sys, json, requests

# 1. Kumpulkan seluruh "Kesadaran" MICO-JDEQ dari folder resmi
KESADARAN_DIR = os.path.expanduser("~/mico_jdeq/")
KESADARAN = ""
for root, dirs, files in os.walk(KESADARAN_DIR):
    for file in files:
        if file.endswith(".md") or file.endswith(".txt"):
            filepath = os.path.join(root, file)
            with open(filepath, 'r') as f:
                KESADARAN += f.read() + "\n"

# 2. Konfigurasi Groq
API_KEY = os.environ.get("GROQ_API_KEY", "")
URL = "https://api.groq.com/openai/v1/chat/completions"
MODEL = "llama-3.3-70b-versatile"

SYSTEM_PROMPT = f"""Kamu adalah asisten AI utama dalam ekosistem MICO-JDEQ Awareness Digital.
Berikut adalah seluruh data dan konteks yang kamu butuhkan untuk memahami MICO-JDEQ:
=== MULAI CETAK BIRU MICO-JDEQ ===
{KESADARAN[:30000]}
=== AKHIR CETAK BIRU MICO-JDEQ ===
Gunakan konteks di atas untuk menjawab semua pertanyaan dengan akurat. Jika ada yang tidak ada di konteks, katakan 'Tidak ada dalam basis pengetahuan MICO-JDEQ'.
"""

def tanya(prompt):
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
    return r.json()["choices"][0]["message"]["content"] if r.status_code == 200 else json.dumps({"error": r.text})

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(tanya(" ".join(sys.argv[1:])))
    else:
        print("Penggunaan: python3 groq_awareness_worker.py <pertanyaan>")
