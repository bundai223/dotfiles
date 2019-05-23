include_cookbook 'dotfiles'
include_cookbook 'ghq'

repos = [
  'mzyy94/RictyDiminished-for-Powerline',
  'zsh-users/zsh-completions',
  'zplug/zplug',
  'rupa/z',
  'dylanaraps/neofetch'
]
repos.each { |name| get_repo name }

execute "#{sudo(node[:user])} pip install --user powerline-status"

package 'fontforge'
