#!/data/data/com.termux/files/usr/bin/bash
[ -z "$1" ] && echo "❌ Gunakan: compile.sh [file]" && exit 1
bash engineering/router.sh compile "$1"
