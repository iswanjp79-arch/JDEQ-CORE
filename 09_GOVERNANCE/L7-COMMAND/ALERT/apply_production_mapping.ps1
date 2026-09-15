Param(
  [string]$RepoRoot = "D:\MICO_SSOT",
  [string]$MappingFile = "D:\MICO_SSOT\09_GOVERNANCE\L7-COMMAND\ALERT\production_mapping.csv",
  [string[]]$FileGlobs = @("**\*.sh","**\*.ps1","**\*.yaml","**\*.json","**\*.md")
)

if (-not (Test-Path $MappingFile)) {
  Write-Error "Mapping file not found: $MappingFile"
  exit 1
}

$map = Import-Csv -Path $MappingFile -Header Placeholder,ReplaceValue
Push-Location $RepoRoot

foreach ($glob in $FileGlobs) {
  $files = Get-ChildItem -Path $RepoRoot -Recurse -Include $glob -File -ErrorAction SilentlyContinue
  foreach ($f in $files) {
    $content = Get-Content -Raw -Path $f.FullName -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }
    $orig = $content
    foreach ($m in $map) {
      $content = $content -replace [regex]::Escape($m.Placeholder), $m.ReplaceValue
    }
    if ($content -ne $orig) {
      Copy-Item -Path $f.FullName -Destination ($f.FullName + ".bak") -Force
      $content = $content -replace "`r`n","`n"
      Set-Content -Path $f.FullName -Value $content -Encoding utf8
      Write-Output "Patched $($f.FullName)"
    }
  }
}

Pop-Location
Write-Output "Production mapping applied. Review changes and commit."
