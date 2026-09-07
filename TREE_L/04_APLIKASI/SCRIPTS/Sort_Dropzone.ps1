# ============================================
# TAHAP 1 - DO: Sort Dropzone ke Knowledge Base
# TARGET: Hanya D:\MICO_DROPZONE_EDUKASI
# ============================================

$Dropzone = "D:\MICO_DROPZONE_EDUKASI"
$Knowledge = "D:\MICO_SSOT\KNOWLEDGE_BASE"
$IndexCsv   = "D:\MICO_SSOT\DATA_INDEX_PLAN.csv"
$Unrecognized = Join-Path $Knowledge "99_UNRECOGNIZED"

# Pastikan folder tujuan ada
$folders = @{
    '.pdf'  = "02_PDF_TEKNIK"
    '.jpg'  = "03_FOTO_PROYEK"
    '.jpeg' = "03_FOTO_PROYEK"
    '.png'  = "03_FOTO_PROYEK"
    '.docx' = "01_MODUL"
    '.doc'  = "01_MODUL"
    '.txt'  = "01_MODUL"
    '.md'   = "01_MODUL"
}
$required = $folders.Values | Select-Object -Unique
foreach ($r in $required) {
    New-Item -ItemType Directory -Path (Join-Path $Knowledge $r) -Force | Out-Null
}
New-Item -ItemType Directory -Path $Unrecognized -Force | Out-Null

# Baca file di Dropzone
$files = Get-ChildItem -Path $Dropzone -File -Force -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Output "Dropzone kosong. Tidak ada file untuk diproses."
    # TIDAK MENGGUNAKAN exit agar PowerShell tidak tertutup
}
else {
    # Impor index CSV (jika ada)
    if (Test-Path $IndexCsv) {
        $index = Import-Csv $IndexCsv
    } else {
        $index = @()
    }

    foreach ($file in $files) {
        $ext = $file.Extension.ToLower()
        try {
            if ($folders.ContainsKey($ext)) {
                $destFolder = Join-Path $Knowledge $folders[$ext]
                $destPath = Join-Path $destFolder $file.Name

                # Hindari overwrite
                if (Test-Path $destPath) {
                    $base = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    $newName = "{0}_{1}{2}" -f $base, (Get-Date -Format "yyyyMMdd_HHmmss"), $file.Extension
                    $destPath = Join-Path $destFolder $newName
                }

                Move-Item -Path $file.FullName -Destination $destPath -Force
                $status = "PROCESSED"
                $destRelative = $destPath.Substring($Knowledge.Length + 1)
            } else {
                # File tidak dikenali -> karantina
                $destPath = Join-Path $Unrecognized $file.Name
                Move-Item -Path $file.FullName -Destination $destPath -Force
                $status = "UNRECOGNIZED"
                $destRelative = "99_UNRECOGNIZED\" + $file.Name
            }

            # Update index CSV
            $row = [PSCustomObject]@{
                source_path = $file.FullName
                source_type = $ext
                target_folder = $destFolder
                status = $status
                notes = ""
            }
            $index += $row
            Write-Output "[$status] $($file.Name) -> $destRelative"
        }
        catch {
            Write-Warning "Gagal memproses $($file.Name): $($_.Exception.Message)"
        }
    }

    # Simpan index
    $index | Export-Csv -Path $IndexCsv -NoTypeInformation -Encoding UTF8
    Write-Output "Selesai. Index diperbarui di $IndexCsv"
}
