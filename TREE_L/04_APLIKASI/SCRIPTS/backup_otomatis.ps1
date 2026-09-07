# backup_otomatis.ps1
# Tujuan: Backup folder MICO SSOT & Knowledge Base ke arsip harian
$SumberUtama = "D:\MICO_SSOT"
$SumberKnowledge = "D:\MICO_SSOT\KNOWLEDGE_BASE"
$SumberDatabase = "D:\MICO\database"
$TargetBackup = "D:\MICO_ARCHIVE\BACKUP_OTOMATIS"

# Buat timestamp
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$FolderTujuan = Join-Path $TargetBackup $Stamp

# Buat folder tujuan
New-Item -ItemType Directory -Path $FolderTujuan -Force | Out-Null

# Fungsi copy folder
function Backup-Folder {
    param([string]$Src, [string]$Dest)
    if (Test-Path $Src) {
        $folderName = Split-Path $Src -Leaf
        robocopy $Src (Join-Path $Dest $folderName) /E /R:1 /W:1 /NFL /NDL /NP | Out-Null
        Write-Output "BACKUP OK: $Src -> $(Join-Path $Dest $folderName)"
    } else {
        Write-Output "LEWATI: $Src tidak ditemukan"
    }
}

# Eksekusi backup
Backup-Folder -Src $SumberUtama -Dest $FolderTujuan
Backup-Folder -Src $SumberKnowledge -Dest $FolderTujuan
Backup-Folder -Src $SumberDatabase -Dest $FolderTujuan

Write-Output "SELESAI: Backup tersimpan di $FolderTujuan"
