vagrant_list()
{
  vagrant status | tail -n +3 | head -n -4 | awk '{print $1}'
}
