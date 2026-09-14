# P2-ROLLBACK

## Prinsip
Bila eksekusi P2 gagal sebagian, kembalikan ke baseline bf634d2
tanpa menyentuh L4/L5/runtime/deployment.

## Skenario
| ID | Kondisi | Aksi |
|---|---|---|
| RB-01 | Runner rotasi crash | Hentikan runner, arsip tetap utuh |
| RB-02 | Alert writer crash | Hentikan writer, tidak ada alert dikirim |
| RB-03 | Sanitizer fail | REJECT seluruh payload, catat |
| RB-04 | CB trip saat eksekusi | BLOCKED, jalankan manual override bila diizinkan L0 |
| RB-05 | Rollback penuh | git checkout bf634d2 pada scope P2-EXECUTION |

## Langkah Rollback Penuh
1. Hentikan semua proses P2 yang sedang berjalan
2. Snapshot evidence P2 yang sudah ada
3. git revert commit P2 execution (bukan reset)
4. Verifikasi runtime masih NOT_ACTIVE
5. Verifikasi deployment masih LOCKED
6. Catat rollback di audit log

## Batas
- TIDAK memakai git reset --hard
- TIDAK menghapus evidence
- TIDAK menyentuh state runtime aktif
- TIDAK mengangkat deployment
