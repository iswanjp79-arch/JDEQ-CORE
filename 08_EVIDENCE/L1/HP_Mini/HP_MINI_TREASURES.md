# HP MINI  5 HARTA KARUN (Out-of-the-Box)
# 2026-09-11  Non-Konvensional Brainstorm
# Status: CANDIDATE  bukan design approved

## HARTA KARUN 1  Cold Vault (Air-gapped by Design)
- Tidak punya modem seluler  cabut WiFi USB dongle = faraday cage sukarela
- Satu-satunya node di constellation yang bisa offline permanen
- Fungsi: simpan seed phrase, identitas, recovery code, private key
- Effort: 0 detik. Biaya: Rp 0.
- Prioritas: SANGAT TINGGI

## HARTA KARUN 2  Offline Package Cache (Hemat Kuota)
- HP Mini jadi cermin paket Debian/Python untuk seluruh constellation
- Vivo/Z83/PC-i5 ambil paket via LAN dari HP Mini, bukan internet
- Setup: apt-cacher-ng di HP Mini, arahkan client ke http://192.168.1.6:3142
- Effort: 15 menit sekali. Hemat kuota: 80-95%
- Prioritas: TINGGI (finansial)

## HARTA KARUN 3  Watchdog Node (Monitoring Independen)
- HP Mini ping semua node tiap 5 menit, alert kalau ada yang diam
- Node paling netral untuk pengawas  dia tidak melakukan selain mengawasi
- Syarat: Watchdog tidak boleh jalan di node yang dia awasi
- Effort: 20 menit (setelah L2/L3 dibuka)
- Prioritas: SEDANG

## HARTA KARUN 4  USB Physical Bridge
- 5 USB port: 4x UHCI + 1x EHCI
- Bisa bicara ke USB-Serial (console router), USB-Ethernet, USB-SDR, USB-GPIO
- Tidak ada node lain yang bisa bicara ke hardware non-USB-standar
- Biaya: Rp 30rb-200rb tergantung dongle
- Prioritas: SANGAT TINGGI (jangka panjang)

## HARTA KARUN 5  Single-Purpose Kiosk (Ruang Kerja Murni)
- AntiX + runit + IceWM  hanya 1 aplikasi saat boot
- Tanpa notifikasi, tanpa chat, tanpa distraksi
- Ruang menulis/ngoding paling bersih di constellation
- Effort: 30 menit. Biaya: Rp 0.
- Prioritas: SEDANG

---

## Perbandingan Nilai

| Treasure | Nilai | Effort | Biaya |
|----------|-------|--------|-------|
| Cold Vault | Sangat tinggi | Nol | Rp 0 |
| Offline Package Cache | Tinggi | 15 mnt | Rp 0 |
| Watchdog | Sedang | 20 mnt | Rp 0 |
| USB Physical Bridge | Sangat tinggi | bervariasi | Rp 30-200rb |
| Kiosk Writing Room | Sedang | 30 mnt | Rp 0 |

---

## Catatan Doktrin
- Semua di atas adalah CANDIDATE, bukan design approved.
- Setiap eksekusi butuh Task Card + ACC L0.
- Tidak ada yang dijalankan di sesi ini.
- Disimpan sebagai referensi saat L2/L3 dibuka.
