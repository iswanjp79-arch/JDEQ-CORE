#!/bin/bash
cd ~/mico_jdeq
while inotifywait -r -e modify,create,delete local_root/ 2>/dev/null; do
  echo "Perubahan terdeteksi → diseragamkan dengan Awan & SSOT"
  rsync -av --delete local_root/ cloud_mirror/ 2>/dev/null
  git add . 2>/dev/null
  git commit -m "TERIKAT OTOMATIS: $(date +%s)" 2>/dev/null
done
