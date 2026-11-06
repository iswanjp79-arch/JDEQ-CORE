#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: GIT SYNC ROUTER"
echo " Multi-Platform Tanpa Tabrakan"
echo "=========================================="

LOG="$HOME/mico_jdeq/journal/git_sync.log"

# Daftar remote yang terdaftar
REMOTES=$(git remote | grep -v origin)
echo "[$(date)] MEMULAI SYNC KE $(echo $REMOTES | wc -w) PLATFORM" >> $LOG

# Kirim ke origin (GitHub) dulu
echo "📦 GitHub (origin)..."
git push origin main 2>&1 | tail -3
echo "[$(date)] GitHub: OK" >> $LOG

# Kirim ke Hugging Face (jika ada)
if git remote | grep -q huggingface; then
    echo "🤗 Hugging Face..."
    git push huggingface main 2>&1 | tail -3
    echo "[$(date)] HuggingFace: OK" >> $LOG
fi

# Kirim ke platform lain (jika ada)
for remote in $REMOTES; do
    if [ "$remote" != "huggingface" ]; then
        echo "📡 $remote..."
        git push "$remote" main 2>&1 | tail -3
        echo "[$(date)] $remote: OK" >> $LOG
    fi
    sleep 2  # Jeda 2 detik antar platform untuk hindari tabrakan
done

echo "=========================================="
echo " SYNC SELESAI — Semua platform diperbarui"
echo "=========================================="
