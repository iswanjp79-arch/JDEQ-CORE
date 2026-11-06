#!/data/data/com.termux/files/usr/bin/bash
[ -z "$1" ] && echo "❌ Gunakan: debug.sh [file]" && exit 1
bash engineering/router.sh debug "$1"
