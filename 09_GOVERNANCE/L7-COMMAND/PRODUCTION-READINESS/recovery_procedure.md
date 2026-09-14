# RECOVERY PROCEDURE

1. Deteksi kegagalan via audit log.
2. Klasifikasi (kode exit).
3. Contain (set BLOCKED bila CB open).
4. Recover (jalankan recovery path / restart).
5. Verify (test_e2e.py).
6. Record (evidence + log).
7. Escalate bila > 3 kegagalan / 60 detik.
