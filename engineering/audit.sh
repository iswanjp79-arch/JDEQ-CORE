#!/data/data/com.termux/files/usr/bin/bash
[ -z "$1" ] && echo "❌ Gunakan: audit.sh [file]" && exit 1
bash engineering/router.sh audit "$1"
