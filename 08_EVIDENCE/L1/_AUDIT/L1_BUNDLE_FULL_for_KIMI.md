# L1 FULL AUDIT BUNDLE — for KIMI (with content)
Generated: 2026-09-12 22:27:55

## NODE: Aspire

  (NO L1-06/07/08 files found — PARTIAL)

## NODE: HP_Mini

### FILE: L1-08_ACCEPTANCE.md | 2740 bytes
---BEGIN---
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
---END---

### FILE: L1-08_ACCEPTANCE_ACC.md | 1696 bytes
---BEGIN---
# L1 HP MINI  OFFICIAL ACCEPTANCE
# Status: ACCEPTED_BY_L0
# Tanggal ACC: 2026-09-11 21:0X WIB

## IDENTITAS NODE
- Hostname     : hp-mini
- IP LAN       : 192.168.1.6
- IP Tailscale : 100.92.105.35
- User SSH     : iswanjp (key-only, ed25519 dari PC-i5)

## RINGKASAN L1
- L1-00 s/d L1-07 physical baseline: LENGKAP
- RAM_TOTAL 1.9 GiB / RAM_AVAILABLE 887 MiB: dipisah
- Storage HDD Toshiba 149.1 GB (130 GB free): terverifikasi
- Init system runit: terverifikasi
- Role L1-06: SENSOR_PASIF + ARSIP_2 (LOCKED_BY_L0)
- Yang belum diketahui: baterai detail, Ethernet, webcam, install history

## STATUS PENUTUPAN
CLOSED_WITH_UNKNOWNS
Yang belum diketahui = non-blocker, dibawa ke L2+ sebagai catatan risiko.

## KEPUTUSAN L0
- [x] L1 HP Mini DITERIMA (ACCEPTED_BY_L0)
- Tanggal: 2026-09-11
- Otoritas: Iswan Juman Pancoro, ST (L0)
- Alasan: physical baseline lengkap, tidak ada layer creep, role tetap locked

## EFEK
- L1 HP Mini RESMI CLOSED
- L2 (connectivity) BOLEH DIBUKA atas perintah L0 (belum otomatis terbuka)
- L3/L4 tetap terkunci sampai L2 selesai
- Node HP Mini masuk daftar node L1 selesai di SSOT

## BUKTI TERKAIT
- L1-08_ACCEPTANCE.md (SHA256 8EE74E95181FDB943CBF1B8B8D182BA6F3D30D05FD6F225131C735C0E9BEFE89)
- L1_HP_MINI_RECON_20260911_200317.md (canonical)
- L1_HP_MINI_FULL_20260911_195112.md
- L1-00_to_05_hpmini_20260911_194054.txt
- HP_MINI_TREASURES.md (5 candidate untuk L2+)

## CATATAN
5 harta karun (Cold Vault, Offline Cache, Watchdog, USB Bridge, Kiosk)
tetap berstatus CANDIDATE. Tidak dieksekusi di L1.
Dapat diusulkan sebagai Task Card saat L2/L3 dibuka.

## TANDA TANGAN
Executor : AG-003 / DeepSeek
Reviewer : L0  Iswan Juman Pancoro, ST
Status   : ACCEPTED
---END---

## NODE: Infinix

  (NO L1-06/07/08 files found — PARTIAL)

## NODE: PC5

### FILE: L1-06_role_20260910_141410.txt | 310 bytes
---BEGIN---
Node: PC-i5 (KAPAL-INDUK)
Role: Local Controller / Heavy Processing
Location: Fixed workstation
Always-on: On-demand
Criticality: Primary local node
---END---

