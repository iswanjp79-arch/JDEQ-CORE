#!/usr/bin/env python3
import os, sys, json, requests

API_KEY = os.environ.get("GROQ_API_KEY", "")
URL = "https://api.groq.com/openai/v1/chat/completions"
MODEL = "llama-3.3-70b-versatile"

SYSTEM_PROMPT = """Kamu adalah asisten AI dalam ekosistem MICO-JDEQ Awareness Digital.
MICO-JDEQ adalah sistem orkestrasi agen AI dan komputasi terdistribusi yang dibangun oleh Iswan Juman Pancoro, ST.
Terdiri dari 5 Planes: Compute, Data, Connectivity, Control & Security, Intelligence.
10 Modul: dari Core Identity sampai Digital Awareness Core.
Node: Scout (Vivo Y28), Radar (Z83), Penjaga (Infinix).
Jawablah dengan konteks MICO-JDEQ."""

def ask(prompt):
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
    print(ask(" ".join(sys.argv[1:])) if len(sys.argv) > 1 else "Usage: python3 groq_worker.py <pertanyaan>")
