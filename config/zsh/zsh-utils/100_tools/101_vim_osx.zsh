# 
# guiのvimを開く関数
# ウインドウは一つしか開かない設定で起動
# - or +で始まる引数をもっていたら引数任せ
# 
mvim() {
    if [[ -z $1 || $1 =~ "^[-+]" ]]; then
        /Applications/MacVim.app/Contents/MacOS/mvim $*
    else
        /Applications/MacVim.app/Contents/MacOS/mvim --remote-tab-silent $*
    fi
}


