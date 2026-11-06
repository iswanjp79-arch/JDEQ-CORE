# MICO-JDEQ Digital Consciousness Layer (DCL)

## Backup Policy
- Realtime : Setiap perubahan state
- Hourly   : Snapshot ringan
- Daily    : Backup penuh ke cloud
- Weekly   : Arsip terkompresi
- Monthly  : Immutable archive

## Symlink /current
~/mico_jdeq/current → state terakhir (transparan)

## Observer Daemon
- SSH Restart → Observer → Journal → Dashboard → Checkpoint

## Digital Journal (otomatis)
- Semua perubahan dicatat tanpa intervensi manusia

## Recovery
- restore <checkpoint_id> → kembali ke state sebelumnya

## SymThink
- Semua AI membaca state yang sama, bukan copy-paste
