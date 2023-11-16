$ErrorActionPreference = 'Stop'

mkdir -Force -p ${HOME}/repos/github.com/bundai223/
git clone https://github.com/bundai223/dotfiles.git ${HOME}/repos/github.com/bundai223/dotfiles

# symlink
mkdir -Force -p "$HOME\AppData\Local\Microsoft\Windows Terminal"
mkdir -Force -p "$HOME\Documents\PowerShell"
mkdir -Force -p "$HOME\.config"

New-Item -Value "$HOME\repos\github.com\bundai223\dotfiles\config\WindowsTerminal\settings.json" -Path "$HOME\AppData\Local\Microsoft\Windows Terminal" -Name settings.json -ItemType SymbolicLink
New-Item -Value "$HOME\repos\github.com\bundai223\dotfiles\config\Microsoft.PowerShell_profile.ps1" -Path "$HOME\Documents\PowerShell" -Name Microsoft.PowerShell_profile.ps1 -ItemType SymbolicLink
New-Item -Value "$HOME\repos\github.com\bundai223\dotfiles\config\.gitconfig" -Path "$HOME\" -Name .gitconfig -ItemType SymbolicLink
New-Item -Value "$HOME\repos\github.com\bundai223\dotfiles\config\.config\wezterm" -Path "$HOME\.config\" -Name wezterm -ItemType SymbolicLink
New-Item -Value "$HOME\repos\github.com\bundai223\dotfiles\config\CorvusSKK" -Path "$HOME\AppData\Roaming\" -Name CorvusSKK -ItemType SymbolicLink

# wingetデデキルヨ
# Storeアプリインストールしてちょ
# echo '* Please install store apps.'
# echo '* Launch WindowsStore app.'
# Start-Process shell:AppsFolder\Microsoft.WindowsStore_8wekyb3d8bbwe!App
