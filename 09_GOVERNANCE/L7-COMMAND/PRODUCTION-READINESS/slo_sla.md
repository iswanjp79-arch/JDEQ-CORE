# SLO / SLA - RUNTIME L7

## Konteks
L7 runtime adalah komponen kendali perintah pada PC-i5 (KAPAL-INDUK).
Bersifat lokal, single-instance, tanpa cluster.

## Service Level Objectives (Target Internal)

| Metrik | Target | Catatan |
|---|---|---|
| Availability | 99% bulanan | single node PC-i5 |
| Latency noop p50 | < 100 ms | perintah normal |
| Latency noop p99 | < 500 ms | termasuk I/O filesystem |
| Throughput sustained | 1 perintah/detik | serial |
| Throughput burst | 10 perintah / 10 detik | dengan jeda |
| RTO | <= 15 menit | manual rollback + restore |
| RPO | 0 | state ditulis sebelum exit |
| MTTR | <= 15 menit | sesuai RTO |

## Service Level Agreement (Komitmen Operasional)

1. Setiap exit 9/11/12/13/14 harus tercatat di audit log.
2. Setiap CB open memicu alert.
3. Setiap rollback disertai snapshot evidence sebelum & sesudah.
4. Recovery wajib diverifikasi test_e2e.py sebelum dinyatakan pulih.

## Yang TIDAK Dijamin

- Ketersediaan di luar jam operasional PC-i5.
- Perilaku benar bila state dir dirusak manual.
- Kinerja paralel (lihat concurrency_policy.md).
- Pemulihan otomatis tanpa intervensi.

## Bukti Kuantitatif
Angka di atas adalah target, bukan pengukuran empiris.
Laporan pertama dijadwalkan 7 hari setelah aktivasi L0.
