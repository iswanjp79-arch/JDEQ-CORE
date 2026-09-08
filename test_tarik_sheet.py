import json, urllib.request

config_path = r"D:\MICO_SSOT\TREE_L\10_SECURITY\CONFIG\capture_sheet_email_config.json"
with open(config_path, "r", encoding="utf-8") as f:
    config = json.load(f)

url = config["google_apps_script_url"]
print("Mengambil data dari Google Apps Script...")
with urllib.request.urlopen(url) as resp:
    data = resp.read().decode("utf-8")

print("Berhasil. 3 baris pertama:")
lines = data.strip().splitlines()
for line in lines[:3]:
    print(line)