### FILE: L1-07_PASSPORT_PC5.yml | 9054 bytes
---BEGIN---
passport:
  passport_id: L1-07-PC5-CAPABILITY-PASSPORT
  node_id: KAPAL-INDUK
  node_type: LOCAL_ENGINEERING_CONTROL_PROCESSING_NODE
  architecture_role:
    primary: LOCAL_CONTROLLER
    secondary: ENGINEERING_WORKER
    conditional: HEAVY_PROCESSING
  status: DRAFT_READY_FOR_VERDICT
  authority:
    owner: L0
    planner: AG-001-ChatGPT
    executor: AG-003-DeepSeek
    governance: DOLA

  identity:
    hostname: KAPAL-INDUK
    os: Windows 10 Enterprise
    build: 19045
    cpu: Intel Core i5-3470
    ram_gb: 16
    evidence_status: OBSERVED

  cpu:
    model: Intel Core i5-3470
    cores: 4
    threads: 4
    max_clock_mhz: 3201
    architecture: x86_64
    class: LEGACY_GENERAL_PURPOSE
    status: OBSERVED
    suitable_for:
      - CLI workloads
      - scripting
      - document processing
      - batch processing
      - lightweight local services
    not_yet_proven_for:
      - heavy_parallel_AI
      - large_model_inference
      - sustained_high_concurrency

  memory:
    total_gb: 16
    status: OBSERVED
    suitable_for:
      - normal engineering workload
      - moderate data processing
      - lightweight local AI experimentation
    constraints:
      - memory-intensive workloads require benchmark

  storage:
    C:
      role: OS_SYSTEM
      status: OBSERVED
      policy: PROTECTED
    D:
      role: WORKING_DATA_SSOT
      status: OBSERVED
      policy: PRIMARY_ENGINEERING_WORK_AREA
    E:
      role: DATA_ADDITIONAL_STORAGE
      model: ST500DM002-1ER14C
      media_type: HDD
      status: OBSERVED_WITH_BAD_BLOCKS
      policy: HOLD_HEAVY_IO
      event_log_evidence: bad block berulang 2026-09-06 23:10
      required_action: chkdsk E: /scan (read-only) sebelum dipakai lebih jauh

  thermal:
    status: OBSERVED_LIMITED
    available:
      - MSAcpi_ThermalZoneTemperature:
          TZ00_0: 3010 tenths_K -> 27.9 C
          TZ01_0: 3030 tenths_K -> 29.9 C
    not_available:
      - CPU die sensor langsung tidak diekspos Windows
      - Win32_TemperatureProbe mengembalikan 1 OK, 1 Unknown tanpa angka
    catatan: kondisi idle, thermal zone rendah
    alternatif_rekomendasi:
      - LibreHardwareMonitor portable (read-only, tidak install)
      - HWiNFO64 portable (read-only)
      - Open Hardware Monitor portable
      - BIOS/UEFI thermal reading saat boot
      - Vendor WMI thermal (tidak berlaku untuk OEM custom build)
    status_instalasi: BELUM - menunggu ACC L0 terpisah

  connectivity:
    tailscale: OBSERVED
    tailscale_ip: 100.124.50.70
    network_role: TARGET
    server_exposure: UNVERIFIED

  software_capability:
    windows_shell:
      powershell: OBSERVED
      cmd: OBSERVED
    linux_capability:
      wsl: OBSERVED
      ubuntu_environment: OBSERVED
    programming:
      python: CANDIDATE
      c_cpp: CANDIDATE
      php_mysql: CANDIDATE

  data_capabilities:
    file_processing: OBSERVED
    indexing: OBSERVED
    structured_data_csv: OBSERVED
    structured_data_json: OBSERVED
    sqlite: CANDIDATE
    vector_database: DEFERRED

  ai_capabilities:
    local_llm: CANDIDATE
    embedding: CANDIDATE
    rag: CANDIDATE
    ocr: CANDIDATE
    agent_worker: CANDIDATE
    cloud_ai_relay: CANDIDATE

  orchestration:
    local_control: TARGET
    gateway: CANDIDATE
    nats: DEFERRED
    mcp: CANDIDATE
    docker: DEFERRED_UNTIL_NEEDED
    kubernetes: DEFERRED

  security:
    credential_storage: RESTRICTED
    public_exposure: BLOCKED_BY_DEFAULT
    firewall_changes: APPROVAL_REQUIRED
    destructive_operations: BLOCKED_BY_DEFAULT

  capability_classes:
    VERIFIED: supported by current evidence
    OBSERVED: directly seen but not fully validated
    CANDIDATE: plausible but requires test
    UNVERIFIED: insufficient evidence
    DEFERRED: intentionally not activated
    BLOCKED: prohibited until governance condition met

  passport_limitations:
    - no claim of maximum performance without benchmark
    - no claim of thermal safety without current measurement
    - no claim of storage health without current health evidence
    - no claim of production readiness from folder structure alone
    - no capability becomes installation authority

  transition_to_L1_08:
    required:
      - L1-00_complete: yes
      - L1-01_complete: yes
      - L1-02_complete: yes
      - L1-03_complete: yes
      - L1-04_complete: yes
      - L1-05_complete: yes
      - L1-06_complete: yes
      - anomalies_recorded: yes (Drive E bad block, CPU thermal limitation)
      - evidence_index_complete: yes
      - L0_acceptance: PENDING
