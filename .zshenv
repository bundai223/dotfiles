# 共通設定の記述と環境毎のファイル読み込み

export GHQ_ROOT=~/repos
export PERSONAL_ZSH_DIR=${GHQ_ROOT}/github.com/bundai223/dotfiles/zsh

fpath=(~/repos/github.com/zsh-users/zsh-completions/src(N-/) $fpath)
fpath=(${PERSONAL_ZSH_DIR}/functions/completions(N-/) $fpath)
#fpath=(/usr/local/share/zsh/site-functions(N-/) $fpath)

export PATH=/usr/bin:/bin:/usr/sbin:/sbin
path=(${PERSONAL_ZSH_DIR}/functions(N-/) $path)

GITHUB_TOKEN_PATH=~/.config/git/github_token
if [ -f $GITHUB_TOKEN_PATH ]; then
    export HOMEBREW_GITHUB_API_TOKEN=`cat $GITHUB_TOKEN_PATH`
else
    echo "Please access: https://github.com/settings/tokens and put token to $GITHUB_TOKEN_PATH."
fi

# ローカル用設定を読み込む
if [ -f ~/.zshenv_local ]; then
    source ~/.zshenv_local
fi

