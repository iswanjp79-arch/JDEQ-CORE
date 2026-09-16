#!/data/data/com.termux/files/usr/bin/bash
while true; do
  if [ $(free -m | grep Mem | awk "{print \$4}") -lt 150 ]; then
    pkill -f python || echo "Memory Protected"
  fi
  sleep 60
done