---END---

### FILE: L1-08_ACCEPTANCE_PC5.yml | 991 bytes
---BEGIN---
acceptance_report:
  task_id: MICO-L1-PC5-ACCEPT-004
  tanggal: 2026-09-10
  node: PC-i5 (KAPAL-INDUK)
  mode: READ_ONLY
  versi: 2
  status: DRAFT_VERIFIKASI_PENDING

  ringkasan_saat_ini:
    L1-00: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-01: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-02: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-03: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-04: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-05: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-06: TERKUMPUL_BELUM_DIVERIFIKASI
    L1-07: DRAFT_DISUSUN_BELUM_DIVERIFIKASI
    L1-08: THIS_FILE

  gate:
    l0_acceptance: PENDING
    ag001_verdict: SIMULASI_BELUM_SAH
    audit_independen: BELUM

  referensi:
    - L1-STATUS_CORRECTION.yml
    - L1_RECONCILIATION_REPORT.yml
    - UPDATED_EVIDENCE_INDEX.yml

  catatan:
    - File ini menggantikan versi sebelumnya yang mengklaim APPROVED terlalu dini.
    - Verdict AG-001 yang tertulis sebelumnya bukan verdict sah, melainkan simulasi.
    - Status resmi: STRUKTUR_SELESAI_VERIFIKASI_PENDING.
---END---

### FILE: L1-08_evidence_list_20260910_150742.txt | 3602 bytes
---BEGIN---

Name                                    Length LastWriteTime       
----                                    ------ -------------       
CPU_THERMAL_ALTERNATIVE_RESEARCH.yml      3740 9/10/2026 2:35:04 PM
DRIVE_E_HEALTH_EVIDENCE.txt               1590 9/10/2026 2:24:20 PM
L1-00_identity_20260910_141410.txt         898 9/10/2026 2:14:15 PM
L1-00_timestamp_20260910_141410.txt         42 9/10/2026 2:14:12 PM
L1-01_cpu_20260910_141410.txt              544 9/10/2026 2:14:16 PM
L1-01_cpu_load_20260910_141410.txt         210 9/10/2026 2:14:17 PM
L1-02_mem_20260910_141410.txt              272 9/10/2026 2:14:17 PM
L1-02_swap_20260910_141410.txt             302 9/10/2026 2:14:17 PM
L1-03_disks_20260910_141410.txt           1110 9/10/2026 2:14:17 PM
L1-03_partitions_20260910_141410.txt      2222 9/10/2026 2:14:17 PM
L1-03_volumes_20260910_141410.txt         1134 9/10/2026 2:14:17 PM
L1-04_battery_STATUS.txt                   234 9/10/2026 2:16:49 PM
L1-04_powercfg_20260910_141410.txt         164 9/10/2026 2:14:17 PM
L1-04_thermal_20260910_141410.txt          262 9/10/2026 2:14:17 PM
L1-04_thermal_reconciled.txt               496 9/10/2026 2:24:19 PM
L1-05_peripherals_20260910_141410.txt     6566 9/10/2026 2:14:18 PM
L1-06_role_20260910_141410.txt             310 9/10/2026 2:14:18 PM
L1-07_PASSPORT_PC5.yml                    9054 9/10/2026 2:35:02 PM
L1-08_ACCEPTANCE_PC5.yml                   991 9/10/2026 3:07:42 PM
L1-08_evidence_list_20260910_141649.txt   2636 9/10/2026 2:16:49 PM
L1-08_evidence_list_20260910_150742.txt      0 9/10/2026 3:07:42 PM
L1-STATUS_CORRECTION.yml                  1113 9/10/2026 2:55:21 PM
L1_RECONCILIATION_REPORT.yml              2558 9/10/2026 2:26:18 PM
UPDATED_EVIDENCE_INDEX.yml                1095 9/10/2026 3:07:42 PM


---END---

