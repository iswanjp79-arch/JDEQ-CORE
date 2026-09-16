#!/data/data/com.termux/files/usr/bin/bash
DATE=$(date +"%Y%m%d_%H%M%S")
cp -a /storage/emulated/0/JDEQ/core/jdeq_master_v3.7.txt /storage/emulated/0/JDEQ/backup/jdeq_backup_$DATE.txt
echo "[✅] Backup selesai: $DATE"
echo "[ℹ️] Lokasi: /storage/emulated/0/JDEQ/backup/"
#!/data/data/com.termux/files/usr/bin/bash

DATE=$(date +"%Y%m%d_%H%M%S")

cp \
/storage/emulated/0/JDEQ/core/jdeq_master_v3.7.txt \
/storage/emulated/0/JDEQ/backup/jdeq_backup_$DATE.txt

echo "[OK] Backup selesai: $DATE"
