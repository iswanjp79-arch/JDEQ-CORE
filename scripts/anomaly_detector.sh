#!/data/data/com.termux/files/usr/bin/bash
THRESHOLD=90
RAM=$(free -m | awk '/Mem:/ {print int($3/$2*100)}')
DISK=$(df -h /data | awk 'NR==2 {print int($5)}')
[ "$RAM" -gt "$THRESHOLD" ] && bash ~/mico_jdeq/scripts/send_alert.sh "RAM kritis: ${RAM}%!"
[ "$DISK" -gt "$THRESHOLD" ] && bash ~/mico_jdeq/scripts/send_alert.sh "Disk kritis: ${DISK}%!"
echo "$(date): Anomaly check selesai. RAM=${RAM}%, DISK=${DISK}%" >> ~/mico_jdeq/journal/anomaly.log
