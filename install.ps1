#Requires -Version 5

# install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

$known_buckets = @(
  'extras'
)
$unknown_buckets = @(
  @{name = 'bundai223'; url = 'https://github.com/bundai223/scoop-for-jp'},
  @{name = 'anurse'; url = 'https://github.com/anurse/scoop-bucket'}, # 
  @{name = 'sh4869221b'; url = 'https://github.com/sh4869221b/scoop-bucket'}, # virtualbox
  @{name = 'wangzq'; url = 'https://github.com/wangzq/scoop-bucket'} # powershell-core
)
$apps = @(
  'googlechrome',
  'brave',
  'vivaldi',
  '7zip',
  'bitwarden',
  'hain',
  'vcxsrv',
  'phraseexpress',
  'screentogif',
  'vscode',
  'vagrant',
  'zeal',
  'skk-fep',
  'thilmera7',
  'hhkbcng',
  'ctrl2cap',
  # 'buttercup',
  # 'screenpresso',
  # 'screeninfo', # https://v2.rakuchinn.jp/
  'sudo'
)
  
# add bucekts
scoop install git # bucketインストールにはgit必要
$known_buckets | % { scoop bucket add $_ }
$unknown_buckets | % { scoop bucket add $_['name'] $_['url'] }

# install app
$apps | % { scoop install $_ }

# Storeアプリインストールしてちょ
echo '* Please install store apps.'
echo '* Launch WindowsStore app.'
Start-Process shell:AppsFolder\Microsoft.WindowsStore_8wekyb3d8bbwe!App
