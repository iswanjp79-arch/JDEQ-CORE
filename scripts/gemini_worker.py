#!/usr/bin/env python3
import os, sys, json, requests
API_KEY = os.environ.get("GEMINI_API_KEY", "")
URL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent"
def tanya(prompt):
    headers = {"Content-Type": "application/json"}
    data = {"contents": [{"parts": [{"text": prompt}]}]}
    r = requests.post(f"{URL}?key={API_KEY}", headers=headers, json=data)
    return r.json()["candidates"][0]["content"]["parts"][0]["text"] if r.status_code == 200 else json.dumps({"error": r.text})
if __name__ == "__main__":
    print(tanya(" ".join(sys.argv[1:])) if len(sys.argv) > 1 else "Usage: gemini_worker.py <prompt>")
