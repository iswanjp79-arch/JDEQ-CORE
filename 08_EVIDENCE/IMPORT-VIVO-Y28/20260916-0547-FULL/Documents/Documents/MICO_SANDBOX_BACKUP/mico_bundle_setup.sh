#!/bin/bash
# ========================================================
# NAMA       : mico_bundle_setup.sh
# FUNGSI     : Membuat MICO futuristik + auto-start Termux:Boot
# AUTHOR     : Senior Software Engineer Mode
# ========================================================

# ===================== PATH & NAMA FILE =================
BOOT_DIR="$HOME/.termux/boot"
SCRIPT_NAME="mico_cyber_ai.sh"
SCRIPT_PATH="$BOOT_DIR/$SCRIPT_NAME"
MODEL_PATH="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
LLAMA_EXEC=$(find $HOME -name "llama-cli" -type f -executable | head -n 1)
LOGFILE="$HOME/mico_bridge.log"
BACKUP_DIR="$HOME/storage/shared/MICO_Backup"

# ===================== WARNA ===========================
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; NC='\033[0m'

# ===================== FUNGSI ==========================
run_in_ubuntu() {
    local cmd=$1
    echo -e "${CYAN}[SYSTEM] Mengeksekusi di Ubuntu:${NC} $cmd" | tee -a "$LOGFILE"
    proot-distro login ubuntu -- /bin/bash -c "$cmd" | tee -a "$LOGFILE"
}

speak() {
    if command -v termux-tts-speak &>/dev/null; then
        termux-tts-speak "$1"
    fi
}

show_loading() {
    ascii_frames=("▄▀▄ ▄▀▄" "▀▄▀ ▀▄▀" "▄▀▄ ▀▄▀" "▀▄▀ ▄▀▄")
    echo -e "${MAGENTA}MICO futuristik sedang memuat model...${NC}"
    for i in {1..6}; do
        for frame in "${ascii_frames[@]}"; do
            clear
            echo -e "${BLUE}==============================================${NC}"
            echo -e "${MAGENTA}       MICO ↔ UBUNTU BRIDGE FUTURISTIK${NC}"
            echo -e "${BLUE}==============================================${NC}"
            echo -e "${YELLOW}$frame${NC}"
            sleep 0.2
        done
    done
    clear
}

create_mico_script() {
    mkdir -p "$BOOT_DIR"
    cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash
MODEL_PATH="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
LLAMA_EXEC=$(find $HOME -name "llama-cli" -type f -executable | head -n 1)
LOGFILE="$HOME/mico_bridge.log"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; NC='\033[0m'

run_in_ubuntu() {
    local cmd=$1
    echo -e "${CYAN}[SYSTEM] Mengeksekusi di Ubuntu:${NC} $cmd" | tee -a "$LOGFILE"
    proot-distro login ubuntu -- /bin/bash -c "$cmd" | tee -a "$LOGFILE"
}

speak() {
    if command -v termux-tts-speak &>/dev/null; then
        termux-tts-speak "$1"
    fi
}

show_loading() {
    ascii_frames=("▄▀▄ ▄▀▄" "▀▄▀ ▀▄▀" "▄▀▄ ▀▄▀" "▀▄▀ ▄▀▄")
    echo -e "${MAGENTA}MICO futuristik sedang memuat model...${NC}"
    for i in {1..6}; do
        for frame in "${ascii_frames[@]}"; do
            clear
            echo -e "${BLUE}==============================================${NC}"
            echo -e "${MAGENTA}       MICO ↔ UBUNTU BRIDGE FUTURISTIK${NC}"
            echo -e "${BLUE}==============================================${NC}"
            echo -e "${YELLOW}$frame${NC}"
            sleep 0.2
        done
    done
    clear
}

show_loading
echo -e "${GREEN}Binary  : $LLAMA_EXEC${NC}"
echo -e "${GREEN}Model   : $MODEL_PATH${NC}"
echo -e "${GREEN}Logfile : $LOGFILE${NC}"
echo -e "${YELLOW}Ketik 'exit' untuk keluar.${NC}\n"

SYSTEM_PROMPT="Anda adalah MICO, AI futuristik.
Anda memiliki akses ke Ubuntu/Kali Linux. 
Jika perlu menjalankan perintah teknis, tuliskan format:
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
EOF

    chmod +x "$SCRIPT_PATH"
}

backup_script() {
    mkdir -p "$BACKUP_DIR"
    cp "$SCRIPT_PATH" "$BACKUP_DIR/"
    echo -e "${CYAN}[INFO] Backup script tersimpan di: $BACKUP_DIR${NC}"
}

# ===================== EXECUTE ==========================
create_mico_script
backup_script
echo -e "${GREEN}[INFO] MICO futuristik siap auto-start di Termux:Boot${NC}"
