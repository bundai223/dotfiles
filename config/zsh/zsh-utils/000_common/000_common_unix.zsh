disable_laptop_keyboard()
{
  # get id $(xinput list)
  id=$(xinput list|grep Apple|sed 's/.*id=\([0-9]*\).*$/\1/g')
  xinput float $id
}

enable_laptop_keyboard()
{
  id=$(xinput list|grep Apple|sed 's/.*id=\([0-9]*\).*$/\1/g')
  xinput reattach $id 3
}

recovery-pacman() {
    sudo pacman "$@"  \
    --log /dev/null   \
    --noscriptlet     \
    --dbonly          \
    --overwrite       \
    --nodeps          \
    --needed
}

install_font () {
  dir=~/.local/share/fonts
  test -e $dir || mkdir -p $dir
  cp $@ $dir
  fc-cache -f
  sudo fc-cache -f
}
