#!/data/data/com.termux/files/usr/bin/bash
[ -z "$1" ] && echo "❌ Gunakan: review.sh [file]" && exit 1
bash engineering/router.sh review "$1"
