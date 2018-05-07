include_cookbook 'dotfiles'
include_cookbook 'git'
include_cookbook 'python'
include_cookbook 'go'
include_cookbook 'rust'
include_cookbook 'ruby'
include_cookbook 'tmux'
include_cookbook 'neovim'
include_cookbook 'ghq'
include_cookbook 'zsh'
#include_cookbook 'mysql'

include_cookbook 'myrepos'

repos = [
  'mzyy94/RictyDiminished-for-Powerline',
  'zplug/zplug',
  'rupa/z',
  'dylanaraps/neofetch'
]
repos.each {|name| get_repo name}

execute "#{sudo(node[:user])} pip install --user powerline-status"

package 'fontforge'
