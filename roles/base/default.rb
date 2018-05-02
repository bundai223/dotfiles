#include_cookbook 'dotfiles'
#include_cookbook 'git'
#include_cookbook 'python'
#include_cookbook 'go'
#include_cookbook 'rust'
#include_cookbook 'ruby'
#include_cookbook 'tmux'
#include_cookbook 'neovim'
#include_cookbook 'ghq'
#include_cookbook 'zsh'

include_cookbook 'myrepos'

execute "add zplug" do
  command <<-EOL
    #{sudo(node[:user])} ghq get zplug/zplug
  EOL

  not_if 'test -e ~/repos/github.com/zplug/zplug'
end

execute "add z" do
  command <<-EOL
    #{sudo(node[:user])} ghq get rupa/z
  EOL

  not_if 'test -e ~/repos/github.com/rupa/z'
end

execute "add neofetch" do
  command <<-EOL
    #{sudo(node[:user])} ghq get dylanaraps/neofetch
  EOL

  not_if 'test -e ~/repos/github.com/dylanaraps/neofetch'
end
