#!/usr/bin/env python3
"""Gemini Semantic Cache + Groq Fallback"""
import os, json, hashlib, time, requests

CACHE_DIR = os.path.expanduser("~/mico_jdeq/cache/gemini")
os.makedirs(CACHE_DIR, exist_ok=True)
GEMINI_KEY = os.environ.get("GEMINI_API_KEY", "")
GROQ_KEY = os.environ.get("GROQ_API_KEY", "")

def get_cache_key(prompt):
    return hashlib.sha256(prompt.encode()).hexdigest()[:16]

def query_gemini(prompt):
    cache_key = get_cache_key(prompt)
    cache_file = os.path.join(CACHE_DIR, cache_key + ".json")
    
    # Cek cache dulu
    if os.path.exists(cache_file):
        with open(cache_file) as f:
            cached = json.load(f)
        if time.time() - cached["ts"] < 3600:
            return cached["response"] + " [CACHE]"
    
    # Panggil Gemini
    url = f"https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key={GEMINI_KEY}"
    data = {"contents": [{"parts": [{"text": prompt}]}]}
    
    try:
        r = requests.post(url, json=data, timeout=10)
        if r.status_code == 200:
            response = r.json()["candidates"][0]["content"]["parts"][0]["text"]
            with open(cache_file, "w") as f:
                json.dump({"ts": time.time(), "response": response}, f)
            return response
        else:
            return fallback_groq(prompt)
    except:
        return fallback_groq(prompt)

def fallback_groq(prompt):
    """Jika Gemini throttled, gunakan Groq."""
    import subprocess
    result = subprocess.run(["python3", os.path.expanduser("~/mico_jdeq/scripts/groq_controller_v3.py"), prompt], 
                          capture_output=True, text=True, timeout=15)
    return result.stdout.strip() + " [FALLBACK-GROQ]"

if __name__ == "__main__":
    import sys
    prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Apa itu MICO-JDEQ?"
    print(query_gemini(prompt))
