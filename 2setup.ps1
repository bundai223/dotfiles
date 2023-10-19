#Requires -Version 5
$ErrorActionPreference = 'Stop'

# wsl --install

# nankano policy
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# install scoop
# Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

$known_buckets = @(
  'extras',
  'nerd-fonts'
)
$unknown_buckets = @(
  @{name = 'bundai223'; url = 'https://github.com/bundai223/scoop-for-jp'},
  @{name = 'anurse'; url = 'https://github.com/anurse/scoop-bucket'}, # 
  @{name = 'sh4869221b'; url = 'https://github.com/sh4869221b/scoop-bucket'}, # virtualbox
  @{name = 'wangzq'; url = 'https://github.com/wangzq/scoop-bucket'}
)
$apps = @(
  'firacode',
  'ghq',
  'vivaldi',
  '7zip',
  'bitwarden',
  'screentogif',
  'zeal',
  'ctrl2cap',
  # 'screenpresso',
  # 'screeninfo', # https://v2.rakuchinn.jp/
  'pwsh',
  'sudo',
  'vim',
  'neovim',
  'vcredist',
  'obsidian',
  'wezterm'
)
  
# add bucekts
scoop install git # bucketインストールにはgit必要
$known_buckets | % { scoop bucket add $_ }
$unknown_buckets | % { scoop bucket add $_['name'] $_['url'] }

# install app
$apps | % { scoop install $_ }

# install powershell module
Install-Module posh-git -Scope CurrentUser
# Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSReadLine -RequiredVersion 2.1.0
Install-Module ZLocation -Scope CurrentUser

ssh-keygen -t ed25519 -C "bundai223@gmail.com"
