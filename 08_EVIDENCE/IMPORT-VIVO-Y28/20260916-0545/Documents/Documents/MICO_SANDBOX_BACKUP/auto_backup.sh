#!/data/data/com.termux/files/usr/bin/bash
while true; do
  cd ~/JDEQ_SINGULARITY && git add . && git commit -m "Auto Backup $(date)"
  sleep 3600
done