### FILE: L1_PC5_CLOSURE_DECLARATION.yml | 1845 bytes
---BEGIN---
deklarasi_penutupan:
  node: PC-i5 (KAPAL-INDUK)
  tanggal: 2026-09-10 17:03
  diputuskan_oleh: L0 — Iswan Juman Pancoro, S.T.
  status: L1_PC5_CLOSED_WITH_PUNCH_LIST
  dasar: Keputusan langsung L0 sebagai otoritas mutlak

  cakupan_penutupan:
    - L1-00 s/d L1-06: TERKUMPUL, DITUTUP
    - L1-07 paspor: DITUTUP sebagai draft
    - L1-08 acceptance: DITUTUP dengan catatan

  punch_list_terbuka:
    - id: KIMI_F001
      isi: Rekonsiliasi angka RAM sudah diperbaiki (13.70 GB resmi)
      status: koreksi terkirim, belum diverifikasi KIMI
    - id: KIMI_F002
      isi: Thermal threshold diganti berbasis beban CPU
      status: koreksi terkirim, belum diverifikasi KIMI
    - id: KIMI_F003
      isi: Cmdlet Get-JobObject dihapus dari checklist
      status: koreksi terkirim, belum diverifikasi KIMI
    - id: KIMI_F004
      isi: Port RDP/WinRM ditunda ke L2
      status: tercatat
    - id: KIMI_F005
      isi: Bukti sudah dikirim ke KIMI
      status: menunggu verdict ulang
    - id: DRIVE_E
      isi: HOLD_HEAVY_IO
      status: permanen sampai chkdsk /scan (butuh ACC L0)
    - id: THERMAL_CPU
      isi: PLATFORM_LIMITATION
      status: permanen, tercatat
    - id: HASH_MANIFEST
      isi: Belum dibuat
      status: butuh Task Card terpisah

  larangan_setelah_penutupan:
    - Tidak ada perubahan file di L1/PC5/ tanpa Task Card baru
    - Tidak ada klaim L1 verified sampai KIMI verdict ulang
    - Tidak naik ke L2 tanpa ACC L0 baru

  klaim_sah:
    - "L1 PC-i5 ditutup atas keputusan L0."
    - "Tidak ada klaim data hilang pada evidence yang diperiksa."
    - "Tidak ada mutasi sistem di luar D:\MICO_SSOT\08_EVIDENCE."
    - "Tidak ada instalasi software."

  catatan:
    - Penutupan ini tidak membatalkan temuan KIMI.
    - Temuan KIMI tetap punch list.
    - Bila KIMI beri verdict ulang, punch list diperbarui.
---END---

### FILE: L1_PC5_CLOSURE_PACKAGE.yml | 720 bytes
---BEGIN---
closure_package:
  task_id: MICO-L1-PC5-CLOSURE-001
  tanggal: 2026-09-10
  node: PC-i5 (KAPAL-INDUK)
  mode: READ_ONLY
  status_resmi: AUDIT_READY

  status_per_item:
    L1-00_identitas: TERKUMPUL
    L1-01_cpu: TERKUMPUL
    L1-02_memori: TERKUMPUL
    L1-03_storage: TERKUMPUL
    L1-04_daya_suhu: TERKUMPUL
    L1-05_antarmuka: TERKUMPUL
    L1-06_peran: TERKUMPUL
    L1-07_paspor: DRAFT_DISUSUN
    L1-08_acceptance: DRAFT_VERIFIKASI_PENDING

  status_keseluruhan: STRUKTUR_SELESAI_VERIFIKASI_PENDING
  l0_acceptance: PENDING
  ag001_verdict: BELUM_DIMINTA
  independent_audit: BELUM_DIJALANKAN

  yang_tidak_boleh_diklaim:
    - L1_PC5_CLOSED
    - L1_PC5_FULL_LOCKED
    - BASELINE_FROZEN
    - L0_ACCEPTED
---END---

### FILE: L1_PC5_PUNCH_LIST.yml | 821 bytes
---BEGIN---
punch_list:
  task_id: MICO-L1-PC5-CLOSURE-001
  tanggal: 2026-09-10
  node: PC-i5 (KAPAL-INDUK)

  permanent_limitation:
    - id: THERMAL_ACPI_ONLY
      deskripsi: Sensor CPU die tidak diekspos Windows
      bukti: L1-04_thermal_reconciled.txt
      kondisi: 27.9C / 29.9C via ACPI zone
      dampak: tidak bisa deteksi throttle beban tinggi via ACPI
      tindakan_lanjutan: pertimbangkan alat portable (belum diinstall)

  deferred_repair:
    - id: DRIVE_E_HEAVY_IO
      deskripsi: ST500DM002 bad block berulang
      bukti: DRIVE_E_HEALTH_EVIDENCE.txt
      event: 2026-09-06 23:10 bad block \Device\Harddisk1\DR1
      keputusan: HOLD_HEAVY_IO
      tindakan_lanjutan: chkdsk E: /scan (read-only, butuh ACC L0)

  tidak_ada_dalam_punch_list:
    - data loss
    - system mutation
    - software installation
