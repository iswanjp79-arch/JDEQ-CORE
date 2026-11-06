#!/data/data/com.termux/files/usr/bin/bash
# MATT — hanya mengirim notifikasi saat diminta (on-demand)
bash ~/mico_jdeq/scripts/send_alert.sh "📋 MATT: $1"
echo "[$(date)] MATT: $1" >> ~/mico_jdeq/journal/matt.log
