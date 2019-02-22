home = node[:home]
user = node[:user]
group = node[:group]

define :mydir, mode: '755' do
  dirpath = params[:name]

  directory dirpath do
    owner user
    group group
    mode params[:mode]
  end
end

mydir "#{home}/.ssh" do
  mode '700'
end

mydir "#{home}/.config"
mydir "#{home}/.local"
mydir "#{home}/.local/bin"
mydir "#{home}/.local/themes"
mydir "#{home}/.local/icons"
mydir "#{home}/.config/git"
mydir "#{home}/.config/zsh/z"
mydir "#{home}/.config/nvim"
mydir "#{home}/.config/spacemacs/layers"
mydir "#{home}/.config/Code/User"
mydir "#{home}/repos"

remote_file "#{home}/.gitconfig" do
  source 'files/.gitconfig'
  owner user
  group group
  not_if "test -e #{home}/.gitconfig"
end

template "#{home}/.config/nvim/init.vim" do
  source 'templates/init.vim.erb'
  owner user
  group group
  not_if "test -e #{home}/.config/nvim/init.vim"
end

template "#{home}/.zlogin" do
  source 'templates/.zlogin.erb'
  owner user
  group group
  not_if "test -e #{home}/.zlogin"
end

template "#{home}/.zshrc" do
  source 'templates/.zshrc.erb'
  owner user
  group group
  not_if "test -e #{home}/.zshrc"
end

template "#{home}/.zshenv" do
  source 'templates/.zshenv.erb'
  owner user
  group group
  not_if "test -e #{home}/.zshenv"
end

template "#{home}/.xinitrc" do
  source 'templates/.xinitrc.erb'
  owner user
  group group
  not_if "test -e #{home}/.xinitrc"
end

remote_file "#{home}/.tmux.conf" do
  source 'files/.tmux.conf'
  owner user
  group group
end

# ssh setting
if node[:is_wsl]
  execute 'cp ssh keys' do
    command <<-EOL
      cp /mnt/c/tools/ssh/* #{home}/.ssh/
      chown #{user}:#{group} #{home}/.ssh/*
      chmod 600 #{home}/.ssh/*
    EOL

    only_if 'test -d /mnt/c/tools/ssh'
  end
end

file "#{home}/.ssh/known_hosts" do
  content ''
  owner user
  group group
  not_if "test -e #{home}/.ssh/known_hosts"
end

ssh_targets = %w(gitlab.com github.com)
ssh_targets.each do |target|
  execute "ssh-keygen -R #{target}" do
    user user
  end
  execute "ssh-keyscan #{target}>>#{home}/.ssh/known_hosts" do
    user user
  end
end

# github_token
if node[:is_wsl]
  execute 'cp github_token' do
    command <<-EOL
      cp /mnt/c/tools/github_token #{home}/.config/git/
      chown #{user}:#{group} #{home}/.config/git/github_token
    EOL

    only_if 'test -e /mnt/c/tools/github_token'
  end
end


dotfile '.config/pip'
dotfile '.config/powerline'
dotfile '.spacemacs'
dotfile '.spacemacs.d'
dotfile '.config/Code/User/settings.json'
dotfile '.ctags'
dotfile '.conkyrc'
