# healthcheck.ps1 — Denyut Nadi PC-i5 (Read-Only)

$os = Get-CimInstance Win32_OperatingSystem
$diskC = Get-PSDrive C -ErrorAction SilentlyContinue
$diskD = Get-PSDrive D -ErrorAction SilentlyContinue

$ramFreeMB = [math]::Round($os.FreePhysicalMemory / 1KB, 2)
$ramTotalMB = [math]::Round($os.TotalVisibleMemorySize / 1KB, 2)

$pingOK = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet

$tailscale = Get-Service Tailscale -ErrorAction SilentlyContinue
$tailscaleStatus = if ($tailscale) { $tailscale.Status.ToString() } else { "NOT_FOUND" }

$result = [PSCustomObject]@{
    node_id          = "KAPAL-INDUK"
    timestamp        = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ram_free_mb      = $ramFreeMB
    ram_total_mb     = $ramTotalMB
    disk_c_free_gb   = if ($diskC) { [math]::Round($diskC.Free / 1GB, 2) } else { 0 }
    disk_d_free_gb   = if ($diskD) { [math]::Round($diskD.Free / 1GB, 2) } else { 0 }
    ping_internet    = $pingOK
    tailscale_status = $tailscaleStatus
}

$result | ConvertTo-Json
