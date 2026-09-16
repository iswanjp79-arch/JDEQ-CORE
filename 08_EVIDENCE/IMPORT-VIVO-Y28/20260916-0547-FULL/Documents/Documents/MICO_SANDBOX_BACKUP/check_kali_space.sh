#!/data/data/com.termux/files/usr/bin/bash

TARGET_SIZE_GB=15

echo "=== STORAGE CHECK KALI INSTALL ==="
echo

FREE_KB=$(df /data | awk 'NR==2 {print $4}')
FREE_GB=$((FREE_KB / 1024 / 1024))

echo "Free space available : ${FREE_GB} GB"
echo "Required safe space  : ${TARGET_SIZE_GB} GB"
echo

if [ "$FREE_GB" -ge "$TARGET_SIZE_GB" ]; then
    echo "STATUS: AMAN ✔"
else
    echo "STATUS: TIDAK CUKUP ❌"
fi
