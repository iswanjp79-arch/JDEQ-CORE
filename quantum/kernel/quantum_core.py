import hashlib, json, time
from pathlib import Path
SSOT_HASH = Path.home()/"mico_jdeq"/"SSOT_MASTER.lock"
def get_truth():
    return SSOT_HASH.read_text().strip() if SSOT_HASH.exists() else "default_truth"
def ikat_semua():
    induk = hashlib.sha256(get_truth().encode()).hexdigest()
    for lokasi in Path.home().glob("mico_jdeq/**/.bond"):
        lokasi.write_text(induk)
    return induk
while True:
    kunci = ikat_semua()
    print(f"🔗 TERIKAT: {kunci[:16]}...")
    time.sleep(1)
