#Requires -Version 5

# install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

$buckets = 'extras'
$apps = 'googlechrome',
        'brave'
  
# add bucekts
$buckets | % { scoop bucket add $_ }

# install app
$a = $apps -join ' '
scoop install $a
