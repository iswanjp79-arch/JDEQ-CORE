# P2-OBSERVABILITY

## Metrik yang Diamati

### P2-1 Rotasi
| Metrik | Target | Sumber |
|---|---|---|
| Rotasi sukses / hari | >= 1 | rotation manifest |
| Kegagalan rotasi | 0 (idealnya) | rotation_audit |
| CB trip | 0 | cb state file |
| Ukuran arsip rata-rata | <= 50 MB | manifest |

### P2-2 Alert
| Metrik | Target | Sumber |
|---|---|---|
| Alert terkirim / hari | sesuai kejadian | alert ledger |
| Alert dedup drop | <= 30% | alert ledger |
| Sanitizer reject | tercatat | sanitizer log |
| Retry exhaustion | 0 | alert ledger |

## Saluran Pengamatan
- File ledger: 08_EVIDENCE/L7-OPERATIONAL/
- Manifest rotasi: rotation_manifest.json
- Manifest alert: alert_manifest.json
- Audit entry per operasi

## Alarm yang Diperlukan
- CB rotasi open -> notifikasi ke L0
- Alert tidak terkirim > 3 kali -> BLOCKED + notifikasi
- Sanitizer reject CRITICAL -> review L0

## Batas
- Pengamatan TIDAK menyentuh L4/L5
- Pengamatan TIDAK mengaktifkan runtime
- Semua data pengamatan read-only
