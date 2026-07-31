#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY KANBAN-DRIVEN AUTOMATION"
echo "=========================================="

# 1. Hapus Kanban lokal yang salah
echo "[1/3] Membatalkan Kanban lokal..."
ssh iswan@z83-server.tail2a1291.ts.net "rm -rf ~/mico_jdeq/kanban && echo '✅ Kanban lokal dihapus.'"

# 2. Buat Kanban Worker yang membaca dari GitHub Projects
echo "[2/3] Membangun Kanban Worker..."
ssh iswan@z83-server.tail2a1291.ts.net "cat > ~/mico_jdeq/kanban_worker.py << 'PYEOF'
#!/usr/bin/env python3
\"\"\"
Kanban-Driven Automation Worker
Membaca status dari GitHub Projects dan mengeksekusi tugas secara otomatis.
\"\"\"
import subprocess, json, time, os

REPO = 'iswanjp79-arch/JDEQ-CORE'
INTERVAL = 300  # 5 menit

def cek_kanban():
    \"\"\"Cek status Kanban via GitHub CLI.\"\"\"
    try:
        hasil = subprocess.run(
            ['gh', 'project', 'list', '--owner', 'iswanjp79-arch', '--format', 'json'],
            capture_output=True, text=True, timeout=10
        )
        if hasil.returncode == 0:
            data = json.loads(hasil.stdout)
            print(json.dumps(data, indent=2))
            return data
    except Exception as e:
        print(f'❌ Gagal membaca Kanban: {e}')
    return None

def eksekusi_tugas(item):
    \"\"\"Eksekusi tugas berdasarkan status di Kanban.\"\"\"
    status = item.get('status', '')
    judul = item.get('title', '')

    if status == 'Deploy' and 'Health Check' in judul:
        print(f'🚀 Menjalankan Health Check...')
        subprocess.run(['bash', os.path.expanduser('~/mico_jdeq/scripts/health_check.sh')])

    elif status == 'Deploy' and 'Backup' in judul:
        print(f'🚀 Menjalankan Backup...')
        subprocess.run(['tar', '-czf', f'/tmp/backup_{int(time.time())}.tar.gz', os.path.expanduser('~/mico_jdeq/')])

    else:
        print(f'📋 Tugas \"{judul}\" status \"{status}\" — menunggu.')

if __name__ == '__main__':
    print('🔍 Kanban Worker aktif. Memantau setiap 5 menit...')
    while True:
        data = cek_kanban()
        if data:
            for item in data.get('items', []):
                eksekusi_tugas(item)
        time.sleep(INTERVAL)
PYEOF
chmod +x ~/mico_jdeq/kanban_worker.py && echo '✅ Kanban Worker terpasang di Z83.'"

# 3. Daftarkan di Registry & Commit
echo "[3/3] Mendaftarkan di SSOT..."
cat >> ~/mico_jdeq/registry/ai_workers.json << 'REG'
{"kanban_worker": {"role": "kanban_driven_automation", "plane": "control_security", "status": "active", "note": "Membaca GitHub Projects via API"}}
REG

cd ~/mico_jdeq && git add -A && git commit -m "ADR-0014: Kanban-Driven Automation - Batalkan Kanban Lokal, Gunakan GitHub Projects API" && echo "✅ Kanban-Driven Automation terkunci."

echo "=========================================="
echo " KANBAN-DRIVEN AUTOMATION SIAP"
echo " Worker di Z83 akan memantau Kanban"
echo " cloud setiap 5 menit."
echo "=========================================="
