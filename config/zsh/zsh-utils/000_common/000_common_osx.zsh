# Displayの製造元を表示
# LP : LG製（はずれ）
# LSN : Samsung製（当たり）
display_info_15inch()
{
    ioreg -lw0 | grep \"EDID\" | sed "/[^<]*</s///" | xxd -p -r | strings -6
}

refresh_memory()
{
    du -sx / &> /dev/null & sleep 25 && kill $!
}

install_font() {
    cp $@ ~/Library/Fonts/
}

show_allfile_on_finder() {
    flag="$1"
    if [ "on" = $flag ]; then
        echo "Enable show all files on finder."
        defaults write com.apple.finder AppleShowAllFiles -boolean true
        killall Finder
    elif [ "off" = $flag ]; then
        echo "Reset show all files on finder."
        defaults delete com.apple.finder AppleShowAllFiles
        killall Finder
    else
        echo "usage:"
        echo "    show_allfile_on_finder [on|off]"
    fi
}

alias compile_plantuml="java -jar ~/local/bin/plantuml.jar  -charset UTF-8 -tsvg -nbthread auto $<"
