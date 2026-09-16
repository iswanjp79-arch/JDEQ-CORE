#!/bin/bash
echo "🚀 Mengaktifkan JDEQ Survival Mode (15 Kb/s Ready)"
# Matikan service yang butuh internet berat
nmcli networking off 2>/dev/null
# Arahkan Python ke Library Lokal saja
export PIP_NO_INDEX=true
export PIP_FIND_LINKS=/sdcard/JDEQ_MASTER_CORE/03_KAKI_STORAGE/packages
echo "✅ Sistem siap bekerja Offline."
