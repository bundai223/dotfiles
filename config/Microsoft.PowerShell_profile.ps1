# bashっぽいバインド
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
# 標準だと Ctrl+d は DeleteCharOrExit のため、うっかり端末が終了することを防ぐ
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar

# Get-PSReadLineKeyHandler -Key Tab
# EditMode Emacs 標準のタブ補完
Set-PSReadLineKeyHandler -Key Tab -Function Complete
# メニュー補完に変更
# Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete


function CustomHosts { code C:\Windows\System32\drivers\etc\hosts }
Set-Alias hosts CustomHosts

Set-Alias dc docker-compose
Set-Alias d docker
Set-Alias g git
Set-Alias v vagrant
Set-Alias hosts CustomHosts
function RunWhich { gcm $args | fl }
Set-Alias which RunWhich

function RunNpx {
  docker run -it --rm -v "$(pwd):/workspace" --workdir "/workspace" node:alpine3.12 npx $args
}
Set-Alias npx RunNpx

function RunNpm {
  docker run -it --rm -v "$(pwd):/workspace" --workdir "/workspace" node:alpine3.12 npm $args
}
Set-Alias npm RunNpm

function RunHocho {
  # docker run -it --rm hocho:latest
  docker run -v "${home}/.ssh:/tmp/.ssh:ro" -v "$(pwd):/data" --rm -it hocho:latest $args
}
Set-Alias hocho RunHocho

function RunSpacemacs {
  docker run -it --rm `
    --name spacemacs `
    -e DISPLAY="host.docker.internal:0.0" `
    -v //var/run/docker.sock:/var/run/docker.sock `
    -v "$HOME/.ssh:/root/.ssh" `
    -v "$HOME/ghq:/root/ghq" `
    -v "$HOME/ghq:/root/repos" `
    -v "$HOME/.gitconfig:/root/.gitconfig" `
    -v "$HOME/.bashrc:/root/.bashrc" `
    -v "$HOME/ghq/github.com/bundai223/dotfiles/config/SKK-JISYO.L:/root/.skk-jisyo" `
    -v "dotemacs:/root/.emacs.d" `
    -v "dotasdf:/root/.asdf" `
    -v "dotlocal:/root/.local" `
    -v "aptlists:/var/lib/apt/lists" `
    -v "$HOME/ghq/github.com/bundai223/dotfiles/config/.spacemacs:/root/.spacemacs" `
    bundai223/spacemacs `
    emacs --insecure
}
Set-Alias emacs RunSpacemacs

function RunBashSpacemacs {
  docker run -it --rm `
    --name spacemacs `
    -e DISPLAY="host.docker.internal:0.0" `
    -v //var/run/docker.sock:/var/run/docker.sock `
    -v "$HOME/.ssh:/root/.ssh" `
    -v "$HOME/ghq:/root/ghq" `
    -v "$HOME/ghq:/root/repos" `
    -v "$HOME/.gitconfig:/root/.gitconfig" `
    -v "$HOME/.bashrc:/root/.bashrc" `
    -v "dotemacs:/root/.emacs.d" `
    -v "dotasdf:/root/.asdf" `
    -v "dotlocal:/root/.local" `
    -v "aptlists:/var/lib/apt/lists" `
    -v "$HOME/ghq/github.com/bundai223/dotfiles/config/.spacemacs:/root/.spacemacs" `
    bundai223/spacemacs `
    bash
    # -v "$HOME/ghq/github.com/bundai223/dotfiles/config/.spacemacs:/root/.skk-jisho" `
}
Set-Alias bash_emacs RunBashSpacemacs

# Rails static analyser
function RunBrakeman {
  docker run -v "$(pwd):/code" presidentbeef/brakeman --color
}
Set-Alias brakeman RunBrakeman


$env:REDMINE_HOST = 'https://redmine-system-dev.k-idea.jp/redmine/'
$env:REDMINE_APIKEY = 'c6ef4868d80e60ff521ae2fb332e23dfc2e25251'
$env:LESSCHARSET = 'utf-8'
$env:LANG = 'ja_JP.UTF-8'

function prompt() {
 "PS " + (Split-Path (Get-Location) -Leaf) + "> "
}
Set-Alias pwd Get-Location

function RunIdp {
  Param([string]$entity_id, [string]$assertion_consumer_service, [string]$single_logout_service)

  docker run --rm --name=testsamlidp `
    -p "8080:8080" `
    -v "${HOME}/ghq/gitlab-system-dev.k-idea.jp\sys-dev\ai_system\ai_package\Mitsubishi_H_I\ai_q/lib/idp/authsources.php:/var/www/simplesamlphp/config/authsources.php" `
    -e SIMPLESAMLPHP_SP_ENTITY_ID="$entity_id" `
    -e SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE="$assertion_consumer_service" `
    -e SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE="$single_logout_service" `
    -d kristophjunge/test-saml-idp
}
function StopIdp {
  docker stop testsamlidp
}
Set-Alias idp RunIdp
Set-Alias idp_stop StopIdp

function RunAws {
  docker run -it --rm --name=awscli -v ~/.aws:/root/.aws lorentzca/aws $args
}
Set-Alias aws RunAws

# fzfでghq look
function gf {
  $path = ghq list | fzf
  if ($LastExitCode -eq 0) {
    cd "$(ghq root)\$path"
  }
}

# cdの履歴をzで利用できるように
Import-Module ZLocation

# powerline for powershell
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
