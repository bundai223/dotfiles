#.bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

eval "$(rbenv init -)"
