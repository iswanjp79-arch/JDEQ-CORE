#!/data/data/com.termux/files/usr/bin/bash

ROOTFS="$HOME/kali-arm64"

exec proot --link2symlink -0 \
-r "$ROOTFS" \
-b /dev \
-b /proc \
-b /sys \
-b /sdcard \
-w /root \
/usr/bin/env -i \
HOME=/root \
TERM=$TERM \
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
/bin/bash --login
