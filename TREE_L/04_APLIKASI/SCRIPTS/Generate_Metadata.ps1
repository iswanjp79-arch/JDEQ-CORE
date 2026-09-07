$targetFolder = "D:\MICO_SSOT\KNOWLEDGE_BASE\03_FOTO_PROYEK"
$files = Get-ChildItem -Path $targetFolder -Filter "*.jpg"

foreach ($file in $files) {
    $mdPath = "$($file.FullName).md"
    
    if (-Not (Test-Path $mdPath)) {
        $dateStr = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $content = @"
---
Judul: $($file.Name)
Tanggal: $dateStr
Path_Asli: $($file.FullName)
Deskripsi_AI: [KOSONG]
Status_RAG: PENDING_EMBEDDING
---
"@
        Set-Content -Path $mdPath -Value $content -Encoding UTF8
        Write-Output "[CREATED] Ghost Metadata kanggé $($file.Name)"
    } else {
        Write-Output "[SKIPPED] Metadata wus ana kanggé $($file.Name)"
    }
}
Write-Output "Siklus Tahap 1 - Ghost Metadata SELESAI."
