# 共通設定の記述と環境毎のファイル読み込み

GHQ_ROOT=~/repos
PERSONAL_ZSH_DIR=${GHQ_ROOT}/github.com/bundai223/dotfiles/zsh

fpath=(~/repos/github.com/zsh-users/zsh-completions/src(N-/) $fpath)
fpath=(${PERSONAL_ZSH_DIR}/functions/completions(N-/) $fpath)
#fpath=(/usr/local/share/zsh/site-functions(N-/) $fpath)

PATH=/usr/bin:/bin:/usr/sbin:/sbin
path=(${PERSONAL_ZSH_DIR}/functions(N-/) $path)


# ローカル用設定を読み込む
if [ -f ~/.zshenv_local ]; then
    source ~/.zshenv_local
fi


PATH="~/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="~/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="~/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"~/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=~/perl5"; export PERL_MM_OPT;

