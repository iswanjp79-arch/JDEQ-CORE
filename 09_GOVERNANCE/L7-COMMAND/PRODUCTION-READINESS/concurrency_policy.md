# CONCURRENCY POLICY

## Desain Saat Ini
Runtime L7 dirancang **single-instance**: satu proses `l7_runtime.py` melayani
satu perintah pada satu waktu. Tidak ada eksekusi paralel di sisi runtime.

## Mengapa
- State files (`nonces.jsonl`, `commands.jsonl`, `sequence.jsonl`,
  `circuit_breaker.json`) ditulis dengan pola append + read-check-write.
- Bila dua proses berjalan bersamaan, ada risiko:
  - nonce yang sama lolos dua kali (race pada cek nonce)
  - sequence yang sama terpakai dua kali
  - CB mencatat kegagalan ganda dari satu peristiwa
- Proteksi saat ini: **serialisasi oleh pemanggil**.

## Aturan Operasional
1. Pemanggil (skrip/agent/L0) WAJIB mengirim satu perintah per waktu.
2. Tunggu proses `l7_runtime.py` selesai (exit code keluar) sebelum
   mengirim perintah berikutnya.
3. Bila butuh mengirim cepat, gunakan antrean serial (queue).

## Batas Kinerja
- Throughput realistis : ± 1 perintah/detik (bergantung I/O filesystem).
- Tidak ada paralelisme internal.

## Jika Diperlukan Skala Lebih Tinggi
- Wajib menambahkan file lock (`runtime_state/.lock`).
- Wajib menambahkan mekanisme append atomik (misal `fcntl.flock`).
- Perubahan tersebut masuk **Sprint terpisah**, bukan modifikasi ad-hoc.

## Bukti
- Uji serial: `test_rt_harness.py` (RT01–RT15) berjalan serial.
- Uji E2E: `test_e2e.py` (8 skenario) berjalan serial.
