$ErrorActionPreference = 'Stop'

$installDir = Join-Path (Get-ToolsLocation) 'sak-utility'
$dataDir = Join-Path $installDir 'data'

Uninstall-BinFile -Name 'sak-utility'

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'S.A.K. Utility.lnk'
if (Test-Path -LiteralPath $shortcut) {
  Remove-Item -LiteralPath $shortcut -Force
}

if (Test-Path -LiteralPath $installDir) {
  Get-ChildItem -LiteralPath $installDir -Force |
    Where-Object { $_.Name -ne 'data' } |
    Remove-Item -Recurse -Force
  if (Test-Path -LiteralPath $dataDir) {
    Write-Host "S.A.K. Utility's settings, logs and reports were kept in $dataDir. Delete that folder to remove them."
  } else {
    Remove-Item -LiteralPath $installDir -Force
  }
}