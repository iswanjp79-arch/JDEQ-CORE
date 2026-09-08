$root = "D:\MICO_SSOT\TREE_L"
$backupRoot = Join-Path $root "12_BACKUP\LOCAL"
$manifestDir = Join-Path $root "12_BACKUP\MANIFEST"
$evidenceDir = Join-Path $root "08_EVIDENCE\RUNTIME"

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = Join-Path $backupRoot "backup_$timestamp"
New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null

$filesToBackup = @(
    "$root\09_GOVERNANCE\ADR\ADR-0001-arsitektur-dasar-mico-jdeq-pc5.md",
    "$root\09_GOVERNANCE\ADR\ADR-0002-credential-vault-zero-trust.md",
    "$root\09_GOVERNANCE\POLICY\SOP-001.md",
    "$root\09_GOVERNANCE\POLICY\SOP-002.md",
    "$root\09_GOVERNANCE\POLICY\SOP-003.md",
    "$root\09_GOVERNANCE\POLICY\PROMPT_GENERATOR_TEMPLATE.md",
    "$root\03_LOGIKA\KERNEL_RULES.md",
    "$root\05_PIPELINE\PIPELINE_FLOW.md",
    "$root\08_EVIDENCE\EVIDENCE_TEMPLATE.json",
    "$root\06_RUNTIME\healthcheck.ps1",
    "$root\CHANGELOG.md",
    "$root\INDEKS_MASTER.md"
)

$manifest = @()
foreach ($file in $filesToBackup) {
    if (Test-Path $file) {
        $dest = Join-Path $backupFolder (Split-Path $file -Leaf)
        Copy-Item $file -Destination $dest -Force
        $hash = (Get-FileHash $dest -Algorithm SHA256).Hash
        $manifest += [PSCustomObject]@{
            source = $file
            backup_file = $dest
            sha256 = $hash
        }
    } else {
        Write-Output "LEWATI: $file"
    }
}

$manifestPath = Join-Path $manifestDir "backup_manifest_$timestamp.json"
$manifest | ConvertTo-Json -Depth 3 | Out-File $manifestPath -Encoding UTF8

$evidence = @()
$evidence += "BACKUP_OTOMATIS"
$evidence += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$evidence += "Folder: $backupFolder"
$evidence += "Manifest: $manifestPath"
$evidence += "Jumlah file: $($manifest.Count)"
$evidencePath = Join-Path $evidenceDir "BACKUP_BUILD_$timestamp.txt"
$evidence | Out-File $evidencePath -Encoding UTF8

Write-Output "Backup selesai: $backupFolder"
Write-Output "Manifest: $manifestPath"
Write-Output "Evidence: $evidencePath"
