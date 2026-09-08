import csv, json, os, urllib.request, datetime, hashlib

CONFIG_PATH = r"D:\MICO_SSOT\TREE_L\10_SECURITY\CONFIG\capture_sheet_email_config.json"
CSV_PATH = r"D:\MICO_SSOT\TREE_L\02_DATA\RAW\google_sheet_capture.csv"
LOG_PATH = r"D:\MICO_SSOT\TREE_L\08_EVIDENCE\RUNTIME\capture_sheet_store.log"

def baca_config():
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

def ambil_data_sheet(url):
    with urllib.request.urlopen(url) as resp:
        return resp.read().decode("utf-8")

def csv_ke_list(csv_text):
    lines = csv_text.strip().splitlines()
    if not lines:
        return []
    return list(csv.DictReader(lines))

def baca_csv_lokal():
    if not os.path.exists(CSV_PATH):
        return []
    with open(CSV_PATH, "r", newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def tulis_csv_lokal(rows, fieldnames):
    os.makedirs(os.path.dirname(CSV_PATH), exist_ok=True)
    with open(CSV_PATH, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, '') for k in fieldnames})

def tulis_log(pesan):
    os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(f"[{datetime.datetime.now():%Y-%m-%d %H:%M:%S}] {pesan}\n")

def hitung_sha256(file_path):
    h = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            h.update(chunk)
    return h.hexdigest()

def main():
    config = baca_config()
    csv_text = ambil_data_sheet(config["google_apps_script_url"])
    rows_baru = csv_ke_list(csv_text)
    if not rows_baru:
        tulis_log("Tidak ada data dari sheet")
        return

    rows_lokal = baca_csv_lokal()
    semua_rows = rows_lokal + rows_baru

    all_keys = set()
    for r in semua_rows:
        for k in r.keys():
            if k is not None:
                all_keys.add(str(k))
    fieldnames = sorted(all_keys)

    tulis_csv_lokal(semua_rows, fieldnames)
    hash_csv = hitung_sha256(CSV_PATH)
    tulis_log(f"CSV diperbarui. Jumlah baris: {len(semua_rows)}. SHA256: {hash_csv}")
    print("Selesai menyimpan CSV. Cek file di", CSV_PATH)

if __name__ == "__main__":
    main()
