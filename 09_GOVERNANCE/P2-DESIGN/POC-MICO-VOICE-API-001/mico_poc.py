#!/usr/bin/env python3
"""
MICO-VOICE/API PoC-001
=====================
Minimal proof-of-concept: text input -> MICO state -> API request -> API response -> MICO state.

Boundary:
- Bukan "mengambil alih Gemini". Ini memanggil Gemini API sebagai external AI capability.
- State MICO disimpan lokal, bukan bergantung pada history GUI provider.
- API key dari environment variable. Tidak di-hardcode, tidak di-commit.

Acceptance Test (per L0):
1. User memasukkan text
2. Request tercatat di MICO state
3. Request diterima API resmi
4. Response diterima
5. Response dicatat
6. Conversation state tetap tersedia setelah proses selesai
7. Provider session internal tidak dibutuhkan untuk memulihkan state MICO
+ Restart client -> load MICO state -> continue conversation
"""

import json
import hashlib
import datetime
import os
import sys
import urllib.request
import urllib.error

STATE_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "mico_state.json")
PROVIDER = "gemini"
MODEL = "gemini-2.0-flash"
API_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent"


def utcnow():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def hash_entry(entry):
    s = json.dumps(entry, sort_keys=True, ensure_ascii=False)
    return hashlib.sha256(s.encode("utf-8")).hexdigest()


def load_state():
    if not os.path.exists(STATE_FILE):
        return {
            "conversation_id": "conv-mico-poc-001",
            "created_at": utcnow(),
            "messages": [],
            "sequence": 0,
        }
    with open(STATE_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def save_state(state):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f, indent=2, ensure_ascii=False)


def call_gemini_api(prompt, api_key):
    url = API_ENDPOINT.format(model=MODEL) + "?key=" + api_key
    body = json.dumps({
        "contents": [{"parts": [{"text": prompt}]}]
    }).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=body,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    # Extract text
    candidates = data.get("candidates", [])
    if not candidates:
        raise RuntimeError("No candidates in response: " + json.dumps(data)[:500])
    parts = candidates[0].get("content", {}).get("parts", [])
    if not parts:
        raise RuntimeError("No parts in candidate")
    return parts[0].get("text", "")


def append_entry(state, entry):
    state["sequence"] += 1
    entry["sequence"] = state["sequence"]
    entry["hash"] = hash_entry({k: v for k, v in entry.items() if k != "hash"})
    state["messages"].append(entry)


def run_once(prompt, api_key):
    state = load_state()

    # 1. Log request into MICO state
    request_entry = {
        "direction": "request",
        "timestamp": utcnow(),
        "provider": PROVIDER,
        "model": MODEL,
        "request": prompt,
        "provenance": "cli-user-input",
    }
    append_entry(state, request_entry)
    save_state(state)  # save BEFORE hitting API (crash-safe)

    # 2. Call API
    try:
        response_text = call_gemini_api(prompt, api_key)
        status = "ok"
    except urllib.error.HTTPError as e:
        response_text = f"[HTTP {e.code}] {e.read().decode('utf-8', errors='ignore')[:300]}"
        status = f"http_error_{e.code}"
    except Exception as e:
        response_text = f"[ERROR] {type(e).__name__}: {e}"
        status = "error"

    # 3. Log response into MICO state
    response_entry = {
        "direction": "response",
        "timestamp": utcnow(),
        "provider": PROVIDER,
        "model": MODEL,
        "response": response_text,
        "status": status,
        "provenance": "api-provider",
    }
    append_entry(state, response_entry)
    save_state(state)

    return status, response_text


def cmd_send(prompt):
    api_key = os.environ.get("MICO_GEMINI_API_KEY", "")
    if not api_key:
        print("[BLOCKED] MICO_GEMINI_API_KEY tidak di-set di environment.")
        print("[BLOCKED] Set dulu, contoh (PowerShell):")
        print("          $env:MICO_GEMINI_API_KEY = 'AIza...'")
        sys.exit(2)
    status, resp = run_once(prompt, api_key)
    print(f"[{status}]")
    print(resp)


def cmd_history():
    state = load_state()
    print(f"conversation_id : {state['conversation_id']}")
    print(f"created_at      : {state['created_at']}")
    print(f"sequence        : {state['sequence']}")
    print(f"messages        : {len(state['messages'])}")
    print("---")
    for m in state["messages"]:
        print(f"#{m['sequence']:03d} [{m['direction']:8s}] {m['timestamp']} hash={m['hash'][:12]}...")
        key = "request" if m["direction"] == "request" else "response"
        snippet = m.get(key, "")[:80].replace("\n", " ")
        print(f"        {snippet}")


def cmd_verify():
    state = load_state()
    bad = 0
    for m in state["messages"]:
        expected = m["hash"]
        recomputed = hash_entry({k: v for k, v in m.items() if k != "hash"})
        ok = (expected == recomputed)
        marker = "OK" if ok else "MISMATCH"
        if not ok:
            bad += 1
        print(f"#{m['sequence']:03d} [{marker}] {m['direction']}")
    print(f"---")
    print(f"Total: {len(state['messages'])} | Bad: {bad}")
    sys.exit(1 if bad else 0)


def cmd_state_dump():
    print(json.dumps(load_state(), indent=2, ensure_ascii=False))


def usage():
    print("Usage:")
    print("  python mico_poc.py send <text>     # kirim prompt, log ke state, panggil API")
    print("  python mico_poc.py history         # tampilkan riwayat MICO state")
    print("  python mico_poc.py verify          # verifikasi hash setiap entry")
    print("  python mico_poc.py dump            # dump raw JSON state")
    sys.exit(1)


def main():
    if len(sys.argv) < 2:
        usage()
    cmd = sys.argv[1]
    if cmd == "send":
        if len(sys.argv) < 3:
            print("[FAIL] butuh argumen text")
            sys.exit(1)
        prompt = " ".join(sys.argv[2:])
        cmd_send(prompt)
    elif cmd == "history":
        cmd_history()
    elif cmd == "verify":
        cmd_verify()
    elif cmd == "dump":
        cmd_state_dump()
    else:
        usage()


if __name__ == "__main__":
    main()