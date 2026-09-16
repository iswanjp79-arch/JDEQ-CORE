# MICO-JDEQ PORTABLE TOOLS
Fungsi: skrip seragam PC-i5 (Windows) + Termux (Linux).
Prinsip: satu perintah, dua OS.

## Skrip
| Skrip Windows | Skrip Linux | Fungsi |
|---|---|---|
| mico-status.ps1 | mico-status.sh | Cek status git + vault + hooks |
| mico-verify.ps1 | mico-verify.sh | Verifikasi SHA256 key files |
| mico-backup.ps1 | mico-backup.sh | Bundle mirror manual |
| mico-install-hooks.ps1 | mico-install-hooks.sh | Pasang hooks |

## Cara Pakai — Windows (PC-i5)
pwsh -File mico-status.ps1
pwsh -File mico-verify.ps1
pwsh -File mico-backup.ps1

## Cara Pakai — Termux (Vivo Y28)
export MICO_ROOT=$HOME/MICO_SSOT
sh mico-status.sh
sh mico-verify.sh
sh mico-backup.sh

## Catatan
- Termux butuh `git`, `sha256sum` (bawaan coreutils).
- MICO_ROOT wajib di-set di Linux (default: $HOME/MICO_SSOT).
- Windows default: D:\MICO_SSOT (hardcoded untuk PC-i5).