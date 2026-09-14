# P2-1 — ROTATION RUNNER DESIGN (Pseudocode)

## Prinsip
- Satu berkas runner
- Idempotent: dipanggil berapa kali pun hasil sama
- Tanpa rekursi
- Depth-limited enumeration
- Whitelist pola: runtime_audit*.jsonl

## Pseudocode

FUNCTION rotate_once():
  lock = acquire_file_lock(STATE_DIR + "/.rotation.lock")
  IF lock.failed: RETURN BLOCKED_LOCKED

  IF cb_rotation.is_open(): RETURN BLOCKED_CB

  f = STATE_DIR + "/runtime_audit.jsonl"
  IF NOT exists(f): RELEASE; RETURN NOOP_MISSING

  size = file_size(f)
  age  = now() - last_rotation_time
  IF size < 50MB AND age < 24h: RELEASE; RETURN NOOP_NOT_DUE

  flush_and_close(f)
  archive_name = "runtime_audit." + format_ts(now()) + ".jsonl"
  target = STATE_DIR + "/" + archive_name

  TRY:
    atomic_rename(f, target)
  CATCH:
    cb_rotation.record_failure()
    RELEASE; RETURN BLOCKED_RENAME_FAILED

  create_empty(f)
  h = sha256(target)
  append_manifest(archive_name, size, h, trigger)
  emit_single_audit_entry(ROTATION_COMPLETED, archive_name, h)
  RELEASE; RETURN OK

## Batas
- Tidak ada operasi delete
- Tidak ada operasi move di luar STATE_DIR
- Tidak ada eksekusi perintah shell
