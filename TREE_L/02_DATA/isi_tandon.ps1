# isi_tandon.ps1 — Isi tandon air bersih lokal (Local Mirror)
$root = "D:\MICO_SSOT\TREE_L"
$tandon = "$root\02_DATA\TANDON_UPDATE"
New-Item -ItemType Directory -Path $tandon -Force | Out-Null

$sumber = @(
    "$root\09_GOVERNANCE\POLICY",
    "$root\03_LOGIKA\KERNEL_RULES.md",
    "$root\05_PIPELINE\PIPELINE_FLOW.md",
    "$root\08_EVIDENCE\EVIDENCE_TEMPLATE.json",
    "$root\06_RUNTIME\healthcheck.ps1",
    "$root\12_BACKUP\LOCAL\backup_otomatis.ps1"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$manifest = @()

foreach ($src in $sumber) {
    if (Test-Path $src) {
        if ((Get-Item $src).PSIsContainer) {
            $files = Get-ChildItem $src -File -Recurse
        } else {
            $files = Get-Item $src
        }

        foreach ($f in $files) {
            $rel = $f.FullName.Substring($root.Length + 1).Replace("\", "_")
            $dest = Join-Path $tandon $rel
            Copy-Item $f.FullName -Destination $dest -Force
            $hash = (Get-FileHash $dest -Algorithm SHA256).Hash
            $manifest += [PSCustomObject]@{
                source = $f.FullName
                tandon_file = $dest
                sha256 = $hash
            }
        }
    }
}

$manifestPath = Join-Path $tandon "tandon_manifest_$timestamp.json"
$manifest | ConvertTo-Json -Depth 4 | Out-File $manifestPath -Encoding UTF8

Write-Output "Tandon terisi: $($manifest.Count) file"
Write-Output "Manifest: $manifestPath"
