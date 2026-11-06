#!/data/data/com.termux/files/usr/bin/bash
# Cloud Execution Router — memilih cloud worker, kirim tugas, terima hasil
TASK="$1"
PARAMS="$2"
LOG="$HOME/mico_jdeq/journal/cloud_executor.log"
echo "[$(date)] TASK: $TASK | PARAMS: $PARAMS" >> $LOG

case "$TASK" in
    "ai_reasoning")
        # Kirim ke Groq API
        RESULT=$(python3 ~/mico_jdeq/scripts/groq_controller_v3.py "$PARAMS" 2>&1)
        ;;
    "network_scan")
        # Kirim ke GCloud Shell — nmap dari cloud
        RESULT=$(gcloud cloud-shell ssh --authorize-session --command="nmap -sT -p 22,4222,8222 z83-server.tail2a1291.ts.net" 2>&1)
        ;;
    "gemini_analyze")
        # Kirim ke Gemini API dengan semantic cache
        RESULT=$(python3 ~/mico_jdeq/modules/gemini_cache.py "$PARAMS" 2>&1)
        ;;
    "subnet_calc")
        # Kalkulasi subnet — ringan, bisa lokal
        RESULT=$(python3 -c "import ipaddress; n=ipaddress.ip_network('$PARAMS',strict=False); print(f'Network: {n.network_address}, Mask: {n.netmask}, Hosts: {n.num_addresses-2}')" 2>&1)
        ;;
    "storage_sync")
        # Sinkronisasi ke Google Drive via rclone
        RESULT=$(rclone sync ~/mico_jdeq/ gdrive:MICO_JDEQ_Backup --progress 2>&1)
        ;;
    "health_check")
        RESULT=$(bash ~/mico_jdeq/scripts/health_check_enterprise.sh 2>&1)
        ;;
    *)
        RESULT="Unknown task: $TASK"
        ;;
esac

# Kirim hasil kembali ke Telegram sebagai notifikasi ringkas
SUMMARY=$(echo "$RESULT" | head -5)
bash ~/mico_jdeq/scripts/send_alert.sh "📊 $TASK selesai: $SUMMARY" 2>/dev/null || true
echo "$RESULT"
