disable_laptop_keyboard()
{
  # get id $(xinput list)
  xinput float 13
}

enable_laptop_keyboard()
{
  xinput reattach 13 3
}

