#!/data/data/com.termux/files/usr/bin/bash
PROJECT="mico-sandbox-2026"
LOG="$HOME/mico_jdeq/journal/gcloud.log"

# Inisialisasi koneksi ke Cloud Shell
gcloud config set project $PROJECT 2>/dev/null
echo "[$(date)] GCloud: Project $PROJECT siap." >> $LOG

# Cold-start mitigation: kirim ping setiap 15 menit
gcloud cloud-shell ssh --authorize-session --command="echo 'keepalive'" 2>/dev/null && \
    echo "[$(date)] GCloud: Cold-start mitigated." >> $LOG || \
    echo "[$(date)] GCloud: Perlu autentikasi manual." >> $LOG
echo "✅ GCloud Gateway siap."
