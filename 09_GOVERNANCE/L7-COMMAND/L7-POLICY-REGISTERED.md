# L7 POLICY — REGISTERED (NON-RUNTIME)
Kode      : MICO-L7-POLICY-001
Tanggal   : 2026-09-14
Otoritas  : L0 — Iswan Juman Pancoro, ST
Status    : POLICY_REGISTERED
Runtime   : NOT_ACTIVE
Target    : L7 Command Unification

## RUANG LINGKUP
Dokumen ini mendaftarkan Task Card L7 sebagai KEBIJAKAN RESMI.
Runtime gateway, anti-replay mechanism, dan scheduler belum diimplementasikan.

## YANG DIDAFTARKAN SEBAGAI KEBIJAKAN
1. 20 butir ketetapan L7 (lihat PROMPT-AG001-L7-COMMAND-UNIFICATION.md)
2. 3 aturan pengaman (kebijakan, belum runtime):
   - command_replay: DITOLAK
   - command_duplikasi: DITOLAK (window 1 jam)
   - stale_execution: 15 menit expiry
3. Jalur penyimpanan:
   - Laporan: 09_GOVERNANCE\L7-COMMAND\
   - Bukti: 08_EVIDENCE\L7-OPERATIONAL\
   - Audit: 09_GOVERNANCE\L7-COMMAND\AUDIT\
4. Batasan mutlak:
   - Vivo Y28 = command terminal only
   - PC-i5 = compute/verify/store
   - L4/L5 = NO MUTATION
   - SSOT = WRITE VIA GOVERNANCE PATH ONLY
   - Final authority = L0

## YANG BELUM DIBERLAKUKAN (butuh Task Card deployment terpisah)
- Runtime command gateway
- Anti-replay mechanism (kode)
- Authentication chain (Vivo → gateway)
- Audit log otomatis per perintah
- Ringkasan harian ke Vivo
- Scheduler

## OPEN ITEMS (WAJIB TETAP OPEN)
1. command replay
2. command duplication
3. stale command execution
Ketiga item belum ditutup sampai ada implementasi + evidence.

## STATUS
POLICY_REGISTERED — AWAITING L0 CLARIFICATION FOR DEPLOYMENT