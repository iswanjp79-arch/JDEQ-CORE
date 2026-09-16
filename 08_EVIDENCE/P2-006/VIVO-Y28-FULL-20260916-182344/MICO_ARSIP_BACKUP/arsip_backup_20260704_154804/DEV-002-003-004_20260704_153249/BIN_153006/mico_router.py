#!/usr/bin/env python3
import sys, os, subprocess, json
from pathlib import Path

HOME = Path.home()
MODEL_PATH = HOME / "JDEQ/models/qwen2.5-0.5b-instruct-q2_k.gguf"
LLAMA_CLI = "/data/data/com.termux/files/usr/bin/llama-cli"
KEYRING_DIR = HOME / "JDEQ/CORE_MEMORY/KEYRING"

def load_gemini_key():
    for f in KEYRING_DIR.iterdir():
        if not f.is_file() or f.name.startswith("."):
            continue
        try:
            with open(f, "r", errors="ignore") as fh:
                for line in fh:
                    if "AIza" in line:
                        for bagian in line.split():
                            if bagian.startswith("AIza"):
                                return bagian.strip("\"'")
        except PermissionError:
            continue
    return None

def run_local(prompt):
    cmd = [LLAMA_CLI, "-m", str(MODEL_PATH), "-p", prompt, "-n", "128", "--no-display-prompt"]
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=60).stdout.strip()
    except Exception:
        return None

def run_gemini(prompt, key):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={key}"
    try:
        out = subprocess.run(
            ["curl", "-s", "-X", "POST", url,
             "-H", "Content-Type: application/json",
             "-d", json.dumps({"contents":[{"parts":[{"text":prompt}]}]),
             "--connect-timeout","10"],
            capture_output=True, text=True, timeout=15
        )
        if out.returncode == 0:
            j = json.loads(out.stdout)
            return j["candidates"][0]["content"]["parts"][0]["text"]
    except Exception:
        return None

if __name__ == "__main__":
    if len(sys.argv)<2:
        print("[MICO] Gunakan: mico_gateway.sh <pertanyaan>"); sys.exit(1)
    prompt = " ".join(sys.argv[1:])
    try:
        subprocess.run(["ping","-c","1","google.com"], capture_output=True, timeout=2, check=True)
        online=True
    except Exception:
        online=False

    resp=None; sumber=""
    if online:
        k=load_gemini_key()
        if k:
            resp=run_gemini(prompt,k); sumber="Gemini‑Awan"
    if not resp and MODEL_PATH.exists():
        resp=run_local(prompt); sumber="Qwen‑Lokal"

    if resp:
        print(f"[MICO via {sumber}] {resp}")
    else:
        print("[MICO] Tidak dapat memproses saat ini.")
