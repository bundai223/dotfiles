# download myrepos

myrepos = [
  'bundai223/dotfiles',
  'bundai223/terminal-tools',
  'bundai223/myvim_dict',
  'bundai223/dash_snippet',
  'bundai223/mysnip',
  'bundai223/vim-template',
  'bundai223/powerline-ext-tmux',
  'bundai223/blog.bundai223',
  'bundai223/bundai223.github.io',
  'git@gitlab.com:bundai223/private-memo.git'
]
myrepos.each { |name| get_repo name }

install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Discord_Regular_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Discord_Oblique_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Discord_Bold_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Discord_Bold_Oblique_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Regular_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Bold_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Bold_Oblique_for_Powerline.ttf"
install_font "#{node[:home]}/repos/gitlab.com/bundai223/RictyDiminished-for-Powerline/Ricty_Diminished_Oblique_for_Powerline.ttf"
