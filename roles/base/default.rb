node.reverse_merge!({
  mysql: {
    root_password: 'D12uM3m4y+',
  }
})

directory "#{node[:home]}/.ssh" do
  owner node[:user]
  group node[:group]
  mode '700'
end

execute 'cp ssh keys' do
  command <<-EOL
    cp /mnt/c/tools/ssh/* #{node[:home]}/.ssh/
    chown #{node[:user]}:#{node[:group]} #{node[:home]}/.ssh/*
    chmod 600 #{node[:home]}/.ssh/*
  EOL

  only_if 'uname -a | grep Microsoft'
  only_if 'test -d /mnt/c/tools/ssh'
end

execute 'known_hosts update' do
  command <<-EOL
    #{sudo(node[:user])}TARGET=gitlab.com ssh-keygen -R $TARGET && ssh-keyscan $TARGET>>~/.ssh/known_hosts
    #{sudo(node[:user])}TARGET=github.com ssh-keygen -R $TARGET && ssh-keyscan $TARGET>>~/.ssh/known_hosts
  EOL
end


include_cookbook 'dotfiles'
include_cookbook 'git'
include_cookbook 'go'
include_cookbook 'ghq'

include_cookbook 'myrepos'

include_cookbook 'python'
include_cookbook 'rust'
include_cookbook 'ruby'
include_cookbook 'nodejs'
include_cookbook 'tmux'
include_cookbook 'neovim'
include_cookbook 'zsh'
include_cookbook 'mysql'
include_cookbook 'yarn'
include_cookbook 'zeroconf'
include_cookbook 'chrome'

repos = [
  'mzyy94/RictyDiminished-for-Powerline',
  'zplug/zplug',
  'rupa/z',
  'dylanaraps/neofetch'
]
repos.each {|name| get_repo name}

execute "#{sudo(node[:user])} pip install --user powerline-status"

package 'fontforge'
