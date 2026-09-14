# P2-EXECUTION-TEST-MATRIX

## Uji Rotasi Log
| ID | Nama | Harapan | Sumber |
|---|---|---|---|
| RT-01 | Rotasi normal | Arsip dibuat, hash valid | rotation_test_plan.md |
| RT-02 | Size threshold | Rotasi paksa | rotation_test_plan.md |
| RT-03 | Disk penuh | BLOCKED, tidak ada data hilang | rotation_test_plan.md |
| RT-04 | Rename gagal | BLOCKED, berkas asli utuh | rotation_test_plan.md |
| RT-05 | Hash mismatch | INTEGRITY_CONFLICT | rotation_test_plan.md |
| RT-06 | Dua rotasi beruntun | Yang kedua NOOP | rotation_test_plan.md |
| RT-07 | Interupsi di tengah | Recoverable | rotation_test_plan.md |

## Uji Circuit Breaker
| ID | Nama | Harapan | Sumber |
|---|---|---|---|
| CB-01 | 10 gagal / 60s | CB open | cb_test_plan.md |
| CB-02 | 9 gagal, 1 sukses | CB closed | cb_test_plan.md |
| CB-03 | Cooldown 15m | Reset otomatis | cb_test_plan.md |
| CB-04 | Manual override L0 | Diizinkan, tercatat | cb_test_plan.md |

## Uji Alert
| ID | Nama | Harapan | Sumber |
|---|---|---|---|
| AL-01 | Pull normal | Alert diterima | alert_delivery_policy.md |
| AL-02 | Dedup 5m | Duplikat dibuang | alert_delivery_policy.md |
| AL-03 | Sanitasi kunci terlarang | REJECT | metadata_sanitizer_config.json |
| AL-04 | Truncate detail >2000 | Terpotong | metadata_sanitizer_config.json |
| AL-05 | Retry 3x lalu BLOCKED | BLOCKED | alert_delivery_policy.md |

## Uji Restore
| ID | Nama | Harapan | Sumber |
|---|---|---|---|
| RS-01 | Restore arsip utuh | Hash cocok | restore_test_plan.md |
| RS-02 | Arsip rusak | Verify fail, batal | restore_test_plan.md |
| RS-03 | Restore saat runtime aktif | DILARANG | restore_test_plan.md |

## Batas
- Semua uji dijalankan pada environment TERKENDALI
- Tidak ada uji yang menyentuh L4/L5
- Tidak ada uji yang mengaktifkan runtime produksi

