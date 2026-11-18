# Chocolatey packages

Sources of the [Chocolatey](https://community.chocolatey.org/) packages for Randy Northrup's apps.

| Package | App | Install |
|---|---|---|
| [sak-utility](sak-utility) | [S.A.K. Utility](https://sakutility.com/), a free, portable Windows toolkit for PC technicians, IT pros, and sysadmins | `choco install sak-utility` |

## sak-utility

`tools/chocolateyinstall.ps1` downloads the official release ZIP from [GitHub Releases](https://github.com/RandyNorthrup/S.A.K.-Utility/releases), checks its SHA-256 (the value in the release's `SHA256SUMS.txt`), and extracts it to the Chocolatey tools location, `C:\tools\sak-utility` by default.

The app keeps its settings, logs and reports in a `data` folder beside `sak_utility.exe` and will not start from a read-only folder, so it cannot live in the package folder under `C:\ProgramData\chocolatey\lib`, which standard users can only read. In the tools location, the install script lets only SYSTEM and Administrators change the program files and gives every user write access to the `data` folder.

The package adds a `sak-utility` command (a shim for `sak_utility.exe` only; the other programs in the ZIP are not shimmed) and a Start menu shortcut. Uninstalling removes the program, the shim and the shortcut, and keeps the `data` folder.

To build and test locally:

```pwsh
cd sak-utility
choco pack
choco install sak-utility --source . -y
```

Problems with the app itself belong in the [S.A.K. Utility issues](https://github.com/RandyNorthrup/S.A.K.-Utility/issues).
