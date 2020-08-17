#Requires -Version 5

# enable wsl2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

wsl --set-default-version 2

# install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

$known_buckets = @(
  'extras'
)
$unknown_buckets = @(
  @{name = 'bundai223'; url = 'https://github.com/bundai223/scoop-for-jp'},
  @{name = 'anurse'; url = 'https://github.com/anurse/scoop-bucket'}, # 
  @{name = 'sh4869221b'; url = 'https://github.com/sh4869221b/scoop-bucket'}, # virtualbox
  @{name = 'wangzq'; url = 'https://github.com/wangzq/scoop-bucket'}
)
$apps = @(
  'googlechrome',
  'brave',
  'vivaldi',
  '7zip',
  'keypirinha',
  'bitwarden',
  'vcxsrv',
  'phraseexpress',
  'screentogif',
  'vscode',
  'vagrant',
  'zeal',
  'skk-fep',
  'thilmera7',
  'ctrl2cap',
  # 'buttercup',
  # 'screenpresso',
  # 'screeninfo', # https://v2.rakuchinn.jp/
  'pwsh',
  'sudo',
  'vim',
  'windows-terminal'
)
  
# add bucekts
scoop install git # bucketインストールにはgit必要
$known_buckets | % { scoop bucket add $_ }
$unknown_buckets | % { scoop bucket add $_['name'] $_['url'] }

# install app
$apps | % { scoop install $_ }

# install powershell module
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

# symlink
New-Item -Value "$HOME\ghq\github.com\bundai223\dotfiles\config\WindowsTerminal.settings.json" -Path "$HOME\AppData\Local\Microsoft\Windows Terminal" -Name settings.json -ItemType SymbolicLink
New-Item -Value "$HOME\ghq\github.com\bundai223\dotfiles\config\Microsoft.PowerShell_profile.ps1" -Path "$HOME\Documents\PowerShell" -Name Microsoft.PowerShell_profile.ps1 -ItemType SymbolicLink

# Storeアプリインストールしてちょ
echo '* Please install store apps.'
echo '* Launch WindowsStore app.'
Start-Process shell:AppsFolder\Microsoft.WindowsStore_8wekyb3d8bbwe!App
