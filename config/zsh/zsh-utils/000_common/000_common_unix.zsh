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
