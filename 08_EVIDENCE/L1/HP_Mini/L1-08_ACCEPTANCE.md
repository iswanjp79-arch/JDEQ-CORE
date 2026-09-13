# L1-08 ACCEPTANCE  HP MINI
# Status: CLOSED_WITH_UNKNOWNS
# Tanggal: 2026-09-11
# Otoritas: L0 (Iswan Juman Pancoro, ST)

## L1-00 IDENTITAS
- hostname: hp-mini
- OS: Debian GNU/Linux 13 (trixie)  AntiX derivative
- Kernel: 6.6.119-antix.1-amd64-smp
- Arch: x86_64
- Init system: runit (bukan systemd)

## L1-01 CPU
- Model: Intel Atom N475 @ 1.83 GHz
- Cores/Threads: 2/2
- Freq max/min: 1833/1000 MHz

## L1-02 MEMORI (dipisah sesuai audit)
- RAM_TOTAL     : 1.9 GiB
- RAM_AVAILABLE : 887 MiB
- RAM_USAGE     : 1.0 GiB used
- Swap          : 1.0 GiB (0 used)

## L1-03 PENYIMPANAN
- Device: TOSHIBA MK1665GSX H (HDD, bukan SSD)
- Size  : 149.1 GB
- Used  : 8.5 GB
- Free  : 130 GB (7%)
- FS    : ext4

## L1-04 DAYA & SUHU
- CPU Core 0: +53.0 C (crit +100 C)
- Baterai: Full, 100%, 12.27 V
- Detail kapasitas/siklus: NOT_TESTED

## L1-05 ANTARMUKA FISIK
- USB: Keyboard Primax, WiFi Realtek RTL8188FTV (dongle), Webcam HP, Mouse ASUS
- PCI: Intel Atom SoC, Integrated Graphics, ICH7/NM10 chipset
- Network HW: eth0, wlan0, wlan1, tailscale0, lo
- Display: LVDS-1 (internal), VGA-1 (eksternal), renderD128

## L1-06 PERAN FISIK (LOCKED L0)
- Assigned: SENSOR_PASIF + ARSIP_2
- Status: LOCKED_BY_L0
- Verifikasi pendukung: kondisi fisik mendukung (RAM/CPU/storage)

## L1-07 CAPABILITY PASSPORT
| Kemampuan       | Status     |
|-----------------|-----------|
| SSH client      | VERIFIED  |
| SSH server      | VERIFIED  |
| Tailscale       | VERIFIED  |
| WiFi (USB)      | VERIFIED  |
| Ethernet        | NOT_TESTED|
| Webcam          | OBSERVED  |
| Storage arsip   | VERIFIED  |
| Sensor pasif    | CANDIDATE |
| AI lokal        | LIMITED   |

## L1-08 PENUTUPAN
- [x] L1-00 s/d L1-07 physical baseline lengkap
- [x] Anomali tercatat
- [x] Yang belum diketahui tercatat eksplisit
- [x] Role L0 tetap LOCKED
- [x] Tidak ada perubahan sistem (zero mutation)
- [x] Layer discipline: L2/L3/L4 tidak dibuka

## YANG BELUM DIKETAHUI (non-blocker, dibawa ke L2+ sebagai catatan risiko)
- Baterai: kapasitas desain, siklus, health  NOT_TESTED
- Ethernet port: belum diuji  NOT_TESTED
- Webcam: terdeteksi, belum diuji  NOT_TESTED
- Riwayat instalasi: UNKNOWN (tidak diasumsikan)

## BATAS LAYER
- SSH/Tailscale terverifikasi = CAPABILITY EVIDENCE, bukan pembukaan L2
- Cron/Rsync/konfigurasi = URUSAN L2/L3/L4, tidak dibuka
- L2 (connectivity): LOCKED sampai L0 buka

## BUKTI
- Canonical: L1_HP_MINI_RECON_20260911_200317.md
- Duplicate (SUPERSEDED, disimpan): L1_HP_MINI_RECON_20260911_200538.md.SUPERSEDED
- Full survey: L1_HP_MINI_FULL_20260911_195112.md
- Raw L1-00..05: L1-00_to_05_hpmini_20260911_194054.txt

## STATUS
CLOSED_WITH_UNKNOWNS
L1 TUTUP. L2 MASIH DIKUNCI.

Executor: AG-003 / DeepSeek
Reviewer: L0  menunggu pengesahan
