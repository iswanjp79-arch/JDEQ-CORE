#!/data/data/com.termux/files/usr/bin/bash
# ENGINEERING ROUTER — DeepSeek ↔ Blackbox CLI
TASK="$1"
FILE="$2"
[ -z "$TASK" ] && echo "❌ Gunakan: router.sh [audit|review|debug|compile] [file]" && exit 1
[ -z "$FILE" ] && echo "❌ Masukkan file target" && exit 1
[ ! -f "$FILE" ] && echo "❌ File tidak ditemukan" && exit 1

EVDIR="$HOME/JDEQ/evidence/$TASK"
mkdir -p "$EVDIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUT="$EVDIR/${TIMESTAMP}_$(basename $FILE).json"

echo "🔧 Engineering Router — $TASK"
echo "📄 Target: $FILE"
echo "📤 Mengirim ke Blackbox CLI..."

case "$TASK" in
    audit)
        PROMPT="Audit kode berikut. Laporkan keamanan, bug, dan potensi perbaikan:\n\n$(cat $FILE)"
        ;;
    review)
        PROMPT="Review kode berikut. Berikan penilaian kualitas dan saran perbaikan:\n\n$(cat $FILE)"
        ;;
    debug)
        PROMPT="Debug kode berikut. Temukan error dan berikan solusi:\n\n$(cat $FILE)"
        ;;
    compile)
        PROMPT="Periksa apakah kode berikut bisa dikompilasi dengan aman. Laporkan dependency yang diperlukan:\n\n$(cat $FILE)"
        ;;
    *)
        echo "❌ Tugas tidak dikenal"; exit 1
        ;;
esac

# Panggil Blackbox CLI
RESULT=$(bash tools/blackbox_cli.sh "$PROMPT" 2>/dev/null)

# Simpan evidence
python3 -c "
import json, os
evidence = {
    'timestamp': '$TIMESTAMP',
    'task': '$TASK',
    'file': '$FILE',
    'model': 'blackboxai/openai/gpt-5.5',
    'prompt_preview': '''${PROMPT:0:200}''',
    'response': '''${RESULT:0:2000}''',
    'status': 'completed'
}
with open('$OUT', 'w') as f:
    json.dump(evidence, f, indent=2)
print(f'✅ Evidence tersimpan: $OUT')
"
