# 共通設定の記述と環境毎のファイル読み込み

export REPOS_ROOT=~/repos
export PERSONAL_ZSH_DIR=${REPOS_ROOT}/github.com/bundai223/dotfiles/config/zsh

fpath=($fpath ~/repos/github.com/zsh-users/zsh-completions/src(N-/))
fpath=($fpath ~/repos/github.com/bobthecow/git-flow-completion(N-/))
fpath=($fpath ${PERSONAL_ZSH_DIR}/functions/completions(N-/))

# export PATH=/usr/bin:/bin:/usr/sbin:/sbin
path=(${PERSONAL_ZSH_DIR}/functions(N-/) $path)

# GITHUB_TOKEN_PATH=~/.config/git/github_token
# if [ -f $GITHUB_TOKEN_PATH ]; then
#     export HOMEBREW_GITHUB_API_TOKEN=`cat $GITHUB_TOKEN_PATH`
# else
#     echo "Please access: https://github.com/settings/tokens and put token to $GITHUB_TOKEN_PATH."
# fi

export ZSH_HISTORY_FILE="$HOME/.config/zsh/zsh_histroy.db"
# peco などと組み合わせて検索するためのキーバインド
# # そのディレクトリで使用したコマンドしか候補に出さないか、
# # 今までの履歴を全部候補に出すか切り分けらる
export ZSH_HISTORY_KEYBIND_GET_BY_DIR="^r"
export ZSH_HISTORY_KEYBIND_GET_ALL="^r^a"
export FILTER_CMD=peco

# 専用のセレクタ I/F から SQL を実行する
export ZSH_HISTORY_KEYBIND_SCREEN="^r^r"

# substring 系のキーバインド
# BUFFER (コマンドライン) に何もなければ通常の動作
export ZSH_HISTORY_KEYBIND_ARROW_UP="^p"
export ZSH_HISTORY_KEYBIND_ARROW_DOWN="^n"

export PATH=${PERSONAL_ZSH_DIR}/functions:$PATH

# plugins
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# ローカル用設定を読み込む
if [ -f ~/.zshenv_local ]; then
  source ~/.zshenv_local
fi

# export NVIM_PYTHON_LOG_FILE=~/.config/nvim/nvim.log
# export NVIM_PYTHON_LOG_LEVEL=INFO#DEBUG
