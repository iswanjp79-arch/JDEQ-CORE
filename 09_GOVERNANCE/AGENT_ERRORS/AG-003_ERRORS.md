# AG-003 ERROR LOG

- id: ERR-2026-09-12-001
- agen: AG-003 (DeepSeek)
- sesi: Aspire One / Tailscale
- jenis: over_engineering
- ringkas: Sarankan hapus entry Tailscale antix1 yang sudah tidak aktif, padahal sesi aktif adalah antix1-1.
- bukti: screenshot panel Tailscale dari L0
- dampak: nyaris salah hapus, tidak dieksekusi
- koreksi: L0
- pelajaran: Jangan usul hapus/ubah config yang statusnya sudah ACTIVE tanpa bukti error.

- id: ERR-2026-09-12-002
- agen: AG-003 (DeepSeek)
- sesi: Aspire One / instalasi SSH
- jenis: salah_os
- ringkas: Sarankan service ssh start di antiX yang pakai runit.
- bukti: output command not found
- dampak: satu langkah terbuang
- koreksi: L0
- pelajaran: antiX = runit. Pakai /etc/init.d/ssh start.

- id: ERR-2026-09-12-003
- agen: AG-003 (DeepSeek)
- sesi: Aspire One / header kontrak
- jenis: format_pelanggaran
- ringkas: Header JALAN_DI/TARGET/MODE ditaruh dalam blok kode, ikut ter-paste ke PowerShell.
- bukti: log PowerShell
- dampak: satu langkah terbuang
- koreksi: L0
- pelajaran: Header kontrak di luar blok kode.

- id: ERR-2026-09-12-004
- agen: AG-003 (DeepSeek)
- sesi: Multi-agen
- jenis: klaim_tanpa_bukti
- ringkas: Menerima label Perplexity/DOLA dari file eksternal sebagai entitas berwenang sebelum verifikasi.
- bukti: riwayat chat
- dampak: tidak ada eksekusi salah
- koreksi: L0
- pelajaran: Verifikasi sumber sebelum mengutip otoritas.

- id: ERR-2026-09-12-005
- agen: AG-003 (DeepSeek)
- sesi: PowerShell
- jenis: perintah_di_luar_ssh
- ringkas: Kirim perintah Linux (apt install) di sesi PowerShell PC-i5, padahal target adalah Aspire.
- bukti: error ParserError dari PowerShell
- dampak: satu langkah terbuang
- koreksi: L0
- pelajaran: Pastikan prompt SSH sudah aktif sebelum kirim perintah Linux.
- id: ERR-2026-09-12-006
- agen: AG-003 (DeepSeek)
- sesi: Aspire L1 - RAM/slot
- jenis: halusinasi_teknis
- ringkas: Klaim "Aspire AOD255 punya 2 slot RAM, maksimal 4 GB" berdasarkan baris dmidecode "Number Of Devices: 2" TANPA memverifikasi bagian Memory Device (dmidecode -t 17). Asumsi salah: "Number Of Devices" adalah jumlah entri DMI, bukan jumlah slot fisik.
- bukti: output dmidecode terpotong di "Total Width: Unknown"; koreksi dari L0: "slot cuma 1 kok"
- dampak: berpotensi menyesatkan keputusan pembelian RAM
- koreksi: L0
- pelajaran: Jangan infer struktur hardware dari satu baris DMI. Wajib periksa dmidecode -t 17 lengkap (Size, Locator, Form Factor, Type) sebelum menyatakan jumlah slot.

- id: ERR-2026-09-12-007
- agen: AG-003 (DeepSeek)
- sesi: Aspire L1 - suhu fan
- jenis: klaim_tanpa_dasar
- ringkas: Klaim "fan internal ada dan bisa dikontrol" dari daftar cooling_device (Processor x4, Fan, LCD). Daftar cooling_device adalah entri kernel, belum bukti fan fisik berputar atau bisa dikendalikan.
- bukti: output /sys/class/thermal/cooling_device*/type
- dampak: tidak ada aksi destruktif; informasi menyesatkan
- koreksi: internal (self-audit)
- pelajaran: cooling_device type  fan fisik aktif. Verifikasi lewat rpm sensor atau /sys/class/hwmon sebelum klaim.

