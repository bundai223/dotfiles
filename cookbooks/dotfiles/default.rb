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
mydir "#{home}/.config/dictionary"
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
  cmds = [
    "cp -r /mnt/c/.ssh/* #{home}/.ssh/",
    "chown #{user}:#{group} #{home}/.ssh/*",
    "chmod 600 #{home}/.ssh/*"
  ]

  cmds.each do |cmd|
    execute cmd do
      only_if 'test -d /mnt/c/.ssh'
    end
  end
end

file "#{home}/.ssh/known_hosts" do
  content '# generated by itamae'
  owner user
  group group
  not_if "test -e #{home}/.ssh/known_hosts"
end

ssh_targets = %w[gitlab.com github.com]
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
  cmds = [
    "cp /mnt/c/tools/github_token #{home}/.config/git/",
    "chown #{user}:#{group} #{home}/.config/git/github_token"
  ]

  cmds.each do |cmd|
    execute cmd do
      only_if 'test -e /mnt/c/tools/github_token'
    end
  end
end

include_cookbook 'git'
execute "git clone git@github.com:bundai223/dotfiles.git #{home}/repos/github.com/bundai223/dotfiles" do
  user user
  not_if "test -e #{home}/repos/github.com/bundai223/dotfiles"
end
execute 'git init' do
  user user
  cwd "#{home}/repos/github.com/bundai223/dotfiles"
  only_if "test -e #{home}/repos/github.com/bundai223/dotfiles"
end

dotfile '.config/pip'
dotfile '.config/powerline'
dotfile '.spacemacs'
dotfile '.spacemacs.d'
dotfile '.config/Code/User/settings.json'
dotfile '.ctags'
dotfile '.config/ctags'
dotfile '.config/nvim/lua'
dotfile '.config/nvim/nlsp-settings'
dotfile '.config/yamllint'
dotfile '.conkyrc'
# dotfile '.gemrc' # 追加したいオプションができるまでなし

include_cookbook 'aspell'
execute "aspell -d en dump master | aspell -l en expand > #{home}/.config/dictionary/my.dict" do
  user user
  cwd "#{home}/.config/dictionary"
  not_if "test -e #{home}/.config/dictionary/my.dict"
end
