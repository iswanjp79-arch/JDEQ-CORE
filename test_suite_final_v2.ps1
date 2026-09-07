$root = "D:\MICO_SSOT\TREE_L"
$baselinePath = "D:\MICO_SSOT\BASELINE_HASHES.json"
$results = @()

function Test-Case { param($Name, $Condition, $Detail)
    $script:results += [PSCustomObject]@{
        Test = $Name; Status = if ($Condition) {"PASS"} else {"FAIL"}; Detail = $Detail
    }
}

# Baca baseline
$baseline = Get-Content $baselinePath | ConvertFrom-Json

# 1. Jumlah folder = 14
Test-Case "Jumlah folder 14" ((Get-ChildItem $root -Directory).Count -eq 14) "Folder: $((Get-ChildItem $root -Directory).Count)"

# 2. File kunci ada
Test-Case "KERNEL_LOCK.md ada" (Test-Path "$root\02_DATA\KERNEL_LOCK.md") "Path: 02_DATA"
Test-Case "KERNEL_LAYER_LOCK.json ada" (Test-Path "$root\08_EVIDENCE\KERNEL_LAYER_LOCK.json") "Path: 08_EVIDENCE"

# 3. File pemetaan 14 pilar ada
Test-Case "PEMETAAN_14_PILAR.md ada" (Test-Path "$root\03_LOGIKA\PEMETAAN_14_PILAR.md") "Path: 03_LOGIKA"

# 4. Baseline kapasitas ada
Test-Case "BASELINE_KAPASITAS_PC5.md ada" (Test-Path "$root\01_FISIK\BASELINE_KAPASITAS_PC5.md") "Path: 01_FISIK"

# 5. Batas agen ada
Test-Case "KEMAMPUAN_BATAS_AGEN.md ada" (Test-Path "$root\09_GOVERNANCE\KEMAMPUAN_BATAS_AGEN.md") "Path: 09_GOVERNANCE"

# 6. Pemetaan bahasa ada
Test-Case "PEMETAAN_BAHASA_14_PILAR.md ada" (Test-Path "$root\03_LOGIKA\PEMETAAN_BAHASA_14_PILAR.md") "Path: 03_LOGIKA"

# 7. Git repository ada
Test-Case "Git repo aktif" (Test-Path "D:\MICO_SSOT\.git") "Path: .git"

# 8. Hash sesuai baseline
$hash1 = (Get-FileHash "$root\02_DATA\KERNEL_LOCK.md" -Algorithm SHA256).Hash
Test-Case "Hash KERNEL_LOCK.md sesuai baseline" ($hash1 -eq $baseline.KERNEL_LOCK_MD) "Current: $hash1"

$hash2 = (Get-FileHash "$root\08_EVIDENCE\KERNEL_LAYER_LOCK.json" -Algorithm SHA256).Hash
Test-Case "Hash KERNEL_LAYER_LOCK.json sesuai baseline" ($hash2 -eq $baseline.KERNEL_LAYER_LOCK_JSON) "Current: $hash2"

# 9. File Vivo kunci ada
Test-Case "86m_neuron_definition.md ada" (Test-Path "$root\03_LOGIKA\VIVO_MASTER\86m_neuron_definition.md") "Path: VIVO_MASTER"
Test-Case "MASTER_PLAN_FINAL.md ada" (Test-Path "$root\02_DATA\VIVO_MASTER\MASTER_PLAN_FINAL.md") "Path: VIVO_MASTER"

# Hasil
Write-Output "`n=== HASIL TEST ==="
$results | Format-Table -AutoSize
$fail = ($results | Where-Object Status -eq "FAIL").Count
Write-Output "`nTOTAL FAIL: $fail"
Write-Output $(if ($fail -eq 0) {"STATUS: fail=0 TERCAPAI - BUKTI VALID"} else {"STATUS: MASIH ADA FAIL - PERIKSA"})
