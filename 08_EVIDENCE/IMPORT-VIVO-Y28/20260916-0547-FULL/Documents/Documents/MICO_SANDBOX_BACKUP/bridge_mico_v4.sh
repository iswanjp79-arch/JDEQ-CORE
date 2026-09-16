#!/bin/bash
# ========================================================
# NAMA       : bridge_mico_v4.sh
# FUNGSI     : MICO ↔ Ubuntu Bridge dengan warna + suara
# AUTHOR     : Senior Software Engineer Mode
# ========================================================

# ===================== KONFIGURASI =====================
MODEL_PATH="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
LLAMA_EXEC=$(find $HOME -name "llama-cli" -type f -executable | head -n 1)
DISTRO="ubuntu"
LOGFILE="$HOME/mico_bridge.log"

# ===================== WARNA ===========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# ===================== FUNSI ===========================
run_in_ubuntu() {
    local cmd=$1
    echo -e "${CYAN}[SYSTEM] Mengeksekusi di Ubuntu:${NC} $cmd" | tee -a "$LOGFILE"
    proot-distro login $DISTRO -- /bin/bash -c "$cmd" | tee -a "$LOGFILE"
}

speak() {
    # Gunakan Termux TTS
    if command -v termux-tts-speak &>/dev/null; then
        termux-tts-speak "$1"
    fi
}

# ===================== SYSTEM PROMPT ===================
SYSTEM_PROMPT="Anda adalah MICO, AI berdaulat tinggi.
Anda memiliki akses ke Ubuntu/Kali Linux. 
Jika perlu menjalankan perintah teknis (Nmap, SQLMap, dll.), tuliskan dalam format:
EXEC_START[perintah]EXEC_END."

# ===================== HEADER ==========================
echo -e "${BLUE}==============================================${NC}"
echo -e "${MAGENTA}   MICO ↔ UBUNTU BRIDGE v4.0 ACTIVE${NC}"
echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}Binary  : $LLAMA_EXEC${NC}"
echo -e "${GREEN}Model   : $MODEL_PATH${NC}"
echo -e "${GREEN}Logfile : $LOGFILE${NC}"
echo -e "${YELLOW}Ketik 'exit' untuk keluar.${NC}\n"

# ===================== LOOP INTERAKSI ==================
while true; do
    echo -ne "${GREEN}Input> ${NC}"
    read USER_INPUT
    [[ "$USER_INPUT" == "exit" ]] && break

    # Jalankan MICO dan tangkap output
    RESPONSE=$("$LLAMA_EXEC" -m "$MODEL_PATH" -p "$SYSTEM_PROMPT\nUser: $USER_INPUT\nMICO:" -n 256 --color)
    
    echo -e "${YELLOW}[MICO]:${NC}"
    echo "$RESPONSE" | tee -a "$LOGFILE"
    speak "$RESPONSE"

    # ===================== LOGIKA BRIDGE ==================
    while [[ "$RESPONSE" =~ EXEC_START\[(.*)\]EXEC_END ]]; do
        CMD="${BASH_REMATCH[1]}"
        run_in_ubuntu "$CMD"
        # Hapus blok agar tidak infinite loop
        RESPONSE="${RESPONSE/EXEC_START\[$CMD\]EXEC_END/}"
    done
done

echo -e "${BLUE}=== Bridge MICO Terminated ===${NC}"
