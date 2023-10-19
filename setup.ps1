$ErrorActionPreference = 'Stop'

# windows powershellじゃないと動かなさそう
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe

# winget install Microsoft.PowerToys wez.wezterm Microsoft.PowerShell Microsoft.WindowsTerminal Obsidian.Obsidian
winget install --silent Microsoft.PowerToys Microsoft.WindowsTerminal Microsoft.VisualStudioCode Amazon.NoSQLWorkbench
winget install JanDeDobbeleer.OhMyPosh -s winget

wsl --install 

# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# iwr -useb https://raw.githubusercontent.com/bundai223/dotfiles/main/install.ps1 | iex
