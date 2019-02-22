node.reverse_merge!({
#  mysql: {
#    root_password: 'D12uM3m4y+',
#  }
})

include_cookbook 'sudo_nopassword'
include_cookbook 'git'
include_cookbook 'dotfiles'
include_cookbook 'go'
include_cookbook 'ghq'
include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'nodejs'
include_cookbook 'rust'

include_cookbook 'tmux'
include_cookbook 'neovim'
include_cookbook 'zsh'
# include_cookbook 'mysql'
include_cookbook 'yarn'
include_cookbook 'zeroconf'
include_cookbook 'chrome'

include_cookbook 'myrepos'

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