---END---

### FILE: L1-06_location.txt | 60 bytes
---BEGIN---
Location: Fixed workstation
---END---

### FILE: L1-06_node.txt | 56 bytes
---BEGIN---
Node: PC-i5 (KAPAL-INDUK)
---END---

### FILE: L1-06_role.txt | 88 bytes
---BEGIN---
Role: Local Controller / Heavy Processing
---END---

### FILE: L1-08_ACCEPTANCE_PC5_v1_20260910_1448.yml | 2778 bytes
---BEGIN---
acceptance_report:
  task_id: MICO-L1-PC5-ACCEPT-004
  tanggal: 2026-09-10
  node: PC-i5 (KAPAL-INDUK)
  mode: READ_ONLY
  referensi_verdict: AG001-L1-PC5-003 (APPROVED_WITH_CONDITIONS)

  ringkasan:
    L1-00: COMPLETE
    L1-01: COMPLETE
    L1-02: COMPLETE
    L1-03: COMPLETE
    L1-04: COMPLETE
    L1-05: COMPLETE
    L1-06: COMPLETE
    L1-07: COMPLETE
    L1-08: THIS_FILE

  anomali_final:
    drive_e:
      status: HOLD_HEAVY_IO
      alasan: bad block berulang 2026-09-06 23:10
      tindakan: chkdsk /scan read-only (butuh ACC L0 terpisah)
      larangan: format, repair, backup aktif
    thermal_cpu:
      status: PLATFORM_LIMITATION
      alasan: CPU die tidak diekspos Windows
      catatan: thermal zone ACPI terbaca (27.9C, 29.9C)
      alternatif: 4 opsi dicatat, belum diterapkan

  bukti:
    root: D:\MICO_SSOT\08_EVIDENCE\L1\PC5\
    total_file_kanonik: 21
    index: UPDATED_EVIDENCE_INDEX.yml
    arsip_duplikat: _superseded/

  klaim_sah:
    - "Tidak ditemukan bukti kehilangan data pada evidence yang diperiksa."
    - "Tidak ada mutasi sistem."
    - "Tidak ada instalasi software."
    - "Tidak ada klaim capability tanpa bukti."

  gate:
    l0_acceptance: APPROVED
    l0_accepted_at: 2026-09-10
    ag001_verdict: APPROVED_WITH_CONDITIONS
    naik_ke_L2: DIBLOKIR sampai 5 node lain selesai
    node_lain: BELUM DIMULAI

  status_final: L1_PC5_ACCEPTED
---END---

### FILE: L1-08_evidence_list.txt | 2028 bytes
---BEGIN---

Name                    Length LastWriteTime       
----                    ------ -------------       
L1-00_identity.txt         898 9/10/2026 2:09:37 PM
L1-00_timestamp.txt         42 9/10/2026 2:09:34 PM
L1-01_cpu.txt              544 9/10/2026 2:09:44 PM
L1-01_cpu_load.txt         210 9/10/2026 2:09:47 PM
L1-02_mem.txt              272 9/10/2026 2:09:51 PM
L1-02_swap.txt             302 9/10/2026 2:09:52 PM
L1-03_disks.txt           1110 9/10/2026 2:10:06 PM
L1-03_partitions.txt      2222 9/10/2026 2:10:08 PM
L1-03_volumes.txt         1134 9/10/2026 2:10:06 PM
L1-04_battery.txt            0 9/10/2026 2:10:15 PM
L1-04_powercfg.txt         164 9/10/2026 2:10:15 PM
L1-04_thermal.txt          262 9/10/2026 2:10:16 PM
L1-05_peripherals.txt     3472 9/10/2026 2:10:29 PM
L1-06_location.txt          60 9/10/2026 2:10:35 PM
L1-06_node.txt              56 9/10/2026 2:10:34 PM
L1-06_role.txt              88 9/10/2026 2:10:34 PM
L1-08_evidence_list.txt      0 9/10/2026 2:11:50 PM


---END---

### FILE: L1-08_evidence_list_20260910_141410.txt | 4706 bytes
---BEGIN---

