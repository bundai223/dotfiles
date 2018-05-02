py_help() {
    target=$1
    python -c "import ${target}; help(${target})"
}

py3_help() {
    target=$1
    python3 -c "import ${target}; help(${target})"
}


# pip zsh completion start
function _pip3_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip3_completion pip3
# pip zsh completion end

