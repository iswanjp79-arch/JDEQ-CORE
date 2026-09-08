import csv, json, os, smtplib, urllib.request, datetime, hashlib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

CONFIG_PATH = r"D:\MICO_SSOT\TREE_L\10_SECURITY\CONFIG\capture_sheet_email_config.json"
CSV_PATH = r"D:\MICO_SSOT\TREE_L\02_DATA\RAW\google_sheet_capture.csv"
LOG_PATH = r"D:\MICO_SSOT\TREE_L\08_EVIDENCE\RUNTIME\capture_sheet_email.log"

def baca_config():
    print("[1/5] Membaca file konfigurasi...")
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

def ambil_data_sheet(url):
    print("[2/5] Mengambil data dari Google Apps Script...")
    with urllib.request.urlopen(url, timeout=15) as resp:
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

def kirim_email(smtp_server, smtp_port, username, password, recipient, subject, body):
    msg = MIMEMultipart()
    msg["From"] = username
    msg["To"] = recipient
    msg["Subject"] = subject
    msg.attach(MIMEText(body, "plain"))
    print("[3/5] Mengirim email via SSL (port 465)...")
    server = smtplib.SMTP_SSL(smtp_server, 465, timeout=15)
    server.login(username, password)
    server.sendmail(username, recipient, msg.as_string())
    server.quit()

def tulis_log(pesan):
    os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(f"[{datetime.datetime.now():%Y-%m-%d %H:%M:%S}] {pesan}\n")

def hitung_sha256(file_path):
    print("[4/5] Menghitung SHA256...")
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

    ids_lokal = {row.get("id") for row in rows_lokal if row.get("id")}
    rows_baru_sebenarnya = [r for r in rows_baru if r.get("id") not in ids_lokal]

    if not rows_baru_sebenarnya:
        tulis_log("Tidak ada baris baru")
        return

    tulis_csv_lokal(semua_rows, fieldnames)

    for row in rows_baru_sebenarnya:
        subject = f"MICO-JDEQ: Baris baru ({row.get('id','tanpa_id')})"
        body = json.dumps(row, indent=2)
        try:
            kirim_email(
                config["smtp_server"], config["smtp_port"],
                config["smtp_username"], config["smtp_password"],
                config["recipient_email"], subject, body
            )
            tulis_log(f"Email {row.get('id','tanpa_id')} berhasil")
        except Exception as e:
            tulis_log(f"Email {row.get('id','tanpa_id')} gagal: {e}")

    hash_csv = hitung_sha256(CSV_PATH)
    tulis_log(f"CSV diperbarui. SHA256: {hash_csv}")
    print("[5/5] Selesai. Skrip berjalan tanpa hang.")

if __name__ == "__main__":
    main()
