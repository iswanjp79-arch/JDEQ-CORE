# MICO-JDEQ · SESSION SAFETY GATE
Kode   : P2-CONTROL-002
Status : APPROVED_FOR_PLANNING
Runtime: NOT_STARTED

## 1. Model Ancaman
Runtime connection -> New/Unknown session -> No verified context ->
Agent masih punya execution path -> Out-of-bound action.

## 2. Solusi
Runtime connection -> New/Unknown session -> Session Safety Gate ->
No verified context -> EXECUTION = BLOCKED.
Yang dilindungi: execution path, bukan memory provider.

## 3. Session Identity
MICO membuat identifier sendiri:
MICO_SESSION_ID, MICO_TASK_ID, MICO_AGENT_ID,
MICO_CONTEXT_VERSION, MICO_AUTHORIZATION_STATE.
Session provider boleh berubah. MICO Session State tetap.

## 4. Local Watchdog (rencana)
LOCAL WATCHDOG -> CHECK MICO SESSION STATE ->
KNOWN/VERIFIED ? YES -> ALLOW. NO -> BLOCK + REQUIRE ZHH.

## 5. Session Handshake Token
SESSION_ID, AGENT_ID, TASK_ID, CONTEXT_VERSION,
AUTHORITY, EXPIRY, NONCE, INTEGRITY_REFERENCE.
Status awal: UNTRUSTED. Setelah handshake valid: TRUSTED_FOR_TASK.

## 6. Execution State Machine
UNKNOWN -> UNTRUSTED -> HANDSHAKE_PENDING -> VERIFIED ->
AUTHORIZED -> EXECUTING -> VERIFYING -> CLOSED.
Session restart: EXECUTING -> CONTEXT LOST -> UNTRUSTED.
Dilarang: UNTRUSTED -> EXECUTING.

## 7. Kill-Switch
Berbasis policy violation yang dapat dibuktikan.
Bukan keylogger. Bukan content sniffing.
Boundary: hanya putus execution channel. Tidak seluruh sistem.

## 8. Fail-Safe
WATCHDOG UNKNOWN -> EXECUTION = BLOCK.
Failure of control = deny execution.

## 9. KAM Integration
IDENTITY -> CONTEXT -> AUTHORITY -> KNOWLEDGE BOUNDARY ->
ACCESS BOUNDARY -> SESSION GATE -> TASK -> EXECUTION.
Credential tetap: Z83. AG-003 tidak pegang secret.

## 10. Keputusan Kunci
- Session Handshake: WAJIB
- New/Unknown Session: UNTRUSTED
- Execution Authority: tidak boleh diwariskan otomatis
- MICO Session State: dikendalikan MICO
- Provider Session State: bukan SSOT MICO
- Auto-ZHH: session validation lokal, bukan manipulasi provider
- Kill-switch: hanya pada controlled execution channel
- Keylogger/content sniffing: DILARANG
- Provider session internal control: OUT OF SCOPE

## 11. Acceptance
TEST 01 New session tanpa handshake -> BLOCKED
TEST 02 Handshake valid -> TASK ALLOWED
TEST 03 Session restart -> authorization invalidated
TEST 04 New session -> tidak inherit authority
TEST 05 Unauthorized command -> BLOCK + RECORD
TEST 06 Watchdog failure -> BLOCKED
TEST 07 MICO state survive provider change -> recoverable
TEST 08 Credential store tidak terekspos ke AG-003 -> PASS

## 12. Status
DECISION_STATUS = APPROVED_FOR_PLANNING
IMPLEMENTATION = NOT_STARTED
RUNTIME_ACTIVATION = NONE
ARCHITECTURE_CHANGE = NONE
GOVERNANCE_GATE = DOLA
FINAL_AUTHORITY = L0
