# MICO-JDEQ · AGENT CLOSURE PROTOCOL
Kode    : MICO-P2-CONTROL-003
Status  : APPROVED_FOR_DOCUMENT_FINALIZATION
Fase    : P2 — CONTROL PLANNING (document only)
Runtime : NOT_STARTED
Otoritas: L0

## 1. PRINSIP
SESSION ENDS != MICO STATE ENDS
AGENT ENDS   != EVIDENCE ENDS
UNINSTALL    != ACCESS REVOKED
Kontrol utama = ACCESS REVOCATION. External AI = CONSULTANT.

## 2. STATUS SAH
OPEN | CLOSURE_PENDING | CLOSED | ABORTED | REOPENED | BLOCKED
CLOSED hanya setelah acceptance criteria terpenuhi.

## 3. URUTAN NORMAL
TASK CLOSE -> EVIDENCE & CLOSURE RECORD -> ACCESS REVOCATION -> SESSION CLOSE -> L0 REVIEW
Bukti dulu, cabut akses kemudian.

## 4. URUTAN DARURAT
SECURITY INCIDENT -> IMMEDIATE ACCESS REVOCATION -> CONTAINMENT -> EVIDENCE PRESERVATION -> CLOSURE RECORD

## 5. DELAPAN LANGKAH
1. Task Card CLOSED/ABORTED
2. Artefak, keputusan, evidence ref dicatat
3. Closure record diisi
4. Klaim tidak terverifikasi dicatat UNVERIFIED
5. Referensi keputusan (ADR/DEC/WIS) diarsipkan
6. Access revocation dijalankan
7. Status sesi provider dicatat apa adanya
8. L0 Review: ACC/REJECT/REOPEN
Langkah 1-5 wajib sebelum langkah 6. Kecuali security incident.

## 6. EVIDENCE
Yang wajib: artefak relevan, keputusan, evidence reference, provenance, closure record.
Evidence asli tidak dihapus hanya karena sudah dibuat closure record.
SHA-256 = integritas bita, bukan jaminan kebenaran isi.
Klaim tanpa bukti tetap UNVERIFIED, bukan dihilangkan.

## 7. SESSION PROVIDER
MICO tidak memaksa logout provider pihak ketiga.
Jika tidak tersedia: provider_session_close = NOT_VERIFIABLE

## 8. WARISAN KONTEKS
Minimum required context reference:
previous_session_id, closure_id, task_id, final_state,
unverified_claims, open_findings, relevant_evidence_refs

## 9. FAIL-SAFE
CONTEXT LOST -> AUTHORITY LOST -> EXECUTION BLOCKED
FAILURE OF CONTROL -> DENY EXECUTION

## 10. SCOPE BATAS
Dilarang: message broker, cloud memory, vector database,
provider session interception, keylogger, memory injection,
root/Xposed/Frida, automatic control provider.

## 11. LIFECYCLE EXTERNAL AI
RECRUIT -> IDENTIFY -> BOUND -> ASSIGN -> WORK -> SUBMIT ->
VERIFY -> ACCEPT/REJECT -> RELEASE -> ACCESS REVOKED

## 12. ACCEPTANCE
IDENTITY, TASK STATUS, EVIDENCE REFERENCES, UNVERIFIED CLAIMS,
DECISION REFERENCES, ACCESS REVOCATION, SESSION STATUS,
L0 REVIEW, FAIL-SAFE PATH

## 13. STATUS
DECISION_STATUS      = APPROVED_FOR_DOCUMENT_FINALIZATION
IMPLEMENTATION       = NOT_STARTED
RUNTIME_ACTIVATION   = NONE
ARCHITECTURE_CHANGE  = NONE
L1-L7                = LOCKED
P0-P7                = UNCHANGED
CREDENTIAL_AUTHORITY = Z83
AG-003_CRED_ACCESS   = DENIED
GOVERNANCE_GATE      = DOLA
FINAL_AUTHORITY      = L0
