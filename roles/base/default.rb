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

ssh_targets = %w(gitlab.com github.com)
ssh_targets.each do |target|
  execute "known_hosts update #{target}" do
    command <<-EOL
      #{sudo(node[:user])}ssh-keygen -R #{target}
      #{sudo(node[:user])}ssh-keyscan #{target}>>~/.ssh/known_hosts
    EOL
  end
end


include_cookbook 'sudo_nopassword'
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