Name                                    Length LastWriteTime       
----                                    ------ -------------       
L1-00_identity.txt                         898 9/10/2026 2:09:37 PM
L1-00_identity_20260910_141410.txt         898 9/10/2026 2:14:15 PM
L1-00_timestamp.txt                         42 9/10/2026 2:09:34 PM
L1-00_timestamp_20260910_141410.txt         42 9/10/2026 2:14:12 PM
L1-01_cpu.txt                              544 9/10/2026 2:09:44 PM
L1-01_cpu_20260910_141410.txt              544 9/10/2026 2:14:16 PM
L1-01_cpu_load.txt                         210 9/10/2026 2:09:47 PM
L1-01_cpu_load_20260910_141410.txt         210 9/10/2026 2:14:17 PM
L1-02_mem.txt                              272 9/10/2026 2:09:51 PM
L1-02_mem_20260910_141410.txt              272 9/10/2026 2:14:17 PM
L1-02_swap.txt                             302 9/10/2026 2:09:52 PM
L1-02_swap_20260910_141410.txt             302 9/10/2026 2:14:17 PM
L1-03_disks.txt                           1110 9/10/2026 2:10:06 PM
L1-03_disks_20260910_141410.txt           1110 9/10/2026 2:14:17 PM
L1-03_partitions.txt                      2222 9/10/2026 2:10:08 PM
L1-03_partitions_20260910_141410.txt      2222 9/10/2026 2:14:17 PM
L1-03_volumes.txt                         1134 9/10/2026 2:10:06 PM
L1-03_volumes_20260910_141410.txt         1134 9/10/2026 2:14:17 PM
L1-04_battery.txt                            0 9/10/2026 2:10:15 PM
L1-04_battery_20260910_141410.txt            0 9/10/2026 2:14:17 PM
L1-04_powercfg.txt                         164 9/10/2026 2:10:15 PM
L1-04_powercfg_20260910_141410.txt         164 9/10/2026 2:14:17 PM
L1-04_thermal.txt                          262 9/10/2026 2:10:16 PM
L1-04_thermal_20260910_141410.txt          262 9/10/2026 2:14:17 PM
L1-05_peripherals.txt                     3472 9/10/2026 2:10:29 PM
L1-05_peripherals_20260910_141410.txt     6566 9/10/2026 2:14:18 PM
L1-06_location.txt                          60 9/10/2026 2:10:35 PM
L1-06_node.txt                              56 9/10/2026 2:10:34 PM
L1-06_role.txt                              88 9/10/2026 2:10:34 PM
L1-06_role_20260910_141410.txt             310 9/10/2026 2:14:18 PM
L1-08_evidence_list.txt                   2028 9/10/2026 2:11:52 PM
L1-08_evidence_list_20260910_141410.txt      0 9/10/2026 2:14:18 PM


---END---

### FILE: L1-08_evidence_list_20260910_141649.txt | 2636 bytes
---BEGIN---

Name                                    Length LastWriteTime       
----                                    ------ -------------       
L1-00_identity_20260910_141410.txt         898 9/10/2026 2:14:15 PM
L1-00_timestamp_20260910_141410.txt         42 9/10/2026 2:14:12 PM
L1-01_cpu_20260910_141410.txt              544 9/10/2026 2:14:16 PM
L1-01_cpu_load_20260910_141410.txt         210 9/10/2026 2:14:17 PM
L1-02_mem_20260910_141410.txt              272 9/10/2026 2:14:17 PM
L1-02_swap_20260910_141410.txt             302 9/10/2026 2:14:17 PM
L1-03_disks_20260910_141410.txt           1110 9/10/2026 2:14:17 PM
L1-03_partitions_20260910_141410.txt      2222 9/10/2026 2:14:17 PM
L1-03_volumes_20260910_141410.txt         1134 9/10/2026 2:14:17 PM
L1-04_battery_20260910_141410.txt            0 9/10/2026 2:14:17 PM
L1-04_battery_STATUS.txt                   234 9/10/2026 2:16:49 PM
L1-04_powercfg_20260910_141410.txt         164 9/10/2026 2:14:17 PM
L1-04_thermal_20260910_141410.txt          262 9/10/2026 2:14:17 PM
L1-05_peripherals_20260910_141410.txt     6566 9/10/2026 2:14:18 PM
L1-06_role_20260910_141410.txt             310 9/10/2026 2:14:18 PM
L1-08_evidence_list_20260910_141410.txt   4706 9/10/2026 2:14:18 PM
L1-08_evidence_list_20260910_141649.txt      0 9/10/2026 2:16:49 PM


