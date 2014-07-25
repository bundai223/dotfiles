# 共通設定の記述と環境毎のファイル読み込み


# ローカル用設定を読み込む
if [ -f ~/.zshenv_local ]; then
    source ~/.zshenv_local
fi


