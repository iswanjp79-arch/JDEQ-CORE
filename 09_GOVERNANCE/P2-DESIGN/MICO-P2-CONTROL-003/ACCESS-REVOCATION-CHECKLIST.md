# MICO-JDEQ · ACCESS REVOCATION CHECKLIST
Kode: MICO-P2-CONTROL-003
Status: APPROVED_FOR_DOCUMENT_FINALIZATION

## 1. PRINSIP
UNINSTALL != ACCESS REVOKED
ACCESS REVOCATION = kontrol utama.

## 2. CHECKLIST
[X] sudah + bukti | [ ] belum | [N/A] tidak berlaku | [UNK] tidak dapat diverifikasi

### A — TASK
- [ ] Task Card CLOSED / ABORTED
- [ ] Alasan penutupan dicatat
- [ ] Sub-task tercatat statusnya

### B — EVIDENCE (WAJIB SEBELUM C)
- [ ] Artefak kerja (path + SHA-256)
- [ ] Keputusan (ADR/DEC/WIS) direferensikan
- [ ] Evidence reference ke 08_EVIDENCE/
- [ ] Klaim tidak terverifikasi -> UNVERIFIED
- [ ] Open findings dicatat
- [ ] Closure record diisi lengkap

### C — ACCESS REVOCATION
- [ ] Session token dicabut
- [ ] Task token selesai/dicabut
- [ ] Temporary workspace dibersihkan
- [ ] Kanal komunikasi ditutup
- [ ] Akses lain dicatat & dicabut

### D — PROVIDER SESSION
- [ ] Status dicatat apa adanya (closed|open|NOT_VERIFIABLE)
- [ ] Tidak diklaim MICO memaksa logout
- [ ] Jika tidak ada kontrol: NOT_VERIFIABLE

### E — HANDOVER KONTEKS
- [ ] previous_session_id
- [ ] closure_id
- [ ] task_id
- [ ] final_state
- [ ] unverified_claims
- [ ] open_findings
- [ ] relevant_evidence_refs

### F — FAIL-SAFE
- [ ] context lost -> execution blocked
- [ ] failure of control -> deny execution
- [ ] alasan blokir dicatat

### G — L0 REVIEW
- [ ] ACC / REJECT / REOPEN
- [ ] Catatan L0
- [ ] Status akhir: CLOSED/ABORTED/REOPENED/BLOCKED

## 3. ATURAN MUTLAK
1. Bukti sebelum cabut akses (kecuali security incident)
2. Klaim tanpa bukti -> UNVERIFIED
3. Sesi provider tidak dipaksa ditutup
4. CLOSED hanya setelah acceptance criteria
5. Kegagalan penutupan -> sesi berikutnya diblokir
6. CONTEXT LOST -> AUTHORITY LOST -> EXECUTION BLOCKED

## 4. STATUS
DOCUMENT_STATUS      = APPROVED_FOR_DOCUMENT_FINALIZATION
RUNTIME_ACTIVATION   = NONE
ARCHITECTURE_CHANGE  = NONE
CREDENTIAL_TOUCH     = NONE
GOVERNANCE_GATE      = DOLA
FINAL_AUTHORITY      = L0
