#!/data/data/com.termux/files/usr/bin/bash
# JANTUNG SCOUT - Otomatis menyalakan layanan inti

echo "[SCOUT] Menyalakan Jantung..."

# Mulai SSH
if ! pgrep sshd > /dev/null; then
    sshd
    echo "  ✅ SSHd dinyalakan."
fi

# Mulai Cron
if ! pgrep crond > /dev/null; then
    crond
    echo "  ✅ Crond dinyalakan."
fi

# Mulai Ollama
if ! pgrep ollama > /dev/null; then
    nohup ollama serve > /dev/null 2>&1 &
    echo "  ✅ Ollama dinyalakan."
fi

echo "[SCOUT] Jantung siap."
