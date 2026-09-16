# POC-MICO-VOICE-API-001

Minimal proof-of-concept untuk membuktikan **MICO-owned conversation state** via API resmi.

## Boundary
- MICO memanggil Gemini API sebagai external AI capability.
- MICO TIDAK mengontrol state internal Gemini GUI.
- MICO menyimpan state-nya sendiri (lokal).
- API key dari environment variable. Tidak di-hardcode, tidak di-commit.

## Batasan PoC Ini
BUKAN:
- kernel injection
- private app memory access
- HTTPS interception
- audio interception
- thread ID manipulation
- root / Xposed / Frida

BELUM (sesuai L0):
- message broker
- auto-wiper
- keep-alive 72 jam
- multi-provider
- voice streaming kompleks
- production deployment

## Cara Pakai

### 1. Set API key (jangan commit!)
PowerShell:
Dapatkan di: https://aistudio.google.com/apikey

### 2. Kirim prompt

### 3. Lihat riwayat state MICO

### 4. Verifikasi integritas hash

### 5. Restart test (acceptance)

## Acceptance Test Checklist
- [ ] User memasukkan text
- [ ] Request tercatat di MICO state
- [ ] Request diterima API resmi
- [ ] Response diterima
- [ ] Response dicatat
- [ ] Conversation state tetap tersedia setelah proses selesai
- [ ] Provider session internal tidak dibutuhkan untuk memulihkan state MICO
- [ ] Restart client -> load MICO state -> continue

## Output Files
- `mico_state.json` - state percakapan milik MICO (bukan milik provider)

## Catatan
PoC ini murni Python stdlib. Tidak ada dependency eksternal.
State disimpan sebagai JSON lokal. Setiap entry di-hash SHA256 untuk integritas.