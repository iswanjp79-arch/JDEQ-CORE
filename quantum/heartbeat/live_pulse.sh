#!/data/data/com.termux/files/usr/bin/bash
while true; do
  echo "$(date +%s) | HIDUP | TERIKAT | SESUAI DOKTRIN" >> ~/mico_jdeq/state/life.log
  curl -s --unix-socket ~/mico_jdeq/sockets/core.sock PING >/dev/null 2>&1
  sleep 3
done
