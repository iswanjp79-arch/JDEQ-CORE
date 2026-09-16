#!/bin/bash
# ========================================================
# NAMA       : bridge_mico_v5.sh
# FUNGSI     : MICO ↔ Ubuntu Bridge dengan animasi ASCII
# AUTHOR     : Senior Software Engineer Mode
# ========================================================

MODEL_PATH="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
LLAMA_EXEC=$(find $HOME -name "llama-cli" -type f -executable | head -n 1)
DISTRO="ubuntu"
LOGFILE="$HOME/mico_bridge.log"

# ===================== WARNA ===========================
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; NC='\033[0m'

# ===================== FUNSI ===========================
run_in_ubuntu() {
    local cmd=$1
    echo -e "${CYAN}[SYSTEM] Mengeksekusi di Ubuntu:${NC} $cmd" | tee -a "$LOGFILE"
    proot-distro login $DISTRO -- /bin/bash -c "$cmd" | tee -a "$LOGFILE"
}

speak() {
    if command -v termux-tts-speak &>/dev/null; then
        termux-tts-speak "$1"
    fi
}

# ===================== ANIMASI LOADING =================
ascii_frames=(
"▄▄ ▄▄\n██ ██\n██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄\n██ ██ ▄█▀██ ██ ██ ██ ▄█▀██\n██ ██ ▀█▄██ ██ ██ ██ ▀████"
"▄▄ ▄▄\n██ ██\n██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄\n██ ██ ▄█▀██ ██ ██ ██ ▄█▀██\n██ ██ ▀█▄██ ██ ██ ██ ▀█▀▀█"
"▄▄ ▄▄\n██ ██\n██ ██  ▀▀█▄ ███▄███▄  ▀▀█▀\n██ ██ ▄█▀██ ██ ██ ██ ▄█▀██\n██ ██ ▀█▄██ ██ ██ ██ ▀████"
"▄▄ ▄▄\n██ ██\n██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄\n██ ██ ▄█▀██ ██ ██ ██ ▄█▀█▀\n██ ██ ▀█▄██ ██ ██ ██ ▀████"
)

show_loading() {
    echo -e "${MAGENTA}MICO sedang memuat model, sabar sebentar...${NC}"
    for i in {1..8}; do
        for frame in "${ascii_frames[@]}"; do
            clear
            echo -e "${BLUE}==============================================${NC}"
            echo -e "${MAGENTA}   MICO ↔ UBUNTU BRIDGE v5.0 ACTIVE${NC}"
            echo -e "${BLUE}==============================================${NC}"
            echo -e "${YELLOW}$frame${NC}"
            sleep 0.2
        done
    done
    clear
}

# ===================== HEADER ==========================
show_loading
echo -e "${GREEN}Binary  : $LLAMA_EXEC${NC}"
echo -e "${GREEN}Model   : $MODEL_PATH${NC}"
echo -e "${GREEN}Logfile : $LOGFILE${NC}"
echo -e "${YELLOW}Ketik 'exit' untuk keluar.${NC}\n"

# ===================== LOOP INTERAKSI ==================
SYSTEM_PROMPT="Anda adalah MICO, AI berdaulat tinggi.
Anda memiliki akses ke Ubuntu/Kali Linux. 
Jika perlu menjalankan perintah teknis (Nmap, SQLMap, dll.), tuliskan dalam format:
EXEC_START[perintah]EXEC_END."

while true; do
    echo -ne "${GREEN}Input> ${NC}"
    read USER_INPUT
    [[ "$USER_INPUT" == "exit" ]] && break

    RESPONSE=$("$LLAMA_EXEC" -m "$MODEL_PATH" -p "$SYSTEM_PROMPT\nUser: $USER_INPUT\nMICO:" -n 256 --color)
    
    echo -e "${YELLOW}[MICO]:${NC}"
    echo "$RESPONSE" | tee -a "$LOGFILE"
    speak "$RESPONSE"

    while [[ "$RESPONSE" =~ EXEC_START\[(.*)\]EXEC_END ]]; do
        CMD="${BASH_REMATCH[1]}"
        run_in_ubuntu "$CMD"
        RESPONSE="${RESPONSE/EXEC_START\[$CMD\]EXEC_END/}"
    done
done

echo -e "${BLUE}=== Bridge MICO Terminated ===${NC}"
