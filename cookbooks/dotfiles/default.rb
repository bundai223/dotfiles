
directory "#{node[:home]}/.ssh" do
  owner node[:user]
  group node[:group]
  mode '700'
end

directory "#{node[:home]}/.config" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.local" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.local/bin" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/git" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/zsh/z" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/nvim" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/spacemacs/layers" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/repos" do
  owner node[:user]
  group node[:group]
end

remote_file "#{node[:home]}/.gitconfig" do
  source 'files/.gitconfig'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.gitconfig"
end

template "#{node[:home]}/.config/nvim/init.vim" do
  source 'templates/init.vim.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.config/nvim/init.vim"
end

template "#{node[:home]}/.zshrc" do
  source 'templates/.zshrc.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.zshrc"
end

template "#{node[:home]}/.zshenv" do
  source 'templates/.zshenv.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.zshenv"
end

template "#{node[:home]}/.xinitrc" do
  source 'templates/.xinitrc.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.xinitrc"
end

remote_file "#{node[:home]}/.tmux.conf" do
  source 'files/.tmux.conf'
  owner node[:user]
  group node[:group]
end

remote_file "#{node[:home]}/.ctags" do
  source '../../config/.ctags'
  owner node[:user]
  group node[:group]
end

# ssh setting
execute 'cp ssh keys' do
  command <<-EOL
    cp /mnt/c/tools/ssh/* #{node[:home]}/.ssh/
    chown #{node[:user]}:#{node[:group]} #{node[:home]}/.ssh/*
    chmod 600 #{node[:home]}/.ssh/*
  EOL

  only_if 'uname -a | grep Microsoft && test -d /mnt/c/tools/ssh'
end

ssh_targets = %w(gitlab.com github.com)
ssh_targets.each do |target|
  execute "known_hosts update #{target}" do
    command <<-EOL
      #{sudo(node[:user])}ssh-keygen -R #{target}
      #{sudo(node[:user])}ssh-keyscan #{target}>>#{node[:home]}/.ssh/known_hosts
    EOL
  end
end

# github_token
execute 'cp github_token' do
  command <<-EOL
    cp /mnt/c/tools/github_token #{node[:home]}/.config/git/
    chown #{node[:user]}:#{node[:group]} #{node[:home]}/.config/git/github_token
  EOL

  only_if 'uname -a | grep Microsoft && test -e /mnt/c/tools/github_token'
end


# powerline
#dotfile '.config/powerline'
execute "#{sudo(node[:user])} ln -s #{node[:home]}/repos/github.com/bundai223/dotfiles/config/.config/powerline #{node[:home]}/.config/powerline" do
  not_if "test -L #{node[:home]}/.config/powerline"
end

# spacemacs
execute "#{sudo(node[:user])} ln -s #{node[:home]}/repos/github.com/bundai223/dotfiles/config/.spacemacs #{node[:home]}/.spacemacs" do
  not_if "test -L #{node[:home]}/.spacemacs"
end

execute "#{sudo(node[:user])} ln -s #{node[:home]}/repos/github.com/bundai223/dotfiles/config/.spacemacs.d #{node[:home]}/.spacemacs.d" do
  not_if "test -L #{node[:home]}/.spacemacs.d"
end
