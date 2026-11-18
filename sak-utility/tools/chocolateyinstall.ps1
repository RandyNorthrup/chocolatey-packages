$ErrorActionPreference = 'Stop'

$installDir = Join-Path (Get-ToolsLocation) 'sak-utility'
$dataDir = Join-Path $installDir 'data'
$exePath = Join-Path $installDir 'sak_utility.exe'

# An upgrade replaces the program files and keeps the app's data folder.
if (Test-Path -LiteralPath $installDir) {
  Get-ChildItem -LiteralPath $installDir -Force |
    Where-Object { $_.Name -ne 'data' } |
    Remove-Item -Recurse -Force
} else {
  New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Only SYSTEM and Administrators may change the program files; Users may read and run them.
& icacls.exe $installDir /inheritance:r /grant:r '*S-1-5-18:(OI)(CI)F' '*S-1-5-32-544:(OI)(CI)F' '*S-1-5-32-545:(OI)(CI)RX' | Out-Null
if ($LASTEXITCODE -ne 0) { throw "icacls failed on $installDir (exit $LASTEXITCODE)" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $installDir
  url64bit       = 'https://github.com/RandyNorthrup/S.A.K.-Utility/releases/download/v0.9.3/SAK-Utility-Windows-x64.zip'
  checksum64     = '4DE827F7ED62A550AB2C0038E02EF3761C3148BF76CB97F858132A6B33FC0E70'
  checksumType64 = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

# The app keeps its settings, logs and reports here and refuses to start if it cannot write to it.
if (-not (Test-Path -LiteralPath $dataDir)) {
  New-Item -ItemType Directory -Path $dataDir | Out-Null
}
& icacls.exe $dataDir /grant '*S-1-5-32-545:(OI)(CI)M' | Out-Null
if ($LASTEXITCODE -ne 0) { throw "icacls failed on $dataDir (exit $LASTEXITCODE)" }

Install-BinFile -Name 'sak-utility' -Path $exePath -UseStart

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'S.A.K. Utility.lnk'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $exePath -WorkingDirectory $installDir