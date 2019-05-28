include_cookbook 'dotfiles'
include_cookbook 'ghq'

repos = [
  'dylanaraps/neofetch',
  'mzyy94/RictyDiminished-for-Powerline',
  'rupa/z',
  'yuru7/HackGen',
  'zsh-users/zsh-completions',
  'zplug/zplug',
]
repos.each { |name| get_repo name }

execute "#{sudo(node[:user])} pip install --user powerline-status"

package 'fontforge'
