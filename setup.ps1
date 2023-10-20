$ErrorActionPreference = 'Stop'

# windows powershellじゃないと動かなさそう
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe

winget install --silent Microsoft.PowerToys Microsoft.VisualStudioCode Amazon.NoSQLWorkbench
winget install --silent Buttercup.Buttercup KeeWeb.KeeWeb win32yank
winget install JanDeDobbeleer.OhMyPosh -s winget
winget install --silent XPFCXLSGH2H786 # msstore CorvusSKK
winget install --silent 9N0DX20HK701 # msstore Windows Terminal
winget install --silent 9N3GRQTX1QPF # Screenpresso

wsl --install 

# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# iwr -useb https://raw.githubusercontent.com/bundai223/dotfiles/main/install.ps1 | iex
