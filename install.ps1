#Requires -Version 5

# install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

$known_buckets = @(
  'extras'
)
$unknown_buckets = @(
  @{name = 'jp'; url = 'https://github.com/rkbk60/scoop-for-jp'}
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
  # 'buttercup',
  # 'screenpresso',
  # 'thilmera7',
  # 'skkfep',
  # 'hhkbconfig',
  # 'screeninfo', # https://v2.rakuchinn.jp/
  'sudo'
)
  
# add bucekts
$known_buckets | % { scoop bucket add $_ }
$unknown_buckets | % { scoop bucket add $_['name'] $_['url'] }

# install app
$apps | % { scoop install $_ }
