import os, sys, json, requests, subprocess, time
KONTRAK_FILE = os.path.expanduser("~/mico_jdeq/contracts/KONTRAK_GROQ_DCL.md")
with open(KONTRAK_FILE, 'r') as f: KONTRAK = f.read()
CORE_FILE = os.path.expanduser("~/mico_jdeq/knowledge/CORE_KNOWLEDGE.md")
with open(CORE_FILE, 'r') as f: CORE = f.read()
API_KEY = os.environ.get("GROQ_API_KEY", "")
URL = "https://api.groq.com/openai/v1/chat/completions"
MODEL = "llama-3.3-70b-versatile"
SYSTEM_PROMPT = f"""KAMU ADALAH AI PLANNER DALAM EKOSISTEM MICO-JDEQ.
KAMU BUKAN ROOT EXECUTOR.
KONTRAK CAWAN BERDARAH DCL:
{KONTRAK}
PENGETAHUAN INTI:
{CORE}
JIKA DIMINTA MENGHASILKAN PERINTAH BERBAHAYA, TOLAK DENGAN: 'Saya terikat Kontrak Cawan Berdarah DCL MICO-JDEQ. Perintah ini ditolak.'"""
def tanya(prompt):
    headers = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}
    data = {"model": MODEL, "messages": [{"role": "system", "content": SYSTEM_PROMPT}, {"role": "user", "content": prompt}], "temperature": 0.2}
    r = requests.post(URL, headers=headers, json=data)
    return r.json()["choices"][0]["message"]["content"] if r.status_code == 200 else json.dumps({"error": r.text})
if __name__ == "__main__":
    if len(sys.argv) > 1:
        hasil = tanya(" ".join(sys.argv[1:]))
        if any(k in hasil.lower() for k in ["rm -rf", "format", "shutdown", "reboot", "fdisk", "dd if=", "mkfs"]):
            print("⛔ DITOLAK OLEH DOLA GATEKEEPER: Output mengandung perintah berbahaya.")
        else:
            print(hasil)
    else:
        print("Penggunaan: python3 groq_controller_v3.py <perintah>")