---END---

## NODE: Vivo

  (NO L1-06/07/08 files found — PARTIAL)

## NODE: Z83

### FILE: L1-06_role_z83_20260910_203615.txt | 1444 bytes
---BEGIN---
hostname: markas-utama
uptime: 1 day, 20:48, 4 users, load average 0.03 / 0.09 / 0.08

SERVICES RUNNING (top 19):
  cron.service                     Regular background program processing daemon
  dbus.service                     D-Bus System Message Bus
  fail2ban.service                 Fail2Ban Service
  fwupd.service                    Firmware update daemon
  getty@tty1.service               Getty on tty1
  ModemManager.service             Modem Manager
  networkd-dispatcher.service      Dispatcher daemon for systemd-networkd
  NetworkManager.service           Network Manager
  polkit.service                   Authorization Manager
  postfix.service                  Postfix Mail Transport Agent
  prometheus-node-exporter.service Prometheus exporter for machine metrics
  rsyslog.service                  System Logging Service
  snapd.service                    Snap Daemon
  ssh.service                      OpenBSD Secure Shell server
  systemd-journald.service         Journal Service
  systemd-logind.service           User Login Management
  systemd-networkd.service         Network Management
  systemd-oomd.service             Userspace OOM Killer
  systemd-resolved.service         Network Name Resolution

CATATAN:
  - Load sangat rendah (0.03/0.09/0.08)
  - Fail2ban aktif (keamanan SSH)
  - Prometheus node-exporter aktif (monitoring)
  - Postfix aktif (mail)
  - systemd-oomd aktif (pelindung OOM untuk RAM kecil)
---END---

### FILE: L1-07_capability_passport.yaml | 1965 bytes
---BEGIN---
passport:
  node: Z83
  hostname: markas-utama
  role: physical-role
  collected_at: 2026-09-10T20:29+07:00
  mode: read-only
  retention: zero

identity:
  os: Ubuntu 26.04 LTS (resolute)
  kernel: 7.0.0-31-generic
  arch: x86_64
  uptime: 1d 20h 42m
  load: [0.13, 0.15, 0.11]

compute:
  cpu: Intel Atom x5-Z8350
  cores: 4
  threads: 4
  freq_max_mhz: 1920
  freq_min_mhz: 480
  governor: schedutil
  vt_x: true
  l2_cache_mib: 2

memory:
  ram_total_kb: 3399724
  ram_available_kb: 2676740
  ram_used_mib: 706
  swap_total_kb: 8118264

storage:
  emmc_total_gb: 57.7
  root:
    device: /dev/mmcblk0p2
    fs: ext4
    size_gb: 56
    used_gb: 24
    free_gb: 30
    use_pct: 45
  boot_efi:
    device: /dev/mmcblk0p1
    fs: vfat
    size_gb: 1.1
  external:
    mount: /mnt/gdrive
    type: rclone
    size_gb: 400
    used_gb: 11
  zeroretention:
    mount: /var/log/mico-jdeq
    type: tmpfs
    size_mb: 10

thermal:
  zones: 6
  readings_c:
    acpitz: 46.6
    str0: 46.65
    int3400: 20
    pnit: 49
    soc_dts0: 48
    soc_dts1: 46
  power: axp288_charger_usb

io:
  usb:
    - primax_keyboard
    - root_hub_x2
  network:
    enp1s0: 192.168.1.11
    wlan0: 192.168.1.15
    tailscale0: 100.67.36.31
    docker0: down
  pci:
    - atom_soc
    - intel_integrated_graphics
    - realtek_gbe
  video:
    - /dev/dri/card1
    - renderD128

services_running:
  - cron
  - dbus
  - fail2ban
  - fwupd
  - getty@tty1
  - ModemManager
  - networkd-dispatcher
  - NetworkManager
  - polkit
  - postfix
  - prometheus-node-exporter
  - rsyslog
  - snapd
  - ssh
  - systemd-journald
  - systemd-logind
  - systemd-networkd
  - systemd-oomd
  - systemd-resolved

capabilities:
  - headless_compute
  - ssh_remote
  - tailscale_mesh
  - prometheus_metrics_export
  - fail2ban_protection
  - rclone_external_storage
  - zeroretention_logging

constraints:
  - no_install
  - no_config_change
  - no_file_write_on_z83
  - read_only

