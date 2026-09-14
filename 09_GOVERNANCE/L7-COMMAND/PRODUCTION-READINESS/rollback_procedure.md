# ROLLBACK PROCEDURE

1. Set runtime_state = LOCKED.
2. Hentikan pemanggilan l7_runtime.py.
3. Snapshot evidence yang ada.
4. Git checkout ke commit stabil sebelumnya.
5. Re-verify dengan test_rt_harness.py.