status: PASSPORT_READY
---END---

### FILE: L1-08_acceptance.md | 1407 bytes
---BEGIN---
# BERITA ACARA SONDIR L1 — NODE Z83

## IDENTITAS
- Node       : Z83 (markas-utama)
- Peran      : physical-role
- OS         : Ubuntu 26.04 LTS (resolute), kernel 7.0.0-31-generic
- Tailscale  : 100.67.36.31
- Waktu      : 2026-09-10 20:29 +07:00
- Mode       : read-only, zero-retention

## CAKUPAN
L1-00  Identitas sistem        : SELESAI
L1-01  CPU / compute           : SELESAI
L1-02  Memory                  : SELESAI
L1-03  Storage                 : SELESAI
L1-04  Thermal / power         : SELESAI
L1-05  I/O (USB/Net/PCI/Video) : SELESAI
L1-06  Physical role           : SELESAI
L1-07  Capability passport     : SELESAI (YAML)
L1-08  Acceptance              : SELESAI (dokumen ini)

## RINGKASAN KEMAMPUAN
- Headless compute (Atom x5-Z8350, 4C, 3.2 GiB RAM, swap 7.7 GiB)
- Storage internal eMMC 57.7 GB (root 45% used) + rclone 400 GB
- Jaringan: LAN, WiFi, Tailscale mesh
- Remote: ssh, tailscale, prometheus-node-exporter
- Proteksi: fail2ban
- Zero-retention logging: /var/log/mico-jdeq (tmpfs 10 MB)

## BUKTI
D:\MICO_SSOT\08_EVIDENCE\L1\Z83\
  - L1-00 ... L1-05 (6 file)
  - L1-07_capability_passport.yaml
  - L1-08_acceptance.md

## KESIMPULAN
Z83 dinyatakan memenuhi seluruh kriteria sondir L1.
Status akhir: AUDIT_READY.
Rekomendasi: siap masuk tahap berikutnya (L2) setelah perintah L0.

Tanda tangan:
  Executor : Senior Technical Executor
  Reviewer : L0
  Status   : AUDIT_READY
---END---

### FILE: L1_Z83_CLOSURE_DECLARATION.yml | 1572 bytes
---BEGIN---
deklarasi_penutupan:
  node: Z83 (markas-utama)
  tanggal: 2026-09-10 23:20
  diputuskan_oleh: L0 — Iswan Juman Pancoro, S.T.
  status: L1_Z83_CLOSED_WITH_PUNCH_LIST
  dasar: Keputusan langsung L0 sebagai otoritas mutlak

  cakupan_penutupan:
    - L1-00 s/d L1-06: TERKUMPUL, DITUTUP
    - L1-07 paspor: DITUTUP sebagai draft
    - L1-08 acceptance: DITUTUP
    - L1-AUDIT_PERMS: DITUTUP
    - L1-PERMS_CLEANUP: DITUTUP

  punch_list_terbuka:
    - id: Z83-T05
      isi: 6 koneksi UNKNOWN (laporan 09 Sep)
      status: register L2/keamanan
      butuh: review L2

  punch_list_closed:
    - id: Z83-T01
      isi: .secrets 775->700
      status: SELESAI (executed by L0)
    - id: Z83-T02
      isi: gdrive_token.json 644->600
      status: SELESAI (executed by L0)
    - id: Z83-T03
      isi: TEMPEL_* 664->600
      status: SELESAI (executed by L0)
    - id: Z83-T04
      isi: File junk 0-byte dihapus
      status: SELESAI (executed by L0)

  verdict_auditor:
    kimi: PASS_WITH_NOTES
    dola: LULUS_DENGAN_CATATAN

  larangan_setelah_penutupan:
    - Tidak ada perubahan file di L1/Z83/ tanpa Task Card baru
    - Tidak ada klaim L1 verified sampai KIMI verdict ulang (jika diminta)
    - Tidak naik ke L2 tanpa ACC L0 baru

  klaim_sah:
    - "L1 Z83 ditutup atas keputusan L0."
    - "Tidak ditemukan bukti kehilangan data pada evidence yang diperiksa."
    - "Mutasi terbatas: chmod 6 path + rm 4 file junk (executed by L0)."
    - "Tidak ada instalasi software."

  bukti_root: D:\MICO_SSOT\08_EVIDENCE\L1\Z83\
  total_file: 11

  next_node: Vivo Y28
---END---

=== END OF BUNDLE ===
